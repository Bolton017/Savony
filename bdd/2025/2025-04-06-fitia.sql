create view VENTE_DETAILS_CPL_2_VISEE as
SELECT vd.ID,
       vd.IDVENTE,
       v.DESIGNATION          AS IDVENTELIB,
       vd.IDPRODUIT ,
       nvl(i.LIBELLE,p.VAL)                  AS IDPRODUITLIB,
       vd.IDORIGINE,
       vd.QTE,
       nvl(vd.PU, 0)          AS PU,
       CAST(nvl(vd.PU * vd.QTE, 0) +nvl(vd.PU * vd.QTE *(vd.TVA/100), 0) AS number(30,2)) AS puTotal,
       CAST(nvl(vd.PUACHAT * vd.QTE, 0) AS number(30,2)) AS puTotalAchat,
       CAST(nvl(vd.PU * vd.QTE, 0) - nvl(vd.PUACHAT * vd.QTE, 0) AS number(30,2)) AS puRevient,
       c.ID  AS IDCATEGORIE,
       c.VAL AS IDCATEGORIELIB,
       v.DATY AS daty,
       m.ID AS IDMAGASIN,
       m.VAL AS IDMAGASINLIB,
       p1.ID AS IDPOINT,
       p1.VAL AS IDPOINTLIB,
       vd.IDDEVISE,
       vd.IDDEVISE AS IDDEVISELIB
FROM VENTE_DETAILS vd
         LEFT JOIN VENTE v ON v.ID = vd.IDVENTE
         LEFT JOIN MAGASIN m ON m.ID = v.IDMAGASIN
         LEFT JOIN PRODUIT p ON p.ID = vd.IDPRODUIT
         LEFT JOIN AS_INGREDIENTS i ON i.ID = vd.IDPRODUIT
         LEFT JOIN POINT p1 ON p1.ID = m.IDPOINT
         LEFT JOIN CATEGORIE c  ON p.IDCATEGORIE  = c.ID
WHERE v.ETAT >= 11
/

create view FABRICATIONFILLECPL2 as
SELECT
    f."ID",f."IDINGREDIENTS",f."LIBELLE",f."REMARQUE",f."IDMERE",f."DATYBESOIN",f."QTE",f."IDUNITE",f."PU",
    ai.LIBELLE AS idingredientsLib,ff.DATY
FROM FABRICATIONFILLE f
         LEFT JOIN AS_INGREDIENTS ai ON ai.id = f.IDINGREDIENTS
JOIN FABRICATION ff on f.IDMERE = ff.ID
WHERE ETAT >= 11
/
