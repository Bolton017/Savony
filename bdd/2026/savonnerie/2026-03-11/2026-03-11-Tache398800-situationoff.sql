create or replace view situationoffille as
SELECT
    rc.IDPRODUITS,
    rc.IDINGREDIENTS,
    rc.LIBINGREDIENTS,
    CAST(NVL(rc.QUANTITE, 0) AS NUMBER(30, 2))                                                        AS qteof,
    CAST(NVL(SUM(mvt.ENTREE), 0) AS NUMBER(30, 2))             AS qtefabrique,
    CAST(NVL(rc.QUANTITE, 0) AS NUMBER(30, 2)) - CAST(NVL(SUM(mvt.ENTREE), 0) AS NUMBER(30, 2))       AS raf,
    rc.IDPRODUITS as id
FROM AS_RECOFFVUESTFAB rc
         LEFT JOIN (
    SELECT
        fab.ID,
        fab.IDOFFILLE,
        f.IDINGREDIENTS
    FROM FABRICATION fab
             LEFT JOIN FABRICATIONFILLE f ON fab.id = f.idMere
    WHERE fab.etat >= 11
    GROUP BY fab.ID, fab.IDOFFILLE, f.IDINGREDIENTS
) fab ON fab.IDINGREDIENTS = rc.IDINGREDIENTS
    AND fab.IDOFFILLE = rc.IDPRODUITS
         LEFT JOIN (
    select st."ID",
           st."IDMVTSTOCK",
           st."IDPRODUIT",
           st."ENTREE",
           st."SORTIE",
           st."IDVENTEDETAIL",
           st."IDTRANSFERTDETAIL",
           st."PU",
           st."MVTSRC",
           st."RESTE",
           st."DESIGNATION",
           m.IDOBJET as idFab
    from MVTSTOCKFILLE st
             left join MVTSTOCK m on st.IDMVTSTOCK = m.ID
    where m.etat >= 11
) mvt ON mvt.IDFAB = fab.ID AND mvt.IDPRODUIT = fab.IDINGREDIENTS
WHERE rc.TYPESTOCK IS NOT NULL
GROUP BY
    rc.IDPRODUITS,
    rc.IDINGREDIENTS,
    rc.LIBINGREDIENTS,
    rc.QUANTITE;