-- Fonction qui gère la mise en maintenance en fonction du temps roulé
CREATE OR REPLACE FUNCTION gestion_maintenance_temps_fonctionnement() 
RETURNS TRIGGER AS $maintenance_temps_fonctionnement$
DECLARE
    total_roule_hours DOUBLE PRECISION := 0;  -- Temps total roulé en heures
    maintenance_count INT;  -- Compteur pour vérifier si le train est déjà en maintenance
    last_maintenance_date TIMESTAMP;  -- Date de la dernière maintenance
    first_trajet_date TIMESTAMP;  -- Date du premier trajet du train
    seuil_roule DOUBLE PRECISION := 100; -- Seuil de temps roulé en heures
BEGIN
    -- Vérifier si le train est déjà en maintenance (non terminé)
    SELECT COUNT(*) INTO maintenance_count
    FROM maintenances
    WHERE id_train = NEW.id_train
    AND date_heure_fin_maintenance IS NULL; -- Si une maintenance est en cours, on ne fait rien

    -- Si le train est déjà en maintenance, on quitte la fonction
    IF maintenance_count > 0 THEN
        RETURN NEW; -- Pas de modification, on quitte la fonction
    END IF;

    -- Récupérer la date de la dernière maintenance terminée pour le train concerné
    SELECT date_heure_fin_maintenance INTO last_maintenance_date
    FROM maintenances
    WHERE id_train = NEW.id_train
    ORDER BY date_heure_fin_maintenance DESC
    LIMIT 1;

    -- Si aucune maintenance n'a été trouvée, récupérer la date du premier trajet du train
    IF last_maintenance_date IS NULL THEN
        SELECT MIN(date_heure_depart_reelle) INTO first_trajet_date
        FROM trajets
        WHERE id_train = NEW.id_train
        AND date_heure_depart_reelle IS NOT NULL; -- On ignore les trajets avec un départ nul

        -- Si aucun trajet n'existe, on quitte la fonction
        IF first_trajet_date IS NULL THEN
            RETURN NEW; -- Pas de modification, on quitte la fonction
        END IF;

        -- Sinon, la date de la dernière maintenance devient la date du premier trajet
        last_maintenance_date := first_trajet_date;
    END IF;

    -- Calculer le temps roulé depuis la dernière maintenance
    SELECT COALESCE(SUM(EXTRACT(EPOCH FROM (date_heure_arrive_reelle - date_heure_depart_reelle)) / 3600), 0) 
    INTO total_roule_hours
    FROM trajets
    WHERE id_train = NEW.id_train
    AND date_heure_depart_reelle >= last_maintenance_date  -- Seulement les trajets après la dernière maintenance
    AND date_heure_depart_reelle IS NOT NULL  -- Ignorer les trajets avec une date de départ nulle
    AND date_heure_arrive_reelle IS NOT NULL;  -- Ignorer les trajets avec une date d'arrivée nulle

    -- Si le temps roulé dépasse le seuil, mettre le train en maintenance
    IF total_roule_hours >= seuil_roule THEN
        -- Créer une entrée de maintenance pour le train concerné
        INSERT INTO maintenances (id_train, date_debut_maintenance)
        VALUES (NEW.id_train, CURRENT_TIMESTAMP);
    END IF;

    RETURN NEW;
END;
$maintenance_temps_fonctionnement$ LANGUAGE plpgsql;

-- Trigger qui appelle la fonction après l'insertion d'un trajet
CREATE TRIGGER trigger_maintenance_temps_fonctionnement
AFTER INSERT ON trajets
FOR EACH ROW
EXECUTE FUNCTION gestion_maintenance_temps_fonctionnement();
