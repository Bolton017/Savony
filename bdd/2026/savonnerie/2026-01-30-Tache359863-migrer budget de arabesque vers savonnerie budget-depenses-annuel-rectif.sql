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
