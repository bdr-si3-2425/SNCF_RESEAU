CREATE OR REPLACE FUNCTION check_coherence_trajet_add()
RETURNS TRIGGER AS $coherence_trajet_add$
	DECLARE
		last_trajet_date_heure_arrive TIMESTAMP;
		last_quai INT;
		next_quai INT;
	BEGIN
		-- Récupérer la dernière gare d'arrivée du train
	    SELECT t.date_heure_arrive_prevue, l.id_quai2
	    INTO last_trajet_date_heure_arrive, last_quai
	    FROM trajets t
	    JOIN liaisons l ON t.id_liaison = l.id_liaison
	    WHERE t.id_train = NEW.id_train
			AND t.id_trajet <> NEW.id_trajet
	    ORDER BY t.date_heure_arrive_prevue DESC
	    LIMIT 1;
	
	    -- Récupérer le quai de départ du nouveau trajet
	    SELECT l.id_quai1
	    INTO next_quai
	    FROM liaisons l
	    WHERE l.id_liaison = NEW.id_liaison;
	
	    -- Vérifier si un trajet précédent existe
	    IF last_trajet_date_heure_arrive IS NOT NULL THEN
	        -- Vérifier que le départ du nouveau trajet est après la fin du dernier trajet
	        IF NEW.date_heure_depart_prevue <= last_trajet_date_heure_arrive THEN
	            RAISE EXCEPTION 'Le train ne peut pas partir avant la fin de son dernier trajet';
	        END IF;
	
	        -- Vérifier que le trajet commence là où le train a fini
	        IF last_quai IS DISTINCT FROM next_quai THEN
	            RAISE EXCEPTION 'Le train ne part pas de là où il est arrivé précédemment';
	        END IF;
	    END IF;
    RETURN NEW;
END;
$coherence_trajet_add$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION check_update_depart_reelle()
RETURNS TRIGGER AS $update_depart_reelle$
DECLARE
    last_trajet_date_heure_arrive TIMESTAMP;
BEGIN
    -- Récupérer la dernière heure d'arrivée du train (avant ce trajet)
    SELECT t.date_heure_arrive_reelle
    INTO last_trajet_date_heure_arrive
    FROM trajets t
    WHERE t.id_train = NEW.id_train
      AND t.id_trajet <> NEW.id_trajet  -- Exclure le trajet en cours de modification
      AND t.date_heure_arrive_reelle IS NOT NULL
    ORDER BY t.date_heure_arrive_reelle DESC
    LIMIT 1;

	IF NEW.date_heure_depart_reelle IS NOT NULL AND last_trajet_date_heure_arrive_reelle IS NULL THEN
        RAISE EXCEPTION 'Impossible de renseigner une heure de départ réelle tant que le trajet précédent n''a pas d''heure d''arrivée réelle';
    END IF;

    -- Vérifier si une arrivée précédente existe
    IF last_trajet_date_heure_arrive IS NOT NULL THEN
        -- Vérifier que l'heure de départ réelle est bien après la dernière arrivée
        IF NEW.date_heure_depart_reelle <= last_trajet_date_heure_arrive THEN
            RAISE EXCEPTION 'L''heure de départ réelle doit être postérieure à la dernière arrivée du train';
        END IF;
    END IF;

    RETURN NEW;
END;
$update_depart_reelle$ LANGUAGE plpgsql;

CREATE TRIGGER verif_trajet_coherent
BEFORE INSERT ON trajets
FOR EACH ROW
EXECUTE FUNCTION check_coherence_trajet_add();

CREATE TRIGGER verif_update_depart_reelle
BEFORE UPDATE OF date_heure_depart_reelle ON trajets
FOR EACH ROW
EXECUTE FUNCTION check_update_depart_reelle();


		
		