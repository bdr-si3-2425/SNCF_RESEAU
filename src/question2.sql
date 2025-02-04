SELECT DISTINCT t.id_train, t.type_train
FROM trains t
JOIN incidents_trains it ON t.id_train = it.id_train
JOIN incidents i ON it.id_incident = i.id_incident
WHERE it.date_heure_debut > (
    SELECT MAX(m.date_heure_fin_maintenance)
    FROM maintenances m
    WHERE m.id_train = t.id_train
    AND m.date_heure_fin_maintenance IS NOT NULL
)
ORDER BY t.id_train;
