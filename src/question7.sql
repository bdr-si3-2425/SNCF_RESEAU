WITH incidents_tous AS (
    SELECT id_incident, date_heure_debut, date_heure_fin FROM incidents_lignes
    UNION ALL
    SELECT id_incident, date_heure_debut, date_heure_fin FROM incidents_trains
    UNION ALL
    SELECT id_incident, date_heure_debut, date_heure_fin FROM incidents_gares
    UNION ALL
    SELECT id_incident, date_heure_debut, date_heure_fin FROM incidents_quais
    UNION ALL
    SELECT im.id_incident, m.date_heure_debut_maintenance, m.date_heure_fin_maintenance 
    FROM incidents_maintenances im
    JOIN maintenances m ON im.id_maintenance = m.id_maintenance
)

SELECT 
    i.type_incident, 
    COUNT(t.id_trajet) AS nombre_trajets_affectes,
    SUM(EXTRACT(EPOCH FROM (t.date_heure_arrive_reelle - t.date_heure_arrive_prevue))) / 60 AS retard_total_minutes
FROM incidents i
JOIN incidents_tous it ON i.id_incident = it.id_incident
JOIN trajets t ON t.date_heure_depart_reelle IS NOT NULL 
  AND t.date_heure_arrive_reelle IS NOT NULL
  AND it.date_heure_debut <= t.date_heure_depart_reelle 
  AND (it.date_heure_fin IS NULL OR it.date_heure_fin >= t.date_heure_arrive_reelle)
GROUP BY i.type_incident
ORDER BY retard_total_minutes DESC
LIMIT 5;
