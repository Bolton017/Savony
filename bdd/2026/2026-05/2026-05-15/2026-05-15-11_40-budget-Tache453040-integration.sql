INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES ('MENUDYANN007', 'Situation recette', 'view_list', 'module.jsp?but=budget/budget-recettes-liste.jsp', 6, 2, 'MENUDYN003');
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES ('MENUDYANN1607007', 'Situation recette annuelle', 'view_list', 'module.jsp?but=budget/budget-recettes-annuel.jsp', 7, 2, 'MENUDYN003');
ALTER TABLE PREVISION ADD
service VARCHAR(255);

create OR REPLACE  view PREVISION_CPL as
select
    p.id,
    p.designation,
    p.idcaisse,
    c.val as idcaisselib,
    p.idventedetail,
    v.IDVENTE,
    v2.designation as idventelib,
    p.idvirement,
    p.debit,
    p.credit,
    p.daty,
    p.etat,
    p.idop,
    o.DESIGNATION as idoplib ,
    p.idorigine,
    p.iddevise,
    p.designation as iddeviselib,
    p.taux,
    p.idtiers,
    p.compte,
    p.idfacture,
    v2.IDRESERVATION,
    p.mois,
    p.annee,
    TO_CHAR(
            TO_DATE(TO_CHAR(p.mois, 'FM00'), 'MM'),
            'FMMonth',
            'NLS_DATE_LANGUAGE=FRENCH'
    ) AS moisLib,
    s.id as idservice,
    p.SERVICE,
    s.libelle AS idServiceLib
from PREVISION p
         left join caisse c on p.idcaisse = c.id
         left join VENTE_DETAILS v on p.IDVENTEDETAIL=v.ID
         left join vente v2 on v2.id=v.IDVENTE
         left join ORDONNERPAIEMENT o on o.id=p.IDOP
         left join devise d on d.id=p.IDDEVISE
         LEFT JOIN SERVICE s ON p.SERVICE = s.COMPTE;

select * from PREVISION;

create or replace view BUDGET_DEPENSE_SUM_VIEW as
select COMPTE,
       mois,
       annee,
       moislib,
       sum(debit) as depenses,
       IDSERVICELIB,
       SERVICE
from PREVISION_CPL
group by COMPTE, mois, annee, moislib, IDSERVICELIB, SERVICE;

create or replace view BUDGET_DEPENSE_SUM_VIEW_BUDGET as
SELECT "COMPTE","MOIS","ANNEE","MOISLIB","DEPENSES","IDSERVICELIB","SERVICE" FROM budget_depense_sum_view WHERE mois IS NOT NULL AND ANNEE IS NOT NULL;

ALTER TABLE FACTUREFOURNISSEUR ADD
SERVICE VARCHAR(255);

create OR REPLACE view FACTUREFOURNISSEURCPL as
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
       f3.IDDEVISE,
       cast(f3.MONTANTTVA as number(30,2)) as MONTANTTVA,
       CAST(f3.MONTANTTTC-f3.MONTANTTVA as number(30,2)) AS MONTANTHT,
       cast(f3.MONTANTTTC as number(30,2)) as montantttc,
       cast(f3.MONTANTTTC*f3.tauxdechange as number(30,2)) as MONTANTTTCAR,
       cast(nvl(mv.debit,0) AS NUMBER(30,2)) AS montantpaye,
       cast(f3.MONTANTTTC-nvl(mv.debit,0) AS NUMBER(30,2)) AS montantreste,
       cast(nvl(f3.tauxdechange,0) AS  NUMBER(30,2)) AS tauxdechange,
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
FROM FACTUREFOURNISSEUR f
         LEFT JOIN FOURNISSEUR f2 ON f2.ID = f.IDFOURNISSEUR
         LEFT JOIN MODEPAIEMENT m ON m.ID = f.IDMODEPAIEMENT
         LEFT JOIN MAGASIN p ON p.ID = f.IDMAGASIN
         JOIN FACTUREFOURNISSEURMONTANT f3 ON f.ID = f3.id
         LEFT JOIN mouvementcaisseGroupeFacture mv ON f.id=mv.IDORIGINE
         LEFT JOIN prevision prev ON prev.idfacture=f.id
         left join type_facture tf on tf.id = f.IDTYPEFACTURE;

