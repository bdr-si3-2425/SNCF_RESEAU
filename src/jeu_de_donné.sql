
INSERT INTO departements (id_departement, nom) VALUES
(75, 'Paris'),
(59, 'Nord'),
(13, 'Bouches-du-Rhône'),
(69, 'Rhône'),
(6, 'Alpes-Maritimes'),
(33, 'Gironde'),
(44, 'Loire-Atlantique'),
(67, 'Bas-Rhin'),
(31, 'Haute-Garonne');


INSERT INTO villes (id_ville, nom, id_departement) VALUES
(1, 'Paris', 75),
(2, 'Lille', 59),
(3, 'Marseille', 13),
(4, 'Lyon', 69),
(5, 'Nice', 6),
(6, 'Bordeaux', 33),
(7, 'Nantes', 44),
(8, 'Strasbourg', 67),
(9, 'Toulouse', 31);

INSERT INTO gares (id_gare, nom, id_ville) VALUES
(1, 'Gare de Lyon', 1),
(2, 'Gare du Nord', 1),
(3, 'Gare de Lille', 2),
(4, 'Gare de Marseille', 3),
(5, 'Gare de Nice', 5),
(6, 'Gare de Lyon-Part-Dieu', 4),
(7, 'Gare de Bordeaux', 6),
(8, 'Gare de Nantes', 7),
(9, 'Gare de Strasbourg', 8),
(10, 'Gare de Toulouse', 9);

INSERT INTO quais (id_quai, id_gare, nom) VALUES
(1, 1, 'Quai 1'), (2, 1, 'Quai 2'),
(3, 2, 'Quai 1'), (4, 2, 'Quai 2'),
(5, 3, 'Quai 1'), (6, 3, 'Quai 2'),
(7, 4, 'Quai 1'), (8, 4, 'Quai 2'),
(9, 5, 'Quai 1'), (10, 5, 'Quai 2'),
(11, 6, 'Quai 1'), (12, 6, 'Quai 2'),
(13, 7, 'Quai 1'), (14, 7, 'Quai 2'),
(15, 8, 'Quai 1'), (16, 8, 'Quai 2'),
(17, 9, 'Quai 1'), (18, 9, 'Quai 2'),
(19, 10, 'Quai 1'), (20, 10, 'Quai 2');


INSERT INTO liaisons (id_liaison, id_quai1, id_quai2) VALUES
(1, 1, 3),   -- Paris -> Lille
(2, 3, 5),   -- Lille -> Marseille
(3, 7, 9),   -- Marseille -> Nice
(4, 1, 11),  -- Paris -> Lyon
(5, 11, 7),  -- Lyon -> Marseille
(6, 1, 13),  -- Paris -> Bordeaux
(7, 13, 15), -- Bordeaux -> Nantes
(8, 1, 17),  -- Paris -> Strasbourg
(9, 1, 19),  -- Paris -> Toulouse
(10, 17, 19); -- Strasbourg -> Toulouse

-- Insertion des lignes
INSERT INTO lignes (id_ligne, nom) VALUES
(1, 'Ligne Paris-Lille'),
(2, 'Ligne Lille-Marseille'),
(3, 'Ligne Marseille-Nice'),
(4, 'Ligne Paris-Lyon'),
(5, 'Ligne Lyon-Marseille'),
(6, 'Ligne Paris-Bordeaux'),
(7, 'Ligne Bordeaux-Nantes'),
(8, 'Ligne Paris-Strasbourg'),
(9, 'Ligne Paris-Toulouse'),
(10, 'Ligne Strasbourg-Toulouse');


INSERT INTO trains (id_train, type_train, id_ligne_habituelle, capacite) VALUES
(1, 'TGV', 1, 500),
(2, 'TER', 2, 200),
(3, 'Intercite', 3, 300),
(4, 'TGV', 4, 500),
(5, 'TER', 5, 200),
(6, 'TGV', 6, 500),
(7, 'TER', 7, 200),
(8, 'TGV', 8, 500),
(9, 'TGV', 9, 500),
(10, 'Intercite', 10, 300),
(11, 'TGV', 10, 500);

