UPDATE menudynamique SET href = '' WHERE id = 'MNDN0000508007';
UPDATE menudynamique SET libelle = 'Liste des caisses' WHERE id = 'MNDN0000508009';
UPDATE menudynamique SET rang = 3, id_pere = 'MNDN00000002111' WHERE id = 'MENUDYN0013';
UPDATE menudynamique SET rang = 4 WHERE id = 'MNDN00000002111114';
UPDATE menudynamique SET rang = 5 WHERE id = 'MNDN00000002111115';
UPDATE menudynamique SET rang = 6 WHERE id = 'MNDN000000011061116';
UPDATE menudynamique SET rang = 7 WHERE id = 'MNDN0000408001';
UPDATE menudynamique SET rang = 8 WHERE id = 'MNDN0000508001';
UPDATE menudynamique SET rang = 9 WHERE id = 'MNDN0000508004';
UPDATE menudynamique SET href = '', rang = 10 WHERE id = 'MNDN0000508007';
UPDATE menudynamique SET rang = 11 WHERE id = 'MNDN0002008001';
UPDATE menudynamique SET rang = 12 WHERE id = 'MNDN0000TR0002111';
UPDATE menudynamique SET rang = 13 WHERE id = 'MNDN0000012';
UPDATE menudynamique SET rang = 14 WHERE id = 'ELM001026';
UPDATE menudynamique SET rang = 10 WHERE id = 'MNDN00002';
UPDATE menudynamique SET rang = 3, niveau = 3, id_pere = 'MNDN0000508007' WHERE id = 'MENUDYN0013';
UPDATE menudynamique SET href = '' WHERE id = 'MNDN0000508007';
UPDATE menudynamique SET rang = 4, niveau = 3, id_pere = 'MNDN0000508007' WHERE id = 'MNDN00002';
UPDATE menudynamique SET niveau = 4 WHERE id = 'MNDN000021';
UPDATE menudynamique SET niveau = 4 WHERE id = 'MNDN000022';

-- script pour l'usermenu

DELETE FROM usermenu WHERE id = 'UM20225C36'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM7038C278'; -- 1 rows
