UPDATE PARAMCONSTANTESOCOBIS
SET ID='PRMS526', VAL='5', DESCE='VALIDERCHEFDEP'
WHERE ROWID='AAFb8kAARAACwT9ACz';

UPDATE PARAMCONSTANTESOCOBIS
SET ID='PRMS557', VAL='2', DESCE='VALIDERACHAPPROV'
WHERE ROWID='AAFb8kAARAACwT+AAQ';

INSERT INTO PARAMCONSTANTESOCOBIS
(ID, VAL, DESCE)
VALUES('PRMS570', '7', 'VALIDERCHEFDEPCIBLE');

CREATE OR REPLACE VIEW "DMDACHATLIB" AS 
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
            THEN 'VIS&Eacute;E par Initiateur'
        WHEN da.ETAT = 5
            THEN 'VIS&Eacute;E par Chef de D&eacute;partement'
        WHEN da.ETAT = 6
            THEN 'VIS&Eacute;E par Direction Source'
        WHEN da.ETAT = 7
            THEN 'VIS&Eacute;E par Chef de D&eacute;partement'
        WHEN da.ETAT = 11
            THEN 'VIS&Eacute;E'
        END AS etatlib,
    da.idObjet,
    da.service,
    s.libelle AS servicelib,
    p.val AS idPrioriteLib,
    da.idPriorite,
    da.DESTINATAIRE,
    sc.LIBELLE as destinataireLib
FROM DMDACHAT da
         LEFT JOIN FOURNISSEUR f ON f.ID = da.fournisseur
         LEFT JOIN MAGASIN2 m ON da.idMagasin = m.ID
         LEFT JOIN categorieIngredient ci ON da.idCategorie = ci.id
         LEFT JOIN service s ON s.compte = da.SERVICE
         LEFT JOIN service sc ON sc.compte = da.DESTINATAIRE
         LEFT JOIN PRIORITEDMDACHAT p ON p.id = da.idPriorite
 
 ;

update PARAMCONSTANTESOCOBIS set id = 'PRMS000537' where VAL = 'FAR' and DESCE = 'FAR';
update PARAMCONSTANTESOCOBIS set id = 'PRMS000494' where id = 'PRMS494' and val = 'TPF0001';
