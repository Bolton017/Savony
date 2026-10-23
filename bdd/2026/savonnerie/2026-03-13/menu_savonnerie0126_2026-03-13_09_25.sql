INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1773382834579104', 'Liste transferts de stock avec anomalies', 'list_alt', 'module.jsp?but=stock/transfertstock/transfertstock-anomalie.jsp', 5, 3, 'MNDN0000000211');

-- script pour l'usermenu

DELETE FROM usermenu WHERE id = 'USRMEN0002'; -- 1 rows
DELETE FROM usermenu WHERE id = 'USRMEN0005'; -- 1 rows
DELETE FROM usermenu WHERE id = 'USRMEN0003'; -- 1 rows
DELETE FROM usermenu WHERE id = 'USRMEN0006'; -- 1 rows
DELETE FROM usermenu WHERE id = 'USRMENCHFAB00304001'; -- 1 rows
DELETE FROM usermenu WHERE id = 'USRMENCTMTRE008040021'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UME89FDCB6'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM65F1B64E'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM489130C7'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMAB0CA872'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM3A9BEE37'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM42E9CDE0'; -- 1 rows
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM31BCC4CE', 'MENUDYN00304001', '*', NULL, 0);
