WITH last_maintenance AS (
    -- Sélectionner la dernière maintenance terminée pour chaque train
    SELECT m.id_train, MAX(m.date_heure_fin_maintenance) AS last_maintenance_end
    FROM maintenances m
    WHERE m.date_heure_fin_maintenance IS NOT NULL  -- Assurer que la maintenance est terminée
    GROUP BY m.id_train
),
incidents_graves AS (
    -- Sélectionner les incidents graves avec impact après la dernière maintenance
    SELECT t.id_train, t.type_train, m.date_heure_debut_maintenance, m.date_heure_fin_maintenance,
           i.type_incident, i.gravite, it.date_heure_debut
    FROM trains t
    JOIN maintenances m ON t.id_train = m.id_train
    JOIN incidents_trains it ON t.id_train = it.id_train
    JOIN incidents i ON it.id_incident = i.id_incident
    JOIN last_maintenance lm ON t.id_train = lm.id_train
    WHERE i.gravite = 'avec impact'  -- Filtrer les incidents graves
      AND it.date_heure_debut > lm.last_maintenance_end  -- Incident survenu après la dernière maintenance terminée
),
incidents_sans_impact AS (
    -- Sélectionner les incidents sans impact après la dernière maintenance, et compter ceux qui sont >= 3
    SELECT t.id_train, COUNT(*) AS count_incidents_sans_impact
    FROM trains t
    JOIN maintenances m ON t.id_train = m.id_train
    JOIN incidents_trains it ON t.id_train = it.id_train
    JOIN incidents i ON it.id_incident = i.id_incident
    JOIN last_maintenance lm ON t.id_train = lm.id_train
    WHERE i.gravite = 'sans impact'  -- Filtrer les incidents sans impact
      AND it.date_heure_debut > lm.last_maintenance_end  -- Incident survenu après la dernière maintenance terminée
    GROUP BY t.id_train
    HAVING COUNT(*) >= 3  -- Filtrer pour n'inclure que les trains avec 3 ou plus d'incidents sans impact
),
temps_fonctionnement AS (
    -- Calculer le temps de fonctionnement total des trains après leur dernière maintenance
    SELECT t.id_train, 
           COALESCE(SUM(EXTRACT(EPOCH FROM (j.date_heure_arrive_reelle - j.date_heure_depart_reelle)) / 3600), 0) AS temps_fonctionnement
    FROM trains t
    JOIN trajets j ON t.id_train = j.id_train
    JOIN last_maintenance lm ON t.id_train = lm.id_train
    WHERE j.date_heure_depart_reelle > lm.last_maintenance_end  -- Trajets après la dernière maintenance terminée
    GROUP BY t.id_train
)
-- Récupérer les trains ayant des incidents graves ou des incidents sans impact (3 ou plus)
SELECT t.id_train, t.type_train
FROM trains t
JOIN incidents_graves ig ON t.id_train = ig.id_train
UNION
SELECT t.id_train, t.type_train
FROM trains t
JOIN incidents_sans_impact isi ON t.id_train = isi.id_train
UNION
SELECT t.id_train, t.type_train
FROM trains t
JOIN temps_fonctionnement tf ON t.id_train = tf.id_train
WHERE tf.temps_fonctionnement > 10; -- On choisit ici le seuil d'heure avant maintenance
