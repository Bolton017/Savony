UPDATE MENUDYNAMIQUE SET LIBELLE = 'GRH et Paie', ICONE = 'account_balance_wallet', HREF = null, RANG = 11, NIVEAU = 1, ID_PERE = null where ID = 'ELM000010';

delete from MENUDYNAMIQUE where id in ('ELM000633',
                                       'JUIN002',
                                       'MD00000003004',
                                       'MD000000040030',
                                       'MD000020040030',
                                       'MD00021110001');

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES ('MENDYN1765357174546422', 'Période de paie', 'calendar_month', 'module.jsp?but=paie/editions/periodepaie-liste.jsp', 5, 2, 'ELM000010');
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES ('MENDYN1765437395219335', 'Gestion des heures supplémentaires', 'list_alt', null, 7, 2, 'ELM000010');
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES ('MENDYN1765481923948780', 'Gestion des abscenses', 'add', null, 3, 2, 'ELM000010');
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES ('ELM000633', 'Gestion du personnel', 'group', null, 1, 2, 'ELM000010');
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES ('MD000000040030', 'Gestion de la paie', 'payments', null, 2, 2, 'ELM000010');
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES ('MD000020040030', 'Gestion des Pointages', 'schedule', null, 4, 2, 'ELM000010');
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES ('MD00021110001', 'Gestion des &eacute;l&eacute;ments de paie', 'calculate', null, 6, 2, 'ELM000010');

-- GESTION DES HEURES SUPPLEMENTAIRES
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES ('MENDYN1765437929624908', 'Liste des HS calculées', 'list_alt', 'module.jsp?but=paie/hs/hsmois-liste.jsp', 2, 3, 'MENDYN1765437395219335');
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES ('MENDYN1765437542785116', 'Calcul HS', 'calculate', 'module.jsp?but=paie/hs/hsmois-calcul.jsp', 1, 3, 'MENDYN1765437395219335');


-- GESTION DES ABSENCES
delete from MENUDYNAMIQUE where id in (
                                       'JUIK003', 'JUIN003',
                                       'JUIN004',
                                       'MD000000001_2'
    );
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES ('MENDYN1765482208757832', 'Liste des absences', 'list_alt', 'module.jsp?but=paie/demande/demande-absence-liste.jsp', 2, 3, 'MENDYN1765481923948780');
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES ('MENDYN1765482234345949', 'Nouvelle absence', 'sticky_note_2', 'module.jsp?but=paie/demande/mademande.jsp', 3, 3, 'MENDYN1765481923948780');
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES ('MD000000001_2', 'Solde des congés-Droits', 'account_balance_wallet', 'module.jsp?but=paie/conge/solde-conge.jsp', 1, 3, 'MENDYN1765481923948780');


-- GESTION DU PERSONNEL

delete from MENUDYNAMIQUE where id in('ELM00063377',
                                      'ELM0006587',
                                      'ELM00065877',
                                      'ELM000650',
                                      'ELM000651',
                                      'ELM000652',
                                      'ELM0006534');

DELETE FROM MENUDYNAMIQUE WHERE ID IN('ELM000658','ELM000659');
DELETE FROM MENUDYNAMIQUE WHERE ID IN('ELM000668','ELM000669');
delete from MENUDYNAMIQUE where id in('ELM0006587','ELM00065877');

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES ('ELM00063377', 'Sanction', 'gavel', 'module.jsp?but=paie/employe/sanction/sanction-liste.jsp', 5, 3, 'ELM000633');
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES ('ELM000650', 'Liste des employés', 'group', 'module.jsp?but=paie/employe/infopersonnel-liste.jsp', 3, 3, 'ELM000633');
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES ('ELM000651', 'Embauche', 'person_add', 'module.jsp?but=paie/employe/infopersonnel-saisie.jsp', 1, 3, 'ELM000633');
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES ('ELM000652', 'Départ', 'logout', 'module.jsp?but=paie/employe/personnelnonvalide-liste.jsp', 2, 3, 'ELM000633');
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES ('ELM0006534', 'Mouvement', 'swap_horiz', null, 4, 3, 'ELM000633');


-- MENU AO ANATY MOUVEMENT
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES ('MENDYN1765387193828636', 'Avancement de fonction', 'add', 'module.jsp?but=paie/avancement/avancement-fonction.jsp', 3, 4, 'ELM0006534');
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES ('MENDYN176538722666076', 'Avancement de contrat', 'add', 'module.jsp?but=paie/avancement/avancement-contrat.jsp', 4, 4, 'ELM0006534');
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES ('MENDYN1765387283877183', 'Avancement de catégorie qualification', 'add', 'module.jsp?but=paie/avancement/avancement-categorie.jsp', 5, 4, 'ELM0006534');
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES ('MENDYN1765387318000411', 'Avancement de direction', 'add', 'module.jsp?but=paie/avancement/avancement-direction.jsp', 6, 4, 'ELM0006534');
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES ('ELM000668', 'Liste', 'list_alt', 'module.jsp?but=paie/avancement/avancement-liste.jsp', 1, 4, 'ELM0006534');



