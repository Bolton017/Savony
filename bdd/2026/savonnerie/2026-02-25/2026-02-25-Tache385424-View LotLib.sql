create or replace view lotlib as
select
    l.*,
    ing.LIBELLE as IDPRODUITLIB,
    eq.VAL as IDEQUIPELIB
from lot l
left join AS_INGREDIENTS ing on ing.ID = l.IDPRODUIT
left join EQUIPE eq on eq.ID = l.IDEQUIPE;