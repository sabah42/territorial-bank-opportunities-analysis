# Analyse territoriale des opportunités bancaires (Loire & Haute-Loire)
## Table des matières

- [Description du projet](#description-du-projet)
- [Objectifs du projet](#objectifs-du-projet)
* [Données et source](#données-et-source)
- [Contenu du projet](#contenu-du-projet)
- [Structure du projet](#structure-du-projet)
- [Étapes principales](#étapes-principales)
- [Description du tableau de bord](#Description-du-tableau-de-bord)
- [Principaux insights](#principaux-insights)
- [Recommandations](#recommandations)
- [Compétences utilisées](#compétences-utilisées)
- [Résultats](#résultats)

---

## Description du projet

Ce projet vise à identifier les communes à fort potentiel pour l’implantation d’agences bancaires dans les départements de la Loire et de la Haute-Loire.

L’approche combine :

- une analyse territoriale des données socio-économiques,
- un scoring des communes,
- une segmentation via K-Means,
- une validation terrain à l’aide de Google Maps.

> Ce projet s’inscrit dans une logique d’aide à la décision pour le développement territorial bancaire.

---

## Objectifs du projet

### Objectifs analytiques

- Identifier les zones sous-couvertes en services bancaires
- Construire un score de potentiel des communes
- Segmenter les communes selon leurs caractéristiques
- Valider les résultats via une analyse terrain

### Objectifs personnels

- Travailler sur un cas métier proche du secteur bancaire
- Combiner analyse de données et logique business
- Utiliser plusieurs outils (SAS, Power BI)

---

## Données et source

- Source principale : INSEE – Base Permanente des Équipements (BPE)
- Données complémentaires :
  - Population
  - Revenu médian
  - Croissance démographique
  - Équipements économiques et services

### Remarque

 Le fichier BPE complet étant volumineux, seule une version échantillon est fournie dans ce dépôt.

Les données ont été nettoyées et transformées avec Power Query.

---

## Contenu du projet

Le projet comprend :

- la préparation et le nettoyage des données,
- la construction d’un score de potentiel,
- la segmentation des communes (K-Means),
- la création d’un dashboard Power BI,
- une validation terrain basée sur Google Maps.

---

## Structure du projet
amazon_reviews_analysis/
│

├── data/ # Données du projet

│ ├── raw/ # Données brutes 

│ │ ├── population.csv

│ │ ├── revenu.csv

│ │ └── bpr.cvs 

│ └── processed/ # Données traitées pour l’analyse

│ └── commune_kmeans.csv

│
├── src/ # Code source sas

│ ├── setup.sas

│ ├── import_data1.sas

│ ├── join1.sas

│ ├── scoring1.sas

│ └── kmeans1.sas

│
├── reports/ # Résultats et livrables

│ ├── Analyse territoriale des opportunités bancaires (Loire & Haute Loire).pbit # Template Power BI du tableau de bord

│ ├── tableau_de_bord_page_1.png # Capture – Vue globale du marché

│ ├── tableau_de_bord_page_2.png # Capture – Analyse du potentiel

│ ├── tableau_de_bord_page_3.png # Capture – Identification des opportinutés

│ └──  tableau_de_bord_page_4.png # Capture – Validation par k-means et terrain

├── README.md # Documentation du projet

---

