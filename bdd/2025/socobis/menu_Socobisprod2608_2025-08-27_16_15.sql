UPDATE menudynamique SET libelle = 'Graphique' WHERE id = 'MENDYN1756281918079-243';
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1756300444397-505', 'Dépense en matière premières', 'fa fa-chart-area', '', 6, 2, 'ELM00T3004001');
UPDATE menudynamique SET libelle = 'Graphique', rang = 3 WHERE id = 'MENDYN1756281918079-243';
UPDATE menudynamique SET rang = 4 WHERE id = 'MENUDYN02108002';
UPDATE menudynamique SET rang = 5 WHERE id = 'MENDYN1756282017293-463';
UPDATE menudynamique SET rang = 6 WHERE id = 'MENDYN1756282063504-866';
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1756300524012-253', 'Liste', 'fa fa-bars', 'module.jsp?but=stat/depense-mat-prem-liste.jsp', 1, 3, 'MENDYN1756300444397-505');
UPDATE menudynamique SET libelle = 'Graphique', rang = 1, niveau = 3, id_pere = 'MENDYN1756300444397-505' WHERE id = 'MENDYN1756281918079-243';
UPDATE menudynamique SET libelle = 'Graphe', rang = 1, niveau = 3, id_pere = 'MENDYN1756300444397-505' WHERE id = 'MENDYN1756281918079-243';
