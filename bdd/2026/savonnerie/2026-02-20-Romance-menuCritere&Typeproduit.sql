INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1771576767101161', 'critère', 'filter_list', '', 3, 2, 'MENUDYN00304002');
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1771576837617955', 'Création', 'add', 'module.jsp?but=critere/critere-saisie.jsp', 1, 3, 'MENDYN1771576767101161');
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1771576878046724', 'Liste', 'list', 'module.jsp?but=produits/typeProduit-liste.jsp', 2, 3, 'MENDYN1771576767101161');
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1771577005699316', 'Type Produit', 'local_offer', '', 4, 2, 'MENUDYN00304002');
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1771577051724772', 'Création', 'add', 'module.jsp?but=produits/typeProduit-saisie.jsp', 1, 3, 'MENDYN1771577005699316');
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1771577063683970', 'Liste', 'list', 'module.jsp?but=produits/typeProduit-liste.jsp', 2, 3, 'MENDYN1771577005699316');

-- script pour l'usermenu

DELETE FROM usermenu WHERE id = 'UM116E0408'; -- 1 rows
