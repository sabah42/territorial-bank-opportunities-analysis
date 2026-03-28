/* charger le setup */
%include "&root./03_sas_code/setup.sas";
proc import datafile="&root./01_data_raw/bpe.csv"
    out=work.bpe_clean
    dbms=csv
    replace;    
    guessingrows=max;
run;
proc print data=work.bpe_clean(obs=10);
run;

proc contents data=work.bpe_clean varnum;
run;

data work.bpe_indicators;
    set work.bpe_clean;

    /* 1. Banques classiques */
    banque_classique = (index(upcase(Libelle_TYPEQU), "BANQUE") > 0);

    /* 2. Services financiers élargis */
    service_financier = (TYPEQU in ("A203","A205","A206","A207","A208"));

    /* 3. Equipements économiques */
    equipement_eco = (
        Libelle_DOM in ("Commerces","Tourisme")
        or Libelle_SDOM in (
            "Artisanat du bâtiment",
            "Services automobiles",
            "Autres services",
            "Services généraux",
            "Grandes surfaces"
        )
    );

    /* 4. Equipements de services à la population */
    equipement_service = (
        Libelle_DOM in (
            "Enseignement",
            "Santé et action sociale",
            "Sports, loisirs et culture",
            "Transports et déplacements"
        )
    );
run;

proc means data=work.bpe_indicators sum;
    var banque_classique service_financier equipement_eco equipement_service;
run;

proc print data=work.bpe_indicators(obs=20);
    var DEPCOM TYPEQU Libelle_DOM Libelle_SDOM Libelle_TYPEQU
        banque_classique service_financier
        equipement_eco equipement_service;
run;

proc sql;
create table clean.commune_equipements as
select 
    DEPCOM,
    sum(banque_classique) as nb_banques_classiques,
    sum(service_financier) as nb_services_financiers,
    sum(equipement_eco) as nb_equipements_eco,
    sum(equipement_service) as nb_equipements_services
from work.bpe_indicators
group by DEPCOM;
quit;
data clean.commune_equipements;
    set clean.commune_equipements;
    code_insee = put(DEPCOM, z5.);
run;
proc print data=clean.commune_equipements(obs=20);
run;
/* Import population communes*/
proc import datafile="&root./01_data_raw/population.CSV"
    out=work.population_historique
    dbms=csv
    replace;
    delimiter=';';
    guessingrows=max;/*SAS regarde plus de lignes pour deviner les types (évite qu’une colonne numérique devienne texte ou l’inverse)*/
    getnames=yes;/* garantit que la première ligne est bien prise comme noms de colonnes (souvent oui par défaut, mais là c’est “safe”). */
run;
/* Recréer le département */
data clean.population_historique;
    set work.population_historique;

    code_insee= put(CODGEO, z5.);
    dep = substr(code_insee,1,2);
run;
/* Garder seulement Loire et Haute-Loire */
data clean.population_42_43;
    set clean.population_historique;

    if dep in ("42","43");
run;
/* Garder seulement les variables utiles */
data clean.population_final;
    set clean.population_42_43
        (keep=code_insee P21_POP P15_POP dep);
run;

/* Calcul de la croissance */
data clean.population_growth;
    set clean.population_final;

    if P15_POP > 0 then
        croissance_pop = (P21_POP - P15_POP) / P15_POP * 100;
    else croissance_pop = .;
run;

/* Voir premières lignes */
proc print data=clean.population_growth(obs=5);
run;
/* Vérifier structure */
proc contents data=clean.population_growth varnum;
run;
/* import revenus */
data clean.revenus_key;
    infile "&root./01_data_raw/revenus.csv"
        dlm=';'
        dsd
        firstobs=2
        lrecl=32767
        truncover;


    length
        commune $100
        code_insee $5
        revenu_median 8
    ;

    input
        commune :$100.
        code_insee :$5.
        commune2 :$100.
        col4
        col5
        col6
        col7
        revenu_median
    ;
    commune = commune2;
    keep code_insee commune revenu_median;
run;

proc print data=clean.revenus_key(obs=10);
run;

proc means data=clean.revenus_key n nmiss min median max;
    var revenu_median;
run;

proc means data=clean.revenus_key;
var revenu_median;
run;


