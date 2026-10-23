
alter table INVENTAIREFILLE add idFournisseur varchar(255);
alter table INVENTAIREFILLE add daty date;



create or replace view V_ETATSTOCK_ENTREE_FOURN as
select e.*,coalesce(b.IDFOURNISSEUR,if.idFournisseur) as idFournisseur from V_ETATSTOCK_ENTREE e
left join MVTSTOCKFILLE m on m.id=e.id
left join mvtstock mv on mv.id=m.IDMVTSTOCK
left join AS_BONDELIVRAISON b on b.ID=mv.IDOBJET
left join inventaire i on i.id=mv.IDOBJET
left join inventairefille if on if.IDINVENTAIRE=i.id
where b.IDFOURNISSEUR is not null or if.IDFOURNISSEUR is not null;