create or replace view SousEcritureCompteExtrait as
select
    compte,
    SUBSTR(COMPTE, 1, 1) as compte1,
    SUBSTR(COMPTE, 1, 2) as compte2,
    SUBSTR(COMPTE, 1, 3) as compte3,
    SUBSTR(COMPTE, 1, 4) as compte4,
    cs.DEBIT,
    cs.CREDIT,
    cast(ce.EXERCICE as number) as annee,
    ce.etat
from COMPTA_SOUS_ECRITURE cs join COMPTA_ECRITURE ce on cs.IDMERE = ce.ID;

create or replace view SousEcritureGroupeByUnionVise as
select t.compte,c.LIBELLE,t.DEBIT,t.CREDIT,t.exercice,t.etat from
    (
        select *
        from SousEcritureGroupCompte
        UNION
        select *
        from SousEcritureGroupCompte1
        UNION
        select *
        from SousEcritureGroupCompte2
        UNION
        select *
        from SousEcritureGroupCompte3
        UNION
        select *
        from SousEcritureGroupCompte4
    ) t join compta_compte c on c.COMPTE = t.compte where etat>=11 order by compte desc;
