 create or replace view FACTUREFOURNISSEUR_FILLECOMPTE as
select ff.COMPTE,
       ff.IDFACTUREFOURNISSEUR,
       ff.etat,
       cast(sum(pu * QTE*(1-(NVL(ff.REMISE, 0) / 100))*ff.TAUXDECHANGE) as number(30, 2))                            as montantht,
       cast(sum(pu * QTE * (tva / 100)*(1-(NVL(ff.REMISE, 0) / 100))*ff.TAUXDECHANGE) as number(30, 2))              as montanttva,
       cast(sum(((pu * QTE*(1-(NVL(ff.REMISE, 0) / 100))*ff.TAUXDECHANGE) + (pu * QTE * (tva / 100)*(1-(NVL(ff.REMISE, 0) / 100))*ff.TAUXDECHANGE))) as number(30, 2)) as montantttc,
       ff.iddevise,
       ff.tauxdechange
from FACTUREFOURNISSEUR_FILLECPL ff
group by COMPTE, IDFACTUREFOURNISSEUR, ff.etat,ff.iddevise,ff.tauxdechange;


create or replace view FACTUREFOURNISSEUR_FILLECPL as
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
       ff.annee,ff.REMISE
from FACTUREFOURNISSEURFILLE ff
         left join PRODUIT_LIBCPL p on p.id = ff.idproduit
         left join FACTUREFOURNISSEUR F on F.ID = ff.IDFACTUREFOURNISSEUR;