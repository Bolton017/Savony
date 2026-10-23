UPDATE menudynamique SET rang = 11, niveau = 2, id_pere = 'MENUDYN001' WHERE id = 'MNDN00002';
UPDATE menudynamique SET niveau = 3 WHERE id = 'MNDN000021';
UPDATE menudynamique SET niveau = 3 WHERE id = 'MNDN000022';
UPDATE menudynamique SET rang = 10 WHERE id = 'MDT021030017';
UPDATE menudynamique SET rang = 11 WHERE id = 'MNDN00001';
UPDATE menudynamique SET rang = 12 WHERE id = 'MENUP001V';
UPDATE menudynamique SET rang = 13 WHERE id = 'ELM000011';
UPDATE menudynamique SET rang = 14 WHERE id = 'MNDN00000002111';
UPDATE menudynamique SET rang = 15 WHERE id = 'ELM000904001';

-- script pour l'usermenu

DELETE FROM usermenu WHERE id = 'USRMENADM07623'; -- 1 rows
DELETE FROM usermenu WHERE id = 'USRMENCHFAB07623'; -- 1 rows
