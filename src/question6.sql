CREATE VIEW trains_disponibles AS
    -- Sélectionner les trains disponibles (pas en maintenance)
    SELECT t.id_train, t.id_ligne_habituelle, t.type_train, t.capacite, l.nom AS ligne_habituelle
    FROM trains t
    JOIN lignes l ON t.id_ligne_habituelle = l.id_ligne
    LEFT JOIN maintenances m ON t.id_train = m.id_train 
        AND m.date_heure_fin_maintenance IS NULL
    WHERE m.id_maintenance IS NULL;

WITH ligne_en_panne AS (
    -- Trouver une ligne ayant un incident grave en cours
    SELECT il.id_ligne
    FROM incidents_lignes il
    JOIN incidents i ON il.id_incident = i.id_incident
    WHERE i.gravite = 'avec impact' 
      AND il.date_heure_fin IS NULL
    LIMIT 1
),
ligne_panne_details AS (
    -- Récupérer le type et les caractéristiques de la ligne en panne
    SELECT lp.id_ligne, COUNT(DISTINCT t.id_train) AS nombre_de_trains, MAX(t.capacite) AS capacite_max
    FROM lignes lp
    LEFT JOIN trains t ON lp.id_ligne = t.id_ligne_habituelle
    WHERE lp.id_ligne IN (SELECT id_ligne FROM ligne_en_panne)
    GROUP BY lp.id_ligne
),
trains_proches AS (
    -- Identifier les trains proches de la ligne en panne
    SELECT td.*, g.id_gare, g.nom AS gare_actuelle
    FROM trains_disponibles td
    JOIN trajets tr ON td.id_train = tr.id_train
    JOIN liaisons li ON tr.id_liaison = li.id_liaison
    JOIN quais q ON li.id_quai1 = q.id_quai OR li.id_quai2 = q.id_quai
    JOIN gares g ON q.id_gare = g.id_gare
    WHERE tr.date_heure_arrive_reelle IS NOT NULL -- Le train est déjà arrivé
)
-- Sélectionner les trains compatibles, disponibles et proches
SELECT tp.id_train, tp.type_train, tp.capacite, tp.ligne_habituelle, tp.gare_actuelle
FROM trains_proches tp
WHERE tp.id_ligne_habituelle NOT IN (SELECT id_ligne FROM ligne_en_panne)
AND tp.capacite >= (SELECT capacite_max FROM ligne_panne_details);