UPDATE menudynamique SET href = 'module.jsp?but=declaration/liste-declaration-tva.jsp' WHERE id = 'MENDYN176638DECL001';
UPDATE menudynamique SET libelle = 'Déclaration de TVA', href = 'module.jsp?but=declaration/liste-declaration-tva.jsp' WHERE id = 'MENDYN176638DECL001';

-- script pour l'usermenu

INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM9C28F9D9', 'MENDYN176638DECLTVAS', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM9D40107F', 'MENDYN176638DECLTVAS', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM5E2EA6C8', 'MENDYN176638DECLTVAL', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMB38034BA', 'MENDYN176638DECLTVAL', NULL, 'dg', 1);
