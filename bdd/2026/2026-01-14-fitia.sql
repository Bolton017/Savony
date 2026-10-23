
alter table MVTSTOCKFILLE add idinventairefille varchar(255);

create or replace view V_ETATSTOCK_ENTREE as
SELECT
    ve.id,
    ai.id AS IDPRODUIT ,
    ai.LIBELLE AS idproduitlib,
    ai.CATEGORIEINGREDIENT ,
    c.VAL AS idtypeproduitlib,
    ve.IDMAGASIN,
    m.VAL AS idmagasinlib,
    CAST(ve.QUANTITE AS number(30,5)) AS QUANTITE ,
    CAST(ve.ENTREE AS number(30,5)) AS ENTREE ,
    CAST(ve.SORTIE AS number(30,5)) AS SORTIE ,
    CAST(ve.RESTE AS number(30,5)) AS RESTE ,
    ai.UNITE ,
    u.VAL AS idunitelib,
    CAST(ve.PU AS number(30,5)) AS PU,
    ve.DATY,
    '' as idFournisseur,
    '' as idFournisseurLib,
    ve.daty as dateAchat
FROM
    MVTSTOCKENTREEAVECRESTE ve
        LEFT JOIN AS_INGREDIENTS ai ON
        ai.id = ve.IDPRODUIT
        LEFT JOIN CATEGORIEINGREDIENT c ON
        ai.CATEGORIEINGREDIENT = c.id
        LEFT JOIN MAGASIN2 m ON
        ve.IDMAGASIN = m.id
        LEFT JOIN UNITE u ON ai.UNITE = u.id
WHERE ve.RESTE > 0 and ve.pu > 0
/


create or replace view INVENTAIRE_FILLE_CPL as
SELECT 
i.ID ,
i.IDINVENTAIRE ,
i.IDPRODUIT ,
p.LIBELLE AS IDPRODUITLIB,
i.EXPLICATION ,
i.QUANTITETHEORIQUE ,
i.QUANTITE ,
i2.DATY ,
i2.IDMAGASIN ,
i.idJauge,
i2.ETAT,
i.MVTSRC
FROM INVENTAIREFILLE i 
LEFT JOIN AS_INGREDIENTS  p ON p.ID  = i.IDPRODUIT 
LEFT JOIN INVENTAIRE i2 ON i2.ID  = i.IDINVENTAIRE

/

create or replace view INVENTAIRE_FILLE_CPL_VALIDE as
SELECT 
i."ID",i."IDINVENTAIRE",i."IDPRODUIT",i."IDPRODUITLIB",i."EXPLICATION",i."QUANTITETHEORIQUE",i."QUANTITE",i."DATY",i."IDMAGASIN",i."IDJAUGE",i.MVTSRC,i."ETAT"
FROM INVENTAIRE_FILLE_CPL i
JOIN INVENTAIRE inventaire ON inventaire.ID  = i.IDINVENTAIRE
WHERE inventaire.ETAT >=11
/