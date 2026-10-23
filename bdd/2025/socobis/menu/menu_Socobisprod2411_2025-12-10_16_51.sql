UPDATE menudynamique SET rang = 5 WHERE id = 'MENDYN001';
UPDATE menudynamique SET rang = 6 WHERE id = 'MD000000040032Z_02';
UPDATE menudynamique SET rang = 7 WHERE id = 'MD000000040032Z_03';
UPDATE menudynamique SET rang = 8 WHERE id = 'MD000000040032Z_04';
UPDATE menudynamique SET rang = 9 WHERE id = 'MENDYN0010';
UPDATE menudynamique SET rang = 10 WHERE id = 'MD00000000101';
UPDATE menudynamique SET rang = 1 WHERE id = 'MENDYN0010';
UPDATE menudynamique SET rang = 2 WHERE id = 'MD000000040031';
UPDATE menudynamique SET rang = 3 WHERE id = 'MD000000040032';
UPDATE menudynamique SET rang = 4 WHERE id = 'AMS006';
UPDATE menudynamique SET rang = 5 WHERE id = 'MD000000040032Z_01';

-- script pour l'usermenu

INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM38574428', 'AMS007', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM326BDE80', 'AMS007', NULL, 'magcentral', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UME7401E6B', 'AMS007', NULL, 'caisse', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM565247AE', 'AMS007', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM9E596678', 'AMS007', NULL, 'gestionnaire', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM07095DBE', 'AMS007', NULL, 'magtransitmp', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM6F6B2F84', 'AMS007', NULL, 'magtransiteblg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMB9DBA198', 'AMS007', NULL, 'ctrmaitre', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM7993C488', 'AMS007', NULL, 'pompiste', 1);
