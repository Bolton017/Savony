UPDATE menudynamique SET libelle = 'Nouvelle prevision' WHERE id = 'MENUDYN0020001';
UPDATE menudynamique SET libelle = 'Liste des previsions' WHERE id = 'MENUDYN0020002';
UPDATE menudynamique SET href = 'module.jsp?but=prevision/prevision-liste-depense.jsp' WHERE id = 'MENUDYN0020004';
UPDATE menudynamique SET libelle = 'Prevision de dépense', href = 'module.jsp?but=prevision/prevision-liste-depense.jsp' WHERE id = 'MENUDYN0020004';
UPDATE menudynamique SET libelle = 'Prevision de recette' WHERE id = 'MENUDYN0020005';
UPDATE menudynamique SET libelle = 'Prevision de recette', href = 'module.jsp?but=prevision/prevision-liste-recette.jsp' WHERE id = 'MENUDYN0020005';

-- script pour l'usermenu

INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM19AF2119', 'MENUDYN0020006', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMD9AD652D', 'MENUDYN0020006', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMB79C1141', 'MENUDYN0020007', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM8D66644D', 'MENUDYN0020007', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMD4F66A55', 'MENUDYN0020008', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM40B5910B', 'MENUDYN0020008', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMF1122931', 'MENUDYN0020009', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM184BE07B', 'MENUDYN0020009', NULL, 'dg', 1);
