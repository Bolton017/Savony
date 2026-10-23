UPDATE menudynamique SET href = 'module.jsp?but=change/taux/taux-liste.jsp' WHERE id = 'MNDN00002';
UPDATE menudynamique SET href = 'module.jsp?but=magasin/magasin-liste.jsp' WHERE id = 'MDT021030017';
UPDATE menudynamique SET libelle = 'Categorie de matière première', href = '' WHERE id = 'MNDN0000012';
UPDATE menudynamique SET libelle = 'Categorie de matière première', href = 'module.jsp?but=annexe/categorie/categorie-liste.jsp' WHERE id = 'MNDN0000012';
UPDATE menudynamique SET libelle = 'Categorie de matière première', href = 'module.jsp?but=annexe/categorie/categorie-liste.jsp', rang = 12, id_pere = 'MNDN00000002111' WHERE id = 'MNDN0000012';
UPDATE menudynamique SET href = 'module.jsp?but=annexe/produit/produit-liste.jsp' WHERE id = 'MNDN00001';

-- script pour l'usermenu

INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM23C38A07', 'MNDN000021', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMEDB2C007', 'MNDN000021', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM9F6E0114', 'MNDN000022', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM713A1E66', 'MNDN000022', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM3EDF1511', 'MNDN0000000201', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMA83B36DC', 'MNDN0000000201', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM58AD527E', 'MNDN0000000202', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM18E2C129', 'MNDN0000000202', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM4C4EDF41', 'MNDN000011', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMF4CBFB0D', 'MNDN000011', NULL, 'magcentral', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM5522B11D', 'MNDN000011', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMAD33ECD6', 'MNDN000012', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM998093CD', 'MNDN000012', NULL, 'magcentral', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM22EF91F2', 'MNDN000012', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM28AFE5C5', 'MNDN0000021', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMB7F7BA68', 'MNDN0000021', NULL, 'magcentral', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMB41B2D0C', 'MNDN0000021', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMBEF14B09', 'MNDN0000022', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMFD8BE5D8', 'MNDN0000022', NULL, 'magcentral', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM05A15B50', 'MNDN0000022', NULL, 'dg', 1);
