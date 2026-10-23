UPDATE historique
SET heure = '00' || SUBSTR(heure, 3)
WHERE heure LIKE '24:%';

update inventaire i set i.heure=(select his.heure from
(select i.id,max(histo.heure) as heure from INVENTAIRE i
left join
(select substr(heure,1,8) as heure,REFOBJET  from HISTORIQUE where ACTION like 'Validation%') histo on histo.refobjet=i.id
where i.ETAT>=11 and i.HEURE is null group by i.id) his where his.id=i.id) where i.heure is null and i.ETAT>=11;


create table mvtStAvecHisto as
select m.id,max(histo.heure) as heure from MVTSTOCK m
join
(select substr(heure,1,8) as heure,REFOBJET  from HISTORIQUE where ACTION like 'Validation%') histo on histo.refobjet=m.id
where m.ETAT>=11 and m.HEURE is null group by m.id;

update MVTSTOCK mv set mv.HEURE=(select his.heure from
mvtStAvecHisto his where his.id=mv.id) where mv.heure is null and mv.ETAT>=11
and exists (select 1 from mvtStAvecHisto mh where mh.id=mv.id );
