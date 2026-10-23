INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1756281918079-243', 'Dépense en matière premières', 'fa fa-chart-area', 'module.jsp?but=stat/depense-mat-prem.jsp', 2, 2, 'ELM00T3004001');
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1756281961904-234', 'Fabrication par produit fini', 'fa fa-chart-area', 'module.jsp?but=stat/fab-produit-fini.jsp', 3, 2, 'ELM00T3004001');
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1756282017293-463', 'Stock de produits finis', 'fa fa-chart-area', 'module.jsp?but=stat/stock-produit-fini.jsp', 4, 2, 'ELM00T3004001');
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1756282063504-866', 'Taux de revient des produits finis', 'fa fa-chart-area', 'module.jsp?but=stat/taux-produit-fini.jsp', 5, 2, 'ELM00T3004001');
UPDATE menudynamique SET icone = 'fa fa-chart-pie' WHERE id = 'ELM00T3004002';
UPDATE menudynamique SET icone = 'fa fa-chart-line', href = '#' WHERE id = 'ELM00T3004001';

-- script pour l'usermenu

DELETE FROM usermenu WHERE id = 'USRMENADM1707001';
DELETE FROM usermenu WHERE id = 'USRMENADM00304001';
DELETE FROM usermenu WHERE id = 'USRMENADM00704001';
DELETE FROM usermenu WHERE id = 'USRMENCHFAB0085554';
DELETE FROM usermenu WHERE id = 'USRMENCHFAB00704001';
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMA28BE93C', 'ELM000011', '*', NULL, 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMD03C8A5F', 'MNDN0005050001', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM4D566820', 'MNDN0005050001', NULL, 'magcentral', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM3EA020DD', 'MNDN0005050001', NULL, 'dg', 1);
