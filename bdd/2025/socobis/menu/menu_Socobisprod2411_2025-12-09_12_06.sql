UPDATE menudynamique SET rang = 4 WHERE id = 'MENUDYN0015';
UPDATE menudynamique SET rang = 5 WHERE id = 'MENUDYN0016';
UPDATE menudynamique SET rang = 6 WHERE id = 'MENUDYN0017';
UPDATE menudynamique SET rang = 7 WHERE id = 'MENUDYN0077';
UPDATE menudynamique SET rang = 8 WHERE id = 'MENUDYN0077RC';
UPDATE menudynamique SET rang = 9 WHERE id = 'MENUDYN7778';
UPDATE menudynamique SET rang = 10 WHERE id = 'MENUDYN0013';
UPDATE menudynamique SET rang = 4 WHERE id = 'MENUDYN0016';
UPDATE menudynamique SET rang = 1 WHERE id = 'MENUDYN0012';
UPDATE menudynamique SET rang = 2 WHERE id = 'MENUDYN0011';
UPDATE menudynamique SET rang = 3 WHERE id = 'MENUDYN0016';
UPDATE menudynamique SET rang = 4 WHERE id = 'MENUDYN0015';
UPDATE menudynamique SET rang = 5 WHERE id = 'MENUDYN0017';
UPDATE menudynamique SET rang = 6 WHERE id = 'MENUDYN0077';
UPDATE menudynamique SET rang = 7 WHERE id = 'MENUDYN0077RC';
UPDATE menudynamique SET rang = 8 WHERE id = 'MENUDYN7778';
UPDATE menudynamique SET rang = 9 WHERE id = 'MENUDYN0013';
UPDATE menudynamique SET rang = 10 WHERE id = 'MENUDYN0014';
UPDATE menudynamique SET rang = 2 WHERE id = 'MENUDYN0017';
UPDATE menudynamique SET rang = 4 WHERE id = 'MENUDYN0016';
UPDATE menudynamique SET libelle = 'Report de caisse' WHERE id = 'MENUDYN0015';
UPDATE menudynamique SET rang = 7 WHERE id = 'MENUDYN0077RC';
UPDATE menudynamique SET libelle = 'Relevé Client', rang = 7 WHERE id = 'MENUDYN0077RC';
UPDATE menudynamique SET libelle = 'Relevé Client', rang = 6 WHERE id = 'MENUDYN0077RC';
UPDATE menudynamique SET rang = 7 WHERE id = 'MENUDYN0077';
UPDATE menudynamique SET rang = 9 WHERE id = 'MENUDYN0014';
UPDATE menudynamique SET rang = 10 WHERE id = 'MENUDYN0013';

-- script pour l'usermenu

INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM5039732C', 'MENUDYN0012', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM77C3FF10', 'MENUDYN0012', NULL, 'dg', 1);
