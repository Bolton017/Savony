-- 21:25 vue ho ampiasain'ilay IA
create or replace view BC_CLIENT_FILLE_CPL_LIB_VISEE as
select bc.*,i.LIBELLE as produitlib
from BONDECOMMANDE_CLIENT_FILLE_CPL bc
join AS_INGREDIENTS i
on i.ID = bc.PRODUIT
JOIN BONDECOMMANDE_CLIENT mere
on mere.ID = bc.IDBC
where ETAT >=11;

-- 23:29 MAJ vue vente visée ho an'ilay IA
create view VENTE_DETAILS_CPL_2_VISEE as
select vd.* from VENTE_DETAILS_CPL_2 vd
         LEFT JOIN VENTE v ON v.ID = vd.IDVENTE
WHERE v.ETAT >= 11