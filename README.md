![separe](https://github.com/studoo-app/.github/blob/main/profile/studoo-banner-logo.png)
# TD 7 - La gestion des droits d'accès utilisateurs
[![Version](https://img.shields.io/badge/Version-2024-blue)]()

## Description
Projet contenant deux base de données MariaDb et un PHPMyAdmin ayant pour finalité
de s'initier et s'entrainer à la gestion des droits utilisateurs SQL.

## Partie 1 - Démonstration - Base de données `gestion_droits`

### Creation des utilisateurs
1. Créez les utilisateurs suivants avec un mot de passe sécurisé : `user_lecture` et `user_ecriture`.

### Attribution des droits d'accès
1. Autorisez l'utilisateur user_lecture à lire les données des tables `utilisateurs` et `produits`.
2. Autorisez l'utilisateur user_ecriture à insérer, modifier et supprimer des données dans les tables `utilisateurs` et `produits`.

### Tests des permissions
1. Connectez-vous à la base de données `gestion_droits` en tant que `user_lecture` et vérifiez que vous pouvez lire les données des tables `utilisateurs` et `produits`.
2. Connectez-vous à la base de données `gestion_droits` en tant que `user_ecriture` et vérifiez que vous pouvez insérer, modifier et supprimer des données dans les tables `utilisateurs` et `produits`.

### Révocation des droits d'accès
1. Révoquez les droits de lecture de l'utilisateur `user_lecture` sur les tables `utilisateurs`.
2. Révoquez les droits de suppression de l'utilisateur `user_ecriture` sur les tables `produits`.

## Partie 2 - Application - Base de données `gestion_evenements`

### Contexte

Vous êtes administrateur d'une base de données pour une startup qui gère une plateforme de réservation d'événements.
Les utilisateurs de la plateforme ont différents rôles : administrateurs, gestionnaires d'événements, et clients.
Chaque rôle dispose de permissions spécifiques pour interagir avec la base de données.

Vous devez configurer les droits d'accès pour ces rôles, en suivant les règles définies ci-dessous, tout en respectant
les bonnes pratiques en matière de sécurité.

### Création des utilisateurs et rôles SQL

1. Créez les utilisateurs suivants avec un mot de passe sécurisé : `admin` , `gestionnaire` et `client`.

2. Attribuer les droits aux utilisateurs en fonction de leur rôle :
    - `admin`: Accès complet
    - `gestionnaire` : Accès en lecture et écriture aux événements et aux réservations, mais pas aux clients.
    - `client` : accès en lecture seule aux événements et réservations, avec possibilité de modifier ses propres réservations.
3. Tester les permissions pour chaque utilisateur
   - Pour `admin` : lire, insérer, modifier et supprimer dans toutes les tables.
   - Pour `gestionnaire` : insérer un nouvel événement et modifier une réservation.
   - Pour `client` : essayer de lire les événements et de modifier une réservation.

### Implémentation de besoins métiers

- Vous devez créer une vue permettant à un gestionnaire d'avoir une liste des participants à un événement donné, cette vue doit contenir les informations suivantes :
   - Le nom de l'événement.
   - La date de l'événement.
   - Le lieu de l'événement.
   - Le nom et l'email des participants.
   - Le nombre de places réservées par chaque participant.

- Vous ajusterez ensuite les permissions pour que le gestionnaire puisse consulter cette vue.

## Partie 3 - Création d'un systeme de logs des opérations

### Contexte

Pour des raisons de sécurité et de traçabilité, vous devez mettre en place un système de logs des opérations effectuées
de modifications sur les bases de données `gestion_evenements` et `gestion_droits`.


### Création de la base des logs

Vous créerez une nouvelle base de données `logs` contenant une table `modifications` avec les colonnes suivantes :

- operation_type : Type de modification (INSERT, UPDATE, DELETE).
- table_name : Nom de la table affectée.
- modified_data : Données impliquées dans la modification (sous forme de JSON pour une flexibilité maximale).
- user_name : Utilisateur ayant exécuté l'opération (obtenu via la variable SQL USER()).
- operation_date : Date et heure de la modification.

### Ajout des triggers

Vous ajouterez des triggers sur les tables des bases de données `gestion_evenements` et `gestion_droits` pour enregistrer
les opérations d'insertion, de modification et de suppression dans la table `modifications` de la base de données `logs`.

### Adapatation des permissions

Vous veillerez à autoriser les permissions d'écriture sur la table `modifications` de la base de données `logs` pour
que tout utilisateur ayant les droits d'écriture sur les tables `gestion_evenements` et `gestion_droits` puisse enregistrer les logs. 

Ensuite vous créerez un utilisateur `logger` avec les droits de lecture sur la table `modifications` pour tester la bonne viusalisation des logs.

