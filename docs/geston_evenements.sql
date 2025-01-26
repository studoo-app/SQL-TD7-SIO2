CREATE DATABASE gestion_evenements;
USE gestion_evenements;

CREATE TABLE evenements (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    date DATE NOT NULL,
    lieu VARCHAR(100) NOT NULL
);

CREATE TABLE reservations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    client_id INT NOT NULL,
    evenement_id INT NOT NULL,
    places INT NOT NULL,
    FOREIGN KEY (evenement_id) REFERENCES evenements(id)
);

CREATE TABLE clients (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE
);

INSERT INTO evenements (nom, date, lieu)
VALUES
    ('Conférence Tech', '2025-03-15', 'Paris'),
    ('Atelier DevOps', '2025-04-10', 'Lyon'),
    ('Salon de l\'Innovation', '2025-05-20', 'Marseille');

INSERT INTO clients (nom, email)
VALUES
    ('Alice Dupont', 'alice.dupont@example.com'),
    ('Bob Martin', 'bob.martin@example.com');

INSERT INTO reservations (client_id, evenement_id, places)
VALUES
    (1, 1, 2),
    (2, 3, 1);