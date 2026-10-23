ALTER TABLE FACTUREFOURNISSEUR ADD
TYPEFACTUREFOURNISSEUR VARCHAR(255);

create or replace view FACTFOURNISSEURCALC as
select v."ID",v."IDFOURNISSEUR",v."IDMODEPAIEMENT",v."DATY",v."DESIGNATION",v."DATEECHEANCEPAIEMENT",v."ETAT",v."REFERENCE",v."IDBC",v."DEVISE",v."TAUX",v."IDMAGASIN",v."IDDEVISE",v."ESTPREVU",v."DATYPREVU",v."NUMERO",v."TYPEACHAT",v."IDTYPEFACTURE",v."IDOBJET",v."IDREF",v."IDDMDACHAT",v."IDFACTUREPRINCIPALE",v."SERVICE",v."REMISE", cast(montantRemiseSansTva+ (montantHT* (nvl(v.REMISE,0)/100)) as number(30,2)) as montantRemise, montantNonRemise,
       v."TYPEFACTUREFOURNISSEUR",cast(montantHT*(1-(nvl(v.REMISE,0)/100)) as number(30,2)) as montantHT,cast(montantTva*(1-(nvl(v.REMISE,0)/100)) as number(30,2)) as montantTva,
    cast(montantTTC*(1-(nvl(v.REMISE,0)/100)) as number(30,2)) as montantTTC, montantTTCAr*(1-(nvl(v.REMISE,0)/100)) as montantTTCAr, MONTANTHTAR*(1-(nvl(v.REMISE,0)/100)) as montantHtAr
    from FACTUREFOURNISSEUR v left join FFFilleCalcGroupeFF vdcv on v.id=vdcv.IDFACTUREFOURNISSEUR;

create table TYPEFACTUREFOURNISSEUR (
    ID    VARCHAR2(255) primary key,
    VAL   VARCHAR2(255),
    DESCE VARCHAR2(255)
);

INSERT INTO TYPEFACTUREFOURNISSEUR (ID, VAL, DESCE) VALUES ('FD', 'FD', 'Facture dépenses');
INSERT INTO TYPEFACTUREFOURNISSEUR (ID, VAL, DESCE) VALUES ('FAE', 'FAE', 'Facture à Éditer');
INSERT INTO TYPEFACTUREFOURNISSEUR (ID, VAL, DESCE) VALUES ('FAR', 'FAR', 'Facture à Recevoir');

create or replace view FACTUREFOURNISSEURCPL as
SELECT f.ID,
       f.IDFOURNISSEUR,
       f2.NOM  AS IDFOURNISSEURLIB,
       f.IDMODEPAIEMENT,
       m.VAL   AS IDMODEPAIEMENTLIB,
       f.DATY,
       f.DESIGNATION,
       f.DATEECHEANCEPAIEMENT,
       f.ETAT,
       CASE
           WHEN f.ETAT = 1
               THEN 'CRÉÉE'
           WHEN f.ETAT = 0
               THEN 'ANNULÉE'
           WHEN f.ETAT = 11
               THEN 'VISÉE'
           END AS ETATLIB,
       f.REFERENCE,
       f.IDBC,
       f.IDMAGASIN,
       f.DEVISE,
       case
           when f.TAUX=0 then 1
           else f.TAUX
           end as taux,
       p.VAL   AS idMagasinLib,
       f.IDDEVISE,
       cast(f.MONTANTTVA as number(30,5)) as MONTANTTVA,
       CAST(f.MONTANTHT as number(30,5)) AS MONTANTHT,
       cast(f.MONTANTTTC as number(30,5)) as montantttc,
       cast(f3.MONTANTTTC*f3.tauxdechange as number(30,2)) as MONTANTTTCAR,
       cast(nvl(mv.MONTANT,0) AS number(30,5)) AS montantpaye,
       cast(f.MONTANTTTC-nvl(mv.MONTANT,0)-0 AS number(30,5)) AS montantreste, -- tokony avoir ilay - 0 farany
       cast(1 AS  number(30,5)) AS tauxdechange,
       prev.id as idPrevision,
       CASE
           WHEN f.estprevu=0 THEN 'NON'
           ELSE 'OUI'
           END
           AS estprevulib,
       f.IDOBJET,
       f.IDREF,
       f.IDTYPEFACTURE,
       tf.VAL as typefacture,
       f.numero,
       f.typeachat,
        f.SERVICE,
        f.REMISE,
        f.idfactureprincipale,
       f.TYPEFACTUREFOURNISSEUR,
       tff.DESCE AS TYPEFACTUREFOURNISSEURLIB
FROM FactFournisseurCalc f
    LEFT JOIN FOURNISSEUR f2 ON f2.ID = f.IDFOURNISSEUR
    LEFT JOIN MODEPAIEMENT m ON m.ID = f.IDMODEPAIEMENT
    LEFT JOIN MAGASIN p ON p.ID = f.IDMAGASIN
    JOIN FACTUREFOURNISSEURMONTANT f3 ON f.ID = f3.id
    LEFT JOIN typefacturefournisseur tff ON tff.id = f.TYPEFACTUREFOURNISSEUR
    LEFT JOIN LIAISONPAIEMENTTOTAL mv ON f.id=mv.ID2
    LEFT JOIN prevision prev ON prev.idfacture=f.id
    left join type_facture tf on tf.id = f.IDTYPEFACTURE;