UPDATE menudynamique SET rang = 1 WHERE id = 'MENUDYN00304001';
UPDATE menudynamique SET rang = 2 WHERE id = 'MNDN000000001';
UPDATE menudynamique SET rang = 3 WHERE id = 'ELM00T3004001';
UPDATE menudynamique SET rang = 4 WHERE id = 'MNDN000000002';
UPDATE menudynamique SET rang = 5 WHERE id = 'MNDN000000003';
UPDATE menudynamique SET rang = 6 WHERE id = 'MENUDYN001';
UPDATE menudynamique SET rang = 7 WHERE id = 'MNDN00002';
UPDATE menudynamique SET rang = 8 WHERE id = 'MDT021030017';
UPDATE menudynamique SET rang = 9 WHERE id = 'MNDN00001';
UPDATE menudynamique SET rang = 10 WHERE id = 'MNDN274';
UPDATE menudynamique SET rang = 11 WHERE id = 'MENUP001V';
UPDATE menudynamique SET rang = 12 WHERE id = 'MENUDYN002';
UPDATE menudynamique SET niveau = 1, id_pere = NULL WHERE id = 'MENUDYN00304002';
UPDATE menudynamique SET rang = 2 WHERE id = 'MENUDYN00304001';
UPDATE menudynamique SET rang = 3 WHERE id = 'MNDN000000001';
UPDATE menudynamique SET rang = 4 WHERE id = 'ELM00T3004001';
UPDATE menudynamique SET rang = 5 WHERE id = 'MNDN000000002';
UPDATE menudynamique SET rang = 6 WHERE id = 'MNDN000000003';
UPDATE menudynamique SET rang = 7 WHERE id = 'MENUDYN001';
UPDATE menudynamique SET rang = 8 WHERE id = 'MNDN00002';
UPDATE menudynamique SET rang = 9 WHERE id = 'MDT021030017';
UPDATE menudynamique SET rang = 10 WHERE id = 'MNDN00001';
UPDATE menudynamique SET rang = 11 WHERE id = 'MNDN274';
UPDATE menudynamique SET rang = 12 WHERE id = 'MENUP001V';
UPDATE menudynamique SET rang = 13 WHERE id = 'MENUDYN002';
UPDATE menudynamique SET rang = 14 WHERE id = 'ELM000011';
UPDATE menudynamique SET rang = 15 WHERE id = 'ELM000904001';
UPDATE menudynamique SET rang = 16 WHERE id = 'MNDN00000002111';
UPDATE menudynamique SET niveau = 2 WHERE id = 'MENUDYN0304008';
UPDATE menudynamique SET niveau = 2 WHERE id = 'MENUDYN0304009';
UPDATE menudynamique SET rang = 1 WHERE id = 'MENUDYN00304003';
UPDATE menudynamique SET rang = 2 WHERE id = 'MENUDYN01908001';
UPDATE menudynamique SET rang = 3 WHERE id = 'MENUDYN02108001';
UPDATE menudynamique SET rang = 1 WHERE id = 'MENUDYN00304001';
UPDATE menudynamique SET rang = 2, niveau = 1, id_pere = NULL WHERE id = 'MENUDYN00304002';
UPDATE menudynamique SET rang = 3 WHERE id = 'ELM00T3004001';
UPDATE menudynamique SET rang = 4 WHERE id = 'MNDN000000001';
UPDATE menudynamique SET rang = 8 WHERE id = 'MENUDYN002';
UPDATE menudynamique SET rang = 9 WHERE id = 'MNDN00002';
UPDATE menudynamique SET rang = 10 WHERE id = 'MDT021030017';
UPDATE menudynamique SET rang = 11 WHERE id = 'MNDN00001';
UPDATE menudynamique SET rang = 12 WHERE id = 'MNDN274';
UPDATE menudynamique SET rang = 13 WHERE id = 'MENUP001V';
UPDATE menudynamique SET rang = 9 WHERE id = 'MNDN274';
UPDATE menudynamique SET rang = 10 WHERE id = 'MNDN00002';
UPDATE menudynamique SET rang = 11 WHERE id = 'MDT021030017';
UPDATE menudynamique SET rang = 12 WHERE id = 'MNDN00001';
UPDATE menudynamique SET rang = 16 WHERE id = 'ELM000904001';

-- script pour l'usermenu

DELETE FROM usermenu WHERE id = 'USRMEN2411001'; -- 1 rows
DELETE FROM usermenu WHERE id = 'USRMEN2411002'; -- 1 rows
DELETE FROM usermenu WHERE id = 'USRMEN2411003'; -- 1 rows
DELETE FROM usermenu WHERE id = 'USRMEN2411004'; -- 1 rows
DELETE FROM usermenu WHERE id = 'USRMEN2411005'; -- 1 rows
DELETE FROM usermenu WHERE id = 'USRMEN2411006'; -- 1 rows
DELETE FROM usermenu WHERE id = 'USRMEN2411007'; -- 1 rows
DELETE FROM usermenu WHERE id = 'USRMEN2411008'; -- 1 rows
DELETE FROM usermenu WHERE id = 'USRMEN2411009'; -- 1 rows
DELETE FROM usermenu WHERE id = 'USRMEN24110010'; -- 1 rows
DELETE FROM usermenu WHERE id = 'USRMEN24110011'; -- 1 rows
DELETE FROM usermenu WHERE id = 'USRMEN24110012'; -- 1 rows
DELETE FROM usermenu WHERE id = 'USRMEN24110013'; -- 1 rows
DELETE FROM usermenu WHERE id = 'USRMEN24110014'; -- 1 rows
DELETE FROM usermenu WHERE id = 'USRMEN24110015'; -- 1 rows
DELETE FROM usermenu WHERE id = 'USRMEN24110016'; -- 1 rows
DELETE FROM usermenu WHERE id = 'USRMEN0001'; -- 1 rows
DELETE FROM usermenu WHERE id = 'USRMEN0004'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM8A2E6C78'; -- 1 rows
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM4452E80A', 'MENUDYN00304002', NULL, 'cheffab', 0);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMF445DA46', 'MENUDYN00304002', NULL, 'dg', 0);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM50A56099', 'MENUDYN00304002', NULL, 'ctrmaitre', 0);
