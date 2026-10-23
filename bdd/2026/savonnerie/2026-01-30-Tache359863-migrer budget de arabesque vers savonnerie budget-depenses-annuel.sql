CREATE OR REPLACE  VIEW "PREVISION_CPL" AS
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
    s.LIBELLE as idservicelib
from PREVISION p
         left join caisse c on p.idcaisse = c.id
         left join VENTE_DETAILS v on p.IDVENTEDETAIL=v.ID
         left join vente v2 on v2.id=v.IDVENTE
         left join ORDONNERPAIEMENT o on o.id=p.IDOP
         left join devise d on d.id=p.IDDEVISE
         left join service s on p.compte=s.compte;

CREATE OR REPLACE VIEW BUDGET_DEPENSE_SUM_VIEW AS
select COMPTE,
       mois,
       annee,
       moislib,
       sum(debit) as depenses
from PREVISION_CPL
group by COMPTE, mois, annee, moislib;

-- SAVONNERIE0126.FACTUREFOURNISSEURCPL source
CREATE OR REPLACE FORCE VIEW "SAVONNERIE0126"."FACTUREFOURNISSEURCPL" ("ID", "IDFOURNISSEUR", "IDFOURNISSEURLIB", "IDMODEPAIEMENT", "IDMODEPAIEMENTLIB", "DATY", "DESIGNATION", "DATEECHEANCEPAIEMENT", "ETAT", "ETATLIB", "REFERENCE", "IDBC", "IDMAGASIN", "DEVISE", "TAUX", "IDMAGASINLIB", "IDDEVISE", "MONTANTTVA", "MONTANTHT", "MONTANTTTC", "MONTANTTTCAR", "MONTANTPAYE", "MONTANTRESTE", "TAUXDECHANGE", "IDPREVISION") AS
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
               THEN 'CREE'
           WHEN f.ETAT = 0
               THEN 'ANNULEE'
           WHEN f.ETAT = 11
               THEN 'VISEE'
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
       prev.id as idPrevision
FROM FACTUREFOURNISSEUR f
         LEFT JOIN FOURNISSEUR f2 ON f2.ID = f.IDFOURNISSEUR
         LEFT JOIN MODEPAIEMENT m ON m.ID = f.IDMODEPAIEMENT
         LEFT JOIN MAGASIN p ON p.ID = f.IDMAGASIN
         JOIN FACTUREFOURNISSEURMONTANT f3 ON f.ID = f3.id
         LEFT JOIN mouvementcaisseGroupeFacture mv ON f.id=mv.IDORIGINE
         LEFT JOIN prevision prev ON prev.idfacture=f.id;

-- SAVONNERIE0126.FACTUREFOURNISSEUR_FILLECPL source
CREATE OR REPLACE FORCE VIEW "SAVONNERIE0126"."FACTUREFOURNISSEUR_FILLECPL" ("ID", "IDFACTUREFOURNISSEUR", "IDPRODUIT", "QTE", "PU", "REMISES", "IDBCDETAIL", "TVA", "PRODUITLIB", "COMPTE", "ETAT", "IDDEVISE", "TAUXDECHANGE", "MOIS", "ANNEE") AS
select ff.ID,
       ff.IDFACTUREFOURNISSEUR,
       ff.IDPRODUIT,
       ff.QTE,
       ff.PU,
       ff.REMISES,
       ff.IDBCDETAIL,
       ff.TVA,
       p.libelle as produitlib,
       ff.compte,
       f.ETAT,
       ff.iddevise,
       ff.tauxdechange,
       ff.mois,
       ff.annee
from FACTUREFOURNISSEURFILLE ff
         left join PRODUIT_LIBCPL p on p.id = ff.idproduit
         left join FACTUREFOURNISSEUR F on F.ID = ff.IDFACTUREFOURNISSEUR;

