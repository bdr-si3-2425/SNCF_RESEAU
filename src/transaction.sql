BEGIN;  -- Démarrer la transaction

-- Étape 1 : Insérer un nouvel incident
INSERT INTO Incidents (type, description, gravite)
VALUES ('Panne mécanique', 'Le train est immobilisé sur la voie.', 'grave')
RETURNING id_incident;  -- On récupère l'ID généré

-- Supposons que l'ID de l'incident inséré est 10
-- Étape 2 : Insérer l’incident dans la table Survenir
INSERT INTO Survenir (id_gare, id_ligne, id_train, id_incident, compte_rendu, impact, date_heure)
VALUES (3, 1, 5, 10, 'Réparation en cours', 'Retard de 1h', NOW());
END;

COMMIT;
