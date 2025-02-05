WITH RECURSIVE trajets_possibles AS (
    -- trajets directs depuis gare départ
    SELECT 
        t.id_trajet,
        t.id_train,
        t.id_liaison,
        l.id_quai1 AS quai_depart,
        l.id_quai2 AS quai_arrivee,
        t.date_heure_depart_prevue,
        t.date_heure_arrive_prevue,
        ARRAY[t.id_trajet] AS chemin_trajets, -- stock pour éviter redondance 
        0 AS nb_correspondances  -- 0 correspondances au début
    FROM trajets t
    JOIN liaisons l ON t.id_liaison = l.id_liaison


    UNION ALL

    -- cherche trajet partant de la gare d'arrivée du trajet précédent
    SELECT 
        t.id_trajet,
        t.id_train,
        t.id_liaison,
        tp.quai_arrivee AS quai_depart,
        l.id_quai2 AS quai_arrivee,
        t.date_heure_depart_prevue,
        t.date_heure_arrive_prevue,
        tp.chemin_trajets || t.id_trajet,
        tp.nb_correspondances + 1 AS nb_correspondances
    FROM trajets t
    JOIN liaisons l ON t.id_liaison = l.id_liaison
    JOIN trajets_possibles tp ON tp.quai_arrivee = l.id_quai1
    WHERE t.date_heure_depart_prevue >= tp.date_heure_arrive_prevue + INTERVAL '10 minutes' -- correspondance avec suffisament de temps
    AND NOT t.id_trajet = ANY(tp.chemin_trajets)  -- impossible de reprendre un trajet précédement utilisé
)

SELECT * 
FROM trajets_possibles 
WHERE quai_arrivee IN (SELECT id_quai FROM quais WHERE id_gare = 10)
AND quai_depart IN (SELECT id_quai FROM quais WHERE id_gare = 1)
ORDER BY nb_correspondances ASC, (date_heure_depart_prevue - date_heure_arrive_prevue) ASC;
