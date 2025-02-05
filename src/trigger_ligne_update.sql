CREATE OR REPLACE FUNCTION check_insert_ligne()
RETURNS TRIGGER AS $add_ligne$
DECLARE
    last_liaison liaisons%ROWTYPE;
    visited_quais INTEGER[]; -- Tableau pour suivre les quais déjà visités
BEGIN
    -- Initialisation du tableau des quais visités
    visited_quais := ARRAY[NEW.id_quai1];

    -- Vérification si une liaison précédente existe pour vérifier le suivi
    SELECT * INTO last_liaison
    FROM liaisons
    WHERE id_quai2 = NEW.id_quai1
    ORDER BY id_liaison DESC
    LIMIT 1;
    
    -- Si la liaison précédente existe, vérifier que l'ordre des quais se suit bien
    IF FOUND THEN
        -- Vérification si la liaison précédente a la gare d'arrivée qui correspond à la gare de départ de la nouvelle liaison
        IF last_liaison.id_quai2 != NEW.id_quai1 THEN
            RAISE EXCEPTION 'Erreur : Les liaisons ne se suivent pas correctement.';
        END IF;
        
        -- Ajouter les quais visités de la liaison précédente dans le tableau des quais visités
        visited_quais := visited_quais || last_liaison.id_quai1;
    END IF;

    -- Vérifier que le quai de départ de la nouvelle liaison n'a pas déjà été visité
    IF NEW.id_quai2 = ANY (visited_quais) THEN
        RAISE EXCEPTION 'Erreur : Le quai % a déjà été visité dans ce trajet.', NEW.id_quai2;
    END IF;

    -- Retourner la ligne insérée
    RETURN NEW;
END;
$add_ligne$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_check_insert_ligne
BEFORE INSERT ON liaisons
FOR EACH ROW
EXECUTE FUNCTION check_insert_ligne();
