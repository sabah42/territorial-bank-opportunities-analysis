%include "&root./03_sas_code/setup.sas";

/* Jointure principale */
proc sql;
create table clean.commune_analysis as
select 
    p.code_insee,
    p.P21_POP as population,
    p.P15_POP,
    p.croissance_pop,
    p.dep,
    e.nb_banques_classiques,
    e.nb_services_financiers,
    e.nb_equipements_eco,
    e.nb_equipements_services,
    r.revenu_median,
    r.commune
from clean.population_growth p

left join clean.commune_equipements e
    on p.code_insee = e.code_insee

left join clean.revenus_key r
    on p.code_insee = r.code_insee
;
quit;

/* Remplacer les valeurs manquantes des équipements par 0 */
data clean.commune_analysis;
    set clean.commune_analysis;

    if nb_banques_classiques = . then nb_banques_classiques = 0;
    if nb_services_financiers = . then nb_services_financiers = 0;
    if nb_equipements_services = . then nb_equipements_services = 0;
    if nb_equipements_eco = . then nb_equipements_eco = 0;
run;

/* Vérification rapide */
proc print data=clean.commune_analysis(obs=10);
run;

proc means data=clean.commune_analysis n nmiss min max mean median;
    var population P15_POP croissance_pop 
        nb_banques_classiques nb_services_financiers
        nb_equipements_services nb_equipements_eco
        revenu_median;
run;

proc contents data=clean.commune_analysis;
run;

/* Calcul de la médiane du revenu par département */
proc means data=clean.commune_analysis noprint;
    class dep;
    var revenu_median;
    output out=clean.revenu_median_dept median=med_revenu;
run;

/* Remplacer les revenus manquants par la médiane du département */
proc sql;
create table clean.commune_analysis2 as
select 
    a.*,
    case 
        when missing(a.revenu_median) then b.med_revenu
        else a.revenu_median
    end as revenu_median_final
from clean.commune_analysis a
left join clean.revenu_median_dept b
    on a.dep = b.dep
;
quit;

/* Finaliser la table */
data clean.commune_analysis;
    set clean.commune_analysis2;

    revenu_median = revenu_median_final;
    drop revenu_median_final _TYPE_ _FREQ_;
run;