INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1765468296624239', 'Salaire', 'fa fa-money-bill', '', 11, 3, 'MD000000040030');
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1765468330900915', 'Saisie par qualification', 'fa fa-pen', '', 1, 4, 'MENDYN1765468296624239');
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1765468357776807', 'Liste des salaires', 'fa fa-list', '', 2, 4, 'MENDYN1765468296624239');

-- script pour l'usermenu

DELETE FROM usermenu WHERE id = 'UMAC218939'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMC6865CDC'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMA533DFC4'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMC277E859'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM39A19A26'; -- 1 rows
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMAEAF6780', 'MENUDYN00304002', NULL, 'cheffab', 0);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMDEE17123', 'MENUDYN00304002', NULL, 'dg', 0);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMC80A960F', 'MENUDYN00304002', NULL, 'ctrmaitre', 0);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM26717471', 'ELM00T3004001', NULL, 'cheffab', 0);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM76393E5F', 'ELM00T3004001', NULL, 'dg', 0);