INSERT INTO incidents (id_incident, type_incident, gravite, description) VALUES
(1, 'Déraillement', 'avec impact', 'Déraillement sur Paris-Lille'),
(2, 'Panne électrique', 'sans impact', 'Panne sur Lille-Marseille'),
(3, 'Grève', 'avec impact', 'Grève sur Marseille-Nice'),
(4, 'Incident technique', 'avec impact', 'Problème signalé sur Bordeaux-Nantes'),
(5, 'Accident voyageur', 'avec impact', 'Accident à la Gare de Lyon'),
(6, 'Retard', 'sans impact', 'Retard sur Paris-Strasbourg'),
(7, 'Grève', 'avec impact', 'Grève sur Paris-Toulouse');


INSERT INTO incidents_lignes (id_ligne, id_incident, compte_rendu, date_heure_debut) VALUES
(1, 1, 'Déraillement signalé', '2023-10-01 09:00:00'),
(2, 2, 'Panne électrique', '2023-10-01 11:00:00'),
(3, 3, 'Grève en cours', '2023-10-01 16:00:00'),
(7, 4, 'Incident technique', '2023-10-02 10:00:00'),
(8, 6, 'Retard important', '2023-10-02 14:00:00'),
(9, 7, 'Grève des conducteurs', '2023-10-03 08:00:00');


INSERT INTO incidents_gares (id_gare, id_incident, compte_rendu, date_heure_debut) VALUES
(1, 5, 'Accident voyageur', '2023-10-01 09:00:00'),
(6, 4, 'Incident technique', '2023-10-02 10:00:00');


INSERT INTO incidents_quais (id_quai, id_incident, compte_rendu, date_heure_debut) VALUES
(1, 5, 'Accident voyageur', '2023-10-01 09:00:00'),
(13, 4, 'Incident technique', '2023-10-02 10:00:00');


INSERT INTO incidents_trains (id_train, id_incident, compte_rendu, date_heure_debut) VALUES
(1, 1, 'Déraillement', '2023-10-01 09:00:00'),
(6, 4, 'Incident technique', '2023-10-02 10:00:00'),
(4, 2, 'Panne électrique sur Marseille-Lille', '2023-10-02 16:00:00'), 
(4, 6, 'Retard sur Paris-Strasbourg', '2023-10-02 17:00:00'),
(4, 2, 'Panne sur la ligne Paris-Toulouse', '2023-10-02 18:00:00');


INSERT INTO equipements (id_equipement, libele) VALUES
(1, 'Ascenseur'),
(2, 'Escalator'),
(3, 'Billeterie'),
(4, 'Distributeur de billets'),
(5, 'Toilettes');

INSERT INTO equipements_gares (id_gare, id_equipement, emplacement, quantite_total, quantite_operationelle) VALUES
(1, 1, 'Hall principal', 2, 2),
(1, 2, 'Quai 1', 1, 1),
(2, 3, 'Entrée nord', 3, 2),
(6, 1, 'Quai 2', 1, 1),
(6, 2, 'Entrée principale', 2, 1),
(7, 3, 'Hall', 2, 2),
(9, 4, 'Hall', 3, 3),
(10, 5, 'Quai 1', 2, 2);

-- Insertion des maintenances avec date de fin pour certains trains
INSERT INTO maintenances (id_maintenance, id_train, date_heure_debut_maintenance, date_heure_fin_maintenance) VALUES
(1, 1, '2023-09-01 07:00:00', '2023-09-01 09:00:00'), -- Train 1, maintenance finie
(2, 4, '2023-10-01 12:00:00', '2023-10-01 14:00:00'), -- Train 4, maintenance finie
(3, 6, '2023-10-02 05:00:00', '2023-10-02 07:00:00'), -- Train 6, maintenance finie
(4, 2, '2023-09-10 08:00:00', NULL), -- Train 2, maintenance non finie
(5, 3, '2023-09-12 10:00:00', NULL), -- Train 3, maintenance non finie
(6, 5, '2023-09-15 14:00:00', NULL), -- Train 5, maintenance non finie
(7, 7, '2023-09-17 16:00:00', NULL), -- Train 7, maintenance non finie
(8, 8, '2023-09-20 18:00:00', NULL), -- Train 8, maintenance non finie
(9, 9, '2023-09-25 06:00:00', NULL), -- Train 9, maintenance non finie
(10, 10, '2023-09-28 09:00:00', NULL), -- Train 10, maintenance non finie
(11, 11, '2023-09-08 07:00:00', '2023-09-10 12:00:00');

