UPDATE menudynamique SET href = 'module.jsp?but=fabrication/ordre-fabrication-liste.jsp' WHERE id = 'MENUDYN00304003';

-- script pour l'usermenu

INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UME89FDCB6', 'MENUDYN3204004', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMD8436813', 'MENUDYN3204004', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM65F1B64E', 'MENUDYN3204004', NULL, 'ctrmaitre', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM489130C7', 'MENUDYN0304005', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMFF585EE5', 'MENUDYN0304005', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMAB0CA872', 'MENUDYN0304005', NULL, 'magtransitmp', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM3A9BEE37', 'MENUDYN0304005', NULL, 'magtransiteblg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM42E9CDE0', 'MENUDYN0304005', NULL, 'ctrmaitre', 1);
