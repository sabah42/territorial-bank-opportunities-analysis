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
territorial-bank-opportunities-analysis/
│

├── data/ # Données du projet

│ ├── raw/ # Données brutes 

│ │ ├── population.csv

│ │ ├── revenu.csv

│ │ └── bpe.cvs 

│ └── processed/ # Données traitées pour l’analyse

│ │ └── commune_kmeans.csv

│
├── src/ # Code source sas

│ ├── setup.sas # Configuration de l’environnement (chemins, bibliothèques, variables globales)

│ ├── import_data1.sas # Import et préparation des données brutes

│ ├── join1.sas # Fusion des différentes sources de données au niveau commune

│ ├── scoring1.sas # Calcul des indicateurs et construction du score de potentiel

│ └── kmeans1.sas # Segmentation des communes et validation du modèle avec K-Means

│
├── reports/ # Résultats et livrables

| ├── dashbord/ # tableau de bord power bi

│ | └── Analyse territoriale des opportunités bancaires (Loire & Haute Loire).pbit # Template Power BI du tableau de bord



| ├── screenshots/ # capture - tableau de bord power bi

| │ ├── tableau_de_bord_page_1.png # Capture – Vue globale du marché

| │ ├── tableau_de_bord_page_2.png # Capture – Analyse du potentiel

| │ ├── tableau_de_bord_page_3.png # Capture – Identification des opportinutés

| │ └──  tableau_de_bord_page_4.png # Capture – Validation par k-means et terrain

├── README.md # Documentation du projet

---
---

## Étapes principales

1. Collecte et préparation des données
2. Nettoyage via Power Query et sas
3. Construction du score de potentiel(SAS)
4. Segmentation des communes avec K-Means (SAS)
5. Création du dashboard Power BI
6. Validation terrain via Google Maps

---

## Description du tableau de bord

### Page 1 – Vue globale du marché

Analyse du territoire :
- nombre de communes,
- population,
- densité bancaire,
- répartition des équipements.

Objectif : comprendre la structure globale du marché.

---

### Page 2 – Analyse du potentiel

Construction et analyse du score :
- distribution du score,
- relation avec la population,
- identification des communes à fort potentiel.

Objectif : détecter les zones intéressantes.

---

### Page 3 – Identification des opportunités

Sélection des communes prioritaires :
- communes sans banque,
- population > 3000 habitants,
- score élevé.

Objectif : identifier les cibles prioritaires.

---

### Page 4 – Validation (K-Means & terrain)

- segmentation des communes (clusters),
- validation via distances réelles aux agences (Google Maps).

Objectif : confirmer la pertinence des choix.

---

## Principaux insights

- Une part importante des communes est sous-couverte en services bancaires
- Trois communes ressortent comme prioritaires :
  **Bonson, Genilac et Savigneux**
- Ces communes combinent :
  - une faible couverture bancaire,
  - une population significative,
  - une distance élevée aux agences existantes

---

## Recommandations

## Recommandations

- Prioriser l’implantation dans les communes identifiées (Bonson, Genilac, Savigneux)

- Compléter l’analyse avec des données sur le comportement client 
  (taux de bancarisation, usage digital, profils socio-économiques)

- Analyser la concurrence locale et les stratégies des banques existantes 

- Renforcer la validation terrain (accessibilité, zones de passage)

- Améliorer le modèle avec d’autres méthodes (hiérarchique, DBSCAN) et données complémentaires

---

## Compétences utilisées

- Analyse de données territoriales
- Scoring et pondération
- Clustering (K-Means)
- Data visualisation (Power BI)
- Interprétation métier
- Validation terrain

---

## Résultats

- Dashboard interactif Power BI
- Identification de zones prioritaires
- Approche combinant data et terrain

---

## Auteur

Sabah ASSAS
