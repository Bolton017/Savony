alter table FACTUREFOURNISSEURFILLE add  ristourne number(30,2) default 0;

create view  FFFilleCalc as
select vd.*,cast(vd.QTE*vd.pu as number(30,2)) as montantNonRemise,
cast(vd.QTE*vd.pu*((nvl(vd.REMISE,0)+nvl(vd.RISTOURNE,0))/100) as number(30,2)) as montantRemiseSansTva,
cast(vd.QTE*vd.pu*(1-(nvl(vd.REMISE,0)/100))*(1-(nvl(vd.RISTOURNE,0)/100)) as number(30,2)) as montantHT,
cast(vd.pu*(1-(nvl(vd.REMISE,0)/100))*(1-(nvl(vd.RISTOURNE,0)/100)) as number(30,2)) as puRemise,
cast(vd.QTE*vd.pu*(1-(nvl(vd.REMISE,0)/100))*(1-(nvl(vd.RISTOURNE,0)/100))*nvl(vd.TAUXDECHANGE,1) as number(30,2)) as montantHTAr,
cast(vd.QTE*vd.pu*(1-(nvl(vd.REMISE,0)/100))*(1-(nvl(vd.RISTOURNE,0)/100))*nvl(vd.tva,0)/100 as number(30,2)) as montantTva,
cast(vd.QTE*vd.pu*(1-(nvl(vd.REMISE,0)/100))*(1-(nvl(vd.RISTOURNE,0)/100))*nvl(vd.TAUXDECHANGE,1)*nvl(vd.tva,0)/100 as number(30,2)) as montantTvaAr,
cast(vd.QTE*vd.pu*(1-(nvl(vd.REMISE,0)/100))*(1-(nvl(vd.RISTOURNE,0)/100))*(1+(nvl(vd.tva,0)/100)) as number(30,2)) as montantTTC,
cast(vd.QTE*vd.pu*(1-(nvl(vd.REMISE,0)/100))*(1-(nvl(vd.RISTOURNE,0)/100))*(1+(nvl(vd.tva,0)/100))*nvl(vd.TAUXDECHANGE,1) as number(30,2)) as montantTTCAr from FACTUREFOURNISSEURFILLE vd;

create view FFFilleCalcGroupeFF as
select vdc.IDFACTUREFOURNISSEUR ,cast(sum(montantNonRemise) as number(30,2)) as montantNonRemise,cast(sum(montantRemiseSansTva) as number(30,2)) as montantRemiseSansTva,
       cast(sum(montantHT) as number(30,2)) as montantHT,cast(sum(montantTTC) as number(30,2)) as montantTTC,cast(sum(montantTva) as number(30,2)) as montantTva,
       cast(sum(montantHTAr) as number(30,2)) as montantHTAr,cast(sum(montantTvaAr) as number(30,2)) as montantTvaAr,cast(sum(montantTTCAr) as number(30,2)) as montantTTCAr
from FFFilleCalc vdc group by vdc.IDFACTUREFOURNISSEUR;

create view FactFournisseurCalc as
select v.*, cast(montantRemiseSansTva+ (montantHT* (nvl(v.REMISE,0)/100)) as number(30,2)) as montantRemise, montantNonRemise,
       cast(montantHT*(1-(nvl(v.REMISE,0)/100)) as number(30,2)) as montantHT,cast(montantTva*(1-(nvl(v.REMISE,0)/100)) as number(30,2)) as montantTva,
       cast(montantTTC*(1-(nvl(v.REMISE,0)/100)) as number(30,2)) as montantTTC, montantTTCAr*(1-(nvl(v.REMISE,0)/100)) as montantTTCAr
from FACTUREFOURNISSEUR v left join FFFilleCalcGroupeFF vdcv on v.id=vdcv.IDFACTUREFOURNISSEUR;

