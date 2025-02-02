CREATE TABLE departements {
	id_departement INT PRIMARY KEY NOT NULL,
	nom VARCHAR(100)
};

CREATE TABLE villes {
	id_ville INT PRIMARY KEY NOT NULL,
	nom VARCHAR(100),
	id_departement INT FOREIGN KEY
};

CREATE TABLE gares {
	id_gare INT PRIMARY KEY NOT NULL,
	nom VARCHAR(100),
	id_ville INT FOREIGN KEY
};

CREATE TABLE equipements {
	id_equipement INT PRIMARY KEY NOT NULL,
	libele VARCHAR(255)
};

CREATE TABLE posseder {
	id_gare INT	FOREIGN KEY,
	id_equipement INT FOREIGN KEY,
	emplacement VARCHAR(255),
	quantite_total INT,
	quantite_operationelle INT
};
CREATE TABLE Survenir {
    id_gare INT FOREIGN KEY,
    id_ligne INT FOREIGN KEY,
    id_train INT FOREIGN KEY,
    id_incident INT FOREIGN KEY,
    compte_rendu TEXT,
    impact VARCHAR(255),
    date_heure DATETIME
    
};
CREATE TABLE Liaison {
    id_gare1 INT FOREIGN KEY,
    id_gare2 INT FOREIGN KEY,
    date DATE,
    heure_depart_prevu TIME,
    heure_arrive_prevu TIME,
    heure_depart_reelle TIME,
    heure_arrive_reelle TIME
};

CREATE TABLE Causes {
    id_cause INT PRIMARY KEY NOT NULL,
    id_train INT FOREIGN KEY,
    type VARCHAR(255),
    statut VARCHAR(255),
    date DATE,
    description TEXT
};
