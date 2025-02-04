WITH Ligne_Impactee AS (
    SELECT id_ligne
    FROM incidents_lignes
    WHERE id_ligne = {ID_LIGNE_INCIDENT}
      AND date_heure_fin IS NULL
),
Gares_Impactees AS (
    SELECT ig.id_gare
    FROM incidents_gares ig
    JOIN incidents i ON ig.id_incident = i.id_incident
    WHERE i.gravite = 'avec impact'
      AND date_heure_fin IS NULL
    UNION
    SELECT q.id_gare
    FROM incidents_quais iq
    JOIN quais q ON iq.id_quai = q.id_quai
    JOIN incidents i ON iq.id_incident = i.id_incident
    WHERE i.gravite = 'avec impact'
      AND date_heure_fin IS NULL
),
Liaisons_Impactees AS (
    SELECT ll.id_liaison
    FROM lignes_liaisons ll
    JOIN incidents_lignes il ON ll.id_ligne = il.id_ligne
    WHERE il.id_ligne = {ID_LIGNE_INCIDENT}
      AND date_heure_fin IS NULL
),
Trajets_Alternatifs AS (
    SELECT DISTINCT 
        t.id_train, 
        t.type_train, 
        tr.id_liaison, 
        g1.nom AS gare_depart, 
        g2.nom AS gare_arrivee
    FROM trajets tr
    JOIN liaisons li ON tr.id_liaison = li.id_liaison
    JOIN quais q1 ON li.id_quai1 = q1.id_quai
    JOIN quais q2 ON li.id_quai2 = q2.id_quai
    JOIN gares g1 ON q1.id_gare = g1.id_gare
    JOIN gares g2 ON q2.id_gare = g2.id_gare
    JOIN trains t ON tr.id_train = t.id_train
    LEFT JOIN Gares_Impactees gi ON gi.id_gare IN (q1.id_gare, q2.id_gare)
    LEFT JOIN Liaisons_Impactees lii ON lii.id_liaison = tr.id_liaison
    WHERE gi.id_gare IS NULL
    AND lii.id_liaison IS NULL
)
SELECT * FROM Trajets_Alternatifs
ORDER BY gare_depart, gare_arrivee;