create or replace view FACTUREFOURNISSEURCPL as
SELECT f.ID,
       f.IDFOURNISSEUR,
       f2.NOM  AS IDFOURNISSEURLIB,
       f.IDMODEPAIEMENT,
       m.VAL   AS IDMODEPAIEMENTLIB,
       f.DATY,
       f.DESIGNATION,
       f.DATEECHEANCEPAIEMENT,
       f.ETAT,
       CASE
           WHEN f.ETAT = 1
               THEN 'CRÉÉE'
           WHEN f.ETAT = 0
               THEN 'ANNULÉE'
           WHEN f.ETAT = 11
               THEN 'VISÉE'
           END AS ETATLIB,
       f.REFERENCE,
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
       cast(f3.MONTANTTTC*f3.tauxdechange as number(30,2)) as MONTANTTTCAR,
       cast(nvl(mv.MONTANT,0) AS number(30,5)) AS montantpaye,
       cast(f.MONTANTTTC-nvl(mv.MONTANT,0)-0 AS number(30,5)) AS montantreste, -- tokony avoir ilay - 0 farany
       cast(1 AS  number(30,5)) AS tauxdechange,
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
        f.SERVICE
FROM FactFournisseurCalc f
    LEFT JOIN FOURNISSEUR f2 ON f2.ID = f.IDFOURNISSEUR
    LEFT JOIN MODEPAIEMENT m ON m.ID = f.IDMODEPAIEMENT
    LEFT JOIN MAGASIN p ON p.ID = f.IDMAGASIN
    JOIN FACTUREFOURNISSEURMONTANT f3 ON f.ID = f3.id
    LEFT JOIN LIAISONPAIEMENTTOTAL mv ON f.id=mv.ID2
    LEFT JOIN prevision prev ON prev.idfacture=f.id
    left join type_facture tf on tf.id = f.IDTYPEFACTURE;


create table RepartirionPG
(
    id             VARCHAR2(50)
        constraint RepartirionPG_pk
            primary key,
    idFactureFIlle VARCHAR2(100),
    idPerte        VARCHAR2(100),
    montant        NUMBER(30, 2)
);

create table perteGainUtilise
(
    id             VARCHAR2(50)
        constraint pgutilise_pk
            primary key,
    val VARCHAR2(100),
    desce        VARCHAR2(100)
);

create or replace view FactFournisseurCalc as
select v.*, cast(montantRemiseSansTva+ (montantHT* (nvl(v.REMISE,0)/100)) as number(30,2)) as montantRemise, montantNonRemise,
       cast(montantHT*(1-(nvl(v.REMISE,0)/100)) as number(30,2)) as montantHT,cast(montantTva*(1-(nvl(v.REMISE,0)/100)) as number(30,2)) as montantTva,
       cast(montantTTC*(1-(nvl(v.REMISE,0)/100)) as number(30,2)) as montantTTC, montantTTCAr*(1-(nvl(v.REMISE,0)/100)) as montantTTCAr, MONTANTHTAR*(1-(nvl(v.REMISE,0)/100)) as montantHtAr
from FACTUREFOURNISSEUR v left join FFFilleCalcGroupeFF vdcv on v.id=vdcv.IDFACTUREFOURNISSEUR;

create or replace view PERTE_GRPORIGINE_FACT as
select lf.id1 as idorigine, sum(ffc.MONTANTHT) as montant, sum(ffc.montantHTAr) as montantar,LISTAGG(id2, ';;') WITHIN GROUP (ORDER BY id2) AS idbcDetail
from LIAISONFACTUREFOURNISSEURS lf
         LEFT JOIN FactFournisseurCalc FFC on FFC.id = lf.id2
where not exists (select 1 from perteGainUtilise p where p.VAL=lf.ID2)
group by lf.id1;

create view FFAVECPERTE_FF_IDPG as
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
    CAST( nvl((CASE WHEN fg.MONTANTPERTEGAIN =0 THEN NULL ELSE  ff.MONTANTPERTEGAIN end),(p.montant*qte*TAUXDECHANGE*ff.pu/fg.montanttotal)) AS NUMBER(30,2) ) AS MONTANTPERTEGAIN ,
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

create or replace view FACTUREFOURNISSEUR_MF as
SELECT ff.ID,
       ff.IDFACTUREFOURNISSEUR,
       ff.IDPRODUIT,
       ff.QTE,
       ff.PU,
       ff.REMISES,
       ff.IDBCDETAIL,
       ff.TVA,
       ff.DEVISE,
       ff.TAUXDECHANGE,
       ff.IDDEVISE,
       ff.DESIGNATION,
       ff.COMPTE,
       ff.MONTANTPERTEGAIN,
       f.IDFOURNISSEUR,
       f.ETAT,
       f.DATY,
       ff.PUREMISE
