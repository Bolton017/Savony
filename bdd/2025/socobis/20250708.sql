CREATE OR REPLACE VIEW V_ETATSTOCK_ENTREE AS
SELECT
    ve.id,
    ai.id AS IDPRODUIT ,
    ai.LIBELLE AS idproduitlib,
    ai.CATEGORIEINGREDIENT ,
    c.VAL AS idtypeproduitlib,
    ve.IDMAGASIN,
    m.VAL AS idmagasinlib,
    CAST(ve.QUANTITE AS number(30,2)) AS QUANTITE ,
    CAST(ve.ENTREE AS number(30,2)) AS ENTREE ,
    CAST(ve.SORTIE AS number(30,2)) AS SORTIE ,
    CAST(ve.RESTE AS number(30,2)) AS RESTE ,
    ai.UNITE ,
    u.VAL AS idunitelib,
    CAST(ve.PU AS number(30,2)) AS PU,
    ve.DATY
FROM
    MVTSTOCKENTREEAVECRESTE2 ve
        LEFT JOIN AS_INGREDIENTS ai ON
        ai.id = ve.IDPRODUIT
        LEFT JOIN CATEGORIEINGREDIENT c ON
        ai.CATEGORIEINGREDIENT = c.id
        LEFT JOIN MAGASIN2 m ON
        ve.IDMAGASIN = m.id
        LEFT JOIN UNITE u ON ai.UNITE = u.id;

CREATE OR REPLACE VIEW CHARGEGROUPBYOFF AS
select ofile.id as idoff, cast(0 as number(30,3)) as montantentree,cast(nvl(sum(c.pu*c.qte),0) as number(30,3)) as montantsortie
from charge c
         left join fabrication fabb on c.IDFABRICATION=fabb.id
         left join OFFILLE ofile on fabb.IDOFFILLE=ofile.ID
where c.etat>=11 group by ofile.id;
       