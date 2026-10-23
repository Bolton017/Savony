alter table ZONECLIENT add forfait number(32,2);
alter table ZONECLIENT add prixcarton number(32,2);
alter table ZONECLIENT add mincarton number(32,2);

update ZONECLIENT set forfait=1000, prixcarton=10, mincarton=5 where id='Z001';
update ZONECLIENT set forfait=1500, prixcarton=12, mincarton=5 where id='Z002';
update ZONECLIENT set forfait=2000, prixcarton=15, mincarton=5 where id='Z003';
update ZONECLIENT set forfait=2000, prixcarton=20, mincarton=5 where id='Z004';
update ZONECLIENT set forfait=2000, prixcarton=100, mincarton=5 where id='Z005';

INSERT INTO ZONECLIENT (ID, VAL, DESCE, FORFAIT, PRIXCARTON, MINCARTON) VALUES ('Z006', 'ZONE E - 2 – Province 201km à 600km', 'ZONE E - 2 – Province 201km à 600km', 2000.00, 200.00, 50.00);
INSERT INTO ZONECLIENT (ID, VAL, DESCE, FORFAIT, PRIXCARTON, MINCARTON) VALUES ('Z007', 'ZONE E - 3 – Province +600km', 'ZONE E - 3 – Province +600km', 2000.00, 300.00, 50.00);


create or replace view CLIENTLIB_ACTIF as
SELECT
    c.ID,c.NOM,c.TELEPHONE,c.MAIL,c.ADRESSE,c.REMARQUE,c.COMPTE,c.IDNATIONALITE,c.COMPTEAUXILIAIRE,c.IDTYPECLIENT,
    t.val AS idTypeClientLib,
    c.codeclient,c.datecarte,c.taxe,c.idprovince,c.echeance,c.telfixe,c.nif,c.stat,c.carte,p.val AS provincelib,
    c.idzoneclient, zc.val as idzoneclientlib,
    c.IDMODEPAIEMENT, mp.val as idModePaiementLib,
    c.cin,
    c.DELAI,
    tf.val AS idtarificationlib,
    zc.forfait
FROM CLIENT c
         LEFT JOIN typeclient t
                   ON c.idTypeClient = t.id
         LEFT JOIN province p ON c.idprovince=p.id
         LEFT JOIN ZONECLIENT zc on c.idzoneclient = zc.ID
         LEFT JOIN MODEPAIEMENT mp on c.idModePaiement = mp.id
         LEFT JOIN tarification tf ON tf.id=c.idtarification where c.ESTACTIF>0;
