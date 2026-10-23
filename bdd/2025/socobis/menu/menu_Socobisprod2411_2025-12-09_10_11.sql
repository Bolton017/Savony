UPDATE menudynamique SET libelle = 'Nouvelle caisse' WHERE id = 'MENUDYN0012';
UPDATE menudynamique SET rang = 1 WHERE id = 'MENUDYN0014';
UPDATE menudynamique SET rang = 2 WHERE id = 'MENUDYN0011';
UPDATE menudynamique SET libelle = 'Nouvelle caisse', rang = 3 WHERE id = 'MENUDYN0012';
UPDATE menudynamique SET rang = 4 WHERE id = 'MENUDYN0013';
UPDATE menudynamique SET rang = 5 WHERE id = 'MENUDYN0015';
UPDATE menudynamique SET rang = 6 WHERE id = 'MENUDYN0016';
UPDATE menudynamique SET rang = 7 WHERE id = 'MENUDYN0017';
UPDATE menudynamique SET rang = 8 WHERE id = 'MENUDYN0077';
UPDATE menudynamique SET rang = 9 WHERE id = 'MENUDYN0077RC';
UPDATE menudynamique SET rang = 10 WHERE id = 'MENUDYN7778';
UPDATE menudynamique SET libelle = 'Nouvelle caisse' WHERE id = 'MENUDYN0012';
UPDATE menudynamique SET rang = 3 WHERE id = 'MENUDYN0011';
UPDATE menudynamique SET rang = 2 WHERE id = 'MENUDYN0011';
UPDATE menudynamique SET libelle = 'Nouvelle caisse', rang = 3 WHERE id = 'MENUDYN0012';
UPDATE menudynamique SET rang = 2 WHERE id = 'MENUDYN0014';
UPDATE menudynamique SET rang = 1 WHERE id = 'MENUDYN0014';
UPDATE menudynamique SET rang = 2 WHERE id = 'MENUDYN0011';
UPDATE menudynamique SET libelle = 'Nouvelle caisse' WHERE id = 'MENUDYN0012';
UPDATE menudynamique SET rang = 3 WHERE id = 'MENUDYN0011';
UPDATE menudynamique SET href = 'module.jsp?but=caisse/report/reportCaisse-liste.jsp', rang = 5 WHERE id = 'MENUDYN0015';
UPDATE menudynamique SET href = 'module.jsp?but=caisse/virementIntraCaisse/virementIntraCaisse-liste.jsp', rang = 6 WHERE id = 'MENUDYN0016';
UPDATE menudynamique SET libelle = 'Nouvelle Entree' WHERE id = 'MENUDYN00171';
UPDATE menudynamique SET libelle = 'Nouvelle Sortie' WHERE id = 'MENUDYN00173';
UPDATE menudynamique SET libelle = 'Liste des mouvement de caisse' WHERE id = 'MENUDYN00172';

-- script pour l'usermenu

INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM4B3969C7', 'MENUDYN00151', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM900BBC23', 'MENUDYN00151', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM32B6DFDD', 'MENUDYN00152', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM300551BB', 'MENUDYN00152', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMB67BB030', 'MENUDYN00161', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM8A380AA9', 'MENUDYN00161', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM0E4383C7', 'MENUDYN00162', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM80133AFE', 'MENUDYN00162', NULL, 'dg', 1);
