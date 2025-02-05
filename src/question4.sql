DO $$  
DECLARE  
    new_ligne_id INT;
    new_train_id INT;
BEGIN  
    -- Vérifier si la ligne existe déjà
    SELECT id_ligne INTO new_ligne_id 
    FROM lignes 
    WHERE nom = 'Ligne Directe Optimisée';

    -- Si la ligne n'existe pas, on l'ajoute
    IF NOT FOUND THEN  
        INSERT INTO lignes (nom)  
        VALUES ('Ligne Directe Optimisée')  
        RETURNING id_ligne INTO new_ligne_id;  
    END IF;

    -- Associer la nouvelle ligne aux liaisons déjà utilisées par plusieurs trains  
    INSERT INTO lignes_liaisons (id_ligne, id_liaison)  
    SELECT new_ligne_id, id_liaison  
    FROM (  
        SELECT id_liaison  
        FROM trajets  
        GROUP BY id_liaison  
        HAVING COUNT(DISTINCT id_train) > 1  
        ORDER BY COUNT(*) DESC  
        LIMIT 10  
    ) AS subquery  
    ON CONFLICT DO NOTHING;  -- Empêcher les doublons  

    -- Vérifier si un train existe déjà sur cette ligne, sinon l'ajouter
    SELECT id_train INTO new_train_id 
    FROM trains
    WHERE id_ligne_habituelle = new_ligne_id AND type_train = 'TGV' LIMIT 1;

    -- Si le train n'existe pas, on l'ajoute
    IF NOT FOUND THEN
        INSERT INTO trains (type_train, id_ligne_habituelle, capacite)  
        VALUES ('TGV', new_ligne_id, 500)  
        RETURNING id_train INTO new_train_id;
    END IF;

    -- Planifier des trajets directs pour limiter les correspondances  
    INSERT INTO trajets (id_train, id_liaison, date_heure_depart_prevue, date_heure_arrive_prevue)  
    SELECT  
        new_train_id,  
        id_liaison,  
        '2025-02-06 07:00:00',  
        '2025-02-06 08:30:00'  
    FROM lignes_liaisons  
    WHERE id_ligne = new_ligne_id;

    -- Afficher un message de confirmation  
    RAISE NOTICE 'Nouvelle ligne créée avec succès : Ligne ID %', new_ligne_id;
END $$;