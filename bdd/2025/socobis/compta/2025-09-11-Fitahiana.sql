create view SousEcritureCompteExtrait as
select
    compte,
    SUBSTR(COMPTE, 1, 1) as compte1,
    SUBSTR(COMPTE, 1, 2) as compte2,
    SUBSTR(COMPTE, 1, 3) as compte3,
    SUBSTR(COMPTE, 1, 4) as compte4,
    DEBIT,
    CREDIT,
    EXERCICE as annee,
    etat
from COMPTA_SOUS_ECRITURE;


create view SousEcritureGroupCompte as
select
    compte,
    sum(DEBIT) as DEBIT,
    sum(CREDIT) AS CREDIT,
    annee,
    etat
from SousEcritureCompteExtrait group by compte, annee, etat;

create view SousEcritureGroupCompte1 as
select
    compte1,
    sum(DEBIT) as DEBIT,
    sum(CREDIT) AS CREDIT,
    annee,
    etat
from SousEcritureCompteExtrait group by compte1, annee, etat;

create view SousEcritureGroupCompte2 as
select
    compte2,
    sum(DEBIT) as DEBIT,
    sum(CREDIT) AS CREDIT,
    annee,
    etat
from SousEcritureCompteExtrait group by compte2, annee, etat;

create view SousEcritureGroupCompte3 as
select
    compte3,
    sum(DEBIT) as DEBIT,
    sum(CREDIT) AS CREDIT,
    annee,
    etat
from SousEcritureCompteExtrait group by compte3, annee, etat;


create view SousEcritureGroupCompte4 as
select
    compte4,
    sum(DEBIT) as DEBIT,
    sum(CREDIT) AS CREDIT,
    annee,
    etat
from SousEcritureCompteExtrait group by compte4, annee, etat;


create or replace view SousEcritureGroupeByUnionVise as
select t.compte,c.LIBELLE,t.DEBIT,t.CREDIT,t.annee,t.etat from
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
    ) t join compta_compte c on c.COMPTE = t.compte order by compte desc;



create sequence seqCompteClient
    minvalue 1
    maxvalue 999999999999
    start with 60000
    increment by 1
    cache 20;

CREATE OR REPLACE FUNCTION getseqCompteClient
   RETURN NUMBER
IS
   retour   NUMBER;
BEGIN
SELECT seqCompteClient.NEXTVAL INTO retour FROM DUAL;

RETURN retour;
END;


create sequence seqCompteFournisseur
    minvalue 1
    maxvalue 999999999999
    start with 60000
    increment by 1
    cache 20;


CREATE OR REPLACE FUNCTION getseqCompteFournisseur
   RETURN NUMBER
IS
   retour   NUMBER;
BEGIN
SELECT seqCompteFournisseur.NEXTVAL INTO retour FROM DUAL;

RETURN retour;
END;
