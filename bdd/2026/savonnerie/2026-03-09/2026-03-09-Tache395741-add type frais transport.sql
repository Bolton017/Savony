alter table BONDECOMMANDE_CLIENT add TYPEFRAISTRANSPORT NUMBER(2);
alter table  vente add TYPEFRAISTRANSPORT NUMBER(2);

create or replace view INSERTION_VENTE as
SELECT
    v.ID,
    v.DESIGNATION,
    v.IDMAGASIN,
    v.DATY,
    v.REMARQUE,
    v.ETAT,
    v.IDORIGINE,
    v.IDCLIENT,
    CAST(' ' AS varchar(100)) AS iddevise,
    v.ESTPREVU,
    v.DATYPREVU,
    v.IDRESERVATION,
    v.echeancefacture,
    v.modepaiement,
    v.modelivraison,
    v.fraislivraison,
    v.referencefact,
    v.LIEULIVRAISON,
    v.DATELIVRAISON,
    v.IDZONECLIENT,
    zc.VAL as IDZONECLIENTLIB,
    v.TYPEFRAISTRANSPORT
FROM VENTE v
LEFT JOIN ZONECLIENT zc on idzoneclient = zc.ID;

INSERT INTO CATEGORIEINGREDIENT (ID, VAL, DESCE, ESTACHAT) VALUES ('CATS000001', 'Service', 'Service', null);