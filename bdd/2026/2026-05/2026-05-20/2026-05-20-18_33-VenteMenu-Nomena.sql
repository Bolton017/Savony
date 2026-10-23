INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM3FC020B3', 'ELM01', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM8A81CBBD', 'ELM01', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM2A916E23', 'ELM01', NULL, 'respvente', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM9FB16B10', 'ELM01', NULL, 'magcentral', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM717F5668', 'ELM01', NULL, 'dirvente', 1);

UPDATE menudynamique SET libelle = 'Bon de Commande' WHERE id = 'MNDN00000000107';
UPDATE menudynamique SET rang = 1 WHERE id = 'MNDNAN001';
UPDATE menudynamique SET rang = 2 WHERE id = 'MNDN000000006';
UPDATE menudynamique SET libelle = 'Bon de Commande', rang = 2 WHERE id = 'MNDN00000000107';
UPDATE menudynamique SET rang = 3 WHERE id = 'MNDN000000006';
UPDATE menudynamique SET rang = 4 WHERE id = 'MNDN000000007';

INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMC73AE0D1', 'MNDN000000006', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM52B935DD', 'MNDN000000006', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM851673A1', 'MNDN000000006', NULL, 'respvente', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMDD64886D', 'MNDN000000006', NULL, 'magcentral', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMF25E54C5', 'MNDN000000006', NULL, 'dirvente', 1);