create or replace view FACTUREFOURNISSEURFILLE_PAYE as
SELECT
    FFF.ID,
    FFF.IDFACTUREFOURNISSEUR,
    FFF.IDPRODUIT,
    FFF.QTE,
    FFF.PU,
    FFF.REMISES,
    FFF.IDBCDETAIL,
    FFF.TVA,
    FFF.PRODUITLIB,
    FFF.COMPTE,
    FFF.COMPTE  AS COMPTEREGR,
    FFF.ETAT,
    FFF.IDDEVISE,
    FFF.TAUXDECHANGE,
    FF.MONTANTTTC,
    FFF.MOIS,
    FFF.ANNEE,
    FF.DATY,
    -- Pourcentage payé (safe)
    FF.MONTANTPAYE * 100 / NULLIF(FF.MONTANTTTC, 0) AS POURCENTAGEPAYE,
    -- Montant payé fille
    (FF.MONTANTPAYE / NULLIF(FF.MONTANTTTC, 0)) * (FFF.QTE * FFF.PU) AS MONTANTFILLEPAYE,
    -- Reste à payer
    (FFF.QTE * FFF.PU)
        - ((FF.MONTANTPAYE / NULLIF(FF.MONTANTTTC, 0)) * (FFF.QTE * FFF.PU)) AS RESTEAPAYERFILLE,
    -- Montant payé AR
    ((FF.MONTANTPAYE / NULLIF(FF.MONTANTTTC, 0)) * (FFF.QTE * FFF.PU))
        * FFF.TAUXDECHANGE AS MONTANTFILLEPAYEAR,
    -- Montant total fille
    (FFF.QTE * FFF.PU) AS MONTANTFILLE,
    FF.SERVICE
FROM FACTUREFOURNISSEUR_FILLECPL FFF
    LEFT JOIN FACTUREFOURNISSEURCPL FF
    ON FF.ID = FFF.IDFACTUREFOURNISSEUR;

create or replace view SITUATION_BUDGET_DEPENSES as
select
    '-' as id,
    bdsv.COMPTE,
    IDSERVICELIB as service,
    bdsv.mois,
    bdsv.annee,
    bdsv.moislib,
    bdsv.depenses as budget,
    ffc.montant as montantfacture,
    ffc.montantpaye as paiement,
    ffc.resteapayer,
    bdsv.depenses - ffc.montant as ecartfacturebudget,
    bdsv.depenses - ffc.montantpaye as ecartbudgetpaiement
    from budget_depense_sum_view bdsv
left join (
    select
    SUBSTR(compteregr, 1, LENGTH(bdsv_inner.COMPTE)) as compteregr_groupe,
    mois,
    annee,
    SERVICE,
    sum(montantfille * TAUXDECHANGE)     as montant,
    sum(MontantFillePaye * TAUXDECHANGE) as montantpaye,
    sum(resteapayerfille * TAUXDECHANGE) as resteapayer
from facturefournisseurfille_paye ffp
  cross join (select distinct COMPTE from budget_depense_sum_view_budget) bdsv_inner
where SUBSTR(ffp.compteregr, 1, LENGTH(bdsv_inner.COMPTE)) = bdsv_inner.COMPTE
group by SUBSTR(compteregr, 1, LENGTH(bdsv_inner.COMPTE)), mois, annee, SERVICE
) ffc
on ffc.compteregr_groupe like bdsv.COMPTE||'%'
    and ffc.mois = bdsv.mois
    and ffc.annee = bdsv.annee
    and ffc.SERVICE = bdsv.SERVICE;

create or replace view VENTE_DETAILS_PAYE as
SELECT
    VD.ID,
    VD.IDVENTE,
    VD.IDPRODUIT,
    VD.IDORIGINE,
    VD.QTE,
    VD.PU,
    VD.REMISE,
    VD.TVA,
    VD.PUACHAT,
    VD.PUVENTE,
    VD.IDDEVISE,
    VD.TAUXDECHANGE,
    VD.DESIGNATION,
    VD.COMPTE,
    VD.PUREVIENT,
    VD.IDBCFILLE,
    VD.UNITE,
    VD.POIDS,
    VD.RISTOURNE,
    VD.IDPREVISION,
    V.MOIS,
    V.ANNEE,
    V.MONTANTPAYE * 100 / NULLIF(V.MONTANTTTC,0) AS  pourcentagepaye,
    (V.MONTANTPAYE / NULLIF(V.MONTANTTTC, 0)) * (VD.QTE * VD.PU) AS MontantFillePaye,
    (VD.QTE * VD.PU) - ((V.MONTANTPAYE / NULLIF(V.MONTANTTTC, 0)) * (VD.QTE * VD.PU))   AS resteapayerfille,
    ((V.MONTANTPAYE / NULLIF(V.MONTANTTTC, 0)) * (VD.QTE * VD.PU)) * VD.TAUXDECHANGE AS MontantFillePayeAr,
    (VD.QTE * VD.PU) AS montantfille
