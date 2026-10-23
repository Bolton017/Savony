create view AS_BONDELIVRAISON_LIBMP as
select bl.ID,
       bl.REMARQUE,
       bl.IDBC,
       bl.DATY,
       bl.ETAT,
       bl.MAGASIN,
       m.VAL as MAGASINlib,
       case
           when bl.etat = 1 then 'CR&Eacute;&Eacute;(E)'
           when bl.etat = 11 then 'VIS&Eacute;(E)'
           end as etatlib,
       bl.idfournisseur,
       f.nom AS idfournisseurlib,
       bl.IDFACTUREFOURNISSEUR
from AS_BONDELIVRAISON bl
         left join MAGASINPOINT m on bl.MAGASIN = m.ID
         LEFT JOIN fournisseur f ON f.id=bl.idfournisseur;