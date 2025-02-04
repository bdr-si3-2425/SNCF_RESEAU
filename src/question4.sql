-- Vue sur les gares ayant au moins 1 correspondances
CREATE VIEW meilleures_correspondances AS
SELECT g.id_gare, g.nom, COUNT(DISTINCT l.id_ligne) AS nombre_de_lignes
FROM gares g
JOIN quais q ON g.id_gare = q.id_gare
JOIN liaisons li ON q.id_quai IN (li.id_quai1, li.id_quai2)
JOIN lignes_liaisons ll ON li.id_liaison = ll.id_liaison
GROUP BY g.id_gare, g.nom
HAVING COUNT(DISTINCT l.id_ligne) > 1
ORDER BY nombre_de_lignes DESC;

SELECT * from meilleures_correspondances;

/*
Cette requête permet d'ajouter une nouvelle ligne ferroviaire
en reliant deux gares optimales identifiées précédemment.
*/


--Insertion de la nouvelle ligne :

INSERT INTO lignes (nom) VALUES ('Nouvelle Ligne Express');

--Insertion de nouvelles gares en fonction des résultats de la requête précédente :

INSERT INTO gares (nom, id_ville) 
VALUES ('Nouvelle Gare X', 3), ('Nouvelle Gare Y', 4);

--Ajout des quais dans ces gares :

INSERT INTO quais (id_gare, nom) 
VALUES (1, 'Quai X1'), (2, 'Quai Y1');

--Ajout des liaisons avec des quais déjà existants pour assurer des correspondances :

INSERT INTO liaisons (id_quai1, id_quai2) 
VALUES (1, 5), (2, 8);

--Ajout des correspondances dans lignes_liaisons :

INSERT INTO lignes_liaisons (id_ligne, id_liaison) 
VALUES (LAST_INSERT_ID(), 1), (LAST_INSERT_ID(), 2);


INSERT INTO lignes (terminus1, terminus2)
VALUES (/*id_gare1*/, /*id_gare2*/);






