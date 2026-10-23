    UPDATE menudynamique SET icone = 'add' WHERE id = 'MNDN000000024';
UPDATE menudynamique SET icone = 'list_alt' WHERE id = 'MNDN000000025';
UPDATE menudynamique SET icone = 'list_alt' WHERE id = 'MNDN002208001';
UPDATE menudynamique SET icone = 'add' WHERE id = 'MNDN000000026';
UPDATE menudynamique SET icone = 'list_alt' WHERE id = 'MNDN000000027';
UPDATE menudynamique SET icone = 'list_alt' WHERE id = 'MNDN000000028';

-- script pour l'usermenu

DELETE FROM usermenu WHERE id = 'UM1ACCEB98'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMB88412F8'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM9C3B3F08'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM65754C64'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM4683A89A'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMAF84C22D'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM9978981A'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM731B5E43'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMC380E330'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMC67CE024'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMMMT'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM33C0066D'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMB8B9BE63'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM77B93B2A'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM2AEE60E8'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMMMT02356446545'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMMMT5465121254654'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMMMT546512125465412345'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM1BD8CB2B'; -- 1 rows
DELETE FROM usermenu WHERE id = 'USRMENADM170700804001'; -- 1 rows
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM13A13025', 'MNDN000000028', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMFDDB8E82', 'MNDN000000028', NULL, 'magcentral', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM866FC0DD', 'MNDN000000028', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMED66F7D4', 'MNDN000000028', NULL, 'magtransitmp', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM4E422685', 'MNDN000000028', NULL, 'magtransiteblg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM5B5C5DB9', 'MNDN000000028', NULL, 'ctrmaitre', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM764D4E4D', 'MEN764610006403774', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMC229D1EA', 'MEN764610006403774', NULL, 'magcentral', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM90ADFDE8', 'MEN764610006403774', NULL, 'caisse', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMECCFC05B', 'MEN764610006403774', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM532DE836', 'MEN764610006403774', NULL, 'gestionnaire', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMEBC7550F', 'MEN764610006403774', NULL, 'magtransitmp', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM4DB1A7B0', 'MEN764610006403774', NULL, 'magtransiteblg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMEEB450C6', 'MEN764610006403774', NULL, 'ctrmaitre', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM32B50DEC', 'MEN764610006403774', NULL, 'pompiste', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMC1C3BBCC', 'MNDNMT0119', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMD1E8878D', 'MNDNMT0119', NULL, 'magcentral', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMA946B6FE', 'MNDNMT0119', NULL, 'caisse', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM0E9D29D5', 'MNDNMT0119', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM2AD1C3EF', 'MNDNMT0119', NULL, 'gestionnaire', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM9B950483', 'MNDNMT0119', NULL, 'magtransitmp', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMFC41AEF6', 'MNDNMT0119', NULL, 'magtransiteblg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMF8D13CC6', 'MNDNMT0119', NULL, 'ctrmaitre', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM8ED8108F', 'MNDNMT0119', NULL, 'pompiste', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM6DC9B43F', 'MENDYN1764919987323625', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM1625DB0E', 'MENDYN1764919987323625', NULL, 'magcentral', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM73FC13A7', 'MENDYN1764919987323625', NULL, 'caisse', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM6814C3B6', 'MENDYN1764919987323625', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMFEDE5BAB', 'MENDYN1764919987323625', NULL, 'gestionnaire', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM623D6E90', 'MENDYN1764919987323625', NULL, 'magtransitmp', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMB6ADE54C', 'MENDYN1764919987323625', NULL, 'magtransiteblg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM55950519', 'MENDYN1764919987323625', NULL, 'ctrmaitre', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMD4E30755', 'MENDYN1764919987323625', NULL, 'pompiste', 1);




UPDATE menudynamique SET libelle = 'Détails par entrée' WHERE id = 'MNDN0002706171';
