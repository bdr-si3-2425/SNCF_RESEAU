CREATE OR REPLACE FUNCTION check_quais_differents_gare() 
RETURNS TRIGGER AS $quais_differents_gare$
DECLARE
    gare1 INT;
    gare2 INT;
BEGIN
    SELECT id_gare INTO gare1 FROM quais WHERE id_quai = NEW.id_quai1;
    SELECT id_gare INTO gare2 FROM quais WHERE id_quai = NEW.id_quai2;
    
    IF gare1 = gare2 THEN
        RAISE EXCEPTION 'Les deux quais d''une liaison doivent appartenir à des gares différentes';
    END IF;
    
    RETURN NEW;
END;
$quais_differents_gare$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_check_quais
BEFORE INSERT OR UPDATE ON liaisons
FOR EACH ROW
EXECUTE FUNCTION check_quais_differents_gare();
