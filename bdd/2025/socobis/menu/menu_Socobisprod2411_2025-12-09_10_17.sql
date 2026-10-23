UPDATE menudynamique SET href = 'module.jsp?but=compta/ecriture/ecriture-liste.jsp' WHERE id = 'MNDSN287';
UPDATE menudynamique SET libelle = 'État comptable', href = '' WHERE id = 'MNDN285';
UPDATE menudynamique SET href = 'module.jsp?but=compta/lettrage/lettrage-liste.jsp' WHERE id = 'MNDNT2205001';
UPDATE menudynamique SET href = 'module.jsp?but=compta/compte/compte-liste.jsp' WHERE id = 'MNDNT2205004';
UPDATE menudynamique SET libelle = 'Écriture comptable', href = 'module.jsp?but=compta/ecriture/ecriture-liste.jsp' WHERE id = 'MNDSN287';

-- script pour l'usermenu

INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM55B89CEA', 'MNDSN286', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM77D678B5', 'MNDSN286', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMD540E233', 'MNDSN285', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMBE99EC3A', 'MNDSN285', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMFC3B59D8', 'MNDNT2205003', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM335BC793', 'MNDNT2205003', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM5C53074D', 'MNDNT2205002', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMED86A410', 'MNDNT2205002', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMC10BFA23', 'MNDNT2205006', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM1D24CD32', 'MNDNT2205006', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM9938B392', 'MNDNT2205005', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM3089E2F5', 'MNDNT2205005', NULL, 'dg', 1);
