-- migration socobis -> savonnerie


CREATE
OR REPLACE VIEW
"TIERSENSEMBLE"
("ID",
"NOM",
"NIF",
"STAT",
"ADRESSE",
"CONTACT",
"CODEPOSTAL",
"COMPTE",
"IDTYPEFOURNISSEUR",
"COMPTEAUXILIAIRE",
"ESTACTIF",
"ECHEANCE",
"DEVISE",
"MAIL",
"BANQUE") AS
SELECT f.ID,
       NOM,
       NIF,
       STAT,
       ADRESSE,
       CONTACT,
       CODEPOSTAL,
       COMPTE,
       IDTYPEFOURNISSEUR,
       COMPTEAUXILIAIRE,
       ESTACTIF,
       '' AS ECHEANCE,
       '' AS DEVISE,
       '' AS MAIL,
       '' AS BANQUE
FROM FOURNISSEUR f
UNION ALL
SELECT c.ID,
       c.NOM,
       c.NIF,
       c.STAT,
       c.ADRESSE,
       c.mail         AS contact,
       ''             AS codepostal,
       c.COMPTE,
       c.IDTYPECLIENT AS idTypefournisseur,
       c.COMPTEAUXILIAIRE,
       c.ESTACTIF,
       ''             AS ECHEANCE,
       'AR'           AS devise,
       c.MAIL,
       ''             AS banque
FROM CLIENT c;

CREATE
OR REPLACE
VIEW "COMPTA_SOUSECRITURE_LIB"
("ID",
"NUMERO",
"COMPTE",
"JOURNAL",
"IDJOURNAL",
"ECRITURE",
"DATY",
"CREDIT",
"DEBIT",
"DATECOMPTABLE",
"EXERCICE",
"REMARQUE",
"ETAT",
"IDMERE",
"HORSEXERCICE",
"OD",
"ORIGINE",
"TIERS",
"LIBELLEPIECE",
"COMPTE_AUX",
"RAISONSOCIAL",
"FOLIO",
"LETTRAGE",
"ANALYTIQUE",
"COMPTEAUXILIAIRE",
"COMPTE_AUXLIB",
"IDOBJET") AS
SELECT sousecr.id,
       cpt.LIBELLE              AS numero,
       cpt.COMPTE,
       jrn.val                  AS journal,
       jrn.id                   AS idjournal,
       sousecr.REMARQUE         AS ecriture,
       sousecr.DATY,
       sousecr.CREDIT,
       sousecr.DEBIT,
       sousecr.DATY             AS DATECOMPTABLE,
       sousecr.EXERCICE,
       sousecr.REMARQUE,
       sousecr.ETAT,
       sousecr.idmere,
       CAST(0 AS NUMBER)        AS HORSEXERCICE,
       CAST('-' AS varchar(50)) AS OD,
       CE.ORIGINE               AS ORIGINE,
       CAST('' AS varchar2(50)) AS tiers,
       sousecr.LIBELLEPIECE,
       sousecr.COMPTE_AUX,
       CAST('' AS varchar(100)) AS RAISONSOCIAL,
       sousecr.folio,
       sousecr.LETTRAGE,
       sousecr.ANALYTIQUE,
       te.COMPTEAUXILIAIRE      AS compteauxiliaire,
       te.NOM                   AS compte_auxlib,
       ce.IDOBJET               AS idobjet-- nanampy colonne id objet ftsn
FROM COMPTA_SOUS_ECRITURE sousecr
         JOIN COMPTA_COMPTE cpt ON
    sousecr.COMPTE = cpt.COMPTE
         JOIN COMPTA_JOURNAL jrn ON
    sousecr.JOURNAL = jrn.ID
         LEFT JOIN tiersensemble te ON
    sousecr.COMPTE_AUX = te.id
         LEFT JOIN COMPTA_ECRITURE CE ON
    CE.ID = sousecr.idMERE;

INSERT INTO COMPTA_COMPTE (ID, COMPTE, LIBELLE, TYPECOMPTE, CLASSY, ANALYTIQUE_OBLI, IDJOURNAL, CODEIMPOT)
VALUES ('COMGEN0002', '401000', 'FOURNISSEUR', '1', '4', NULL, 'COMP000035', NULL);
INSERT INTO COMPTA_COMPTE (ID, COMPTE, LIBELLE, TYPECOMPTE, CLASSY, ANALYTIQUE_OBLI, IDJOURNAL, CODEIMPOT)
VALUES ('COMGEN0001', '411000', 'CLIENT', '1', '4', NULL, 'COMP000044', NULL);

UPDATE CLIENT
SET compte = '411000'
WHERE 1 < 2;
UPDATE FOURNISSEUR
SET compte = '401000'
WHERE 1 < 2;
