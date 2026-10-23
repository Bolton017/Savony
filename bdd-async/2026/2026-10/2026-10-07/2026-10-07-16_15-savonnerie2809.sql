-- Stefan
-- Changement dept

CREATE OR REPLACE VIEW MVTSTOCKLIB AS
SELECT
    m.ID ,
    m.DESIGNATION ,
    m.IDMAGASIN ,
    m.IDOBJET ,
    m2.VAL  AS idMagasinlib,
    m.IDVENTE ,
    v.DESIGNATION  AS idVentelib,
    m.IDTRANSFERT ,
    CAST('' AS VARCHAR2(255)) AS idTransfertlib,
    m.IDTYPEMVSTOCK ,
    t.VAL AS idTypeMvStocklib ,
    m.DATY ,
    m.ETAT ,
    CASE
        WHEN m.ETAT = 0
            THEN 'ANNUL&Eacute;'
        WHEN m.ETAT = 1
            THEN 'CR&Eacute;&Eacute;'
        WHEN m.ETAT = 11
            THEN 'VALID&Eacute;'
        END AS etatlib,
    v.IDRESERVATION,
    CAST(gm.montantEntree AS NUMBER(30,2)) AS montantEntree,
    CAST(gm.montantSortie AS NUMBER(30,2)) AS montantSortie,
    (
        m.DESIGNATION || ' ' ||
        NVL(m2.VAL, '') || ' ' ||
        NVL(v.DESIGNATION, '') || ' ' ||
        TO_CHAR(m.DATY, 'YYYY-MM-DD')
        ) AS motsClesss,
    m.remarque,
    m.HEURE,
    dm.IDDIRECTION as idDepartement,
    dm.IDDIRECTIONLib AS idDepartementLib,
    m.IDCATEGORIESTOCK,
    cs.val as idCategorieStockLib
FROM MVTSTOCK m
         LEFT JOIN TYPEMVTSTOCK t ON t.ID = m.IDTYPEMVSTOCK
         LEFT JOIN VENTE v ON v.ID = m.IDVENTE
         LEFT JOIN MAGASIN2 m2 ON m2.ID = m.IDMAGASIN
         LEFT JOIN DIRECTIONMAGASINLIB dm ON dm.IDMAGASIN = m.IDMAGASIN
         left join mvtStockFilleGroupeMere gm on gm.IDMVTSTOCK=m.ID
         LEFT JOIN categorieStock cs ON m.IDCATEGORIESTOCK = cs.id;


CREATE OR REPLACE VIEW V_INVENTAIREFILLECPL_2 AS
SELECT
    i.ID AS ID,
    i.IDINVENTAIRE AS IDINVENTAIRE,
    i.IDPRODUIT AS IDPRODUIT,
    p.LIBELLE AS IDPRODUITLIB,
    i.EXPLICATION AS EXPLICATION,
    CAST(
            NVL(i.QUANTITETHEORIQUE, 0)
        AS NUMBER(30, 6)
    ) AS QUANTITETHEORIQUE,
    CAST(
            NVL(i.QUANTITE, 0)
        AS NUMBER(30, 6)
    ) AS QUANTITE,
    p.LIBELLEEXTACTE AS LIBELLEEXTACTE,
    CAST(
            NVL(i.PU, 0)
        AS NUMBER(30, 6)
    ) AS PU,
    CAST(
            NVL(i.QUANTITE, 0)
                - NVL(i.QUANTITETHEORIQUE, 0)
        AS NUMBER(30, 6)
    ) AS ECART,
    iv.DATY AS DATEINV,
    CAST(
            NVL(i.PU, 0)
                * NVL(i.QUANTITETHEORIQUE, 0)
        AS NUMBER(30, 6)
    ) AS MONTANTTHEORIQUE,
    CAST(
            NVL(i.PU, 0)
                * NVL(i.QUANTITE, 0)
        AS NUMBER(30, 6)
    ) AS MONTANTREELLE,
    CAST(
            (
                NVL(i.PU, 0)
                    * NVL(i.QUANTITE, 0)
                )
                -
            (
                NVL(i.PU, 0)
                    * NVL(i.QUANTITETHEORIQUE, 0)
                )
        AS NUMBER(30, 6)
    ) AS ECARTMONTANT,
    p.CATEGORIEINGREDIENT AS CATEGORIEINGREDIENT,
    i.MVTSRC,
    au.ID AS idUnite,
    au.VAL AS idUniteLib,
    iv.idMagasin,
    m.IDMAGASINLIB as idMagasinLib,
    m.idDIRECTION AS IDDEPARTEMENT,
    m.IDDIRECTIONLIB AS IDDEPARTEMENTLIB
FROM
    INVENTAIREFILLE i
        LEFT JOIN INVENTAIRE iv
                  ON
                      iv.ID = i.IDINVENTAIRE
        LEFT JOIN AS_INGREDIENTS p
                  ON
                      p.ID = i.IDPRODUIT
        LEFT JOIN AS_UNITE au ON
        au.ID = p.UNITE
        LEFT JOIN DIRECTIONMAGASINLIB m ON m.IDMAGASIN = iv.IDMAGASIN
WHERE
    iv.ETAT >= 11
;


