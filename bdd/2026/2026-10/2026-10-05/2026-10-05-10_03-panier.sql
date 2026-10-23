INSERT INTO ROLES (IDROLE, DESCROLE, RANG) VALUES ('com', 'Commercial', 4);

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
    c.PAYEUR,
    c.image
FROM CLIENT c
    LEFT JOIN typeclient t ON c.idTypeClient = t.id
    LEFT JOIN province p ON c.idprovince=p.id
    LEFT JOIN ZONECLIENT zc on c.idzoneclient = zc.ID
    LEFT JOIN MODEPAIEMENT mp on c.idModePaiement = mp.id
    LEFT JOIN tarification tf ON tf.id=c.idtarification;

INSERT INTO USERHOMEPAGE (ID, CODESERVICE, CODEDIR, IDROLE, URLPAGE) VALUES ('UP000001', 'com', null, 'com', 'mobile/client-liste.jsp');
INSERT INTO UTILISATEUR (REFUSER, LOGINUSER, PWDUSER, NOMUSER, ADRUSER, TELUSER, IDROLE, IDSERVICE, IDDEPARTEMENT) VALUES (1925, 'commercial', '8kiian8e6h', 'Commercial', 'DIR42', null, 'com', '62', null);
INSERT INTO PARAMCRYPT (ID, NIVEAU, CROISSANTE, IDUTILISATEUR) VALUES ('CRYCOM001893', 4, 1, '1925');
INSERT INTO CNAPS_USER (ID, CODE_DR, USER_INIT, AGENT_MO, AGENT_DISPONIBLE, USERNAME, CODE_SERVICE, ID_UTILISATEUR) VALUES ('CNPCOM000213', 'DIR00001', '1', '1', '1', 'Commercial', '1', '1925');


select GETSEQUTILISATEUR() from dual;
INSERT INTO PARAMCONSTANTESOCOBIS (ID, VAL, DESCE) VALUES ('PRZ0001', 'com', 'com');

CREATE TABLE PANIER (
    id varchar(255) PRIMARY KEY,
    idProduit VARCHAR(255),
    pu NUMBER(30,2),
    qte NUMBER(30,2),
    idUnite VARCHAR(255),
    idClient varchar(255),
    etat number,
    FOREIGN KEY (idClient) REFERENCES CLIENT(id),
    FOREIGN KEY (idProduit) REFERENCES AS_INGREDIENTS(id)
);

CREATE SEQUENCE SEQ_PANIER INCREMENT BY 1 MINVALUE 1 MAXVALUE 999999999999999999999999999 NOCYCLE CACHE 20 NOORDER ;

CREATE OR REPLACE FUNCTION GETSEQPANIER
    RETURN NUMBER IS
    retour NUMBER;
BEGIN
    SELECT SEQ_PANIER.nextval INTO retour FROM dual;
    return retour;
END;

create or replace view CLIENTLIBPANIER as
SELECT
    c.ID,c.NOM,c.TELEPHONE,c.MAIL,c.ADRESSE,c.REMARQUE,c.COMPTE,c.IDNATIONALITE,c.COMPTEAUXILIAIRE,c.IDTYPECLIENT,
    C.idTypeClientLib,
    c.codeclient,c.datecarte,c.taxe,c.idprovince,c.echeance,c.telfixe,c.nif,c.stat,c.carte,c.provincelib,
    c.idzoneclient, c.idzoneclientlib,
    c.IDMODEPAIEMENT, c.idModePaiementLib,
    c.cin,
    c.DELAI,
    c.idtarificationlib,
    c.PAYEUR,
    c.image,
    (SELECT COUNT(*) FROM PANIER p WHERE p.idClient = c.ID AND p.etat = 1) AS qtePanier
FROM CLIENTLIB c;

create or replace view PANIERLIB as
select
    p.ID,
    p.IDCLIENT,
    p.QTE,
    p.IDPRODUIT,
    p.ETAT,
    c.NOM as idClientLib,
    ai.LIBELLE as idProduitLib,
    p.pu,
    u.VAL as idUniteLib,
    p.idUnite
from panier p
left join client c on c.id = p.idClient
left join AS_INGREDIENTS ai on ai.id = p.IDPRODUIT
LEFT JOIN AS_UNITE u ON u.id = p.idUnite;
