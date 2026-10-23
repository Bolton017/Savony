create or replace view AS_BONDECOMMANDE_CPL_PDF as
select bcf.ID,bcf.PRODUIT,bcf.IDBC,bcf.QUANTITE,bcf.QUANTITE*bcf.PU AS montant,bcf.PU,bcf.TVA,bcf.UNITE,bcf.REMISE,
       ab.DATY,
       ab.ETAT,
       bcf.REMARQUE,
       ab.DESIGNATION,
       ab.MODEPAIEMENT,
       ab.FOURNISSEUR,
       ab.REFERENCE,
       p.LIBELLE  as produitlib,
       u.VAL  as unitelib,
       mp.VAL as MODEPAIEMENTLIB,
       F.nom  AS FOURNISSEURLIB,
       CAST(bcf.quantite * bcf.pu * ((bcf.remise/100)+(ab.REMISE/100)) AS NUMBER(30,2)) AS remiseMontant,
       CAST(bcf.quantite * bcf.pu*(1-bcf.remise/100) AS NUMBER(30,2)) AS montantht,
       CAST((bcf.quantite * bcf.pu - (bcf.quantite * bcf.pu * (bcf.remise/100))) * (bcf.tva/100)*(1-(ab.REMISE/100)) AS NUMBER(30,2)) AS montanttva,
       CAST((bcf.quantite * bcf.pu - (bcf.quantite * bcf.pu * (bcf.remise/100)))*(1-(ab.REMISE/100))
            + (bcf.quantite * bcf.pu - (bcf.quantite * bcf.pu * (bcf.remise/100))) * (bcf.tva/100)*(1-(ab.REMISE/100))
           AS NUMBER(30,2)) AS montantttc,
       bcf.iddevise,
       CAST((
           (bcf.quantite * bcf.pu - (bcf.quantite * bcf.pu * (bcf.remise/100)))
               + (bcf.quantite * bcf.pu - (bcf.quantite * bcf.pu * (bcf.remise/100))) * (bcf.tva/100)
           ) * bcf.TAUXDECHANGE*(1-(ab.REMISE/100))
       AS NUMBER(30,2)) AS montantttcar,
       bcf.TAUXDECHANGE
from AS_BONDECOMMANDE_FILLE bcf
    left outer join AS_BONDECOMMANDE AB on AB.ID = bcf.IDBC
    left join AS_INGREDIENTS P on bcf.PRODUIT = P.ID
    left join AS_UNITE u on bcf.UNITE = u.id
    left join MODEPAIEMENT mp on AB.MODEPAIEMENT = mp.id
    left join fournisseur F on AB.fournisseur = F.id;