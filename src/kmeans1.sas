%include "&root./03_sas_code/setup.sas";

/* =======================================================
   K-MEANS - SEGMENTATION DES COMMUNES
   Objectif : identifier des profils de communes
   à partir des variables normalisées
   ======================================================= */

/* 1) Nettoyage des anciennes tables si elles existent */
proc datasets lib=clean nolist;
    delete kmeans_result commune_kmeans communes_sans_banque_kmeans;
quit;

/* 2) K-Means sur les variables normalisées */
proc fastclus data=clean.commune_norm
              maxclusters=4
              out=clean.kmeans_result;
    var pop_norm
        revenu_norm
        eco_norm
        ser_norm
        croissance_norm
        bank_norm;
run;

/* 3) Vérifier le nombre de communes par cluster */
proc freq data=clean.kmeans_result;
    tables cluster;
run;

/* 4) Joindre le cluster à la table finale de scoring */
proc sql;
create table clean.commune_kmeans as
select 
    a.*,
    b.cluster
from clean.commune_ranked a
left join clean.kmeans_result b
    on a.code_insee = b.code_insee
;
quit;

/* 5) Ajouter un label lisible pour Power BI / présentation */
data clean.commune_kmeans;
    set clean.commune_kmeans;

    length cluster_label $50;

    if cluster = 1 then cluster_label = "Cluster 1";
    else if cluster = 2 then cluster_label = "Cluster 2";
    else if cluster = 3 then cluster_label = "Cluster 3";
    else if cluster = 4 then cluster_label = "Cluster 4";
    else cluster_label = "Non classé";
run;

/* 6) Contrôle rapide */
proc print data=clean.commune_kmeans(obs=10);
    var code_insee commune dep population croissance_pop revenu_median
        nb_banques_classiques nb_services_financiers
        score_final cluster cluster_label;
run;

/* 7) Moyenne des variables par cluster pour interprétation */
proc means data=clean.commune_kmeans mean median min max;
    class cluster;
    var population croissance_pop revenu_median
        nb_banques_classiques nb_services_financiers
        nb_equipements_eco nb_equipements_services
        score_final;
run;

/* 8) Table spéciale : communes sans banque + cluster */
proc sql;
create table clean.communes_sans_banque_kmeans as
select *
from clean.commune_kmeans
where nb_banques_classiques = 0
order by score_final desc
;
quit;

/* 9) Contrôle */
proc print data=clean.communes_sans_banque_kmeans(obs=15);
    var commune dep population croissance_pop revenu_median
        nb_equipements_eco nb_equipements_services
        score_final cluster cluster_label;
run;

/* 10) Export pour Power BI */
proc export data=clean.commune_kmeans
    outfile="&root./02_data_processed/commune_kmeans.csv"
    dbms=csv
    replace;
run;

proc export data=clean.communes_sans_banque_kmeans
    outfile="&root./02_data_processed/communes_sans_banque_kmeans.csv"
    dbms=csv
    replace;
run;