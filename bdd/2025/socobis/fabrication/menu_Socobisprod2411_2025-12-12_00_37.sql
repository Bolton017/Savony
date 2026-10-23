DELETE FROM menudynamique WHERE id = 'MENDYN1758268474616469';
UPDATE menudynamique SET rang = 6 WHERE id = 'MENDYN1758268499623140';

-- script pour l'usermenu

INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMD7E17E51', 'MENDYN1758268499623140', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM6ABC788A', 'MENDYN1758268499623140', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM9578924E', 'MENDYN1758268499623140', NULL, 'magtransitmp', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UME61F12E7', 'MENDYN1758268499623140', NULL, 'magtransiteblg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UME0619C3C', 'MENDYN1758268499623140', NULL, 'ctrmaitre', 1);

DELETE FROM menudynamique WHERE id = 'MENDYN1756282017293-463';
DELETE FROM menudynamique WHERE id = 'MENDYN1756371621833614';
UPDATE menudynamique SET href = 'module.jsp?but=stat/stock-produit-fini-liste.jsp' WHERE id = 'MENDYN1756371601724688';

-- script pour l'usermenu

INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM6F12F04F', 'JUIK003', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM17089E5B', 'JUIK003', NULL, 'magcentral', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM890B937E', 'JUIK003', NULL, 'caisse', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM05C59346', 'JUIK003', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UME81AAE92', 'JUIK003', NULL, 'gestionnaire', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM79EABE2C', 'JUIK003', NULL, 'magtransitmp', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM7EBA1802', 'JUIK003', NULL, 'magtransiteblg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM99E6A7EF', 'JUIK003', NULL, 'ctrmaitre', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM1A27A7C5', 'JUIK003', NULL, 'pompiste', 1);

