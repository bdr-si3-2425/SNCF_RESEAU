WITH Trafic_Gares AS (
    SELECT 
        g.id_gare,
        g.nom AS nom_gare,
        COUNT(DISTINCT tr.id_train) AS nombre_trains,
        (SELECT COUNT(*) FROM quais q WHERE q.id_gare = g.id_gare) AS nbr_quai
    FROM gares g
    JOIN liaisons l ON g.id_gare IN (l.id_quai1, l.id_quai2)
    JOIN trajets tr ON l.id_liaison = tr.id_liaison
    WHERE 
        (tr.date_heure_depart_reelle::TIME BETWEEN '07:00:00' AND '09:00:00' 
        OR tr.date_heure_arrive_reelle::TIME BETWEEN '07:00:00' AND '09:00:00'
        OR tr.date_heure_depart_reelle::TIME BETWEEN '17:00:00' AND '19:00:00' 
        OR tr.date_heure_arrive_reelle::TIME BETWEEN '17:00:00' AND '19:00:00')
    GROUP BY g.id_gare, g.nom
),
Incidents_Gares AS (
    SELECT 
        ig.id_gare,
        COUNT(DISTINCT it.id_train) AS trains_impactes
    FROM incidents_gares ig
    JOIN incidents_trains it ON ig.id_incident = it.id_incident
    WHERE 
        (ig.date_heure_debut::TIME BETWEEN '07:00:00' AND '09:00:00' 
        OR ig.date_heure_debut::TIME BETWEEN '17:00:00' AND '19:00:00')
    GROUP BY ig.id_gare
),
Saturation_Gares AS (
    SELECT 
        tg.id_gare,
        tg.nom_gare,
        tg.nbr_quai,
        tg.nombre_trains + COALESCE(ig.trains_impactes, 0) AS total_trains
    FROM Trafic_Gares tg
    LEFT JOIN Incidents_Gares ig ON tg.id_gare = ig.id_gare
    WHERE (tg.nombre_trains + COALESCE(ig.trains_impactes, 0)) >= tg.nbr_quai
)
SELECT * FROM Saturation_Gares
ORDER BY total_trains DESC;
