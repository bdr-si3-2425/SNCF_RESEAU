CREATE TABLE departements (
	id_departement INT PRIMARY KEY NOT NULL,
	nom VARCHAR(100)
);

CREATE TABLE incidents (
    id_incident SERIAL PRIMARY KEY,
    type VARCHAR(100) NOT NULL,
    description TEXT
);

CREATE TABLE lignes (
    id_ligne SERIAL PRIMARY KEY,
    FOREIGN KEY (terminus1) INT REFERENCES gares(id_gare),
    FOREIGN KEY (terminus2) INT REFERENCES gares(id_gare)
);

CREATE TABLE trains (
    id_train SERIAL PRIMARY KEY,
    type VARCHAR(100) NOT NULL,
    capacite INT NOT NULL
);


CREATE TABLE villes (
	id_ville INT PRIMARY KEY NOT NULL,
	nom VARCHAR(100),
	FOREIGN KEY (id_departement) INT REFERENCES departements(id_departement)
);

CREATE TABLE gares (
	id_gare INT PRIMARY KEY NOT NULL,
	nom VARCHAR(100),
	FOREIGN KEY (id_ville) INT REFERENCES villes(id_ville)
);

CREATE TABLE equipements (
	id_equipement INT PRIMARY KEY NOT NULL,
	libele VARCHAR(255)
);

CREATE TABLE equipements_gares (
	emplacement VARCHAR(255),
	quantite_total INT,
	quantite_operationelle INT,
	FOREIGN KEY (id_gare) INT	REFERENCES gares(id_gare),
	FOREIGN KEY (id_equipement) INT REFERENCES equipements(id_equipement)
);

CREATE TABLE survenues_incidents (
    compte_rendu TEXT,
    impact VARCHAR(255),
    date_heure TIMESTAMP,
    FOREIGN KEY (id_gare) INT REFERENCES gares(id_gare),
    FOREIGN KEY (id_ligne) INT REFERENCES lignes(id_ligne),
    FOREIGN KEY (id_train) INT REFERENCES trains(id_train),
    FOREIGN KEY (id_incident) INT REFERENCES incidents(id_incident)
);

CREATE TABLE liaisons (
    date DATE,
    heure_depart_prevu TIME,
    heure_arrive_prevu TIME,
    heure_depart_reelle TIME,
    heure_arrive_reelle TIME,
    FOREIGN KEY (id_gare1) INT REFERENCES gares(id_gare),
    FOREIGN KEY (id_gare2) INT REFERENCES gares(id_gare),
);

CREATE TABLE maintenances {
    id_cause INT PRIMARY KEY NOT NULL,
    type VARCHAR(255),
    statut VARCHAR(255),
    date DATE,
    description TEXT,
    FOREIGN KEY (id_train) INT REFERENCES trains(id_train)
};
