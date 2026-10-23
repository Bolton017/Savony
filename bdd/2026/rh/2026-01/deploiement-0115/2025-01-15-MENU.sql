-- MENU gestion pointages
DELETE FROM MENUDYNAMIQUE WHERE ID IN('MENDYN00001', 'MENDYN00891', 'MENDYN00981');

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES ('MENDYN1765892827090649', 'Pointage cantine', 'add', 'module.jsp?but=cantine/pointage-cantine.jsp', 4, 3, 'MD000020040030');
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES ('MENDYN00001', 'Nouveau pointage', 'add', 'module.jsp?but=paie/pointage/pointage-saisie.jsp', 1, 3, 'MD000020040030');
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES ('MENDYN00891', 'Liste des pointages', 'view_list', 'module.jsp?but=paie/pointage/pointage-liste.jsp', 2, 3, 'MD000020040030');
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES ('MENDYN00981', 'Visa Pointage', 'fact_check', 'module.jsp?but=paie/pointage/pointage-visa.jsp', 3, 3, 'MD000020040030');


