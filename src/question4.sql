-- 1. Ajouter la nouvelle ligne (vérifier si le nom est unique)
WITH new_ligne AS (
    SELECT id_ligne FROM lignes WHERE nom = 'Nouvelle Ligne' LIMIT 1
)
-- Si la ligne n'existe pas déjà, on l'ajoute
INSERT INTO lignes (nom) 
SELECT 'Nouvelle Ligne'
WHERE NOT EXISTS (SELECT 1 FROM new_ligne);

-- 2. Ajouter les liaisons entre les quais existants et la nouvelle ligne
WITH new_ligne AS (
    SELECT id_ligne FROM lignes WHERE nom = 'Nouvelle Ligne' LIMIT 1
)
-- Vérifier si la liaison n'existe pas déjà avant d'ajouter
INSERT INTO liaisons (id_quai1, id_quai2)
SELECT 11, 12  -- Remplacer par les ID des quais existants
FROM new_ligne
WHERE NOT EXISTS (
    SELECT 1 FROM liaisons 
    WHERE id_quai1_norm = LEAST(11, 12) 
    AND id_quai2_norm = GREATEST(11, 12)
);

-- 3. Ajouter un train à la nouvelle ligne
WITH new_ligne AS (
    SELECT id_ligne FROM lignes WHERE nom = 'Nouvelle Ligne' LIMIT 1
)
INSERT INTO trains (type_train, id_ligne_habituelle, capacite)
SELECT 'TGV', id_ligne, 500
FROM new_ligne;

-- 4. Ajouter un trajet pour ce train
WITH new_train AS (
    SELECT id_train FROM trains WHERE type_train = 'TGV' LIMIT 1
),
new_liaison AS (
    SELECT id_liaison FROM liaisons WHERE id_quai1 = 11 AND id_quai2 = 12 LIMIT 1
)
INSERT INTO trajets (id_train, id_liaison, date_heure_depart_prevue, date_heure_arrive_prevue)
SELECT id_train, id_liaison, '2025-03-01 08:00:00', '2025-03-01 09:00:00'
FROM new_train, new_liaison;

-- 5. Ajouter un incident pour la nouvelle ligne (vérifier s'il existe déjà)
-- Vérifier si l'incident existe déjà avant de l'ajouter
INSERT INTO incidents (type_incident, gravite, description)
SELECT 'Incident Test', 'avec impact', 'Problème technique sur la nouvelle ligne'
WHERE NOT EXISTS (
    SELECT 1 FROM incidents 
    WHERE type_incident = 'Incident Test' 
    AND description = 'Problème technique sur la nouvelle ligne'
) RETURNING id_incident;

-- 6. Ajouter l'incident dans la table incidents_lignes (séparer de l'insertion de l'incident)
INSERT INTO incidents_lignes (id_ligne, id_incident, compte_rendu, date_heure_debut)
SELECT id_ligne, id_incident, 'Problème de signalisation', '2025-02-05 12:00:00'
FROM lignes, incidents
WHERE nom = 'Nouvelle Ligne' AND type_incident = 'Incident Test' 
AND description = 'Problème technique sur la nouvelle ligne';
