create sequence SEQPROCESS;

create FUNCTION getSeqProcess
    RETURN NUMBER
        IS
           retour   NUMBER;
BEGIN
SELECT seqProcess.NEXTVAL INTO retour FROM DUAL;

RETURN retour;
END;

create table as_recette_back as select * from as_recette;

delete from as_recette where 1<2;
alter table AS_RECETTE
    modify QUANTITE NUMBER(10, 2);
insert into AS_RECETTE select * from as_recette_back;


create or replace view AS_RECETTEOF as
select offi.id,offi.idMere as IDPRODUITS,offi.idingredients,
cast(offi.qte*cast(nvl(e.qte,1) as number(20,2)) as number(20,2)) as quantite,ing.unite,ing.compose from OFFille offi left join equivalence e
on e.idproduit=offi.idingredients and e.idunite=offi.idunite
left join as_ingredients ing on ing.id=offi.idingredients
union all
select "ID","IDPRODUITS","IDINGREDIENTS",cast (QUANTITE as number(20,2))as quantite,"UNITE","COMPOSE" from AS_RECETTECOMPOSE
/