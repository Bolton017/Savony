UPDATE menudynamique SET libelle = 'Graphe' WHERE id = 'MENDYN1756282017293-463';
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1756302866274-909', 'Stock de produits finis', 'fa fa-chart-area', '', 6, 2, 'ELM00T3004001');
UPDATE menudynamique SET libelle = 'Graphe', rang = 5 WHERE id = 'MENDYN1756282017293-463';
UPDATE menudynamique SET rang = 6 WHERE id = 'MENDYN1756282063504-866';
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1756302895673-426', 'Liste', 'fa fa-bars', 'module.jsp?but=stat/stock-produit-fini-liste.jsp', 1, 3, 'MENDYN1756302866274-909');
UPDATE menudynamique SET libelle = 'Graphe', rang = 1, niveau = 3, id_pere = 'MENDYN1756302866274-909' WHERE id = 'MENDYN1756282017293-463';
