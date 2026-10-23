-- Stefan

CREATE OR REPLACE FORCE VIEW BUDGET_DEPENSE_SUM_VIEW ("COMPTE", "MOIS", "ANNEE", "MOISLIB", "DEPENSES") AS
select COMPTE,
       mois,
       annee,
       moislib,
       sum(debit) as depenses
from PREVISION_CPL
group by COMPTE, mois, annee, moislib
;


CREATE OR REPLACE FORCE VIEW FACTUREFOURNISSEUR_FILLECPL ("ID", "IDFACTUREFOURNISSEUR", "IDPRODUIT", "QTE", "PU", "REMISES", "IDBCDETAIL", "TVA", "PRODUITLIB", "COMPTE", "ETAT", "IDDEVISE", "TAUXDECHANGE", "MOIS", "ANNEE") AS
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



CREATE OR REPLACE FORCE VIEW FACTUREFOURNISSEURFILLE_PAYE AS
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
    SUBSTR(FFF.COMPTE, 1, 2) AS COMPTEREGR,
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
    (FFF.QTE * FFF.PU) AS MONTANTFILLE

FROM FACTUREFOURNISSEUR_FILLECPL FFF
         LEFT JOIN FACTUREFOURNISSEURCPL FF
                   ON FF.ID = FFF.IDFACTUREFOURNISSEUR;




CREATE OR REPLACE FORCE VIEW FACTUREFOURNISSEUR_COMPTEREGR ("COMPTEREGR", "MOIS", "ANNEE", "MONTANT", "MONTANTPAYE", "RESTEAPAYER") AS
select compteregr,
       mois,
       annee,
       sum(montantfille * TAUXDECHANGE)     as montant,
       sum(MontantFillePaye * TAUXDECHANGE) as montantpaye,
       sum(resteapayerfille * TAUXDECHANGE) as resteapayer
from facturefournisseurfille_paye
group by compteregr, mois, annee
;


CREATE OR REPLACE FORCE VIEW SITUATION_BUDGET_DEPENSES ("ID", "COMPTE", "SERVICE", "MOIS", "ANNEE", "MOISLIB", "BUDGET", "MONTANTFACTURE", "PAIEMENT", "RESTEAPAYER", "ECARTFACTUREBUDGET", "ECARTBUDGETPAIEMENT") AS
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
         left join service s on s.compte = bdsv.COMPTE
;