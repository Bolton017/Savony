CREATE OR REPLACE  VIEW V_ETATCAISSE_CLOTURE ("ID", "IDCAISSE", "IDCAISSELIB", "IDTYPECAISSE", "IDTYPECAISSELIB", "IDPOINT", "IDPOINTLIB", "DATEDERNIERREPORT", "MONTANTDERNIERREPORT", "DEBIT", "CREDIT", "RESTE", "DEVISE") AS
    SELECT
        r.ID,
        r.IDCAISSE,
        c.val AS idcaisseLib,
        c.idtypecaisse,
        tc.desce AS idtypecaisselib,
        c.idpoint,
        p.desce AS idpointlib,
        r.DATY AS dateDernierReport,
        CAST(NVL(((r.MONTANT + NVL(mvtAv.CREDIT - mvtAv.DEBIT, 0)) * taux.taux), 0) AS NUMBER(30,2)) AS montantDernierReport,
        CAST(NVL(mvt.debit, 0) AS NUMBER(30,2)) AS debit,
        CAST(NVL(mvt.credit, 0) AS NUMBER(30,2)) AS credit,
        CAST((NVL(mvt.credit, 0) - NVL(mvt.debit, 0)) AS NUMBER(30,2)) AS reste,
        'AR' AS devise
    FROM REPORTCAISSE_deVISE r,
         (
             SELECT  r.IDCAISSE,
                     MAX(r.DATY) AS maxDateReport
             FROM REPORTCAISSE_deVISE r
             WHERE r.ETAT = 11
               AND r.DATY <= TRUNC(SYSDATE)
             GROUP BY r.IDCAISSE
         ) rm,
         (
             SELECT  m.IDCAISSE,
                     SUM(NVL((m.DEBIT * t.taux),0)) AS DEBIT,
                     SUM(NVL((m.CREDIT * t.taux),0)) AS CREDIT
             FROM MOUVEMENTCAISSE_VISE m,
                  (
                      SELECT  r.IDCAISSE,
                              MAX(r.DATY) AS maxDateReport
                      FROM REPORTCAISSE r
                      WHERE r.ETAT = 11
                        AND r.DATY <= TRUNC(SYSDATE)
                      GROUP BY r.IDCAISSE
                  ) rm,
                  (
                      SELECT ta.*
                      FROM TAUXDECHANGE ta,
                           (
                               SELECT MAX(daty) AS daty, iddevise
                               FROM TAUXDECHANGE t
                               WHERE daty <= TRUNC(SYSDATE)
                               GROUP BY iddevise
                           ) tmax
                      WHERE ta.daty = tmax.daty
                        AND ta.iddevise = tmax.iddevise
                  ) t
             WHERE m.IDDEVISE = t.iddevise(+)
               AND m.IDCAISSE = rm.idcaisse(+)
               AND m.DATY >= TRUNC(SYSDATE)
               AND m.DATY <= TRUNC(SYSDATE)
             GROUP BY m.IDCAISSE
         ) mvt,
         (
             SELECT  m.IDCAISSE,
                     SUM(NVL((m.DEBIT * t.taux),0)) AS DEBIT,
                     SUM(NVL((m.CREDIT * t.taux),0)) AS CREDIT
             FROM MOUVEMENTCAISSE_VISE m,
                  (
                      SELECT  r.IDCAISSE,
                              MAX(r.DATY) AS maxDateReport
                      FROM REPORTCAISSE r
                      WHERE r.ETAT = 11
                        AND r.DATY <= TRUNC(SYSDATE)
                      GROUP BY r.IDCAISSE
                  ) rm,
                  (
                      SELECT ta.*
                      FROM TAUXDECHANGE ta,
                           (
                               SELECT MAX(daty) AS daty, iddevise
                               FROM TAUXDECHANGE t
                               WHERE daty <=TRUNC(SYSDATE)
                               GROUP BY iddevise
                           ) tmax
                      WHERE ta.daty = tmax.daty
                        AND ta.iddevise = tmax.iddevise
                  ) t
             WHERE m.IDDEVISE = t.iddevise(+)
               AND m.IDCAISSE = rm.idcaisse(+)
               AND m.DATY >= maxDateReport
               AND m.DATY < TRUNC(SYSDATE)
             GROUP BY m.IDCAISSE
         ) mvtAv,
         (
             SELECT ta.*
             FROM TAUXDECHANGE ta,
                  (
                      SELECT MAX(daty) AS daty, iddevise
                      FROM TAUXDECHANGE t
                      WHERE daty <= TRUNC(SYSDATE)
                      GROUP BY iddevise
                  ) tmax
             WHERE ta.daty = tmax.daty
               AND ta.iddevise = tmax.iddevise
         ) taux,
         CAISSE c,
         TYPECAISSE tc,
         POINT p
    WHERE r.DATY = rm.maxDateReport
      AND r.IDDEVISE = taux.iddevise(+)
      AND r.ETAT = 11
      AND r.IDCAISSE = rm.IDCAISSE
      AND r.IDCAISSE = c.ID(+)
      AND r.IDCAISSE = mvt.idcaisse(+)
      AND r.IDCAISSE = mvtAv.idcaisse(+)
      AND c.IDTYPECAISSE = tc.ID(+)
      AND c.IDPOINT = p.ID;