-- SAVONNERIE0126.FACTUREFOURNISSEURFILLE_PAYE source
CREATE OR REPLACE FORCE VIEW "SAVONNERIE0126"."FACTUREFOURNISSEURFILLE_PAYE" ("ID", "IDFACTUREFOURNISSEUR", "IDPRODUIT", "QTE", "PU", "REMISES", "IDBCDETAIL", "TVA", "PRODUITLIB", "COMPTE", "COMPTEREGR", "ETAT", "IDDEVISE", "TAUXDECHANGE", "MONTANTTTC", "MOIS", "ANNEE", "DATY", "POURCENTAGEPAYE", "MONTANTFILLEPAYE", "RESTEAPAYERFILLE", "MONTANTFILLEPAYEAR", "MONTANTFILLE") AS
select FFF.ID,
       FFF.IDFACTUREFOURNISSEUR,
       FFF.IDPRODUIT,
       FFF.QTE,
       FFF.PU,
       FFF.REMISES,
       FFF.IDBCDETAIL,
       FFF.TVA,
       FFF.PRODUITLIB,
       FFF.COMPTE,
       substr(FFF.COMPTE, 1, 2)                                                                   as compteregr,
       FFF.ETAT,
       FFF.IDDEVISE,
       FFF.TAUXDECHANGE,
       FF.MONTANTTTC,
       --extract(month from FF.DATY) as mois,
       --extract(year from FF.daty) as annee,
       fff.mois,
       fff.annee,
       ff.daty,
       FF.MONTANTPAYE * 100 / FF.MONTANTTTC                                                       as pourcentagepaye,
       ((FF.MONTANTPAYE * 100 / FF.MONTANTTTC) / 100) * (FFF.QTE * FFF.PU)                        as MontantFillePaye,
       (FFF.QTE * FFF.PU) - (((FF.MONTANTPAYE * 100 / FF.MONTANTTTC) / 100) * (FFF.QTE * FFF.PU)) as resteapayerfille,
       (((FF.MONTANTPAYE * 100 / FF.MONTANTTTC) / 100) * (FFF.QTE * FFF.PU)) * FFF.TAUXDECHANGE   as MontantFillePayeAr,
       (FFF.QTE * FFF.PU)                                                                         as montantfille
from FACTUREFOURNISSEUR_FILLECPL FFF
         LEFT JOIN FACTUREFOURNISSEURCPL FF ON FF.ID = FFF.IDFACTUREFOURNISSEUR;

-- SAVONNERIE0126.FACTUREFOURNISSEUR_COMPTEREGR source
CREATE OR REPLACE FORCE VIEW "SAVONNERIE0126"."FACTUREFOURNISSEUR_COMPTEREGR" ("COMPTEREGR", "MOIS", "ANNEE", "MONTANT", "MONTANTPAYE", "RESTEAPAYER") AS
select compteregr,
       mois,
       annee,
       sum(montantfille * TAUXDECHANGE)     as montant,
       sum(MontantFillePaye * TAUXDECHANGE) as montantpaye,
       sum(resteapayerfille * TAUXDECHANGE) as resteapayer
from SAVONNERIE0126.facturefournisseurfille_paye
group by compteregr, mois, annee;

-- SAVONNERIE0126.SITUATION_BUDGET_DEPENSES source
CREATE OR REPLACE FORCE VIEW "SAVONNERIE0126"."SITUATION_BUDGET_DEPENSES" ("ID", "COMPTE", "SERVICE", "MOIS", "ANNEE", "MOISLIB", "BUDGET", "MONTANTFACTURE", "PAIEMENT", "RESTEAPAYER", "ECARTFACTUREBUDGET", "ECARTBUDGETPAIEMENT") AS
select '-' as id,
       bdsv.COMPTE,
       s.LIBELLE as service,
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
         left join facturefournisseur_compteregr ffc
                   on ffc.compteregr = bdsv.COMPTE and ffc.mois = bdsv.mois and ffc.annee = bdsv.annee
         left join service s on s.compte = bdsv.COMPTE;

-- SAVONNERIE0126.SITUATION_BUDGET_DEPENSES_VIDE source
CREATE OR REPLACE FORCE VIEW "SAVONNERIE0126"."SITUATION_BUDGET_DEPENSES_VIDE" ("ID", "COMPTE", "SERVICE", "ANNEE", "MOISDEBUT", "MOISDEBUTLIB", "MOISFIN", "MOISFINLIB", "BUDGET", "MONTANTFACTURE", "PAIEMENT", "RESTEAPAYER", "ECARTFACTUREBUDGET", "ECARTBUDGETPAIEMENT") AS
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
     from situation_budget_depenses where mois between 6 and 8 group by ID, COMPTE, SERVICE, ANNEE);
