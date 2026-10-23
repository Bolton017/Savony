create or replace view AVOIR_MVTCAISSE_ORIGINE as
select f.ID, f.CLIENTLIB as CLIENTLIB, f.DATY, f.DESIGNATION,f.ETAT as ETATLIB, f.IDDEVISE, cast(f.MONTANTTTC as number(30,2)) as MONTANTTTC, cast(f.MONTANTPAYE as number(30,2)) as MONTANTPAYE, cast(f.resteapayerar as number(30,2)) as resteapayerar, mc.ID as idorigine from avoirfclib_cpl f
left join MOUVEMENTCAISSE mc on mc.IDORIGINE = f.ID;