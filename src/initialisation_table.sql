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