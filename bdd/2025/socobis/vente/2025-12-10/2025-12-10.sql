CREATE OR REPLACE  VIEW CLIENTLIB (ID, NOM, TELEPHONE, MAIL, ADRESSE, REMARQUE, COMPTE, IDNATIONALITE, COMPTEAUXILIAIRE, IDTYPECLIENT, IDTYPECLIENTLIB,CODECLIENT,datecarte,taxe,idprovince,echeance,telfixe,nif,stat,carte,provincelib) AS 
  SELECT
    c.ID,c.NOM,c.TELEPHONE,c.MAIL,c.ADRESSE,c.REMARQUE,c.COMPTE,c.IDNATIONALITE,c.COMPTEAUXILIAIRE,c.IDTYPECLIENT,
    t.val AS idTypeClientLib,
    c.codeclient,c.datecarte,c.taxe,c.idprovince,c.echeance,c.telfixe,c.nif,c.stat,c.carte,p.val AS provincelib
FROM CLIENT c
LEFT JOIN typeclient t
ON c.idTypeClient = t.id
LEFT JOIN province p ON c.idprovince=p.id;


-- SCOCOBISPROD1205.PROFORMADETAILS_CPL source

CREATE OR REPLACE  VIEW PROFORMADETAILS_CPL (ID, IDPROFORMA, IDPRODUIT, IDORIGINE, QTE, PU, REMISE, TVA, PUACHAT, PUVENTE, IDDEVISE, TAUXDECHANGE, DESIGNATION, COMPTE, PUREVIENT, IDDEMANDEPRIXFILLE, IDPROFORMALIB, IDPRODUITLIB, PUTOTAL, UNITE, UNITELIB, REMISEMONTANT, MONTANTTOTAL, MONTANTTVA, MONTANTTTC, DATEDEBUT) AS 
  SELECT
    vd.ID,vd.IDPROFORMA,vd.IDPRODUIT,vd.IDORIGINE,vd.QTE,vd.PU,vd.REMISE,vd.TVA,vd.PUACHAT,vd.PUVENTE,v.IDDEVISE,vd.TAUXDECHANGE,vd.DESIGNATION,vd.COMPTE,vd.PUREVIENT,vd.IDDEMANDEPRIXFILLE,
    v.DESIGNATION    AS IDPROFORMALIB,
    p.LIBELLE            AS IDPRODUITLIB,
    cast((vd.QTE * vd.PU) as NUMBER(30,2)) AS puTotal,
    vd.unite,
    au.val AS uniteLib,
    cast(((vd.QTE * vd.PU)*NVL(vd.remise, 0))/100 as NUMBER(30,2)) AS remisemontant,
    cast((vd.QTE * vd.PU)-((vd.QTE * vd.PU)*NVL(vd.remise, 0))/100 as NUMBER(30,2)) as montanttotal,
    (nvl(vd.TVA, 0)/100)*cast((vd.QTE * vd.PU)-((vd.QTE * vd.PU)*NVL(vd.remise, 0))/100 as NUMBER(30,2)) as montanttva,
    cast((vd.QTE * vd.PU)-((vd.QTE * vd.PU)*NVL(vd.remise, 0))/100 as NUMBER(30,2))+(nvl(vd.TVA, 0)/100)*cast((vd.QTE * vd.PU)-((vd.QTE * vd.PU)*NVL(vd.remise, 0))/100 as NUMBER(30,2)) as montantttc,
    vd.datedebut
--       d2.id AS idDevis
FROM PROFORMA_DETAILS vd
         LEFT JOIN PROFORMA v ON v.ID = vd.IDPROFORMA
         LEFT JOIN AS_INGREDIENTS p ON p.ID = vd.IDPRODUIT
         LEFT JOIN AS_UNITE au ON au.id = vd.unite;


CREATE OR REPLACE VIEW PROFORMA_CPL_CREE AS 
	SELECT * FROM PROFORMA_CPL WHERE etat=1;

CREATE OR REPLACE VIEW PROFORMA_CPL_VISEE AS 
	SELECT * FROM PROFORMA_CPL WHERE etat=11;
  
  CREATE OR REPLACE  VIEW VENTE_DETAILS_QTE_GRP (IDBCFILLE, QTE) AS 
  SELECT idbcfille AS idbcfille,sum(qte) AS qte FROM VENTE_DETAILS_CPL_2_VISEE vd GROUP BY idbcfille ;
  
  -- SOCOBISPROD2411.AVOIRFCLIB source

