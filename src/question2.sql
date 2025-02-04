CREATE VIEW trains_maintenance AS
SELECT 
    t.id_train,
    t.type_train,
    COALESCE(SUM(EXTRACT(EPOCH FROM (tr.date_heure_arrive_reelle - tr.date_heure_depart_reelle)) / 3600), 0) AS total_roule_hours,
    im.id_incident AS incident_avec_impact
FROM 
    trains t
LEFT JOIN trajets tr ON t.id_train = tr.id_train
LEFT JOIN maintenances m ON t.id_train = m.id_train
LEFT JOIN incidents_trains it ON t.id_train = it.id_train
LEFT JOIN incidents i ON it.id_incident = i.id_incident AND i.gravite = 'avec impact'
LEFT JOIN incidents_maintenances im ON im.id_incident = i.id_incident
WHERE 
    (tr.date_heure_depart_reelle IS NOT NULL AND tr.date_heure_arrive_reelle IS NOT NULL)
GROUP BY 
    t.id_train, t.type_train, im.id_incident
HAVING 
    (COALESCE(SUM(EXTRACT(EPOCH FROM (tr.date_heure_arrive_reelle - tr.date_heure_depart_reelle)) / 3600), 0) >= 100 
    OR im.id_incident IS NOT NULL);