FROM FFFilleCalc ff
         JOIN FACTUREFOURNISSEUR f ON ff.IDFACTUREFOURNISSEUR = f.ID;


create or replace view FFAVECPERTE_FF as
SELECT
    ff.ID,
    ff.IDFACTUREFOURNISSEUR,
    ff.IDPRODUIT,
    ff.QTE,
    ff.PU,
    ff.REMISES,
    ff.IDBCDETAIL,
    ff.TVA,
    ff.DEVISE,
    ff.TAUXDECHANGE,
    ff.IDDEVISE,
    ff.DESIGNATION,
    ff.COMPTE,
    CAST(nvl(rep.montant,0) AS NUMBER(30,2) ) AS MONTANTPERTEGAIN ,
    ff.IDFOURNISSEUR,
    ff.ETAT,ff.DATY,
    CAST(((ff.PUREMISE*TAUXDECHANGE)+(nvl(rep.MONTANT,0)/qte)) AS NUMBER(30,2) ) AS pupertegain ,
    CAST(((qte*ff.PUREMISE*TAUXDECHANGE)+nvl(rep.montant,0)) AS NUMBER(30,2) ) AS montantavecpertegain,
    asi.LIBELLE AS LIBELLEPRODUIT
FROM
    FACTUREFOURNISSEUR_mf ff
        LEFT JOIN AS_INGREDIENTS asi ON ASI.ID = ff.IDPRODUIT
        left join RepartirionPG rep on rep.IDFACTUREFILLE=ff.id;

CREATE SEQUENCE seq_EntretienRH INCREMENT BY 1 MINVALUE 1 MAXVALUE 999999999999999999999999999 NOCYCLE CACHE 20 NOORDER ;

CREATE OR REPLACE FUNCTION getseq_EntretienRH
    RETURN NUMBER IS
    retour NUMBER;
BEGIN
SELECT seq_EntretienRH.nextval INTO retour FROM dual;
return retour;
END;

CREATE OR REPLACE VIEW REPARTIRIONPGGROUPEE AS
SELECT
    r.IDFACTUREFILLE ,
    NVL(SUM(r.montant), 0) AS montant
FROM REPARTIRIONPG r
GROUP BY r.IDFACTUREFILLE;
select * from FACTUREFOURNISSEURFILLECPL;

create or replace view FACTUREFOURNISSEURFILLECPL as
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
       CAST(f.QTE * f.PU*f.TAUXDECHANGE AS NUMBER(30, 2))                               AS montant,

       ----------------------------------------------------------
       -- 2 Montant remise (appliquee sur HT)
       ----------------------------------------------------------
       CAST((NVL(f.remises, 0) / 100) * (f.QTE * f.PU) AS NUMBER(30, 2)) AS montantRemise,

       ----------------------------------------------------------
       -- 3 Montant HT net apres remise
       ----------------------------------------------------------
       CAST((f.QTE * f.PU)*f.TAUXDECHANGE * (1-(NVL(f.remise, 0) / 100))
           AS NUMBER(30, 2))                                             AS montantht,

       ----------------------------------------------------------
       -- 4 TVA sur montant HT net
       ----------------------------------------------------------
       CAST(
               ((f.QTE * f.PU)*f.TAUXDECHANGE*(1-(NVL(f.remise, 0) / 100)) )
                   * f.TVA / 100
           AS NUMBER(30, 2)
       )                                                                 AS montanttva,

       ----------------------------------------------------------
       -- 5 Montant TTC net (HT net + TVA)
       ----------------------------------------------------------
       CAST(
               ((f.QTE * f.PU)*f.TAUXDECHANGE*(1-(NVL(f.remise, 0) / 100)))
                   + (
                   ((f.QTE * f.PU)*f.TAUXDECHANGE*(1-(NVL(f.remise, 0) / 100)))
                       * f.TVA / 100
                   )
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

                   ((f.QTE * f.PU * f.TAUXDECHANGE*(1-(NVL(f.remise, 0) / 100))))
                   + NVL(r.montant, 0)
           AS NUMBER(30, 2)
       )                                                                 AS montantavecfraisaccessoire,

       ----------------------------------------------------------
       -- 8 PU unitaire HT + accessoires
       ----------------------------------------------------------
       CAST(
               (

                       ((f.QTE * f.PU * f.TAUXDECHANGE*(1-(NVL(f.remise, 0) / 100)))
                           )
                       + NVL(r.montant, 0)
                   ) / f.QTE
           AS NUMBER(30, 2)
       )                                                                 AS puavecfraisaccessoire,

       ----------------------------------------------------------
       -- Info produit
       ----------------------------------------------------------
       NVL(p.LIBELLEEXTACTE, p.LIBELLE)                                  AS libelleexacte,
       f.mois,
       f.annee,f.REMISE