CREATE OR REPLACE  VIEW AVOIRFCLIB (ID, DESIGNATION, IDMAGASIN, IDMAGASINLIB, DATY, REMARQUE, ETAT, IDORIGINE, IDCLIENT, COMPTE, COMPTEAUXILIAIRE, IDVENTE, IDVENTELIB, IDMOTIF, IDMOTIFLIB, IDCATEGORIE, IDCATEGORIELIB, IDDEVISE, TAUXDECHANGE, MONTANTHT, MONTANTTVA, MONTANTTTC, MONTANTHTAR, MONTANTTVAAR, MONTANTTTCAR, IDRESERVATION, TYPEAVOIR, CLIENTLIB) AS 
  SELECT a.ID,
       a.DESIGNATION,
       a.IDMAGASIN,
       m.VAL         AS IDMAGASINLIB,
       a.DATY,
       a.REMARQUE,
       a.ETAT,
       a.IDORIGINE,
       a.IDCLIENT,
       t.COMPTE,
       t.compteauxiliaire,
       a.IDVENTE,
       v.DESIGNATION AS IDVENTELIB,
       a.IDMOTIF,
       ma.VAL        AS IDMOTIFLIB,
       a.IDCATEGORIE,
       c.VAL         AS IDCATEGORIELIB,
       ag.IDDEVISE,
       ag.TAUXDECHANGE,
       ag.MONTANTHT,
       ag.MONTANTTVA,
       ag.MONTANTTTC,
       ag.MONTANTHTAR,
       ag.MONTANTTVAAR,
       ag.MONTANTTTCAR,
       v.IDRESERVATION,
       ta.val as Typeavoir,
       t.NOM as clientlib
FROM AVOIRFC a
         LEFT JOIN magasin2 m ON m.id = a.IDMAGASIN
         LEFT JOIN VENTE v ON v.id = a.IDVENTE
         LEFT JOIN MOTIFAVOIRFC ma ON ma.id = a.IDMOTIF
         LEFT JOIN CATEGORIEAVOIRFC c ON c.id = a.IDCATEGORIE
         JOIN AVOIRFCFILLE_GRP ag ON ag.idavoirfc = a.id
         LEFT JOIN TIERS T ON T.ID = A.IDCLIENT
        left join TYPEAVOIR ta on ta.id = a.IDTYPEAVOIR;

-- ARABESQUE0112.PRODUIT_LIBCPL source

CREATE OR REPLACE  VIEW PRODUIT_LIBCPL (ID, LIBELLE, PU, PV, UNITE, CATEGORIEINGREDIENT, COMPTE_VENTE, IDUNITELIB, CATEGORIELIB, SEUILMIN, SEUILMAX) AS 
  select p.ID,p.LIBELLE ,p.pu,p.pv,p.UNITE ,p.CATEGORIEINGREDIENT , p.COMPTE_VENTE ,
       uni.VAL as idunitelib,
       ga.VAL as categorielib,
       p.seuilmin,
       p.seuilmax
from AS_INGREDIENTS p 
         left join AS_UNITE uni on uni.ID = p.UNITE 
         left join CATEGORIEINGREDIENT ga on ga.ID = p.CATEGORIEINGREDIENT ;




CREATE OR REPLACE  VIEW AVOIR_MF (ID, IDAVOIRFC, IDPRODUIT, IDORIGINE, QTE, PU, REMISE, TVA, PUACHAT, PUVENTE, DESIGNATION, IDMAGASIN, DATY, REMARQUE, ETAT, IDCLIENT, MONTANTHT, MONTANTTVA, MONTANTTTC, TAUXDECHANGE, COMPTE) AS 
  select vd.ID,vd.idavoirfc,vd.IDPRODUIT,vd.IDORIGINE,vd.QTE,vd.PU,vd.REMISE,vd.TVA,vd.PUACHAT,vd.PUVENTE,
		v.DESIGNATION,
       v.IDMAGASIN,
       v.DATY,
       v.REMARQUE,
       v.ETAT,
       v.IDCLIENT,
         cast((vd.PU * vd.qte) as NUMBER(30, 2)) as montantHT,
       cast((vd.PU * vd.qte*(vd.tva/100)) as NUMBER(30, 2)) as montantTVA,
       cast(vd.PU * vd.qte + (vd.PU * vd.qte*(vd.tva/100))  as NUMBER(30, 2)) as montantTTC,
       vd.TAUXDECHANGE AS tauxdechange,
       p.COMPTE_VENTE AS compte
from avoirfcfille vd
 left outer join AVOIRFC  V on V.ID = vd.idavoirfc
         left outer join PRODUIT_LIBCPL p on p.ID = vd.IDPRODUIT;

      CREATE OR REPLACE  VIEW AS_BONDELIVRAISONCLIENT_LIBCPL (ID, REMARQUE, IDVENTE, IDBC, DATY, ETAT, MAGASIN, IDORIGINE, IDCLIENT, IDMAGASINLIB, IDCLIENTLIB, ETATLIB) AS 
  select ab.ID,ab.REMARQUE,ab.IDVENTE,ab.IDBC,ab.DATY,ab.ETAT,ab.MAGASIN,ab.IDORIGINE,ab.IDCLIENT,
m.val AS idmagasinlib,
 c.nom AS idclientlib,
CASE
    WHEN ab.ETAT = 0 THEN '<span style=color: green;>ANNUL&Eacute;</span>'
    WHEN ab.ETAT = 1 THEN '<span style=color: green;>CR&Eacute;&Eacute;</span>'
    WHEN ab.ETAT = 11 THEN '<span style=color: green;>VALID&Eacute;</span>'
END AS ETATLIB

from  AS_BONDELIVRAISON_CLIENT  AB
left join MAGASIN2 m on ab.MAGASIN = m.ID
LEFT JOIN client c ON c.id = ab.idclient;