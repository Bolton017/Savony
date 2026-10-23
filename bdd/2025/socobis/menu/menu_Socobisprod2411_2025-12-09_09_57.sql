UPDATE menudynamique SET href = 'module.jsp?but=vente/bondecommande-liste.jsp' WHERE id = 'MNDN00000000107';

-- script pour l'usermenu

INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMB4BD9072', 'MNDN000000001072', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM09A9C35C', 'MNDN000000001072', NULL, 'magcentral', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMAE5970CF', 'MNDN000000001072', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM5E849C77', 'MNDN000000001071', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM5CCAC1B9', 'MNDN000000001071', NULL, 'magcentral', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMCB87C23C', 'MNDN000000001071', NULL, 'dg', 1);
