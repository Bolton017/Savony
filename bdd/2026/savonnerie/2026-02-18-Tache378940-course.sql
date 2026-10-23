INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELM00317777', 'Logistique', 'local_shipping', NULL, 24, 1, NULL);
INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MENDYN1768378247555359', 'Course', 'apps', NULL, 1, 2, 'ELM00317777');
INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MENDYN1768378269559598', 'Saisie', 'edit', 'module.jsp?but=transport/course-saisie.jsp', 1, 3, 'MENDYN1768378247555359');
INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MENDYN1768378280127693', 'Liste', 'view_list', 'module.jsp?but=transport/course-liste.jsp', 2, 3, 'MENDYN1768378247555359');

INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMA18FEFBB', 'ELM00317777', NULL, 'caisse', 0);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM5F4EA231', 'ELM00317777', NULL, 'dg', 0);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM04BAACCB', 'ELM00317777', NULL, 'gestionnaire', 0);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM055C5043', 'ELM00317777', NULL, 'respachat', 0);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMA9E0BB4C', 'ELM00317777', NULL, 'respvente', 0);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMC3037B11', 'MENDYN1768378247555359', NULL, 'caisse', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM116E0408', 'MENDYN1768378247555359', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM07F3A5A5', 'MENDYN1768378247555359', NULL, 'gestionnaire', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMB5EFEB77', 'MENDYN1768378247555359', NULL, 'respachat', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMEF1D5520', 'MENDYN1768378247555359', NULL, 'respvente', 1);
