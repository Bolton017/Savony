create or replace view FACTUREFOURNISSEUR_FILLE_VISE as
select *
from FACTUREFOURNISSEUR_FILLECOMPTE
where etat >= 11
/

create or replace view VENTE_GRP_VISER as
select *
from VENTE_GRP_TOUS
where etat >=11
/
