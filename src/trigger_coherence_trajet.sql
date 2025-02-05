CREATE OR REPLACE FUNCTION check_coherence_trajet()
RETURN TRIGGER AS $coherence_trajet$
	DECLARE
		last_trajet_date_heure_arrive TIMESTAMP;
	BEGIN
		