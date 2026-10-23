CREATE TABLE "AVOIRACHAT" 
   (	"ID" VARCHAR2(255), 
	"DESIGNATION" VARCHAR2(255), 
	"IDMAGASIN" VARCHAR2(255) NOT NULL ENABLE, 
	"DATY" DATE, 
	"REMARQUE" VARCHAR2(255), 
	"ETAT" NUMBER(32,0), 
	"IDFOURNISSEUR" VARCHAR2(255) NOT NULL ENABLE, 
	"IDFACTURE" VARCHAR2(255), 
	"REMISE" NUMBER(30,2) DEFAULT 0, 
	 CONSTRAINT "PK_AVOIRACHAT" PRIMARY KEY ("ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"  ENABLE, 
	 CONSTRAINT "FK_AVOIRACHAT_MAGASIN" FOREIGN KEY ("IDMAGASIN")
	  REFERENCES "MAGASIN2" ("ID") ENABLE, 
	 CONSTRAINT "FK_AVOIRACHAT_FOURNISSEUR" FOREIGN KEY ("IDFOURNISSEUR")
	  REFERENCES "FOURNISSEUR" ("ID") ENABLE, 
	 CONSTRAINT "FK_AVOIRACHAT_FACTURE" FOREIGN KEY ("IDFACTURE")
	  REFERENCES "FACTUREFOURNISSEUR" ("ID") ENABLE
   );

ALTER TABLE AVOIRACHAT
MODIFY IDMAGASIN VARCHAR2(255) NULL;

CREATE TABLE "AVOIRACHATFILLE" 
   (	"ID" VARCHAR2(255), 
	"IDMERE" VARCHAR2(255) NOT NULL ENABLE, 
	"IDPRODUIT" VARCHAR2(255) NOT NULL ENABLE, 
	"QTE" NUMBER(32,2), 
	"PU" NUMBER(32,2), 
	"REMISE" NUMBER(32,2), 
	"TVA" NUMBER(32,2), 
	"IDDEVISE" VARCHAR2(255) NOT NULL ENABLE, 
	"TAUX" NUMBER(32,2), 
	"DESIGNATION" VARCHAR2(255), 
	"IDFACTUREDETAILS" VARCHAR2(255) NOT NULL ENABLE, 
	"RISTOURNE" NUMBER(30,2) DEFAULT 0, 
	"TAUXDECHANGE" NUMBER(30,2) DEFAULT 1, 
	 CONSTRAINT "PK_AVOIRFILLE" PRIMARY KEY ("ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"  ENABLE, 
	 CONSTRAINT "FK_AVOIRFILLE_MERE" FOREIGN KEY ("IDMERE")
	  REFERENCES "AVOIRACHAT" ("ID") ENABLE, 
	 CONSTRAINT "FK_AVOIRFILLE_PROD" FOREIGN KEY ("IDPRODUIT")
	  REFERENCES "AS_INGREDIENTS" ("ID") ENABLE, 
	 CONSTRAINT "FK_AVOIRFILLE_DEV" FOREIGN KEY ("IDDEVISE")
	  REFERENCES "DEVISE" ("ID") ENABLE, 
	 CONSTRAINT "FK_AVOIRFILLE_FACDET" FOREIGN KEY ("IDFACTUREDETAILS")
	  REFERENCES "FACTUREFOURNISSEURFILLE" ("ID") ENABLE
   );

CREATE SEQUENCE SEQ_AVOIRACHAT INCREMENT BY 1 MINVALUE 1 MAXVALUE 999999999999999999999999999 NOCYCLE CACHE 20 NOORDER ;
CREATE SEQUENCE SEQ_AVOIRACHATFILLE INCREMENT BY 1 MINVALUE 1 MAXVALUE 999999999999999999999999999 NOCYCLE CACHE 20 NOORDER ;

CREATE OR REPLACE FUNCTION GETSEQ_AVOIRACHAT
  RETURN NUMBER
IS
  retour   NUMBER;
BEGIN
SELECT SEQ_AVOIRACHAT.NEXTVAL INTO retour FROM DUAL;
RETURN retour;
END;

CREATE OR REPLACE FUNCTION GETSEQ_AVOIRACHATFILLE
  RETURN NUMBER
IS
  retour   NUMBER;
BEGIN
SELECT SEQ_AVOIRACHATFILLE.NEXTVAL INTO retour FROM DUAL;
RETURN retour;
END;

CREATE OR REPLACE VIEW "AVOIRACHATFILLECALC" AS 
  select vd."ID",vd."IDMERE",vd."IDPRODUIT",vd."QTE",vd."PU",vd."REMISE",vd."TVA",vd."IDDEVISE",vd."TAUX",vd."DESIGNATION",vd."IDFACTUREDETAILS",vd."RISTOURNE",vd."TAUXDECHANGE",cast(vd.QTE*vd.pu as number(30,2)) as montantNonRemise,
cast(vd.QTE*vd.pu*((nvl(vd.REMISE,0)+nvl(vd.RISTOURNE,0))/100) as number(30,2)) as montantRemiseSansTva,
cast(vd.QTE*vd.pu*(1-(nvl(vd.REMISE,0)/100))*(1-(nvl(vd.RISTOURNE,0)/100)) as number(30,2)) as montantHT,
cast(vd.pu*(1-(nvl(vd.REMISE,0)/100))*(1-(nvl(vd.RISTOURNE,0)/100)) as number(30,2)) as puRemise,
cast(vd.QTE*vd.pu*(1-(nvl(vd.REMISE,0)/100))*(1-(nvl(vd.RISTOURNE,0)/100))*nvl(vd.TAUXDECHANGE,1) as number(30,2)) as montantHTAr,
cast(vd.QTE*vd.pu*(1-(nvl(vd.REMISE,0)/100))*(1-(nvl(vd.RISTOURNE,0)/100))*nvl(vd.tva,0)/100 as number(30,2)) as montantTva,
cast(vd.QTE*vd.pu*(1-(nvl(vd.REMISE,0)/100))*(1-(nvl(vd.RISTOURNE,0)/100))*nvl(vd.TAUXDECHANGE,1)*nvl(vd.tva,0)/100 as number(30,2)) as montantTvaAr,
cast(vd.QTE*vd.pu*(1-(nvl(vd.REMISE,0)/100))*(1-(nvl(vd.RISTOURNE,0)/100))*(1+(nvl(vd.tva,0)/100)) as number(30,2)) as montantTTC,
cast(vd.QTE*vd.pu*(1-(nvl(vd.REMISE,0)/100))*(1-(nvl(vd.RISTOURNE,0)/100))*(1+(nvl(vd.tva,0)/100))*nvl(vd.TAUXDECHANGE,1) as number(30,2)) as montantTTCAr from AVOIRAchatFILLE vd
 ;

CREATE OR REPLACE VIEW "AVOIRACHATCALCGROUPEORIGINE" AS 
  select aa.IDFACTURE ,cast(sum(montantNonRemise) as number(30,2)) as montantNonRemise,cast(sum(montantRemiseSansTva) as number(30,2)) as montantRemiseSansTva,
       cast(sum(montantHT) as number(30,2)) as montantHT,cast(sum(montantTTC) as number(30,2)) as montantTTC,cast(sum(montantTva) as number(30,2)) as montantTva,
       cast(sum(montantHTAr) as number(30,2)) as montantHTAr,cast(sum(montantTvaAr) as number(30,2)) as montantTvaAr,cast(sum(montantTTCAr) as number(30,2)) as montantTTCAr
       from AvoirAChatFilleCalc vdc left join avoirAchat aa on aa.id=vdc.IDMERE where aa.ETAT>=11   group by aa.IDFACTURE
 ;

ALTER TABLE FACTUREFOURNISSEUR ADD "ECHEANCEFACTURE" NUMBER(30,2);

CREATE OR REPLACE VIEW "FACTFOURNISSEURCALC" AS 
  select v."ID",v."IDFOURNISSEUR",v."IDMODEPAIEMENT",v."DATY",v."DESIGNATION",v."DATEECHEANCEPAIEMENT",v."ETAT",v."REFERENCE",v."IDBC",v."DEVISE",v."TAUX",v."IDMAGASIN",v."IDDEVISE",v."ESTPREVU",v."DATYPREVU",v."NUMERO",v."TYPEACHAT",v."IDTYPEFACTURE",v."IDOBJET",v."IDREF",v."IDDMDACHAT",v."IDFACTUREPRINCIPALE",v."SERVICE",v."TYPEFACTUREFOURNISSEUR",v."ECHEANCEFACTURE",v."REMISE", cast(montantRemiseSansTva+ montantHT as number(30,2)) as montantRemise, montantNonRemise,
       cast(montantHT as number(30,2)) as montantHT,cast(montantTva as number(30,2)) as montantTva, cast(vdcv.MONTANTTVAAR as number(30,2)) as montantTvaAr,
       cast(montantTTC as number(30,2)) as montantTTC, cast(montantTTCAr as number(30,2)) as montantTTCAr, cast(MONTANTHTAR as number(30,2)) as montantHtAr
from FACTUREFOURNISSEUR v left join FFFilleCalcGroupeFF vdcv on v.id=vdcv.IDFACTUREFOURNISSEUR
;

CREATE OR REPLACE VIEW "FACTUREFOURNISSEURCPL" AS 
  SELECT
    f.ID,
    f.IDFOURNISSEUR,
    f2.NOM  AS IDFOURNISSEURLIB,
    f.IDMODEPAIEMENT,
    m.VAL   AS IDMODEPAIEMENTLIB,
    f.DATY,
    f.DESIGNATION,
    f.DATEECHEANCEPAIEMENT,
    nvl(f.echeancefacture,0) AS echeancefacture,
    f.ETAT,
    CASE
        WHEN f.ETAT = 1
            THEN 'CR&Eacute;&Eacute;E'
        WHEN f.ETAT = 0
            THEN 'ANNUL&Eacute;E'
        WHEN f.ETAT = 11
            THEN 'VIS&Eacute;E'
        WHEN f.ETAT = 15
        	THEN 'CL&Ocirc;TUR&Eacute;E'
        END AS ETATLIB,
    nvl(f.REFERENCE, reff.reference) as reference,
    f.IDBC,
    f.IDMAGASIN,
    f.DEVISE,
    case
        when f.TAUX=0 then 1
        else f.TAUX
        end as taux,
    p.VAL   AS idMagasinLib,
    f.IDDEVISE,
    cast(f.MONTANTTVA as number(30,5)) as MONTANTTVA,
    CAST(f.MONTANTHT as number(30,5)) AS MONTANTHT,
    cast(f.MONTANTTTC as number(30,5)) as montantttc,
    cast(f.MONTANTTTCAR as number(30,5)) as MONTANTTTCAR,
    cast(nvl(mv.MONTANT,0) AS number(30,5)) AS montantpaye,
    cast(nvl(mv.MONTANT,0)*nvl(f.TAUX,1) AS number(30,5)) AS montantpayeAr,
    cast(f.MONTANTTTCAR-((nvl(mv.MONTANT,0)-nvl(av.montantTTC,0))*nvl(f.TAUX,1)) AS number(30,5)) AS montantresteAr,
    cast(f.MONTANTTTC-nvl(mv.MONTANT,0)-nvl(av.montantTTC,0) AS number(30,5)) AS montantreste,
    cast(av.montantTTC as number(30,2)) as montantAvoir,
    cast(f.TAUX AS  number(30,2)) AS tauxdechange,
    prev.id as idPrevision,
    CASE
        WHEN f.estprevu=0 THEN 'NON'
        ELSE 'OUI'
        END
        AS estprevulib,
    f.IDOBJET,
    f.IDREF,
    f.IDTYPEFACTURE,
    tf.VAL as typefacture,
    f.numero,
    f.typeachat,
    f.idfactureprincipale,
    s.libelle AS idServiceLib,
    f.SERVICE,
    f.TYPEFACTUREFOURNISSEUR,
    tff.DESCE AS TYPEFACTUREFOURNISSEURLIB,
    ce.id AS idecriture,
    ta.VAL AS typeachatlib,
    f.remise
FROM FactFournisseurCalc f
    LEFT JOIN TYPEACHAT ta ON ta.DESCE = f.TYPEACHAT
    LEFT JOIN FOURNISSEUR f2 ON f2.ID = f.IDFOURNISSEUR
    LEFT JOIN MODEPAIEMENT m ON m.ID = f.IDMODEPAIEMENT
    LEFT JOIN MAGASIN p ON p.ID = f.IDMAGASIN
    LEFT JOIN LIAISONPAIEMENTTOTAL mv ON f.id=mv.ID2
    left join AvoirAChatCalcGroupeOrigine av on av.IDFACTURE=f.ID
    LEFT JOIN prevision prev ON prev.idfacture=f.id
    left join type_facture tf on tf.id = f.IDTYPEFACTURE
    LEFT JOIN SERVICE s ON f.SERVICE = s.COMPTE
    LEFT JOIN referencefacture reff ON f.id=reff.idfacture
    LEFT JOIN typefacturefournisseur tff ON tff.id = f.TYPEFACTUREFOURNISSEUR
    LEFT JOIN COMPTA_ECRITURE ce ON ce.idobjet=f.id
 ;

CREATE OR REPLACE VIEW "AVOIRACHATFILLECALCGROUPE" AS 
  select vdc.IDMERE as idAvoirAchat ,cast(sum(montantNonRemise) as number(30,2)) as montantNonRemise,cast(sum(montantRemiseSansTva) as number(30,2)) as montantRemiseSansTva,
       cast(sum(montantHT) as number(30,2)) as montantHT,cast(sum(montantTTC) as number(30,2)) as montantTTC,cast(sum(montantTva) as number(30,2)) as montantTva,
       cast(sum(montantHTAr) as number(30,2)) as montantHTAr,cast(sum(montantTvaAr) as number(30,2)) as montantTvaAr,cast(sum(montantTTCAr) as number(30,2)) as montantTTCAr
       from AvoirAChatFilleCalc vdc group by vdc.IDMERE
 ;

CREATE OR REPLACE VIEW "AVOIRACHATCALC" AS 
  select v."ID",v."DESIGNATION",v."IDMAGASIN",v."DATY",v."REMARQUE",v."ETAT",v."IDFOURNISSEUR",v."IDFACTURE",v."REMISE", cast(montantRemiseSansTva+ (montantHT* (nvl(v.REMISE,0)/100)) as number(30,2)) as montantRemise, montantNonRemise,
           cast(montantHT*(1-(nvl(v.REMISE,0)/100)) as number(30,2)) as montantHT,cast(montantTva*(1-(nvl(v.REMISE,0)/100)) as number(30,2)) as montantTva,
    cast(montantTTC*(1-(nvl(v.REMISE,0)/100)) as number(30,2)) as montantTTC, montantTTCAr*(1-(nvl(v.REMISE,0)/100)) as montantTTCAr
    from AVOIRACHAT v left join AvoirAChatFilleCalcGroupe vdcv on v.id=vdcv.idAvoirAchat
 ;

CREATE OR REPLACE VIEW "AVOIRACHATCALC_AVEC_LIB" AS 
  select a."ID",
       a."DESIGNATION",
       a."IDMAGASIN",
       a."DATY",
       a."REMARQUE",
       a."ETAT",
       a."IDFOURNISSEUR",
       a."IDFACTURE",
       a."REMISE",
       a."MONTANTREMISE",
       a."MONTANTNONREMISE",
       a."MONTANTHT",
       a."MONTANTTVA",
       a."MONTANTTTC",
       a."MONTANTTTCAR",
       m.VAL AS idmagasinLib,
       f.nom AS idfournisseurLib,
       CASE
           WHEN a.ETAT = 1 THEN 'Cr&eacute;e'
           WHEN a.ETAT = 11 THEN 'Valid&eacute;'
           WHEN a.ETAT = 0 THEN 'Annul&eacute;'
           ELSE 'Inconnu'
           END AS ETATLIB
from AVOIRACHATCALC a
         left join AvoirAChatFilleCalcGroupe vdcv on a.id = vdcv.idAvoirAchat
         LEFT JOIN MAGASIN2 m ON a.IDMAGASIN = m.ID
         LEFT JOIN FOURNISSEUR f ON a.IDFOURNISSEUR = f.ID
 ;

CREATE OR REPLACE VIEW "AVOIRACHATFILLELIB" AS 
  SELECT
    af.ID,
    af.IDMERE,
    af.IDPRODUIT,
    af.QTE,
    af.PU,
    af.REMISE,
    af.TVA,
    af.IDDEVISE,
    af.TAUX,
    af.DESIGNATION,
    af.IDFACTUREDETAILS,
    p.LIBELLE AS idproduitLib,
    d.val AS iddeviseLib,
    ----------------------------------------------------------
    -- 1 Montant HT brut
    ----------------------------------------------------------
    CAST(af.QTE * af.PU AS NUMBER(30, 2)) AS montant,
    ----------------------------------------------------------
    -- 2 Montant remise (appliquee sur HT)
    ----------------------------------------------------------
    CAST((NVL(af.REMISE, 0) / 100) * (af.QTE * af.PU) AS NUMBER(30, 2)) AS montantRemise,
    ----------------------------------------------------------
    -- 3 Montant HT net apres remise
    ----------------------------------------------------------
    CAST((af.QTE * af.PU) - ((NVL(af.REMISE, 0) / 100) * (af.QTE * af.PU)) AS NUMBER(30, 2)) AS montantht,
    ----------------------------------------------------------
    -- 4 TVA sur montant HT net
    ----------------------------------------------------------
    CAST(((af.QTE * af.PU) - ((NVL(af.REMISE, 0) / 100) * (af.QTE * af.PU))) * af.TVA / 100 AS NUMBER(30, 2))AS montanttva,
    ----------------------------------------------------------
    -- 5 Montant TTC net (HT net + TVA)
    ----------------------------------------------------------
    CAST( ((af.QTE * af.PU) - ((NVL(af.REMISE, 0) / 100) * (af.QTE * af.PU))) + ( ((af.QTE * af.PU) - ((NVL(af.REMISE, 0) / 100) * (af.QTE * af.PU)))  * af.TVA / 100  ) AS NUMBER(30, 2)) AS montantttc,
    CAST(((af.QTE * af.PU) - ((NVL(af.REMISE, 0) / 100) * (af.QTE * af.PU))) * NVL(af.TAUX, 1)AS NUMBER(30, 2)) AS montanthtAr,
    p.compte_achat AS compte
FROM AVOIRACHATFILLE af
    LEFT JOIN AS_INGREDIENTS p ON af.IDPRODUIT = p.ID
    LEFT JOIN DEVISE d ON af.IDDEVISE = d.ID
 
 ;
 
 CREATE OR REPLACE VIEW "AVOIRACHATFILLELIBECRITURE" AS 
  SELECT IDMERE, compte, sum(montanthtAr) AS montantht FROM AVOIRACHATFILLELIB group BY idMere, compte;
 
 INSERT INTO PARAMCONSTANTESOCOBIS
(ID, VAL, DESCE)
VALUES('PRMS493', 'FAR', 'FAR');

INSERT INTO SAVONNERIE1809.PARAMCONSTANTESOCOBIS
(ID, VAL, DESCE)
VALUES('PRMS494', 'TPF0001', 'Type Facture Fournisseur');

CREATE OR REPLACE VIEW "FACTUREFOURNISSEURFILLECPL" AS 
  SELECT f.ID,
       f.IDFACTUREFOURNISSEUR,
       f.IDPRODUIT,
       p.LIBELLE                                                         AS IDPRODUITLIB,
       f.QTE,
       f.PU,
       f.REMISES,
       f.IDBCDETAIL,
       f.TVA,
       f.IDDEVISE,
       f2.DATY,

       ----------------------------------------------------------
       -- 1 Montant HT brut
       ----------------------------------------------------------
       CAST(f.QTE * f.PU AS NUMBER(30, 2))                               AS montant,
       CAST(f.QTE * f.PU AS NUMBER(30, 2))                               AS montanttotal,

       ----------------------------------------------------------
       -- 2 Montant remise (appliquee sur HT)
       ----------------------------------------------------------
       CAST(f.montantRemiseSansTva AS NUMBER(30, 2)) AS montantRemise,

       ----------------------------------------------------------
       -- 3 Montant HT net apres remise
       ----------------------------------------------------------
       CAST(f.MONTANTHT
           AS NUMBER(30, 2))                                             AS montantht,

       ----------------------------------------------------------
       -- 4 TVA sur montant HT net
       ----------------------------------------------------------
       CAST(f.MONTANTTVA
           AS NUMBER(30, 2)
       )                                                                 AS montanttva,

       ----------------------------------------------------------
       -- 5 Montant TTC net (HT net + TVA)
       ----------------------------------------------------------
       CAST(
               f.MONTANTTTC
           AS NUMBER(30, 2)
       )                                                                 AS montantttc,

       ----------------------------------------------------------
       -- 6 Frais accessoires
       ----------------------------------------------------------
       NVL(r.montant, 0)                                          AS fraisaccesoire,

       ----------------------------------------------------------
       -- 7 Montant total avec frais (TTC + accessoires)
       ----------------------------------------------------------
       CAST(
               f.montantTTCAr    + NVL(r.montant, 0)
           AS NUMBER(30, 2)
       )                                                                 AS montantavecfraisaccessoire,

       ----------------------------------------------------------
       -- 8 PU unitaire HT + accessoires
       ----------------------------------------------------------
       CAST(

                   f.puRemise*nvl(f.TAUXDECHANGE,1)
                       + (NVL(r.montant, 0)
                    / f.QTE)
           AS NUMBER(30, 2)
       )                                                                 AS puavecfraisaccessoire,
       cast(f.montantTTCAr as number(30,2)) as montantTTCAr,

       ----------------------------------------------------------
       -- Info produit & localisation
       ----------------------------------------------------------
       NVL(p.LIBELLEEXTACTE, p.LIBELLE)                                  AS libelleexacte,
       f.IDPREVISION,
       p2.ID                                                             AS idpoint,
       p2.VAL                                                            AS idpointlib,
       m.ID                                                              AS idmagasin,
       m.VAL                                                             AS idmagasinlib,
       c.ID                                                              AS idcategorie,
       c.VAL                                                             AS idcategorielib,
       f.designation,
       f.remise

FROM FFFILLECALC f
         LEFT JOIN FACTUREFOURNISSEUR f2
                   ON f2.ID = f.IDFACTUREFOURNISSEUR
         LEFT JOIN MAGASIN m
                   ON m.ID = f2.IDMAGASIN
         LEFT JOIN POINT p2
                   ON p2.ID = m.IDPOINT
         LEFT JOIN AS_INGREDIENTS p
                   ON p.ID = f.IDPRODUIT
         LEFT JOIN CATEGORIEINGREDIENT c
                   ON c.ID = p.CATEGORIEINGREDIENT
         LEFT JOIN REPARTIRIONPGGROUPEE r
                   ON r.IDFACTUREFILLE = f.ID;

CREATE OR REPLACE VIEW "FACTUREFOURNISSEUR_PERTE" AS 
  SELECT f.ID,
       f.IDFOURNISSEUR,
       f.IDMODEPAIEMENT,
       f.DATY,
       f.DESIGNATION,
       f.DATEECHEANCEPAIEMENT,
       f.ETAT,
       f.REFERENCE,
       f.IDBC,
       f.DEVISE,
       f.TAUX,
       f.IDMAGASIN,
       f.IDDEVISE,
       f.ESTPREVU,
       f.DATYPREVU,
       cast (nvl(p.MONTANTAR, 0) as number(30,2)) AS MONTANTPERTEGAIN,
       f.numero ,
       f.TYPEACHAT ,
       f.IDTYPEFACTURE ,
       f.IDOBJET ,
       f.IDREF ,
       f.IDDMDACHAT ,
       f.IDFACTUREPRINCIPALE ,
       f.SERVICE ,
       f.TYPEFACTUREFOURNISSEUR
FROM FACTUREFOURNISSEUR f
         left JOIN perte_grporigine_fact p ON p.idorigine = f.id


 
 ;
 
 CREATE OR REPLACE VIEW "FFAVECPERTE_FF_IDPG" AS 
  SELECT
    ff.ID,
    ff.IDFACTUREFOURNISSEUR,
    ff.IDPRODUIT,
    ff.QTE,
    ff.PU,
    ff.REMISES,
    p.IDBCDETAIL as IDBCDETAIL,
    ff.TVA,
    ff.DEVISE,
    ff.TAUXDECHANGE,
    ff.IDDEVISE,
    ff.DESIGNATION,
    ff.COMPTE,
    CAST( nvl((CASE WHEN fg.MONTANTPERTEGAIN =0 THEN NULL ELSE  ff.MONTANTPERTEGAIN end),(p.montantAr*qte*p.TAUX*ff.pu/fg.montanttotal)) AS NUMBER(30,2) ) AS MONTANTPERTEGAIN ,
    ff.IDFOURNISSEUR,
    ff.ETAT,ff.DATY,
    CAST( (qte*ff.pu*TAUXDECHANGE+nvl((CASE WHEN fg.MONTANTPERTEGAIN =0 THEN NULL ELSE  ff.MONTANTPERTEGAIN end),0))/qte AS NUMBER(30,2) ) AS pupertegain ,
    CAST( (qte*ff.pu*TAUXDECHANGE+nvl((CASE WHEN fg.MONTANTPERTEGAIN =0 THEN NULL ELSE  ff.MONTANTPERTEGAIN end),0)) AS NUMBER(30,2) ) AS montantavecpertegain,
    asi.LIBELLE AS LIBELLEPRODUIT
FROM
    FACTUREFOURNISSEUR_mf ff
        left JOIN perte_grporigine_fact p ON p.idorigine=ff.idfacturefournisseur
        LEFT JOIN ff_grpmere fg ON fg.idfacturefournisseur=ff.idfacturefournisseur
        LEFT JOIN AS_INGREDIENTS asi ON ASI.ID = ff.IDPRODUIT;
