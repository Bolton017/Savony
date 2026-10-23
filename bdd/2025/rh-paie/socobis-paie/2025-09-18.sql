-- PAIEMENT HEURE SUP
create or replace view HEURESUPFABRICATION_CPL as
SELECT
    h.ID,h.IDRESSPARFAB,h.HEURENORMALE ,h.HS,h.MN,h.JF,h.HD,h.IF,h.ETAT,h.REMARQUE,
    p.id AS  idPersonne,
    h.idFabrication,
    fab.daty as dateFabrication,
    CASE
        WHEN h.etat=0
            THEN 'ANNULEE'
        WHEN h.etat=1
            THEN 'CREE'
        WHEN h.etat=11
            THEN 'VISEE'
        END AS etatlib,
    pm.NOM || ' ' || pm.PRENOM AS idPersonnelib,
    p.MATRICULE,
    r.TAUXHORAIRE,
    CAST(nvl(c.montant,0)/((40*52)/12) AS NUMBER(30,2) ) AS TAUXHORAIREEFFECTIVE,
    p.temporaire,
    h.MONTANT,
    h.MONTANTJFHD
FROM HEURESUPFABRICATION h
         LEFT JOIN RESSOURCEPARFABRICATIONCOMPLET r ON r.id = h.IDRESSPARFAB
         LEFT JOIN PAIE_INFO_PERSONNEL p ON p.id = r.idRessource
         LEFT JOIN CATEGORIE_QUALIFICATION c
                   ON c.IDQUALIFICATION = r.IDQUALIFICATION
                       AND (
                          (c.REMARQUE IS NULL)
                              OR (c.REMARQUE = r.IDRESSOURCE)
                          )
         LEFT JOIN LOG_PERSONNEL pm ON pm.id = r.IDRESSOURCE
         LEFT JOIN FABRICATION fab ON fab.ID = h.IDFABRICATION;


CREATE OR REPLACE VIEW RESSOURCEPARFABRICATIONCOMPLET AS
SELECT
    r.id,
    r.idFabrication,
    r.idPoste AS idPosteDefaut,
    r.idRessource,
    p.matricule,
    f.IDOF,
    r.etat,
    p.TEMPORAIRE,
    p.IDQUALIFICATION AS IdQualification,
    c.IDCATEGORIE,
    c.idPoste,
    po.VAL AS idPostelib,
    p.IDQUALIFICATION AS IdQualificationEffective,
    CAST(c.montant / ((40 * 52) / 12) AS NUMBER(30,2)) AS tauxhoraire,
    h.HS,
    h.MN,
    h.JF,
    h.HD,
    h.IF,
    CASE
        WHEN r.etat = 0  THEN 'ANNULEE'
        WHEN r.etat = 1  THEN 'CREE'
        WHEN r.etat = 11 THEN 'VISEE'
        END AS etatlib,
    p.MATRICULE AS idRessourcelib
FROM ressourceParFabrication r
         LEFT JOIN PAIE_INFO_PERSONNEL p
                   ON p.id = r.idRessource
         LEFT JOIN CATEGORIE_QUALIFICATION c
                   ON c.IDQUALIFICATION = r.IDQUALIFICATION
                       AND (
                          (c.REMARQUE IS NULL)
                              OR (c.REMARQUE = r.IDRESSOURCE)
                          )
         LEFT JOIN FABRICATION f
                   ON f.id = r.idFabrication
         LEFT JOIN heureSupFabrication h
                   ON h.idRessParFab = r.id
         LEFT JOIN POSTE po
                   ON po.id = c.idPoste;



CREATE OR REPLACE VIEW SOMME_HEURENORMAL_PERS as
SELECT
    pip.ID AS idPersonnel,
    hv.ID AS idHeureSupVisee,
    hv.IDRESSPARFAB,
    hv.IDFABRICATION,
    hv.IDPERSONNELIB,
    f.DATY AS dateFabrication,
    COALESCE(SUM(hs.HEURENORMALE), 0) AS heureNormale
FROM PAIE_INFO_PERSONNEL pip
         LEFT JOIN HEURESUPFABRICATION_CPL_VISEE hv
                   ON hv.IDPERSONNE = pip.ID
         LEFT JOIN HEURESUPFABRICATION hs
                   ON hs.ID = hv.ID
         LEFT JOIN FABRICATION f
                   ON f.ID = hv.IDFABRICATION
-- WHERE f.DATY BETWEEN :dateDebut AND :dateFin
                       OR f.DATY IS NULL -- keep personnel with no fabrication
GROUP BY
    pip.ID,
    hv.ID, hv.IDRESSPARFAB, hv.IDFABRICATION, hv.IDPERSONNELIB, f.DATY;




CREATE OR REPLACE FORCE VIEW "V_HEURESUP_A_PAYER" ("ID", "IDFABRICATION", "IDHS", "NOMPERSONNEL", "MATRICULE", "MONTANTDU", "MONTANTPAYE", "MONTANT") AS
SELECT
    v.id,
    v.IDFABRICATION,
    v.idHs,
    v.nomPersonnel,
    v.matricule,
    v.montantjfhd AS montantdu,
    COALESCE(SUM(m.debit), 0) AS montantpaye,
    (v.montantjfhd - COALESCE(SUM(m.debit), 0)) AS montant --montant reste a payer
FROM V_PAIEMENT_HEURESUP v
         LEFT JOIN PAIEMENTHEURESUP p
                   ON v.idHs = p.IDHS
         LEFT JOIN MOUVEMENTCAISSE m
                   ON p.ID = m.IDORIGINE
GROUP BY v.id, v.IDFABRICATION, v.idHs, v.nomPersonnel, v.matricule, v.montantjfhd
HAVING (v.montantjfhd - COALESCE(SUM(m.debit), 0)) > 0;


CREATE SEQUENCE seqpaiemenths
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;


CREATE OR REPLACE FUNCTION getseqpaiemenths
    RETURN NUMBER
    IS
    retour   NUMBER;
BEGIN
SELECT seqpaiemenths.NEXTVAL INTO retour FROM DUAL;
RETURN retour;
END;

-- DROP TABLE PAIEMENTHEURESUP;

CREATE TABLE PAIEMENTHEURESUP
(	 ID VARCHAR2(100) NOT NULL ENABLE,
      IDMVTCAISSE VARCHAR2(100),
      IDHS VARCHAR2(100),
      IDFABRICATION VARCHAR2(100),
      MONTANT NUMBER(30,2),
      DATY DATE,
      ETAT NUMBER(*,0)
) ;

CREATE OR REPLACE VIEW "V_PAIEMENT_HEURESUP" ("ID", "IDHS", "IDFABRICATION", "ETATLIB", "NOMPERSONNEL", "MATRICULE", "MONTANT", "MONTANTJFHD") AS
SELECT
    "IDPERSONNE" as id, "ID" AS idHs,"IDFABRICATION","ETATLIB","IDPERSONNELIB" as nomPersonnel, "MATRICULE","MONTANT", "MONTANTJFHD"
FROM HEURESUPFABRICATION_CPL_VISEE WHERE MONTANTJFHD > 0;
