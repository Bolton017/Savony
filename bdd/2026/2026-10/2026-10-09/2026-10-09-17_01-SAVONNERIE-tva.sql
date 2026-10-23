
INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MENDYN17695157391569330010940301', 'Lettrage TVA', 'add', 'module.jsp?but=compta/lettrage/lettrage-tva-saisie.jsp', 2, 3, 'MNDNT2205001C');


UPDATE MENUDYNAMIQUE
SET LIBELLE = 'Lettrées',
    ICONE   = 'view_list',
    HREF    = 'module.jsp?but=compta/lettrage/lettrage-liste.jsp',
    RANG    = 3,
    NIVEAU  = 3,
    ID_PERE = 'MNDNT2205001C'
WHERE ID = 'MENDYN17695153020177390190-94C’;