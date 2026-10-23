-- Tonny

alter table AS_INGREDIENTS add (IDTYPEPRODUIT VARCHAR(50) references TYPEPRODUIT(id));


create or replace view  analyses_type_produit AS
SELECT
    tp.ID              AS idtypeproduit,
    tp.VAL             AS idtypeproduitlib,
    COUNT(a.ID)        AS nombreanalyses
FROM TYPEPRODUIT tp
         LEFT JOIN AS_INGREDIENTS ai
                   ON ai.IDTYPEPRODUIT = tp.ID
         LEFT JOIN FABRICATIONFILLE ff
                   ON ff.IDINGREDIENTS = ai.ID
         LEFT JOIN FABRICATION f
                   ON f.ID = ff.IDMERE
         LEFT JOIN ANALYSE a
                   ON a.IDFABRICATION = f.ID
GROUP BY
    tp.ID,
    tp.VAL
ORDER BY
    tp.VAL;

create or replace view ANALYSECPL as
SELECT
    a.ID,
    a.IDCRITERE,
    a.IDFABRICATION,
    a.VALEUR,
    a.IDRESPONSABLE,
    a.ETAT,
    -- Libellés des références
    c.val AS IDCRITERELIB,               -- depuis table CRITERE
    f.LIBELLE AS IDFABRICATIONLIB,          -- depuis table FABRICATION
    p.NOM || ' ' || p.PRENOM AS IDRESPONSABLELIB, -- depuis table LOG_PERSONNEL (exemple concat)
    -- Libellé pour ETAT (ex: 1=Actif, 0=Inactif)
    CASE
        WHEN f.ETAT=1
            THEN 'CRÉÉ'
        WHEN f.ETAT=11
            THEN 'VALIDÉ'
        WHEN f.ETAT=0
            THEN 'ANNULÉ'
        END AS ETATLIB,
    a.DATY
FROM ANALYSE a
         LEFT JOIN CRITERE c ON a.IDCRITERE = c.ID
         LEFT JOIN FABRICATION f ON a.IDFABRICATION = f.ID
         LEFT JOIN LOG_PERSONNEL p ON a.IDRESPONSABLE = p.ID
    /

