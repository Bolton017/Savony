UPDATE menudynamique SET libelle = 'Nouvelle mouvement de stock' WHERE id = 'MNDN000000024';
UPDATE menudynamique SET libelle = 'Liste des mouvements de stock' WHERE id = 'MNDN000000025';
UPDATE menudynamique SET libelle = 'Détails des mouvements de stock' WHERE id = 'MNDN002208001';
UPDATE menudynamique SET libelle = 'Nouvelle inventaire' WHERE id = 'MNDN000000026';
UPDATE menudynamique SET libelle = 'Liste des inventaires' WHERE id = 'MNDN000000027';
UPDATE menudynamique SET libelle = 'Nouvelle inventaire par categorie' WHERE id = 'MNDN000000028';
UPDATE menudynamique SET libelle = 'Nouveau transfert' WHERE id = 'MNDN000000021111';
UPDATE menudynamique SET libelle = 'Liste des transferts' WHERE id = 'MNDN00000002112';
UPDATE menudynamique SET href = 'module.jsp?but=demande/demandetransfert-liste.jsp' WHERE id = 'MNDN0000000031';

-- script pour l'usermenu

INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM87824FA2', 'MNDN0000000032', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UME5305FE9', 'MNDN0000000032', NULL, 'magcentral', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMDBF7E555', 'MNDN0000000032', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM98DDC28E', 'MNDN0000000032', NULL, 'magtransitmp', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMB9C84C26', 'MNDN0000000032', NULL, 'magtransiteblg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMC99FAC40', 'MNDN0000000032', NULL, 'ctrmaitre', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMA301BAB8', 'MNDN0000000033', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMD8DFAB97', 'MNDN0000000033', NULL, 'magcentral', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM7F55ED83', 'MNDN0000000033', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM8E1797B3', 'MNDN0000000033', NULL, 'magtransitmp', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM520CA31B', 'MNDN0000000033', NULL, 'magtransiteblg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM2EA7E72F', 'MNDN0000000033', NULL, 'ctrmaitre', 1);
