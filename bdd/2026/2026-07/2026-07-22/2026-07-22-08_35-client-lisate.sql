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
       IDTARIFICATION,
       tc.VAL as IDTYPECLIENTLIB,
       ta.VAL as IDTARIFICATIONLIB,
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
         LEFT JOIN TARIFICATION ta on IDTARIFICATION = ta.id
         LEFT JOIN typeclient tc on IDTYPECLIENT = tc.ID
where estactif = 1;