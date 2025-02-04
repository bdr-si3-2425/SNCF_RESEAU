-- Fonction qui gère la mise en maintenance pour les incidents avec impact ou 3 incidents sans impact
CREATE OR REPLACE FUNCTION gestion_maintenance_incidents() 
RETURNS TRIGGER AS $maintenances_incidents$
DECLARE
    incident_gravite GRAVITE_TYPE;
    incident_count INT;
    maintenance_count INT;
    last_maintenance_date TIMESTAMP;
BEGIN
    -- Récupérer la gravité de l'incident concerné
    SELECT gravite INTO incident_gravite
    FROM incidents
    WHERE id_incident = NEW.id_incident;

    -- Vérifier si le train est déjà en maintenance (non terminé)
    SELECT COUNT(*) INTO maintenance_count
    FROM maintenances
    WHERE id_train = NEW.id_train
    AND date_heure_fin_maintenance IS NULL; -- On considère qu'un train est en maintenance tant qu'il n'a pas de date de fin

    -- Si le train est déjà en maintenance, ne rien faire
    IF maintenance_count > 0 THEN
        RETURN NEW; -- Pas de modification, on quitte la fonction
    END IF;

    -- Récupérer la date de la dernière maintenance pour le train concerné
    SELECT date_heure_fin_maintenance INTO last_maintenance_date
    FROM maintenances
    WHERE id_train = NEW.id_train
    ORDER BY date_heure_fin_maintenance DESC
    LIMIT 1;

    -- Si l'incident a un impact, on met directement le train en maintenance
    IF incident_gravite = 'avec impact' THEN
        -- Créer une entrée de maintenance pour le train concerné
        INSERT INTO maintenances (id_train, date_heure_debut_maintenance)
        VALUES (NEW.id_train, CURRENT_TIMESTAMP);
    
    -- Sinon, on compte les incidents sans impact après la dernière maintenance
    ELSE
        -- Compter le nombre d'incidents sans impact depuis la dernière maintenance
        SELECT COUNT(*) INTO incident_count
        FROM incidents_trains it
        JOIN incidents i ON it.id_incident = i.id_incident
        WHERE it.id_train = NEW.id_train
        AND i.gravite = 'sans impact'
        AND it.date_heure_debut >= last_maintenance_date;

        -- Si 3 incidents sans impact sont atteints, on met le train en maintenance
        IF incident_count >= 3 THEN
            INSERT INTO maintenances (id_train, date_heure_debut_maintenance)
            VALUES (NEW.id_train, CURRENT_TIMESTAMP);
        END IF;
    END IF;

    RETURN NEW;
END;
$maintenances_incidents$ LANGUAGE plpgsql;

-- Trigger qui appelle la fonction après l'insertion d'un incident
CREATE TRIGGER trigger_maintenance_incidents
AFTER INSERT ON incidents_trains
FOR EACH ROW
EXECUTE FUNCTION gestion_maintenance_incidents();
