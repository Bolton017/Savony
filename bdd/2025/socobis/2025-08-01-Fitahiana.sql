
create or replace view MOUVEMENTCAISSE_VISE as
select * from MOUVEMENTCAISSE
WHERE ETAT=11;