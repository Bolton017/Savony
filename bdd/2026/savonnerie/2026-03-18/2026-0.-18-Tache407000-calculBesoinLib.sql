create or replace view CALCULBESOINLIB AS
select cb.*,
       m.VAL as IDMAGASINLIB
from CALCULBESOIN cb
         left join Magasin2 m on m.ID = cb.IDMAGASIN;


create or replace view CALCULBESOINFILLELIB as
select cbf.*, ai.LIBELLE as IDPRODUITLIB, cb.DATY, cb.DESIGNATION, cb.IDMAGASIN, cb.IDMAGASINLIB
from CALCULBESOINFILLE cbf
         left join AS_INGREDIENTS ai on ai.ID = cbf.IDPRODUIT
         left join CALCULBESOINlib cb on cb.ID = cbf.IDMERE;

create or replace view ResultatCalculBesoins as
select
    cbf.ID,
    cbf.IDMERE,
    cbf.IDPRODUIT,
    cbf.IDMAGASINLIB,
    r.IDINGREDIENTS,
    ai.LIBELLE,
    ai.UNITE,
    (cbf.QTE * r.QUANTITE) as qte,
    ai.PU,
    (cbf.QTE * ai.PU) as montant
from CALCULBESOINFILLELIB cbf
         left join AS_RECETTE r on r.IDPRODUITS = cbf.IDPRODUIT
         left join AS_INGREDIENTS ai on ai .ID = r.IDINGREDIENTS