CREATE OR REPLACE VIEW INVENTAIRELIB AS
SELECT
    i.ID ,
    i.DATY ,
    i.DESIGNATION ,
    i.IDMAGASIN ,
    m.IDMAGASINLIB as idMagasinLib,
    i.ETAT ,
    CASE
        WHEN i.ETAT = 0
            THEN 'Annul&eacutee'
        WHEN i.ETAT = 1
            THEN 'Cr&eacute&eacutee'
        WHEN i.ETAT = 11
            THEN 'Vis&eacutee'
        END AS ETATLIB,
    i.idcategorie,
    c.VAL AS idcategorieLib,
    UPPER(
            NVL(i.DESIGNATION, '') || ' ' ||
            NVL(m.VAL, '') || ' ' ||
            NVL(c.VAL, '') || ' ' ||
            NVL(i.ID, '') || ' ' ||
            TO_CHAR(i.DATY, 'DD/MM/YYYY') || ' ' ||
            NVL(
                    CASE
                        WHEN i.ETAT = 0 THEN 'Annul&eacutee'
                        WHEN i.ETAT = 1 THEN 'Cr&eacute&eacutee'
                        WHEN i.ETAT = 11 THEN 'Vis&eacutee'
                        END
                , '')
    ) AS MOTSCLESSS,
    i.HEURE,
    dm.idDIRECTION AS IDDEPARTEMENT,
    dm.IDDIRECTIONLIB AS IDDEPARTEMENTLIB,
    CAST(ifgm.montantQuantite AS NUMBER(30,2) ) AS montantQuantite,
    i.REMARQUE
FROM INVENTAIRE i
         LEFT JOIN MAGASINPOINT m ON m.ID = i.IDMAGASIN
         LEFT JOIN DIRECTIONMAGASINLIB dm ON m.IDMAGASIN = i.IDMAGASIN
         LEFT JOIN CATEGORIEINGREDIENT c ON c.id = i.idcategorie
         LEFT JOIN INVENTAIREFILLEGROUPEMERE ifgm ON ifgm.IDINVENTAIRE = i.id;


CREATE OR REPLACE VIEW DEMANDETRANSFERTCPL AS
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
    t.CATEGORIEINGREDIENT,
    CAST(dfg.montantQuantite AS NUMBER(30,2)) AS montantQuantite,
    c.VAL  AS CATEGORIEINGREDIENTLIB,
    s.IDDIRECTION AS IDDEPARTEMENTDEPART,
    s.IDDIRECTIONLIB AS idDepartementLibDepart,
    s2.IDDIRECTION AS IDDEPARTEMENTARRIVE,
    s2.IDDIRECTIONLIB AS idDepartementLibArrive,
    CASE
        WHEN t.ETAT = 0
            THEN 'Annul&eacuteee'
        WHEN t.ETAT = 1
            THEN 'Cr&eacute&eacutee'
        WHEN t.ETAT = 11
            THEN 'Vis&eacutee'
        END AS ETATLIB
FROM demandetransfert t
         LEFT JOIN MAGASINPOINT m ON m.ID = t.IDMAGASINDEPART
         LEFT JOIN MAGASINPOINT m2 ON m2.ID = t.IDMAGASINARRIVE
         LEFT JOIN CATEGORIEINGREDIENT c ON c.ID = t.CATEGORIEINGREDIENT
         LEFT JOIN DIRECTIONMAGASINLIB s ON m.id = s.IDMAGASIN
         LEFT JOIN DIRECTIONMAGASINLIB s2 ON m2.id = s2.IDMAGASIN
         LEFT JOIN DEMTRANSFILLEGROUPEMERE dfg ON dfg.IDDEMANDETRANSFERT = t.id;


CREATE OR REPLACE VIEW TRANSFERTSTOCKCPL AS
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
            THEN 'ANNULÉE'
        WHEN t.ETAT = 1
            THEN 'CRÉÉE'
        WHEN t.ETAT = 11
            THEN 'VISÉE'
        END AS ETATLIB,
    t.iddemande,
    s.IDDIRECTION AS IDDEPARTEMENTDEPART,
    s.IDDIRECTIONLIB AS idDepartementLibDepart,
    s2.IDDIRECTION AS IDDEPARTEMENTARRIVE,
    s2.IDDIRECTIONLIB AS idDepartementLibArrive,
    CAST(tgm.montantQuantite AS NUMBER(30,2)) AS montantQuantite
FROM TRANSFERTSTOCK t
         LEFT JOIN MAGASINPOINT m ON m.ID = t.IDMAGASINDEPART
         LEFT JOIN MAGASINPOINT m2 ON m2.ID = t.IDMAGASINARRIVE
         LEFT JOIN DIRECTIONMAGASINLIB s ON m.id = s.IDMAGASIN
         LEFT JOIN DIRECTIONMAGASINLIB s2 ON m2.id = s2.IDMAGASIN
         LEFT JOIN TRANSTOCKDETAILSGROUPEMERE tgm ON tgm.IDTRANSFERTSTOCK = t.id;
 
 -- menu

UPDATE MENUDYNAMIQUE
SET HREF='module.jsp?but=magasin/directionMagasin-saisie.jsp'
WHERE ID='MNDMDF0001';

UPDATE MENUDYNAMIQUE
SET  HREF='module.jsp?but=magasin/directionMagasin-liste.jsp'
WHERE ID='MNDMDF0002';
 