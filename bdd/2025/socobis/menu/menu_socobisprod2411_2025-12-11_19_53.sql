UPDATE menudynamique SET href = 'module.jsp?but=maintenance/demandetravaux/demandetravaux-liste.jsp' WHERE id = 'MNDNMT0126';
UPDATE menudynamique SET href = 'module.jsp?but=maintenance/planning/planning-liste.jsp' WHERE id = 'MNDNMT0127';

-- script pour l'usermenu

DELETE FROM usermenu WHERE id = 'UMF8374ABA'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM3A1046FE'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMEC9E045B'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM1A625FD1'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMMMT02356446545'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMMMT5465121254654'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMAEAF6780'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMDEE17123'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMC80A960F'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM26717471'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM76393E5F'; -- 1 rows
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM604FA868', 'MNDNMT0128', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UME061D97F', 'MNDNMT0128', NULL, 'magcentral', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMDABB3E28', 'MNDNMT0128', NULL, 'caisse', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMA599CDE3', 'MNDNMT0128', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMB32B714C', 'MNDNMT0128', NULL, 'gestionnaire', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM240CDB5A', 'MNDNMT0128', NULL, 'magtransitmp', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM7F4CC554', 'MNDNMT0128', NULL, 'magtransiteblg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM855FE838', 'MNDNMT0128', NULL, 'respachat', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMF39FED20', 'MNDNMT0128', NULL, 'chefachat', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM7AD34257', 'MNDNMT0128', NULL, 'ctrmaitre', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMC0B7BDAD', 'MNDNMT0128', NULL, 'pompiste', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM32E708DA', 'MNDNMT0129', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM2F14FF43', 'MNDNMT0129', NULL, 'magcentral', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMC93933D6', 'MNDNMT0129', NULL, 'caisse', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM9F0ED536', 'MNDNMT0129', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM3E88A67E', 'MNDNMT0129', NULL, 'gestionnaire', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM0F872556', 'MNDNMT0129', NULL, 'magtransitmp', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM34DF9A5D', 'MNDNMT0129', NULL, 'magtransiteblg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM94AF2E6A', 'MNDNMT0129', NULL, 'respachat', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM1708947D', 'MNDNMT0129', NULL, 'chefachat', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM098B4011', 'MNDNMT0129', NULL, 'ctrmaitre', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMAC661034', 'MNDNMT0129', NULL, 'pompiste', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM3F238826', 'MNDNMT0130', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM3AF1ECA6', 'MNDNMT0130', NULL, 'magcentral', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMBEC7DA27', 'MNDNMT0130', NULL, 'caisse', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM8C46C8C9', 'MNDNMT0130', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM302BC569', 'MNDNMT0130', NULL, 'gestionnaire', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMC5BAE3D0', 'MNDNMT0130', NULL, 'magtransitmp', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM14265EC9', 'MNDNMT0130', NULL, 'magtransiteblg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM94D04945', 'MNDNMT0130', NULL, 'respachat', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM93679840', 'MNDNMT0130', NULL, 'chefachat', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM364AB3B2', 'MNDNMT0130', NULL, 'ctrmaitre', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM71015E89', 'MNDNMT0130', NULL, 'pompiste', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM8F7BAEEF', 'MNDNMT0131', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM0315A6C9', 'MNDNMT0131', NULL, 'magcentral', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM89B5335C', 'MNDNMT0131', NULL, 'caisse', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMDF88B66D', 'MNDNMT0131', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM4AD94155', 'MNDNMT0131', NULL, 'gestionnaire', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM5E55720E', 'MNDNMT0131', NULL, 'magtransitmp', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM6D37970A', 'MNDNMT0131', NULL, 'magtransiteblg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM5BC55C8D', 'MNDNMT0131', NULL, 'respachat', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM9D72FF19', 'MNDNMT0131', NULL, 'chefachat', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM316B70C7', 'MNDNMT0131', NULL, 'ctrmaitre', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMC37749A2', 'MNDNMT0131', NULL, 'pompiste', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM711D9218', 'MNDNMT0119', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM9CC73BB7', 'MNDNMT0119', NULL, 'magcentral', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM0A48E990', 'MNDNMT0119', NULL, 'caisse', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM05CB0E8C', 'MNDNMT0119', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM33052116', 'MNDNMT0119', NULL, 'gestionnaire', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM7F43912F', 'MNDNMT0119', NULL, 'magtransitmp', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMCFF9A43E', 'MNDNMT0119', NULL, 'magtransiteblg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM350889A1', 'MNDNMT0119', NULL, 'respachat', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UME333F060', 'MNDNMT0119', NULL, 'chefachat', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMD6ED50F3', 'MNDNMT0119', NULL, 'ctrmaitre', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM3F2609D4', 'MNDNMT0119', NULL, 'pompiste', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM205BF5E2', 'MENDYN1764919987323625', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM99C732EB', 'MENDYN1764919987323625', NULL, 'magcentral', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM7ADCBBCD', 'MENDYN1764919987323625', NULL, 'caisse', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM887AF5F2', 'MENDYN1764919987323625', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM6F887E70', 'MENDYN1764919987323625', NULL, 'gestionnaire', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM8F2F9B72', 'MENDYN1764919987323625', NULL, 'magtransitmp', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMFA2C8A8D', 'MENDYN1764919987323625', NULL, 'magtransiteblg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM1D481E75', 'MENDYN1764919987323625', NULL, 'respachat', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM7B653848', 'MENDYN1764919987323625', NULL, 'chefachat', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM6F5EA109', 'MENDYN1764919987323625', NULL, 'ctrmaitre', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMC0D1DEEE', 'MENDYN1764919987323625', NULL, 'pompiste', 1);
