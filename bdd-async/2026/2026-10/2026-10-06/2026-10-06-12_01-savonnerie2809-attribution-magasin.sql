INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES('MNDMD0001', 'Attribution magasin', 'list_alt', NULL, 8, 2, 'MNDN000000003');

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES('MNDMDF0001', 'Saisie', 'add', 'module.jsp?but=magasin/magasinDirection-saisie.jsp', 1, 3, 'MNDMD0001');
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES('MNDMDF0002', 'Liste', 'list_alt', 'module.jsp?but=magasin/magasinDirection-liste.jsp', 2, 3, 'MNDMD0001');
