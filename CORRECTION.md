![separe](https://github.com/studoo-app/.github/blob/main/profile/studoo-banner-logo.png)
# TD 7 - La gestion des droits d'accès utilisateurs
[![Version](https://img.shields.io/badge/Version-2024-blue)]()

## Description
Projet contenant deux base de données MariaDb et un PHPMyAdmin ayant pour finalité
de s'initier et s'entrainer à la gestion des droits utilisateurs SQL.

## Partie 1 - Démonstration - Base de données `gestion_droits`

### Creation des utilisateurs
1. Créez les utilisateurs suivants avec un mot de passe sécurisé : `user_lecture` et `user_ecriture`.

   ```sql
   CREATE USER 'user_lecture'@'%' IDENTIFIED BY 'password1';
   CREATE USER 'user_ecriture'@'%' IDENTIFIED BY 'password2';
   ```

### Attribution des droits d'accès
1. Autorisez l'utilisateur user_lecture à lire les données des tables `utilisateurs` et `produits`.

   ```sql
   GRANT SELECT ON gestion_droits.utilisateurs TO 'user_lecture'@'localhost';
   GRANT SELECT ON gestion_droits.produits TO 'user_lecture'@'localhost';
   SHOW GRANTS FOR 'user_lecture'@'%';
   ```

2. Autorisez l'utilisateur user_ecriture à insérer, modifier et supprimer des données dans les tables `utilisateurs` et `produits`.

   ```sql
   GRANT SELECT, INSERT, UPDATE, DELETE ON gestion_droits.utilisateurs TO 'user_ecriture'@'localhost';
   GRANT SELECT, INSERT, UPDATE, DELETE ON gestion_droits.produits TO 'user_ecriture'@'localhost';
   SHOW GRANTS FOR 'user_ecriture'@'%';
   ```

### Tests des permissions
1. Connectez-vous à la base de données `gestion_droits` en tant que `user_lecture` et vérifiez que vous pouvez lire les données des tables `utilisateurs` et `produits`.

   ```bash
   mysql -u user_lecture -p gestion_droits
   ```
   
   ```sql
   SELECT * FROM gestion_droits.utilisateurs;
   INSERT INTO gestion_droits.utilisateurs (nom, email) VALUES ('Charlie', 'charlie@example.com');
   ```

2. Connectez-vous à la base de données `gestion_droits` en tant que `user_ecriture` et vérifiez que vous pouvez insérer, modifier et supprimer des données dans les tables `utilisateurs` et `produits`.

   ```bash
   mysql -u user_ecriture -p gestion_droits
   ````
   
   ```sql
   INSERT INTO gestion_droits.utilisateurs (nom, email) VALUES ('David', 'david@example.com');
   DELETE FROM gestion_droits.utilisateurs WHERE nom = 'Alice';
   ```

### Révocation des droits d'accès
1. Révoquez les droits de lecture de l'utilisateur `user_lecture` sur les tables `utilisateurs`.

   ```sql
   REVOKE SELECT ON gestion_droits.utilisateurs FROM 'user_lecture'@'%';
   SHOW GRANTS FOR 'user_lecture'@'%';
   ```

2. Révoquez les droits de suppression de l'utilisateur `user_ecriture` sur les tables `produits`.

   ```sql
   REVOKE DELETE ON gestion_droits.produits FROM 'user_ecriture'@'%';
   SHOW GRANTS FOR 'user_ecriture'@'%';
   ```

## Partie 2 - Application - Base de données `gestion_evenements`

### Contexte

Vous êtes administrateur d'une base de données pour une startup qui gère une plateforme de réservation d'événements.
Les utilisateurs de la plateforme ont différents rôles : administrateurs, gestionnaires d'événements, et clients.
Chaque rôle dispose de permissions spécifiques pour interagir avec la base de données.

Vous devez configurer les droits d'accès pour ces rôles, en suivant les règles définies ci-dessous, tout en respectant
les bonnes pratiques en matière de sécurité.

### Création des utilisateurs et rôles SQL

1. Créez les utilisateurs suivants avec un mot de passe sécurisé : `admin` , `gestionnaire` et `client`.

   ```sql
    CREATE USER 'admin'@'%' IDENTIFIED BY 'password1';
    CREATE USER 'gestionnaire'@'%' IDENTIFIED BY 'password2';
    CREATE USER 'client'@'%' IDENTIFIED BY 'password3';
    ```

2. Attribuer les droits aux utilisateurs en fonction de leur rôle :
   - `admin`: Accès complet
      
        ```sql
        GRANT ALL PRIVILEGES ON gestion_evenements.* TO 'admin'@'%';
        ```
     
   - `gestionnaire` : Accès en lecture et écriture aux événements et aux réservations, mais pas aux clients.
         
        ```sql
        GRANT SELECT, INSERT, UPDATE ON gestion_evenements.evenements TO 'gestionnaire'@'%';
        GRANT SELECT, INSERT, UPDATE ON gestion_evenements.reservations TO 'gestionnaire'@'%';
        ```
     
   - `client` : accès en lecture seule aux événements et réservations, avec possibilité de modifier ses propres réservations.
         
     ```sql
        GRANT SELECT, INSERT, UPDATE ON gestion_evenements.evenements TO 'client'@'%';
        GRANT SELECT, INSERT, UPDATE ON gestion_evenements.reservations TO 'client'@'%';
        ```
   
3. Tester les permissions pour chaque utilisateur
   - Pour `admin` : lire, insérer, modifier et supprimer dans toutes les tables.

        ```bash
        mysql -u admin -p gestion_evenements
        ```
        
        ```sql
        SELECT * FROM gestion_evenements.evenements;
        INSERT INTO gestion_evenements.evenements (nom, date) VALUES ('Concert', '2024-12-31');
        ```
     
   - Pour `gestionnaire` : insérer un nouvel événement et modifier une réservation.

      ```bash
      mysql -u admin -p gestion_evenements
      ```
     
      ```sql
      INSERT INTO gestion_evenements.evenements (nom, date) VALUES ('Conférence', '2024-11-30');
      UPDATE gestion_evenements.reservations SET nombre_places = 2 WHERE id = 1;
      ```

   - Pour `client` : essayer de lire les événements et de modifier une réservation.

        ```bash
        mysql -u client -p gestion_evenements
        ```
         
        ```sql
        SELECT * FROM gestion_evenements.evenements;
        UPDATE gestion_evenements.reservations SET nombre_places = 3 WHERE id = 1;
        ```

### Implémentation de besoins métiers

- Vous devez créer une vue permettant à un gestionnaire d'avoir une liste des participants à un événement donné, cette vue doit contenir les informations suivantes :
  - Le nom de l'événement.
  - La date de l'événement.
  - Le lieu de l'événement.
  - Le nom et l'email des participants.
  - Le nombre de places réservées par chaque participant.

   ```sql
   CREATE VIEW liste_participants AS
   SELECT 
       e.nom AS nom_evenement,
       e.date AS date_evenement,
       e.lieu AS lieu_evenement,
       c.nom AS nom_participant,
       c.email AS email_participant,
       r.places AS places_reservees
   FROM 
       evenements e
   JOIN 
       reservations r ON e.id = r.evenement_id
   JOIN 
       clients c ON r.client_id = c.id;
   ```
- Vous ajusterez ensuite les permissions pour que le gestionnaire puisse consulter cette vue.

   ```sql
    GRANT SELECT ON gestion_evenements.liste_participants TO 'gestionnaire'@'%';
    ```
  
## Partie 3 - Création d'un systeme de logs des opérations 

### Création de la base des logs

- operation_type : Type de modification (INSERT, UPDATE, DELETE).
- table_name : Nom de la table affectée.
- modified_data : Données impliquées dans la modification (sous forme de JSON pour une flexibilité maximale).
- user_name : Utilisateur ayant exécuté l'opération (obtenu via la variable SQL USER()).
- operation_date : Date et heure de la modification.

```sql
CREATE DATABASE logs;
USE logs;

CREATE TABLE modifications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    operation_type ENUM('INSERT', 'UPDATE', 'DELETE') NOT NULL,
    table_name VARCHAR(100) NOT NULL,
    modified_data JSON,
    user_name VARCHAR(100) NOT NULL,
    operation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Création des triggers INSERT, UPDATE et DELETE

#### Trigger INSERT
```sql
DELIMITER //

CREATE TRIGGER log_evenements_insert
AFTER INSERT ON evenements
FOR EACH ROW
BEGIN
    INSERT INTO logs.modifications (operation_type, table_name, modified_data, user_name)
    VALUES ('INSERT', 'gestion_evenements.evenements', 
            JSON_OBJECT('id', NEW.id, 'nom', NEW.nom, 'date', NEW.date, 'lieu', NEW.lieu), 
            USER());
END;
//

DELIMITER ;
```

```sql
DELIMITER //

CREATE TRIGGER log_produits_insert
AFTER INSERT ON produits
FOR EACH ROW
BEGIN
    INSERT INTO logs.modifications (operation_type, table_name, modified_data, user_name)
    VALUES ('INSERT', 'gestion_droits.produits', 
            JSON_OBJECT('id', NEW.id, 'nom', NEW.nom, 'prix', NEW.prix), 
            USER());
END;
//

DELIMITER ;
```

#### Trigger UPDATE
```sql
DELIMITER //

CREATE TRIGGER log_evenements_update
AFTER UPDATE ON evenements
FOR EACH ROW
BEGIN
    INSERT INTO logs.modifications (operation_type, table_name, modified_data, user_name)
    VALUES ('UPDATE', 'gestion_evenements.evenements', 
            JSON_OBJECT('old_data', JSON_OBJECT('id', OLD.id, 'nom', OLD.nom, 'date', OLD.date, 'lieu', OLD.lieu),
                        'new_data', JSON_OBJECT('id', NEW.id, 'nom', NEW.nom, 'date', NEW.date, 'lieu', NEW.lieu)),
            USER());
END;
//

DELIMITER ;
```

```sql
DELIMITER //

CREATE TRIGGER log_produits_update
AFTER UPDATE ON produits
FOR EACH ROW
BEGIN
    INSERT INTO logs.modifications (operation_type, table_name, modified_data, user_name)
    VALUES ('UPDATE', 'gestion_droits.produits', 
            JSON_OBJECT('old_data', JSON_OBJECT('id', OLD.id, 'nom', OLD.nom, 'prix', OLD.prix),
                        'new_data', JSON_OBJECT('id', NEW.id, 'nom', NEW.nom, 'prix', NEW.prix)),
            USER());
END;
//

DELIMITER ;
```

#### Trigger DELETE
```sql
DELIMITER //

CREATE TRIGGER log_evenements_delete
AFTER DELETE ON evenements
FOR EACH ROW
BEGIN
    INSERT INTO logs.modifications (operation_type, table_name, modified_data, user_name)
    VALUES ('DELETE', 'evenements', 
            JSON_OBJECT('id', OLD.id, 'nom', OLD.nom, 'date', OLD.date, 'lieu', OLD.lieu), 
            USER());
END;
//

DELIMITER ;
```

```sql
DELIMITER //

CREATE TRIGGER log_produits_delete
AFTER DELETE ON produits
FOR EACH ROW
BEGIN
    INSERT INTO logs.modifications (operation_type, table_name, modified_data, user_name)
    VALUES ('DELETE', 'evenements', 
            JSON_OBJECT('id', OLD.id, 'nom', OLD.nom, 'prix', OLD.prix), 
            USER());
END;
//

DELIMITER ;
```

### Adapation des droits

#### Création de l'utilisateur dédié à la lecture des logs

```sql
CREATE USER 'user_logs'@'%' IDENTIFIED BY 'password4';
```

```sql
GRANT INSERT ON logs.modifications TO 'user_ecriture'@'%';
GRANT INSERT ON logs.modifications TO 'admin'@'%';
GRANT INSERT ON logs.modifications TO 'gestionnaire'@'%';
GRANT INSERT ON logs.modifications TO 'client'@'%';
                                      
GRANT SELECT ON logs.modifications TO 'user_logs'@'%';
```