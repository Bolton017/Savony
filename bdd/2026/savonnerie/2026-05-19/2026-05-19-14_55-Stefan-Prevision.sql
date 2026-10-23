-- Stefan

CREATE OR REPLACE VIEW PREVISIONGROUPE AS
SELECT
    COALESCE(v.id, ff.idFactureFournisseur) AS idFacture,
    CASE
        WHEN v.id IS NOT NULL
            THEN 'vente/vente-fiche.jsp&id=' || v.id
        WHEN ff.idFactureFournisseur IS NOT NULL
            THEN 'facturefournisseur/facturefournisseur-fiche.jsp&id=' || ff.idFactureFournisseur
        ELSE NULL
        END AS reference,
    p.daty,
    SUM(p.debit)  AS debit,
    SUM(p.credit) AS credit

FROM prevision p

         LEFT JOIN vente v
                   ON v.id = p.idfacture

         LEFT JOIN facturefournisseurfille ff
                   ON ff.idFactureFournisseur = p.idfacture

GROUP BY
    v.id,
    ff.idFactureFournisseur,
    p.daty
;

CREATE OR REPLACE VIEW PREVISION_COMPLET_CPL AS
SELECT
    p.ID,
    p.DESIGNATION,
    p.IDCAISSE,
    p.IDCAISSELIB,
    p.IDVENTEDETAIL,
    p.IDVENTE,
    p.IDVENTELIB,
    p.IDVIREMENT,
    p.DEBIT,
    p.CREDIT,
    p.DATY,
    p.ETAT,
    p.IDOP,
    p.IDOPLIB,
    p.IDORIGINE,
    p.IDDEVISE,
    p.IDDEVISELIB,
    p.TAUX,
    p.IDTIERS,
    t.NOM as IDTIERSLIB,
    p.COMPTE,
    NVL(pe.effectifDeb,0) AS effectifDebit,
    NVL(pe.effectifCred,0) AS effectifCredit,
    p.debit - NVL(pe.effectifDeb,0) AS depenseEcart,
    p.credit - nVL(pe.effectifCred,0) AS recetteEcart,
    p.idfacture,
    COALESCE(v.IDVENTE, f.IDFACTUREFOURNISSEUR) AS idfacturemere
FROM PREVISION_CPL p
         LEFT JOIN PrevisionAvecMvtCaisse pe ON pe.id = p.id
         LEFT JOIN VENTE_DETAILS v ON v.id = p.idfacture
         LEFT JOIN FACTUREFOURNISSEURFILLE f ON f.id = p.idfacture
         LEFT JOIN TIERS t ON t.id = p.IDTIERS;


CREATE OR REPLACE VIEW PREVISION_COMPLET_CPLPOSITIF AS
SELECT "ID","DESIGNATION","IDCAISSE","IDCAISSELIB","IDVENTEDETAIL","IDVENTE","IDVENTELIB","IDVIREMENT","DEBIT","CREDIT","DATY","ETAT","IDOP","IDOPLIB","IDORIGINE","IDDEVISE","IDDEVISELIB","TAUX","IDTIERS","COMPTE","EFFECTIFDEBIT","EFFECTIFCREDIT","DEPENSEECART","RECETTEECART","IDFACTURE", "IDFACTUREMERE"
from PREVISION_COMPLET_CPL pr WHERE pr.DEPENSEECART >0 OR RECETTEECART >0 order by daty asc

;