-- Zotina

CREATE OR REPLACE VIEW proformafournisseurdetailscpl AS 
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
 		bcf.iddevise
from proformafournisseurdetails bcf
         left outer join proformafournisseur AB on AB.ID = bcf.IDMERE
         left join AS_INGREDIENTS P on bcf.PRODUIT = P.ID
         left join AS_UNITE u on bcf.UNITE = u.id
         left join MODEPAIEMENT mp on AB.MODEPAIEMENT = mp.id
         left join fournisseur F on AB.fournisseur = F.id;


CREATE OR REPLACE VIEW proformafournisseur_merecpl AS 
  SELECT
    ab.ID,
    ab.DATY,
    ab.ETAT,
    ab.REMARQUE,
    ab.DESIGNATION,
    ab.MODEPAIEMENT,
    ab.FOURNISSEUR,
    ab.REFERENCE,
    mp.VAL AS MODEPAIEMENTLIB,
    F.NOM AS FOURNISSEURLIB,
    abf.montantTVA,
    abf.montantHT,
    CAST(nvl((abf.montantHT + abf.montantTVA),0) AS NUMBER(30,2)) AS montantTTC ,
    CAST(nvl((abf.montantHT + abf.montantTVA) * abf.TAUXDECHANGE,0) AS NUMBER(30,2)) AS montantTTCAriary,
    d.val AS idDeviselib,
    d.id AS IDDEVISE,
    CASE
        WHEN ab.ETAT = 1 THEN 'CREEE'
        WHEN ab.ETAT = 11 THEN 'VISEE'
        WHEN ab.ETAT = 0 THEN 'ANNULEE'
        END
        AS ETATLIB
from  proformafournisseur AB
          left join MODEPAIEMENT mp on AB.MODEPAIEMENT = mp.id
          left join FOURNISSEUR F on AB.FOURNISSEUR = F.id
          LEFT JOIN proformafournisseurdetailscpl abf ON abf.IDMERE = ab.ID
          LEFT JOIN DEVISE d ON d.id = ab.IDDEVISE;