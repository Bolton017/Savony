UPDATE menudynamique SET href = 'module.jsp?but=compteur/compteur-liste.jsp' WHERE id = 'MENUDYN01908001';
UPDATE menudynamique SET href = 'module.jsp?but=fabrication/etat-global.jsp' WHERE id = 'MENUDYN02108001';

-- script pour l'usermenu

INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM4F6AE984', 'MENUDYN01908002', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMC6501082', 'MENUDYN01908002', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMEDC4028F', 'MENUDYN01908002', NULL, 'magtransitmp', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM2C402353', 'MENUDYN01908002', NULL, 'magtransiteblg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM9BC01A5B', 'MENUDYN01908002', NULL, 'ctrmaitre', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM5D63F2D2', 'MENUDYN01908003', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMC46BC915', 'MENUDYN01908003', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM1861D31F', 'MENUDYN01908003', NULL, 'magtransitmp', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM7840FD0D', 'MENUDYN01908003', NULL, 'magtransiteblg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM0051F7AA', 'MENUDYN01908003', NULL, 'ctrmaitre', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMD4ECC565', 'MENUDYN02108002', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM1A173FF8', 'MENUDYN02108002', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMD6282BF7', 'MENUDYN02108002', NULL, 'magtransitmp', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM41205F38', 'MENUDYN02108002', NULL, 'magtransiteblg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM3E6E2D5D', 'MENUDYN02108002', NULL, 'ctrmaitre', 1);
