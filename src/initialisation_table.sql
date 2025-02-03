CREATE TYPE gravite_type AS ENUM ('sans impact', 'avec impact');

CREATE TABLE incidents (
    id_incident SERIAL PRIMARY KEY,
    type VARCHAR(100) NOT NULL,
	gravite gravite_type NOT NULL,
    description TEXT
);

CREATE TABLE trains (
    id_train SERIAL PRIMARY KEY,
    type VARCHAR(100) NOT NULL,
    capacite INT NOT NULL
);

CREATE TABLE survenues_incidents (
    id_gare INT REFERENCES gares(id_gare),
    id_ligne INT REFERENCES lignes(id_ligne),
    id_train INT REFERENCES trains(id_train),
    id_incident INT REFERENCES incidents(id_incident),
    compte_rendu TEXT,
    impact VARCHAR(255),
    date_heure TIMESTAMP NOT NULL,
    PRIMARY KEY (id_gare, id_ligne, id_train, id_incident, date_heure)
);

CREATE TABLE departements (
	id_departement INT PRIMARY KEY NOT NULL,
	nom VARCHAR(100)
);

CREATE TABLE villes (
	id_ville INT PRIMARY KEY NOT NULL,
	nom VARCHAR(100),
	id_departement INT,
	FOREIGN KEY (id_departement) REFERENCES departements(id_departement)
);

CREATE TABLE gares (
	id_gare INT PRIMARY KEY NOT NULL,
	nom VARCHAR(100),
	id_ville INT,
	FOREIGN KEY (id_ville) REFERENCES villes(id_ville)
);

CREATE TABLE lignes (
    id_ligne SERIAL PRIMARY KEY,
    terminus1 INT NOT NULL,
    terminus2 INT NOT NULL,
    FOREIGN KEY (terminus1) REFERENCES gares(id_gare),
    FOREIGN KEY (terminus2) REFERENCES gares(id_gare),
    CONSTRAINT unique_ligne UNIQUE (LEAST(terminus1, terminus2), GREATEST(terminus1, terminus2)) -- Permet d'éviter les doublons (A,B) (B,A)
);

CREATE TABLE equipements (
	id_equipement INT PRIMARY KEY NOT NULL,
	libele VARCHAR(255)
);

CREATE TABLE equipements_gares (
    id_gare INT REFERENCES gares(id_gare),
    id_equipement INT REFERENCES equipements(id_equipement),
    emplacement VARCHAR(255),
    quantite_total INT NOT NULL CHECK (quantite_total >= 0),
    quantite_operationelle INT NOT NULL CHECK (quantite_operationelle >= 0 AND quantite_operationelle <= quantite_total),
    PRIMARY KEY (id_gare, id_equipement)
);

CREATE TABLE liaisons (
    id_train INT REFERENCES trains(id_train) ON DELETE CASCADE,
    id_gare1 INT REFERENCES gares(id_gare) ON DELETE CASCADE,
    id_gare2 INT REFERENCES gares(id_gare) ON DELETE CASCADE,
    date DATE NOT NULL,
    heure_depart_prevu TIME,
    heure_arrive_prevu TIME,
    heure_depart_reelle TIME,
    heure_arrive_reelle TIME,
    PRIMARY KEY (id_train, id_gare1, id_gare2, date)
);

CREATE TABLE maintenances (
    id_cause INT PRIMARY KEY NOT NULL,
    id_train INT REFERENCES trains(id_train),
    type VARCHAR(255),
    statut VARCHAR(255),
    date DATE,
    description TEXT
);
