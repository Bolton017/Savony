UPDATE menudynamique SET href = 'module.jsp?but=fabrication/fabrication-liste.jsp' WHERE id = 'MENUDYN00304002';

-- script pour l'usermenu

INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMD1789E4B', 'MENUDYN0304008', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM804909CD', 'MENUDYN0304008', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMA793369C', 'MENUDYN0304008', NULL, 'ctrmaitre', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMF611A28F', 'MENUDYN0304009', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMB34BBA9E', 'MENUDYN0304009', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UME0DFD038', 'MENUDYN0304009', NULL, 'ctrmaitre', 1);
