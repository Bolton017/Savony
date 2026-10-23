UPDATE menudynamique SET href = 'module.jsp?but=filemanager/file-liste-2.jsp' WHERE id = 'MENUP001V';

-- script pour l'usermenu

INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM73147495', 'MENUP0011V', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMD0DE69D7', 'MENUP0011V', NULL, 'dg', 1);