-- Insertion des incidents associés aux maintenances
INSERT INTO incidents_maintenances (id_maintenance, id_incident) VALUES
(1, 1),  -- Train 1, maintenance terminée, incident associé
(2, 5),  -- Train 4, maintenance terminée, incident associé
(3, 4);  -- Train 6, maintenance terminée, incident associé


INSERT INTO trajets (id_trajet, id_train, id_liaison, date_heure_depart_prevue, date_heure_arrive_prevue, date_heure_depart_reelle, date_heure_arrive_reelle) VALUES

(1, 1, 1, '2023-10-01 08:00:00', '2023-10-01 10:00:00', '2023-10-01 08:05:00', '2023-10-01 10:05:00'), -- Paris-Lille
(2, 4, 4, '2023-10-01 07:30:00', '2023-10-01 10:30:00', '2023-10-01 07:35:00', '2023-10-01 10:35:00'), -- Paris-Lyon
(3, 6, 6, '2023-10-02 08:15:00', '2023-10-02 11:15:00', '2023-10-02 08:20:00', '2023-10-02 11:20:00'), -- Paris-Bordeaux
(4, 8, 8, '2023-10-02 07:45:00', '2023-10-02 10:45:00', '2023-10-02 07:50:00', '2023-10-02 10:50:00'), -- Paris-Strasbourg

(5, 2, 2, '2023-10-01 17:30:00', '2023-10-01 22:00:00', '2023-10-01 17:35:00', '2023-10-01 22:05:00'), -- Lille-Marseille
(6, 5, 5, '2023-10-01 18:00:00', '2023-10-01 21:00:00', '2023-10-01 18:05:00', '2023-10-01 21:05:00'), -- Lyon-Marseille
(7, 7, 7, '2023-10-02 17:15:00', '2023-10-02 20:15:00', '2023-10-02 17:20:00', '2023-10-02 20:20:00'), -- Bordeaux-Nantes
(8, 9, 9, '2023-10-03 18:30:00', '2023-10-03 21:30:00', '2023-10-03 18:35:00', '2023-10-03 21:35:00'), -- Paris-Toulouse

(9, 3, 3, '2023-10-01 12:00:00', '2023-10-01 15:00:00', '2023-10-01 12:05:00', '2023-10-01 15:05:00'), -- Marseille-Nice
(10, 10, 10, '2023-10-03 14:00:00', '2023-10-03 17:00:00', '2023-10-03 14:05:00', '2023-10-03 17:05:00'), -- Strasbourg-Toulouse

(11, 11, 1, '2023-09-06 08:00:00', '2023-09-06 12:00:00', '2023-09-06 08:15:00', '2023-09-06 12:30:00'),  -- 4h
(12, 11, 2, '2023-09-07 10:00:00', '2023-09-07 16:00:00', '2023-09-07 10:10:00', '2023-09-07 16:20:00'),  -- 6h
(13, 11, 3, '2023-09-08 09:00:00', '2023-09-08 15:00:00', '2023-09-08 09:05:00', '2023-09-08 15:15:00'),  -- 6h
(14, 11, 4, '2023-09-09 07:00:00', '2023-09-09 13:00:00', '2023-09-09 07:10:00', '2023-09-09 13:20:00'),  -- 6h
(15, 11, 5, '2023-09-10 11:00:00', '2023-09-10 17:00:00', '2023-09-10 11:05:00', '2023-09-10 17:15:00'),  -- 6h
(16, 11, 6, '2023-09-11 06:00:00', '2023-09-11 12:00:00', '2023-09-11 06:05:00', '2023-09-11 12:10:00'),  -- 6h
(17, 11, 7, '2023-09-12 08:00:00', '2023-09-12 14:00:00', '2023-09-12 08:05:00', '2023-09-12 14:10:00');  -- 6h




