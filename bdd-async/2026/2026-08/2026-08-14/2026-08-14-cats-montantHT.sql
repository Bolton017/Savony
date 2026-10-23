
create or replace view VENTE_DETAILS_POIDS as
SELECT v.ID,
       v.IDVENTE,
       v.IDPRODUIT,
       v.IDORIGINE,
       CAST(v.QTE AS NUMBER(38, 2)) AS QTE,
       v.PU,
       v.REMISE,
       v.TVA,
       v.PUACHAT,
       v.PUVENTE,
       v.IDDEVISE,
       v.TAUXDECHANGE,
       v.DESIGNATION,
       v.COMPTE,
       v.PUREVIENT,
       v.IDBCFILLE,
       v.UNITE,
       v.UNITELIB,
       v.PUNET,
       cast(v.MONTANTHT as number(30,2)) as MONTANTHT,
       cast(v.MONTANTTTC as number(30,2)) as MONTANTTTC,
       cast(v.MONTANTTVA as number(30,2)) as montanttva,
       v.MONTANTREMISE,
       v.MONTANT,
       v.poids,
       vc.RESTE                     AS RESTE,
       v.frais                      AS FRAIS,
       v.IDPRODUITLIB,
       v.DATY,
       v.DATYPREVU                  AS DATYPREVU,
       v.IDDEVISE                   AS IDDEVISELIB,
       v.IDCATEGORIELIB,
       v.CATEGORIEPRODUITLIB,
       montantttc                   AS PUTOTAL,
       v.idclientlib,
       v.RISTOURNE                  AS RISTOURNE
FROM VENTE_DETAILS_VIDE v
         LEFT JOIN EQUIVALENCE e
                   ON e.IDPRODUIT = v.IDPRODUIT
                       AND e.IDUNITE = v.UNITE
         LEFT JOIN VENTE_DETAILS_RESTE vc
                   ON vc.ID = v.ID
         LEFT JOIN Vente ve
                   ON ve.ID = v.IDVENTE
         LEFT JOIN VENTE_DETAILS vdc
                   ON vdc.ID = ve.ID;