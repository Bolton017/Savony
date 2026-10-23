CREATE TABLE PRIORITEDMDACHAT (
    id varchar(255) primary key,
    val varchar(255),
    desce varchar(255)
);

CREATE SEQUENCE SEQ_PRIORITEDMDACHAT INCREMENT BY 1 MINVALUE 1 MAXVALUE 999999999999999999999999999 NOCYCLE CACHE 20 NOORDER ;

CREATE OR REPLACE FUNCTION GETSEQPRIORITEDMDACHAT
    RETURN NUMBER IS
    retour NUMBER;
BEGIN
SELECT SEQ_PRIORITEDMDACHAT.nextval INTO retour FROM dual;
return retour;
END;

INSERT INTO PRIORITEDMDACHAT (ID, VAL, DESCE) VALUES ('P000001', 'Immédiate', 'Immédiate');
INSERT INTO PRIORITEDMDACHAT (ID, VAL, DESCE) VALUES ('P000002', 'Urgent', 'Urgent');
INSERT INTO PRIORITEDMDACHAT (ID, VAL, DESCE) VALUES ('P000003', 'Normal', 'Normal');

ALTER TABLE DMDACHAT
ADD idPriorite VARCHAR(255);

UPDATE DMDACHAT SET idPriorite = 'P000003';

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
            THEN 'VIS&Eacute; par PDG'
        WHEN da.ETAT = 3
            THEN 'VIS&Eacute;  par direction'
        WHEN da.ETAT = 4
            THEN 'VIS&Eacute;E par CI'
        WHEN da.ETAT = 9
            THEN 'VIS&Eacute;E par CG'
        END AS etatlib,
    da.idObjet,
    da.service,
    s.libelle AS servicelib,
    p.val AS idPrioriteLib,
    da.idPriorite
FROM DMDACHAT da
    LEFT JOIN FOURNISSEUR f ON f.ID = da.fournisseur
    LEFT JOIN MAGASIN2 m ON da.idMagasin = m.ID
    LEFT JOIN categorieIngredient ci ON da.idCategorie = ci.id
    LEFT JOIN service s ON s.compte = da.SERVICE
    LEFT JOIN PRIORITEDMDACHAT p ON p.id = da.idPriorite;
