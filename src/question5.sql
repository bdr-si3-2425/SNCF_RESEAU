WITH Ligne_Impactee AS (
    SELECT id_ligne
    FROM lignes
    WHERE id_ligne = {ID_LIGNE_INCIDENT} -- Remplacer par l'ID de la ligne impactée
),
Gares_Impactees AS (
    SELECT q.id_gare
    FROM liaisons li
    JOIN quais q ON q.id_quai IN (li.id_quai1, li.id_quai2)
    JOIN lignes_liaisons ll ON li.id_liaison = ll.id_liaison
    WHERE ll.id_ligne = {ID_LIGNE_INCIDENT}
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
    WHERE NOT EXISTS (
        SELECT 1 
        FROM Gares_Impactees gi 
        WHERE gi.id_gare IN (q1.id_gare, q2.id_gare)
    ) -- Exclure les trajets passant par une gare impactée
)
SELECT * FROM Trajets_Alternatifs
ORDER BY gare_depart, gare_arrivee;
