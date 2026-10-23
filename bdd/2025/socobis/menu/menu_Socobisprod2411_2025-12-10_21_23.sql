UPDATE menudynamique SET href = 'module.jsp?but=paie/avance/paieperseltpaie-avance-liste.jsp' WHERE id = 'MD00021110002';
UPDATE menudynamique SET icone = 'add_card', href = 'module.jsp?but=paie/avance/paieperseltpaie-avance-liste.jsp' WHERE id = 'MD00021110002';
UPDATE menudynamique SET href = 'module.jsp?but=paie/eltpaie/paieperseltpaie-indemnite-liste.jsp' WHERE id = 'MD00021110005';

-- script pour l'usermenu

DELETE FROM usermenu WHERE id = 'UM84262D9F'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM72E511A0'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMCF5725A7'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM1C3B15E1'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM8AFD1EF1'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMC42FAAA9'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM840382E9'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMD6C7B50F'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM03D8E4B7'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM66E7BAF8'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM6F46FB89'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM961629B0'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM3540D0A9'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMB822BE77'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMDF40863E'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM8FF602B3'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM2066EDF7'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM7FF6126B'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM9FA6CD56'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM29F21113'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMB9C9FFC0'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM307294FA'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM2FD9050A'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMBFA61BF4'; -- 1 rows
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM02AE76D1', 'MD00021110003', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMF5BC900E', 'MD00021110003', NULL, 'magcentral', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UME860BD92', 'MD00021110003', NULL, 'caisse', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMF8F9C6BE', 'MD00021110003', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM1AD9A1E1', 'MD00021110003', NULL, 'gestionnaire', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM000F2667', 'MD00021110003', NULL, 'magtransitmp', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM5C645B3C', 'MD00021110003', NULL, 'magtransiteblg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMF847B5F7', 'MD00021110003', NULL, 'ctrmaitre', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM8513109E', 'MD00021110003', NULL, 'pompiste', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMF95183DA', 'MD00021110004', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM15CF1447', 'MD00021110004', NULL, 'magcentral', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMBBBD370B', 'MD00021110004', NULL, 'caisse', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM6D4D156E', 'MD00021110004', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM3617105C', 'MD00021110004', NULL, 'gestionnaire', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMFEAAD765', 'MD00021110004', NULL, 'magtransitmp', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMBF07CB75', 'MD00021110004', NULL, 'magtransiteblg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMEEEBB99F', 'MD00021110004', NULL, 'ctrmaitre', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM37F7BDD1', 'MD00021110004', NULL, 'pompiste', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMC4561539', 'MD00021110006', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMD1D67FED', 'MD00021110006', NULL, 'magcentral', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM1E0798A6', 'MD00021110006', NULL, 'caisse', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMF9792421', 'MD00021110006', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM81C06FD5', 'MD00021110006', NULL, 'gestionnaire', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM723A11DA', 'MD00021110006', NULL, 'magtransitmp', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMBB0D342D', 'MD00021110006', NULL, 'magtransiteblg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM76E5E3B4', 'MD00021110006', NULL, 'ctrmaitre', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM6A8CDAB6', 'MD00021110006', NULL, 'pompiste', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM031D3439', 'MD00021110007', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMC504A775', 'MD00021110007', NULL, 'magcentral', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM12E82B75', 'MD00021110007', NULL, 'caisse', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM8206F309', 'MD00021110007', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM5A8DB92F', 'MD00021110007', NULL, 'gestionnaire', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMFA39B4F5', 'MD00021110007', NULL, 'magtransitmp', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMDED3BB30', 'MD00021110007', NULL, 'magtransiteblg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM1D048045', 'MD00021110007', NULL, 'ctrmaitre', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM10CFA6CB', 'MD00021110007', NULL, 'pompiste', 1);
