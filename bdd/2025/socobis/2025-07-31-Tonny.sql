create view DEMANDETRANSFERTCPL as
SELECT
    t.ID ,
    t.DESIGNATION ,
    t.IDMAGASINDEPART ,
    m.VAL AS IDMAGASINDEPARTLIB,
    t.IDMAGASINARRIVE ,
    m2.VAL AS IDMAGASINARRIVELIB,
    t.DATY ,
    t.ETAT ,
    t.idof,
    CASE
        WHEN t.ETAT = 0
            THEN 'ANNULEE'
        WHEN t.ETAT = 1
            THEN 'CREE'
        WHEN t.ETAT = 11
            THEN 'VISEE'
        END AS ETATLIB
FROM demandetransfert t
         LEFT JOIN MAGASINPOINT m ON m.ID = t.IDMAGASINDEPART
         LEFT JOIN MAGASINPOINT m2 ON m2.ID = t.IDMAGASINARRIVE;


create view DEMANDETRANSFERTFILLECPL as
SELECT
    t.ID ,
    t.IDdemandetransfert ,
    t2.DESIGNATION AS IDdemandetransfertLIB,
    t.IDPRODUIT ,
    p.libelle AS IDPRODUITLIB,
    CAST (t.QUANTITE AS NUMBER(30,2)) AS QUANTITE,
    p.TYPESTOCK,
    p.UNITE,
    p.PU
FROM demandetransfertfille t
         LEFT JOIN demandetransfert t2 ON t2.ID = t.IDdemandetransfert
         LEFT JOIN AS_INGREDIENTS  p ON p.ID = t.IDPRODUIT;
