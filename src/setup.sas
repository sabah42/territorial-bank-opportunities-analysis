/* ===================================================== */
/* 00_SETUP.SAS - PROJET CA MARKETING TERRITOIRE          */
/* ===================================================== */

options validvarname=v7;
options mprint mlogic symbolgen;

/* 1) Chemin racine du projet */
%let root=/home/u64454340/Banking Territorial Analysis – Market Opportunities (France);
    
 /* 2) Librairies (dossiers de données) */
libname raw   "&root./01_data_raw";
libname clean "&root./02_data_processed";
libname out   "&root./04_reports";
   
/* 3) Vérification dans le LOG */
%put NOTE: ROOT=&root.;
%put NOTE: RAW=%sysfunc(pathname(raw));
%put NOTE: CLEAN=%sysfunc(pathname(clean));
%put NOTE: OUT=%sysfunc(pathname(out));   

   
    
    
    
    
    
    

 
 
 
 
 
 
 
 