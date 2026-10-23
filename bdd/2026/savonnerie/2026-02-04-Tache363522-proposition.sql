create or replace view PROFORMAFOURNISSEURDETAILSCPL as
select bcf.ID,bcf.PRODUIT,bcf.IDMERE,bcf.QUANTITE,bcf.QUANTITE*bcf.PU AS montant,bcf.PU,bcf.TVA,bcf.TAUXDECHANGE,bcf.UNITE,bcf.REMISE,
       ab.DATY,
       ab.ETAT,
       ab.REMARQUE,
       ab.DESIGNATION,
       ab.MODEPAIEMENT,
       ab.FOURNISSEUR,
       ab.REFERENCE,
       p.LIBELLE  as produitlib,
       u.VAL  as unitelib,
       mp.VAL as MODEPAIEMENTLIB,
       F.nom  AS FOURNISSEURLIB,
       CAST (bcf.quantite * bcf.pu * (bcf.tva/100) AS NUMBER(30,2)) AS montanttva,
       CAST( bcf.quantite * bcf.pu + (bcf.quantite * bcf.pu * (bcf.tva/100)) AS NUMBER(30,2)) AS montantttc,
       CAST (bcf.quantite * bcf.pu + (bcf.quantite * bcf.pu  * (bcf.tva/100)) - bcf.quantite * bcf.pu * (bcf.tva/100) AS NUMBER(30,2)) AS montantht,
       bcf.iddevise,
       ab.IDORIGINE as idoriginemere
from proformafournisseurdetails bcf
         left outer join proformafournisseur AB on AB.ID = bcf.IDMERE
         left join AS_INGREDIENTS P on bcf.PRODUIT = P.ID
         left join AS_UNITE u on bcf.UNITE = u.id
         left join MODEPAIEMENT mp on AB.MODEPAIEMENT = mp.id
         left join fournisseur F on AB.fournisseur = F.id
    /