CREATE OR REPLACE  VIEW MONTANTCAISSE ("CAISSELIB", "IDCAISSE", "MONTANTTHEORIQUE", "MONTANT", "DATEDERNIERREPORT", "EXPLICATION", "IDCLOTURE") AS
    SELECT
        etatcaisse.idcaisseLib AS caisselib,
        etatcaisse.idcaisse,
        CAST(ROUND(etatcaisse.reste, 0) AS NUMBER(30,0)) AS montantTheorique,
        0 AS montant,
        etatcaisse.dateDernierReport AS dateDernierReport,
        '' AS explication,
        '' AS idcloture
    FROM V_ETATCAISSE_CLOTURE etatcaisse
    WHERE TRUNC(etatcaisse.dateDernierReport) <= TRUNC(SYSDATE);


CREATE TABLE CLOTURECAISSE (
   id VARCHAR2(100) PRIMARY KEY,
   daty DATE,
   remarque VARCHAR2(100),
   etat NUMBER
);

CREATE TABLE CLOTURECAISSEFILLE (
    id VARCHAR2(100) PRIMARY KEY,
    idCloture VARCHAR2(100),
    idCaisse VARCHAR2(100),
    explication VARCHAR2(255),
    montant NUMBER(10, 2),
    montantTheorique NUMBER(10, 2),
    CONSTRAINT fk_cloture FOREIGN KEY (idCloture)
        REFERENCES CLOTURECAISSE(id)
);


CREATE SEQUENCE  seq_cloture_caisse INCREMENT BY 1 MINVALUE 1 MAXVALUE 999999999999 NOCYCLE CACHE 20 NOORDER ;

CREATE OR REPLACE FUNCTION getseqcloturecaisse
 RETURN NUMBER
IS
  retour NUMBER;
BEGIN
SELECT seq_cloture_caisse.NEXTVAL into retour from dual;
RETURN retour;
END;

CREATE SEQUENCE  seq_cloture_caisse_fille INCREMENT BY 1 MINVALUE 1 MAXVALUE 999999999999 NOCYCLE CACHE 20 NOORDER ;

CREATE OR REPLACE FUNCTION getseqcloturecaissefille
 RETURN NUMBER
IS
  retour NUMBER;
BEGIN
SELECT seq_cloture_caisse_fille.NEXTVAL into retour from dual;
RETURN retour;
END;


ALTER TABLE CLOTURECAISSE ADD idPoint VARCHAR(100);

