-- Vue sur les meilleures correspondances (le + de correspondances)
CREATE VIEW meilleures_correspondances AS
SELECT g.id_gare, g.nom_gare, COUNT(l.id_ligne) AS nombre_lignes
FROM gares g
JOIN lignes l ON g.id_gare IN (l.terminus1, l.terminus2)
GROUP BY g.id_gare, g.nom_gare
ORDER BY nombre_lignes DESC;

SELECT * from meilleures_correspondances;

/*
Cette requête permet d'ajouter une nouvelle ligne ferroviaire
en reliant deux gares optimales identifiées précédemment.
*/

INSERT INTO lignes (terminus1, terminus2)
VALUES (/*id_gare1*/, /*id_gare2*/);

--Exemple :

BEGIN;

-- Vérifie si les gares existent
SELECT id_gare FROM gares WHERE id_gare IN (5, 8);

-- Ajoute la nouvelle ligne
INSERT INTO lignes (terminus1, terminus2) VALUES (5, 8);

-- Vérifie si la ligne a bien été ajoutée
SELECT * FROM lignes WHERE terminus1 = 5 AND terminus2 = 8;

COMMIT;  -- Valide les changements
-- ROLLBACK; -- Annule si une erreur est détectée


--Vérification (voir si le réseau a été optimisé)
SELECT g.id_gare, g.nom, COUNT(l.id_ligne) AS nombre_lignes
FROM gares g
JOIN lignes l ON g.id_gare IN (l.terminus1, l.terminus2)
GROUP BY g.id_gare, g.nom
ORDER BY nombre_lignes DESC;


