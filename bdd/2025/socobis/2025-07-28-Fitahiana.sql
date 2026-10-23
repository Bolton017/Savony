
ALTER TABLE FactureFournisseurFille ADD mois int;

ALTER TABLE FactureFournisseurFille ADD annee int;

create or replace view ST_INGREDIENTSAUTOACHAT_CPL as
select st.*, 1 as taux from ST_INGREDIENTSAUTO st;

create or replace view COMPTE6 as
SELECT "ID","COMPTE","LIBELLE","TYPECOMPTE","CLASSY","ANALYTIQUE_OBLI","IDJOURNAL"
FROM COMPTA_COMPTE c
WHERE compte LIKE '6%';

ALTER TABLE AS_BONDECOMMANDE ADD idmagasin varchar2(500);