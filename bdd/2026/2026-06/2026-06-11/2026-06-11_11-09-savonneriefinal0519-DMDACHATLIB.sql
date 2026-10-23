ALTER TABLE dmdAchat
ADD service VARCHAR(255);

ALTER TABLE DMDACHAT
ADD echeance NUMBER;

ALTER TABLE DMDACHAT
ADD dateEcheance DATE;

create or replace view DMDACHATLIB as
SELECT
    da.id,
    da.daty,
    da.fournisseur,
    f.nom AS fournisseurlib,
    da.remarque,
    da.dateLimite,
    m.val AS idMagasinLib,
    ci.val AS idCategorieLib,
    da.etat,
    CASE
        WHEN da.ETAT = 0
            THEN 'ANNUL&Eacute;E'
        WHEN da.ETAT = 1
            THEN 'CR&Eacute;&Eacute;E'
        WHEN da.ETAT = 2
            THEN 'VIS&Eacute;E par Chef de D&eacute;partement'
        WHEN da.ETAT = 11
            THEN 'VIS&Eacute;E par Directeur'
        WHEN da.ETAT = 3
            THEN 'VIS&Eacute;E par DMT'
        WHEN da.ETAT = 4
            THEN 'VIS&Eacute;E par CI'
        WHEN da.ETAT = 9
            THEN 'VIS&Eacute;E par CG'
        END AS etatlib,
    da.idObjet
FROM DMDACHAT da
    LEFT JOIN FOURNISSEUR f ON f.ID = da.fournisseur
    LEFT JOIN MAGASIN2 m ON da.idMagasin = m.ID
    LEFT JOIN categorieIngredient ci ON da.idCategorie = ci.id;

INSERT INTO ROLES (IDROLE, DESCROLE, RANG) VALUES ('chef_dep', 'Chef de département', 6);
INSERT INTO UTILISATEUR (REFUSER, LOGINUSER, PWDUSER, NOMUSER, ADRUSER, TELUSER, IDROLE, IDSERVICE) VALUES (880748, 'chefdep', '8dab9al', 'chefdep', 'DIR42', null, 'chef_dep', '62');
INSERT INTO PARAMCRYPT (ID, NIVEAU, CROISSANTE, IDUTILISATEUR) VALUES ('CRY001894', 4, 1, '880748');
INSERT INTO CNAPS_USER (ID, CODE_DR, USER_INIT, AGENT_MO, AGENT_DISPONIBLE, USERNAME, CODE_SERVICE, ID_UTILISATEUR) VALUES ('CNP000214', 'DIR00001', '1', '1', '1', 'chefdep', '1', '880748');

DELETE FROM notification2;