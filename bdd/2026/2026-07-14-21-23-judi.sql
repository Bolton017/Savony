create or replace view VNT_MVTCAISSE_ORIGINE as
select v.id, v.idclientlib, v.daty, v.designation, v.etatlib, v.iddevise, cast(v.montantttc as number(30,2)) as montantttc, cast(v.montantpaye as number(30,2)) as montantpaye, cast(v.montantreste as number(30,2)) as montantreste, mc.id as idorigine from VENTE_CPL v
                                                                                                                                                                                                                                                                  left join mouvementcaisse mc on mc.IDORIGINE = v.ID;

create or replace view FF_MVTCAISSE_ORIGINE as
select f.ID, f.IDFOURNISSEURLIB, f.DATY, f.DESIGNATION, f.ETATLIB, f.IDDEVISE, cast(f.MONTANTTTC as number(30,2)) as MONTANTTTC, cast(f.MONTANTPAYE as number(30,2)) as MONTANTPAYE, cast(f.MONTANTRESTE as number(30,2)) as MONTANTRESTE, mc.ID as idorigine from FACTUREFOURNISSEURCPL f
                                                                                                                                                                                                                                                                       left join MOUVEMENTCAISSE mc on mc.IDORIGINE = f.ID;

CREATE OR REPLACE VIEW FF_VNT_MVTCAISSE_ORIGINE (
    ID,
    IDFOURNISSEURLIB,
    DATY,
    DESIGNATION,
    ETATLIB,
    IDDEVISE,
    MONTANTTTC,
    MONTANTPAYE,
    MONTANTRESTE,
    IDORIGINE
    ) AS
SELECT
    fm.ID,
    fm.IDFOURNISSEURLIB,
    fm.DATY,
    fm.DESIGNATION,
    fm.ETATLIB,
    fm.IDDEVISE,
    CAST(fm.MONTANTTTC AS NUMBER(30,2))   AS MONTANTTTC,
    CAST(fm.MONTANTPAYE AS NUMBER(30,2))  AS MONTANTPAYE,
    CAST(fm.MONTANTRESTE AS NUMBER(30,2)) AS MONTANTRESTE,
    fm.IDORIGINE
FROM FF_MVTCAISSE_ORIGINE fm
UNION ALL
SELECT
    vm.ID,
    vm.IDCLIENTLIB,
    vm.DATY,
    vm.DESIGNATION,
    vm.ETATLIB,
    vm.IDDEVISE,
    CAST(vm.MONTANTTTC AS NUMBER(30,2))   AS MONTANTTTC,
    CAST(vm.MONTANTPAYE AS NUMBER(30,2))  AS MONTANTPAYE,
    CAST(vm.MONTANTRESTE AS NUMBER(30,2)) AS MONTANTRESTE,
    vm.IDORIGINE
FROM VNT_MVTCAISSE_ORIGINE vm;