FROM FACTUREFOURNISSEURFILLE f
         LEFT JOIN FACTUREFOURNISSEUR f2
                   ON f2.ID = f.IDFACTUREFOURNISSEUR
         LEFT JOIN AS_INGREDIENTS p
                   ON p.ID = f.IDPRODUIT
         LEFT JOIN REPARTIRIONPGGROUPEE r
                   ON r.IDFACTUREFILLE = f.ID;




alter table FACTUREFOURNISSEUR
add idfactureprincipale varchar(255);

create or replace view FACTFOURNISSEURCALC as
select v."ID",v."IDFOURNISSEUR",v."IDMODEPAIEMENT",v."DATY",v."DESIGNATION",v."DATEECHEANCEPAIEMENT",v."ETAT",v."REFERENCE",v."IDBC",v."DEVISE",v."TAUX",v."IDMAGASIN",v."IDDEVISE",v."ESTPREVU",v."DATYPREVU",v."NUMERO",v."TYPEACHAT",v."IDTYPEFACTURE",v."IDOBJET",v."IDREF",v."IDDMDACHAT",v."IDFACTUREPRINCIPALE",v."SERVICE",v."REMISE", cast(montantRemiseSansTva+ (montantHT* (nvl(v.REMISE,0)/100)) as number(30,2)) as montantRemise, montantNonRemise,
           cast(montantHT*(1-(nvl(v.REMISE,0)/100)) as number(30,2)) as montantHT,cast(montantTva*(1-(nvl(v.REMISE,0)/100)) as number(30,2)) as montantTva,
    cast(montantTTC*(1-(nvl(v.REMISE,0)/100)) as number(30,2)) as montantTTC, montantTTCAr*(1-(nvl(v.REMISE,0)/100)) as montantTTCAr, MONTANTHTAR*(1-(nvl(v.REMISE,0)/100)) as montantHtAr
    from FACTUREFOURNISSEUR v left join FFFilleCalcGroupeFF vdcv on v.id=vdcv.IDFACTUREFOURNISSEUR;

create or replace view FACTUREFOURNISSEURCPL as
SELECT f.ID,
       f.IDFOURNISSEUR,
       f2.NOM  AS IDFOURNISSEURLIB,
       f.IDMODEPAIEMENT,
       m.VAL   AS IDMODEPAIEMENTLIB,
       f.DATY,
       f.DESIGNATION,
       f.DATEECHEANCEPAIEMENT,
       f.ETAT,
       CASE
           WHEN f.ETAT = 1
               THEN 'CRÉÉE'
           WHEN f.ETAT = 0
               THEN 'ANNULÉE'
           WHEN f.ETAT = 11
               THEN 'VISÉE'
           END AS ETATLIB,
       f.REFERENCE,
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
       cast(f3.MONTANTTTC*f3.tauxdechange as number(30,2)) as MONTANTTTCAR,
       cast(nvl(mv.MONTANT,0) AS number(30,5)) AS montantpaye,
       cast(f.MONTANTTTC-nvl(mv.MONTANT,0)-0 AS number(30,5)) AS montantreste, -- tokony avoir ilay - 0 farany
       cast(1 AS  number(30,5)) AS tauxdechange,
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
        f.SERVICE,
        f.REMISE,
        f.idfactureprincipale
FROM FactFournisseurCalc f
    LEFT JOIN FOURNISSEUR f2 ON f2.ID = f.IDFOURNISSEUR
    LEFT JOIN MODEPAIEMENT m ON m.ID = f.IDMODEPAIEMENT
    LEFT JOIN MAGASIN p ON p.ID = f.IDMAGASIN
    JOIN FACTUREFOURNISSEURMONTANT f3 ON f.ID = f3.id
    LEFT JOIN LIAISONPAIEMENTTOTAL mv ON f.id=mv.ID2
    LEFT JOIN prevision prev ON prev.idfacture=f.id
    left join type_facture tf on tf.id = f.IDTYPEFACTURE;




