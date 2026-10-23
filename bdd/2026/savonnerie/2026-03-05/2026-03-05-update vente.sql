alter table VENTE add IDZONECLIENT VARCHAR(255);
create or replace view CLIENT_ACTIF as
select c.ID,
       NOM,
       TELEPHONE,
       MAIL,
       ADRESSE,
       REMARQUE,
       COMPTE,
       IDNATIONALITE,
       COMPTEAUXILIAIRE,
       IDTYPECLIENT,
       IDPROVINCE,
       ECHEANCE,
       TELFIXE,
       NIF,
       STAT,
       CARTE,
       DATECARTE,
       TAXE,
       CODECLIENT,
       idzoneclient,
       zc.val as idzoneclientlib
FROM CLIENT c
         LEFT JOIN ZONECLIENT zc on idzoneclient = zc.ID
where estactif = 1;

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
    zc.VAL as IDZONECLIENTLIB
FROM VENTE v
         LEFT JOIN ZONECLIENT zc on idzoneclient = zc.ID
