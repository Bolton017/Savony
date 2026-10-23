UPDATE menudynamique SET libelle = 'Nouvelle vente' WHERE id = 'MNDN000000006';
UPDATE menudynamique SET libelle = 'Liste des ventes' WHERE id = 'MNDN000000007';
UPDATE menudynamique SET href = 'module.jsp?but=avoir/avoirFC-liste.jsp' WHERE id = 'MNDN0001109001';
UPDATE menudynamique SET href = 'module.jsp?but=avoir/avoirFC-liste.jsp' WHERE id = 'MNDN0001109001';
UPDATE menudynamique SET href = 'module.jsp?but=bondelivraison-client/bondelivraison-client-liste.jsp' WHERE id = 'MNDN000000012';

-- script pour l'usermenu

INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UME8B70425', 'MNDN0001109002', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM48B2CF18', 'MNDN0001109002', NULL, 'magcentral', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM6CB4769B', 'MNDN0001109002', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM640423C0', 'MNDN0001109003', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMF4B92477', 'MNDN0001109003', NULL, 'magcentral', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMF327EA6A', 'MNDN0001109003', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM97A6DE64', 'MNDN0000000121', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM1BAFB220', 'MNDN0000000121', NULL, 'magcentral', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UME880E173', 'MNDN0000000121', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMA1214D65', 'MNDN0000000122', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM75DA2D2E', 'MNDN0000000122', NULL, 'magcentral', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM77A74784', 'MNDN0000000122', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMEEF045B0', 'MNDN00017210082', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM17E50C5C', 'MNDN00017210082', NULL, 'magcentral', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM5F64C66F', 'MNDN00017210082', NULL, 'dg', 1);
