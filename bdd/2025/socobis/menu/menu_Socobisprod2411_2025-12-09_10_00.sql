UPDATE menudynamique SET href = 'module.jsp?but=vente/proforma/proforma-liste.jsp' WHERE id = 'MNDNAN001';
UPDATE menudynamique SET libelle = 'Nouvelle traite' WHERE id = 'MEN000690';
UPDATE menudynamique SET libelle = 'Liste des traites' WHERE id = 'MEN000691';

-- script pour l'usermenu

INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM9D09AE48', 'MNDNAN003', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMBEB72190', 'MNDNAN003', NULL, 'magcentral', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM5B36B110', 'MNDNAN003', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM1894B951', 'MNDNAN002', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM83CC4B4E', 'MNDNAN002', NULL, 'magcentral', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM5664FAA5', 'MNDNAN002', NULL, 'dg', 1);
