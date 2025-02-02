CREATE TABLE departements (
	id_departement INT PRIMARY KEY NOT NULL,
	nom VARCHAR(100)
);

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
	terminus1 INT,
	terminus2 INT,
    FOREIGN KEY (terminus1) REFERENCES gares(id_gare),
    FOREIGN KEY (terminus2) REFERENCES gares(id_gare)
);

CREATE TABLE equipements (
	id_equipement INT PRIMARY KEY NOT NULL,
	libele VARCHAR(255)
);

CREATE TABLE posseder (
	id_gare INT	REFERENCES gares(id_gare),
	id_equipement INT REFERENCES equipements(id_equipement),
	emplacement VARCHAR(255),
	quantite_total INT,
	quantite_operationelle INT
);
CREATE TABLE survenir (
    id_gare INT REFERENCES gares(id_gare),
    id_ligne INT REFERENCES lignes(id_ligne),
    id_train INT REFERENCES trains(id_train),
    id_incident INT REFERENCES incidents(id_incident),
    compte_rendu TEXT,
    impact VARCHAR(255),
    date_heure TIMESTAMP
    
);
CREATE TABLE liaison (
    id_gare1 INT REFERENCES gares(id_gare),
    id_gare2 INT REFERENCES gares(id_gare),
    date DATE,
    heure_depart_prevu TIME,
    heure_arrive_prevu TIME,
    heure_depart_reelle TIME,
    heure_arrive_reelle TIME
);

CREATE TABLE causes (
    id_cause INT PRIMARY KEY NOT NULL,
    id_train INT REFERENCES trains(id_train),
    type VARCHAR(255),
    statut VARCHAR(255),
    date DATE,
    description TEXT
);