ALTER TABLE CLOTURECAISSE ADD idCaisse VARCHAR(100);
ALTER TABLE CLOTURECAISSE ADD montanttheorique NUMBER(10,2);
ALTER TABLE CLOTURECAISSE ADD montant NUMBER(10, 2);
ALTER TABLE CLOTURECAISSE ADD explication VARCHAR(100);
alter table cloturecaisse add iduser varchar(255);
alter table CLOTURECAISSEFILLE add idbilletage varchar(255);

CREATE OR REPLACE  VIEW CLOTURECAISSE_CPL ("ID", "DATY", "REMARQUE", "ETAT", "IDPOINT", "IDPOINTLIB", "ETATLIB") AS
    SELECT
        cc.ID,cc.DATY,cc.REMARQUE,cc.ETAT,cc.IDPOINT,
        p.val AS idpointlib,
        CASE
            WHEN cc.etat = 1 THEN 'CR&Eacute;&Eacute;E'
            WHEN cc.etat >= 11 THEN 'VIS&Eacute;E'
            ELSE 'AUTRE' end as etatLib
    FROM CLOTURECAISSE cc
             LEFT JOIN POINT p ON cc.idPoint = p.id;

CREATE OR REPLACE  VIEW CLOTURECAISSEFILLE_CPL ("ID", "IDCLOTURE", "IDCAISSE", "EXPLICATION", "MONTANT", "MONTANTTHEORIQUE", "CAISSELIB", "ECART") AS
    SELECT
        cc."ID",cc."IDCLOTURE",cc."IDCAISSE",cc."EXPLICATION",cc."MONTANT",cc."MONTANTTHEORIQUE",
        c.desce AS caisselib,
        cc.montanttheorique - cc.montant AS ecart
    FROM CLOTURECAISSEFILLE cc
             LEFT JOIN CAISSE c ON cc.idCaisse = c.id;


CREATE OR REPLACE VIEW CLOTURECAISSE_CREE AS
    SELECT * FROM CLOTURECAISSE_CPL WHERE etat = 1;

CREATE OR REPLACE VIEW CLOTURECAISSE_VISEE AS
    SELECT * FROM CLOTURECAISSE_CPL WHERE etat = 11;

ALTER TABLE MOUVEMENTCAISSE ADD idCaissier VARCHAR(255);
alter table mouvementCaisse add montantRetourner number(10, 2);
ALTER TABLE MOUVEMENTCAISSE ADD idUser VARCHAR(255);

INSERT INTO AS_INGREDIENTS
(ID, LIBELLE, SEUIL, UNITE, QUANTITEPARPACK, PU, ACTIF, PHOTO, CALORIE, DURRE, COMPOSE, CATEGORIEINGREDIENT, IDFOURNISSEUR, DATY, QTELIMITE, PV, LIBELLEVENTE, SEUILMIN, SEUILMAX, PUACHATUSD, PUACHATEURO, PUACHATAUTREDEVISE, PUVENTEUSD, PUVENTEEURO, PUVENTEAUTREDEVISE, ISVENTE, ISACHAT, COMPTE_VENTE, COMPTE_ACHAT, LIBELLEEXTACTE, TVA, FILEPATH, RESTE, TYPESTOCK, REFPOST, REFQUALIFICATION, IDCHAMBRE, ISPERISHABLE, PV2, IDFAMILLE, IDMAGASIN, PARFUMS, IDTYPEPRODUIT, COMPTE_TVA, ATELIER, PVGROS, COULEUR, TAILLE, CODEBARRE, REFERENCE, CODEGROS, POINTURE, IDCOULEUR, COMPTE_RISTOURNE, IDMODELE)
VALUES('APP', 'APPOINT', 0, 'UNT005042', 0, 0, 0, NULL, 0, NULL, 1, NULL, 'non', TIMESTAMP '2025-07-22 00:00:00.000000', 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, NULL, '72004', '62004', NULL, 20, NULL, 5945, 'FIFO', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
