CREATE TYPE GRAVITE_TYPE AS ENUM ('sans impact', 'avec impact');
CREATE TYPE TRAIN_TYPE AS ENUM ('TGV', 'TER', 'Intercite', 'Fret');

CREATE TABLE incidents (
    id_incident SERIAL PRIMARY KEY,
    type_incident VARCHAR(100) NOT NULL,
	gravite GRAVITE_TYPE NOT NULL,
    description TEXT
);

CREATE TABLE departements (
	id_departement SERIAL PRIMARY KEY,
	nom VARCHAR(100)
);

CREATE TABLE lignes (
    id_ligne SERIAL PRIMARY KEY,
	nom VARCHAR(100)
);


CREATE TABLE trains (
    id_train SERIAL PRIMARY KEY,
    type_train TRAIN_TYPE NOT NULL,
	id_ligne_habituelle INT NOT NULL,
    capacite INT NOT NULL,
	FOREIGN KEY (id_ligne_habituelle) REFERENCES lignes(id_ligne)
);

CREATE TABLE villes (
	id_ville SERIAL PRIMARY KEY,
	nom VARCHAR(100),
	id_departement INT NOT NULL,
	FOREIGN KEY (id_departement) REFERENCES departements(id_departement)
);

CREATE TABLE gares (
	id_gare SERIAL PRIMARY KEY,
	nom VARCHAR(100),
	id_ville INT NOT NULL,
	FOREIGN KEY (id_ville) REFERENCES villes(id_ville)
);

CREATE TABLE quais (
	id_quai SERIAL PRIMARY KEY,
	id_gare INT NOT NULL,
	nom VARCHAR(100),
	FOREIGN KEY (id_gare) REFERENCES gares(id_gare)
);

CREATE TABLE liaisons(
	id_liaison SERIAL PRIMARY KEY,
	id_quai1 INT NOT NULL,
	id_quai2 INT NOT NULL,
	FOREIGN KEY (id_quai1) REFERENCES quais(id_quai),
	FOREIGN KEY (id_quai2) REFERENCES quais(id_quai),
	id_quai1_norm INT GENERATED ALWAYS AS (LEAST(id_quai1, id_quai2)) STORED,
    id_quai2_norm INT GENERATED ALWAYS AS (GREATEST(id_quai1, id_quai2)) STORED,
    CONSTRAINT unique_liaisons UNIQUE (id_quai1_norm, id_quai2_norm) -- Permet d'éviter les doublons (A,B) (B,A)
);

CREATE TABLE lignes_liaisons (
    id_ligne INT NOT NULL,
	id_liaison INT NOT NULL,
	FOREIGN KEY (id_ligne) REFERENCES lignes(id_ligne),
	FOREIGN KEY (id_liaison) REFERENCES liaisons(id_liaison),
	PRIMARY KEY (id_ligne, id_liaison)
);


CREATE TABLE incidents_lignes (
    id_ligne INT NOT NULL,
    id_incident INT NOT NULL,
    compte_rendu TEXT,
    date_heure_debut TIMESTAMP NOT NULL,
	date_heure_fin TIMESTAMP DEFAULT NULL,
	FOREIGN KEY (id_ligne) REFERENCES lignes(id_ligne),
	FOREIGN KEY (id_incident) REFERENCES incidents(id_incident),
    PRIMARY KEY (id_ligne, id_incident, date_heure_debut, date_heure_fin)
);

CREATE TABLE incidents_quais (
    id_quai INT NOT NULL,
    id_incident INT NOT NULL,
    compte_rendu TEXT,
    date_heure_debut TIMESTAMP NOT NULL,
	date_heure_fin TIMESTAMP DEFAULT NULL,
	FOREIGN KEY (id_quai) REFERENCES quais(id_quai),
	FOREIGN KEY (id_incident) REFERENCES incidents(id_incident),
    PRIMARY KEY (id_quai, id_incident, date_heure_debut, date_heure_fin)
);

CREATE TABLE incidents_gares (
    id_gare INT NOT NULL,
    id_incident INT NOT NULL,
    compte_rendu TEXT,
    date_heure_debut TIMESTAMP NOT NULL,
	date_heure_fin TIMESTAMP DEFAULT NULL,
	FOREIGN KEY (id_gare) REFERENCES gares(id_gare),
	FOREIGN KEY (id_incident) REFERENCES incidents(id_incident),
    PRIMARY KEY (id_gare, id_incident, date_heure_debut, date_heure_fin)
);

CREATE TABLE incidents_trains (
    id_train INT NOT NULL,
    id_incident INT NOT NULL,
    compte_rendu TEXT,
    date_heure_debut TIMESTAMP NOT NULL,
	date_heure_fin TIMESTAMP DEFAULT NULL,
	FOREIGN KEY (id_train) REFERENCES trains(id_train),
	FOREIGN KEY (id_incident) REFERENCES incidents(id_incident),
    PRIMARY KEY (id_train, id_incident, date_heure_debut, date_heure_fin)
);

CREATE TABLE equipements (
	id_equipement SERIAL PRIMARY KEY,
	libele VARCHAR(255)
);


CREATE TABLE equipements_gares (
    id_gare INT NOT NULL,
    id_equipement INT NOT NULL,
    emplacement VARCHAR(255) NOT NULL,
    quantite_total INT NOT NULL CHECK (quantite_total > 0),
    quantite_operationelle INT NOT NULL CHECK (quantite_operationelle >= 0 AND quantite_operationelle <= quantite_total),
	FOREIGN KEY (id_gare) REFERENCES gares(id_gare),
	FOREIGN KEY (id_equipement) REFERENCES equipements(id_equipement),
    PRIMARY KEY (id_gare, id_equipement, emplacement)
);

CREATE TABLE trajets (
	id_trajet SERIAL PRIMARY KEY,
    id_train INT NOT NULL,
    id_liaison INT NOT NULL,
	date_heure_depart_prevue TIMESTAMP NOT NULL,
	date_heure_arrive_prevue TIMESTAMP NOT NULL,
	date_heure_depart_reelle TIMESTAMP DEFAULT NULL,
	date_heure_arrive_reelle TIMESTAMP DEFAULT NULL,

	FOREIGN KEY (id_train) REFERENCES trains(id_train) ON DELETE CASCADE,
	FOREIGN KEY (id_liaison) REFERENCES liaisons(id_liaison) ON DELETE CASCADE
);

CREATE TABLE maintenances (
    id_maintenance SERIAL PRIMARY KEY,
    id_train INT NOT NULL,
    date_heure_debut_maintenance TIMESTAMP NOT NULL,
	date_heure_fin_maintenance TIMESTAMP DEFAULT NULL,
	FOREIGN KEY (id_train) REFERENCES trains(id_train)
);

CREATE TABLE incidents_maintenances (
	id_maintenance INT NOT NULL,
	id_incident INT NOT NULL,
	FOREIGN KEY (id_maintenance) REFERENCES maintenances(id_maintenance),
	FOREIGN KEY (id_incident) REFERENCES incidents(id_incident),
	PRIMARY KEY (id_maintenance, id_incident)
);
