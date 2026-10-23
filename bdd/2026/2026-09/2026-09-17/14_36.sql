create or replace view CLIENTLIB as
SELECT
    c.ID,c.NOM,c.TELEPHONE,c.MAIL,c.ADRESSE,c.REMARQUE,c.COMPTE,c.IDNATIONALITE,c.COMPTEAUXILIAIRE,c.IDTYPECLIENT,
    t.val AS idTypeClientLib,
    c.codeclient,c.datecarte,c.taxe,c.idprovince,c.echeance,c.telfixe,c.nif,c.stat,c.carte,p.val AS provincelib,
    c.idzoneclient, zc.val as idzoneclientlib,
    c.IDMODEPAIEMENT, mp.val as idModePaiementLib,
    c.cin,
    c.DELAI,
    tf.val AS idtarificationlib,
    c.PAYEUR
FROM CLIENT c
         LEFT JOIN typeclient t
                   ON c.idTypeClient = t.id
         LEFT JOIN province p ON c.idprovince=p.id
         LEFT JOIN ZONECLIENT zc on c.idzoneclient = zc.ID
         LEFT JOIN MODEPAIEMENT mp on c.idModePaiement = mp.id
         LEFT JOIN tarification tf ON tf.id=c.idtarification;