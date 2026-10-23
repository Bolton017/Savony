UPDATE menudynamique SET href = 'module.jsp?but=facturefournisseur/facturefournisseur-liste.jsp' WHERE id = 'MNDN000000013';
UPDATE menudynamique SET href = 'module.jsp?but=facturefournisseur/dmdachat/dmdachat-liste.jsp' WHERE id = 'MNDN00110901146001';
UPDATE menudynamique SET href = 'module.jsp?but=bondecommande/bondecommande-liste.jsp' WHERE id = 'MNDN001804001';
UPDATE menudynamique SET href = 'module.jsp?but=bondelivraison/bondelivraison-liste.jsp' WHERE id = 'MNDN001804004';
UPDATE menudynamique SET href = 'module.jsp?but=bondelivraison/bondelivraison-liste.jsp' WHERE id = 'MNDN001804004';

-- script pour l'usermenu

INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM43BF742D', 'MNDN000000014', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM13925953', 'MNDN000000014', NULL, 'magcentral', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM2CFA0F9D', 'MNDN000000014', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM90DB226F', 'MNDN000000015', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMD1B3591F', 'MNDN000000015', NULL, 'magcentral', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM708E2EB4', 'MNDN000000015', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM4EA3AFCC', 'MNDN00110901146002', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM37D7663E', 'MNDN00110901146002', NULL, 'magcentral', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMB80329DF', 'MNDN00110901146002', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMBAE7E209', 'MNDN00110901146003', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMAEBFB932', 'MNDN00110901146003', NULL, 'magcentral', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM512A4330', 'MNDN00110901146003', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMF34446E7', 'MNDN001804002', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM61DD2CC9', 'MNDN001804002', NULL, 'magcentral', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMEBA44F22', 'MNDN001804002', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM7054B3C0', 'MNDN001804003', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMD7B22624', 'MNDN001804003', NULL, 'magcentral', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM17DFA439', 'MNDN001804003', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMA13FBD71', 'MNDN001804005', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM9DB54095', 'MNDN001804005', NULL, 'magcentral', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM3E62F8FD', 'MNDN001804005', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM37B4CAC0', 'MNDN001804006', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMA7D5E593', 'MNDN001804006', NULL, 'magcentral', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM16E8A12E', 'MNDN001804006', NULL, 'dg', 1);
