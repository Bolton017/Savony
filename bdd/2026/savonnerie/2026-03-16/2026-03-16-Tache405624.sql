UPDATE menudynamique SET rang = 5, niveau = 2, id_pere = 'MENUDYN00304001' WHERE id = 'MNDN00001';
UPDATE menudynamique SET niveau = 3 WHERE id = 'MNDN000011';
UPDATE menudynamique SET niveau = 3 WHERE id = 'MNDN000012';
UPDATE menudynamique SET rang = 2 WHERE id = 'MNDN000000001';
UPDATE menudynamique SET rang = 3 WHERE id = 'ELM00T3004001';
UPDATE menudynamique SET rang = 8 WHERE id = 'MNDNMT01';
UPDATE menudynamique SET rang = 11 WHERE id = 'MENUDYN003';
UPDATE menudynamique SET rang = 12 WHERE id = 'ELM000010';
UPDATE menudynamique SET rang = 13 WHERE id = 'MENUP001V';
UPDATE menudynamique SET rang = 14 WHERE id = 'ELM000904001';
UPDATE menudynamique SET rang = 15 WHERE id = 'MENUDYNC003';
UPDATE menudynamique SET rang = 17 WHERE id = 'ELM00317777';
UPDATE menudynamique SET rang = 18 WHERE id = 'ELM00317777001';

-- script pour l'usermenu

DELETE FROM usermenu WHERE id = 'USRMENMGCTRL008'; -- 1 rows
DELETE FROM usermenu WHERE id = 'USRMENADM07622'; -- 1 rows
DELETE FROM usermenu WHERE id = 'USRMENCHFAB07622'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMMMT'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM278E3D0F'; -- 1 rows
DELETE FROM usermenu WHERE id = 'USRMENC019'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM31BCC4CE'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM01603T004'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM01603T005'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM01603T006'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM016034T004'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM016035T004'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM016035T005'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM016034T002'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM016034T003'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM016035T006'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM016035T007'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM016036T004'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM016036T005'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM016036T006'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM016037T004'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM016037T005'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM016037T006'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM016037T007'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM016038T004'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM016038T005'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM016038T006'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM016038T007'; -- 1 rows
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UME191ED3D', 'MENUDYN00304001', NULL, 'cheffab', 0);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UME397EF31', 'MENUDYN00304001', NULL, 'caisse', 0);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMC9783C66', 'MENUDYN00304001', NULL, 'dg', 0);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM686DC9AE', 'MENUDYN00304001', NULL, 'magtransiteblg', 0);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM32F6CC12', 'MENUDYN00304001', NULL, 'respachat', 0);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM8A665ED2', 'MENUDYN00304001', NULL, 'respvente', 0);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM1705C10F', 'MENUDYN00304001', NULL, 'pompiste', 0);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM0D0E9DEB', 'MENUDYN00304001', NULL, 'magcentral', 0);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UME0CF44FA', 'MENUDYN00304001', NULL, 'gestionnaire', 0);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM53BDDC38', 'MENUDYN00304001', NULL, 'magtransitmp', 0);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM0142717A', 'MENUDYN00304001', NULL, 'ctrmaitre', 0);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM28F53362', 'MNDNMT01', NULL, 'cheffab', 0);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMFE654F6A', 'MNDNMT01', NULL, 'caisse', 0);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM8E65FE9A', 'MNDNMT01', NULL, 'dg', 0);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM5A1924FD', 'MNDNMT01', NULL, 'magtransiteblg', 0);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMCD013B1B', 'MNDNMT01', NULL, 'respachat', 0);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM25D12D94', 'MNDNMT01', NULL, 'respvente', 0);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMFB87FE72', 'MNDNMT01', NULL, 'pompiste', 0);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMBF645F62', 'MNDNMT01', NULL, 'magcentral', 0);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMBA326F3E', 'MNDNMT01', NULL, 'gestionnaire', 0);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM74C30AC4', 'MNDNMT01', NULL, 'magtransitmp', 0);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMEB3240E4', 'MNDNMT01', NULL, 'ctrmaitre', 0);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UME84E439B', 'ELM000010', NULL, 'cheffab', 0);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMA41CA788', 'ELM000010', NULL, 'caisse', 0);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM4F07B660', 'ELM000010', NULL, 'dg', 0);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM2A7DC44A', 'ELM000010', NULL, 'magtransiteblg', 0);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM1149E970', 'ELM000010', NULL, 'respachat', 0);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM56F23E53', 'ELM000010', NULL, 'respvente', 0);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM1762F23D', 'ELM000010', NULL, 'pompiste', 0);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM18F142E6', 'ELM000010', NULL, 'magcentral', 0);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMBFD3B2AA', 'ELM000010', NULL, 'gestionnaire', 0);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM9E960C9D', 'ELM000010', NULL, 'magtransitmp', 0);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM038B7F21', 'ELM000010', NULL, 'ctrmaitre', 0);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMA61D9A66', 'MENUDYNC003', NULL, 'cheffab', 0);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM511F7E0B', 'MENUDYNC003', NULL, 'caisse', 0);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM0304F98C', 'MENUDYNC003', NULL, 'dg', 0);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM0AC190A1', 'MENUDYNC003', NULL, 'magtransiteblg', 0);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM0A23AAB0', 'MENUDYNC003', NULL, 'respachat', 0);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMD8DE4566', 'MENUDYNC003', NULL, 'respvente', 0);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UME5B68192', 'MENUDYNC003', NULL, 'pompiste', 0);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM59002D41', 'MENUDYNC003', NULL, 'magcentral', 0);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM3A8DA0A0', 'MENUDYNC003', NULL, 'gestionnaire', 0);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMD3B19C1F', 'MENUDYNC003', NULL, 'magtransitmp', 0);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMB4EE94E9', 'MENUDYNC003', NULL, 'ctrmaitre', 0);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM144BA582', 'MNDN00001', NULL, 'caisse', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMF7DFAE52', 'MNDN00001', NULL, 'magtransiteblg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM74F10157', 'MNDN00001', NULL, 'respachat', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMAA9313A6', 'MNDN00001', NULL, 'respvente', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM2D0DD68D', 'MNDN00001', NULL, 'technique', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM97A71554', 'MNDN00001', NULL, 'pompiste', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM00508845', 'MNDN00001', NULL, 'gestionnaire', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM2073161D', 'MNDN00001', NULL, 'magtransitmp', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM78B37BD7', 'MNDN00001', NULL, 'ctrmaitre', 1);