FROM VENTE_DETAILS VD
     LEFT JOIN VENTE_CPL V ON V.ID = VD.IDVENTE;


create or replace view BUDGET_RECETTE_SUM_VIEW as
select COMPTE,
    mois,
    annee,
    moislib,
    sum(credit) as depenses,
    IDSERVICELIB,
    SERVICE
from PREVISION_CPL
where mois is not null and ANNEE is not null
group by COMPTE, mois, annee, moislib, IDSERVICELIB, SERVICE;


create or replace view SITUATION_BUDGET_RECETTES as
select
    '-' as id,
    bdsv.COMPTE,
    IDSERVICELIB as service,
    bdsv.mois,
    bdsv.annee,
    bdsv.moislib,
    bdsv.depenses as budget,
    ffc.montant as montantfacture,
    ffc.montantpaye as paiement,
    ffc.resteapayer,
    bdsv.depenses - ffc.montant as ecartfacturebudget,
    bdsv.depenses - ffc.montantpaye as ecartbudgetpaiement
    from BUDGET_RECETTE_SUM_VIEW bdsv
    left join (
    select
    SUBSTR(ffp.compte, 1, LENGTH(bdsv_inner.COMPTE)) as compteregr_groupe,
    mois,
    annee,
    sum(montantfille * TAUXDECHANGE)     as montant,
    sum(MontantFillePaye * TAUXDECHANGE) as montantpaye,
    sum(resteapayerfille * TAUXDECHANGE) as resteapayer
from VENTE_DETAILS_PAYE ffp
  cross join (select distinct COMPTE from BUDGET_RECETTE_SUM_VIEW) bdsv_inner
where SUBSTR(ffp.compte, 1, LENGTH(bdsv_inner.COMPTE)) = bdsv_inner.COMPTE
group by SUBSTR(ffp.compte, 1, LENGTH(bdsv_inner.COMPTE)), mois, annee
) ffc on ffc.compteregr_groupe like bdsv.COMPTE||'%' and ffc.mois = bdsv.mois and ffc.annee = bdsv.annee;

create or replace view SITUATION_BUDGET_RECETTES_VIDE as
select id, compte, service, annee, 6 as moisdebut,moisdebutlib, 8 as moisfin,moisfinlib, budget, montantfacture, paiement, resteapayer, ECARTFACTUREBUDGET, ECARTBUDGETPAIEMENT from
(select ID,
     COMPTE,
     SERVICE,
     ANNEE,
     sum(nvl(BUDGET, 0)) as budget,
     sum(nvl(MONTANTFACTURE, 0)) as montantfacture,
     sum(nvl(PAIEMENT, 0)) as paiement,
     SUM(nvl(RESTEAPAYER, 0)) as resteapayer,
     SUM(nvl(ECARTFACTUREBUDGET, 0)) as ECARTFACTUREBUDGET,
     SUM(nvl(ECARTBUDGETPAIEMENT, 0)) as ECARTBUDGETPAIEMENT,
     TO_CHAR(
             TO_DATE(TO_CHAR(6, 'FM00'), 'MM'),
             'FMMonth',
             'NLS_DATE_LANGUAGE=FRENCH'
     ) AS moisdebutlib,
     TO_CHAR(
             TO_DATE(TO_CHAR(8, 'FM00'), 'MM'),
             'FMMonth',
             'NLS_DATE_LANGUAGE=FRENCH'
     ) AS moisfinlib
from SITUATION_BUDGET_RECETTES where mois between 6 and 8 group by ID, COMPTE, SERVICE, ANNEE);


UPDATE MENUDYNAMIQUE SET LIBELLE = 'Situation dépense' WHERE  ID = 'MENUDYN007';
UPDATE MENUDYNAMIQUE SET LIBELLE = 'Situation dépense annuelle' WHERE  ID = 'MENUDYN1607007';