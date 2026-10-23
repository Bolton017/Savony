
INSERT INTO UTILISATEUR
(REFUSER, LOGINUSER, PWDUSER, NOMUSER, ADRUSER, TELUSER, IDROLE)
VALUES(991025, 'rpmahefa', '8i8i', 'rpmahefa', 'DIR42', '1002067', 'chefachat');

INSERT INTO PARAMCRYPT
(ID, NIVEAU, CROISSANTE, IDUTILISATEUR)
VALUES('CRY-p0028231025', 4, 1, '991025');
    
INSERT INTO CNAPS_USER
(ID, CODE_DR, USER_INIT, AGENT_MO, AGENT_DISPONIBLE, USERNAME, CODE_SERVICE, ID_UTILISATEUR)
VALUES('CNP-10001431025', 'DIR00001', '1', '1', '1', 'rpmahefa', '1', '991025');


UPDATE UTILISATEUR
SET LOGINUSER='dirusine', PWDUSER='9enqoeja', NOMUSER='Directrice usine', ADRUSER='DIR42', TELUSER=NULL, IDROLE='chefachat'
WHERE REFUSER=880685;

DELETE FROM usermenu WHERE id = 'UM04BB80CC'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM93423B71'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMA0B77BC9'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM9997D0B5'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UME614045E'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM18D26D78'; -- 1 rows

DELETE FROM usermenu WHERE id = 'UM78036263'; -- 1 rows
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM887A68D1', 'ELM000010', NULL, 'cheffab', 0);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM0E4D9260', 'ELM000010', NULL, 'magcentral', 0);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM85BBEFA1', 'ELM000010', NULL, 'caisse', 0);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM111310DB', 'ELM000010', NULL, 'dg', 0);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM2F64DC11', 'ELM000010', NULL, 'gestionnaire', 0);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM634B0CA0', 'ELM000010', NULL, 'magtransitmp', 0);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMDEB62471', 'ELM000010', NULL, 'magtransiteblg', 0);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM725BBECB', 'ELM000010', NULL, 'ctrmaitre', 0);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM68EFB354', 'ELM000010', NULL, 'pompiste', 0);
