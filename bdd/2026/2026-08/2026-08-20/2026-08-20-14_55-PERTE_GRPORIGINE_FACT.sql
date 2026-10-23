CREATE OR REPLACE VIEW PERTE_GRPORIGINE_FACT AS
  select lf.id1 as idorigine, FFC.taux, sum(ffc.MONTANTHT) as montant, sum(ffc.montantHTAr) as montantar,LISTAGG(id2, ';;') WITHIN GROUP (ORDER BY id2) AS idbcDetail
from LIAISONFACTUREFOURNISSEURS lf
         LEFT JOIN FactFournisseurCalc FFC on FFC.id = lf.id2
    where not exists (select 1 from perteGainUtilise p where p.VAL=lf.ID2)
group by lf.id1, FFC.taux;

CREATE OR REPLACE VIEW FFAVECPERTE_FF_IDPG AS
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
    CAST( nvl((CASE WHEN fg.MONTANTPERTEGAIN =0 THEN NULL ELSE  ff.MONTANTPERTEGAIN end),(p.montant*qte*p.TAUX*ff.pu/fg.montanttotal)) AS NUMBER(30,2) ) AS MONTANTPERTEGAIN ,
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


create or replace view FACTUREFOURNISSEURAUTOCOMPLETE as
SELECT
    f.ID,
    CASE
        WHEN f.IDFOURNISSEUR IS NULL
            THEN f.IDFOURNISSEUR
        ELSE f.IDFOURNISSEUR||'---'||fou.nom
        END AS IDFOURNISSEUR ,
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
    f.NUMERO,
    f.TYPEACHAT,
    f.IDTYPEFACTURE,
    f.IDOBJET,
    f.IDREF,
    f.IDDMDACHAT,
    f.REMISEMONTANT,
    f.REMISE,
    f.SERVICE,
    f.IDFACTUREPRINCIPALE,
    f.TYPEFACTUREFOURNISSEUR
FROM FACTUREFOURNISSEUR f
LEFT JOIN FOURNISSEUR fou ON fou.id = f.IDFOURNISSEUR;