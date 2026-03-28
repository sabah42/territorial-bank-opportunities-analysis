%include "&root./03_sas_code/setup.sas";

/* Création des indicateurs */
data clean.commune_indicators;
    set clean.commune_analysis;

    if population > 0 then do;
        densite_equip_eco         = (nb_equipements_eco / population) * 1000;
        densite_equip_ser         = (nb_equipements_services / population) * 1000;
        densite_banques           = (nb_banques_classiques / population) * 1000;
        densite_services_fin      = (nb_services_financiers / population) * 1000;
    end;
    else do;
        densite_equip_eco         = .;
        densite_equip_ser         = .;
        densite_banques           = .;
        densite_services_fin      = .;
    end;
run;

/* Contrôles */
proc means data=clean.commune_indicators n min p25 median p75 max;
    var densite_equip_eco densite_equip_ser densite_banques densite_services_fin;
run;

proc print data=clean.commune_indicators(obs=10);
    var commune population croissance_pop revenu_median
        nb_banques_classiques nb_services_financiers
        nb_equipements_eco nb_equipements_services
        densite_equip_eco densite_equip_ser densite_banques densite_services_fin;
run;

/* Récupérer min et max */
proc sql noprint;
select 
    min(population), max(population),
    min(densite_equip_eco), max(densite_equip_eco),
    min(densite_equip_ser), max(densite_equip_ser),
    min(densite_banques), max(densite_banques),
    min(revenu_median), max(revenu_median),
    min(croissance_pop), max(croissance_pop)
into 
    :pop_min, :pop_max,
    :eco_min, :eco_max,
    :ser_min, :ser_max,
    :bank_min, :bank_max,
    :rev_min, :rev_max,
    :crois_min, :crois_max
from clean.commune_indicators;
quit;

/* Normalisation */
data clean.commune_norm;
    set clean.commune_indicators;

    if &pop_max > &pop_min then 
        pop_norm = (population - &pop_min) / (&pop_max - &pop_min);
    else pop_norm = .;

    if &eco_max > &eco_min then 
        eco_norm = (densite_equip_eco - &eco_min) / (&eco_max - &eco_min);
    else eco_norm = .;

    if &ser_max > &ser_min then 
        ser_norm = (densite_equip_ser - &ser_min) / (&ser_max - &ser_min);
    else ser_norm = .;

    if &bank_max > &bank_min then 
        bank_norm = (densite_banques - &bank_min) / (&bank_max - &bank_min);
    else bank_norm = .;

    if &rev_max > &rev_min then 
        revenu_norm = (revenu_median - &rev_min) / (&rev_max - &rev_min);
    else revenu_norm = .;

    if &crois_max > &crois_min then 
        croissance_norm = (croissance_pop - &crois_min) / (&crois_max - &crois_min);
    else croissance_norm = .;
run;

/* Vérification */
proc means data=clean.commune_norm min max;
    var pop_norm eco_norm ser_norm bank_norm revenu_norm croissance_norm;
run;

/* Calcul du score stratégique */
data clean.commune_score;
    set clean.commune_norm;

    /* score de potentiel territorial : somme des poids = 1 */
    score_potentiel =
          0.20 * pop_norm
        + 0.20 * revenu_norm
        + 0.25 * eco_norm
        + 0.15 * ser_norm
        + 0.20 * croissance_norm
    ;

    /* saturation bancaire */
    score_saturation = bank_norm;

    /* score final */
    score_final = score_potentiel * (1 - score_saturation);
run;

/* Filtrer les très petites communes */
data clean.commune_score_filtered;
    set clean.commune_score;

    if population >= 1000;
run;

/* Classement en 3 groupes */
proc rank data=clean.commune_score_filtered
          out=clean.commune_ranked
          groups=3;
    var score_final;
    ranks rang_score;
run;

data clean.commune_ranked;
    set clean.commune_ranked;

    length potentiel $20;

    if rang_score = 2 then potentiel = "Potentiel élevé";
    else if rang_score = 1 then potentiel = "Potentiel moyen";
    else potentiel = "Potentiel faible";
run;

proc freq data=clean.commune_ranked;
    tables potentiel;
run;

/* Trier les communes par score */
proc sort data=clean.commune_ranked;
    by descending score_final;
run;

proc print data=clean.commune_ranked(obs=20);
    var dep commune population revenu_median croissance_pop
        nb_equipements_eco nb_equipements_services
        nb_banques_classiques nb_services_financiers
        score_potentiel score_saturation score_final potentiel;
run;

/* Identifier les communes sans banque */
proc sql;
create table clean.communes_sans_banque as
select *
from clean.commune_ranked
where nb_banques_classiques = 0
order by score_final desc;
quit;

proc print data=clean.communes_sans_banque(obs=15);
    var commune population croissance_pop revenu_median
        nb_equipements_eco nb_equipements_services score_final;
run;