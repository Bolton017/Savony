
create table Tarification(
    id varchar(255) primary key not null,
    val varchar(255) ,
    desce varchar(255)
);

create sequence seqTarification
    minvalue 1
    maxvalue 999999999999
    start with 1
    increment by 1
    cache 20;

CREATE OR REPLACE FUNCTION getseqTarification
   RETURN NUMBER
IS
   retour   NUMBER;
BEGIN
SELECT seqTarification.NEXTVAL INTO retour FROM DUAL;
RETURN retour;
END;

ALTER TABLE client ADD idtarification varchar(255);
ALTER table client ADD FOREIGN key(idtarification) REFERENCES tarification(id);

CREATE OR REPLACE  VIEW CLIENTLIB ("ID", "NOM", "TELEPHONE", "MAIL", "ADRESSE", "REMARQUE", "COMPTE", "IDNATIONALITE", "COMPTEAUXILIAIRE", "IDTYPECLIENT", "IDTYPECLIENTLIB", "CODECLIENT", "DATECARTE", "TAXE", "IDPROVINCE", "ECHEANCE", "TELFIXE", "NIF", "STAT", "CARTE", "PROVINCELIB", "IDZONECLIENT", "IDZONECLIENTLIB", "IDMODEPAIEMENT", "IDMODEPAIEMENTLIB", "CIN", "DELAI","IDTARIFICATIONLIB") AS
SELECT
    c.ID,c.NOM,c.TELEPHONE,c.MAIL,c.ADRESSE,c.REMARQUE,c.COMPTE,c.IDNATIONALITE,c.COMPTEAUXILIAIRE,c.IDTYPECLIENT,
    t.val AS idTypeClientLib,
    c.codeclient,c.datecarte,c.taxe,c.idprovince,c.echeance,c.telfixe,c.nif,c.stat,c.carte,p.val AS provincelib,
    c.idzoneclient, zc.val as idzoneclientlib,
    c.IDMODEPAIEMENT, mp.val as idModePaiementLib,
    c.cin,
    c.DELAI,
    tf.val AS idtarificationlib
FROM CLIENT c
         LEFT JOIN typeclient t
                   ON c.idTypeClient = t.id
         LEFT JOIN province p ON c.idprovince=p.id
         LEFT JOIN ZONECLIENT zc on c.idzoneclient = zc.ID
         LEFT JOIN MODEPAIEMENT mp on c.idModePaiement = mp.id
         LEFT JOIN tarification tf ON tf.id=c.idtarification;