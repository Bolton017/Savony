create or replace view PREVISION_COMPLET_CPLPOSITIF as
SELECT pr.ID,
       pr.DESIGNATION,
       pr.IDCAISSE,
       pr.IDCAISSELIB,
       pr.IDVENTEDETAIL,
       pr.IDVENTE,
       pr.IDVENTELIB,
       pr.IDVIREMENT,
       pr.DEBIT,
       pr.CREDIT,
       pr.DATY,
       pr.ETAT,
       pr.IDOP,
       pr.IDOPLIB,
       pr.IDORIGINE,
       pr.IDDEVISE,
       pr.IDDEVISELIB,
       pr.TAUX,
       pr.IDTIERS,
       pr.COMPTE,
       pr.EFFECTIFDEBIT,
       pr.EFFECTIFCREDIT,
       pr.DEPENSEECART,
       pr.RECETTEECART,
       pr.IDFACTURE,
       COALESCE(vd.IDVENTE, fcf.IDFACTUREFOURNISSEUR) as IDFACTUREMERE
from PREVISION_COMPLET_CPL pr
         left join VENTE_DETAILS_CPL vd on vd.id = pr.IDFACTURE
         left join FACTUREFOURNISSEURFILLE fcf on fcf.id = pr.IDFACTURE
WHERE pr.DEPENSEECART > 0
   OR RECETTEECART > 0
order by daty asc