alter table MOUVEMENTCAISSE add heure VARCHAR2(10);

alter table REPORTCAISSE add heure VARCHAR2(10);

ALTER TABLE MOUVEMENTCAISSE ADD acquereur varchar(255);

CREATE TABLE TYPEPAIEMENT
(
    ID      VARCHAR2(250) NOT NULL PRIMARY KEY,
    VAL     VARCHAR2(500),
    DESCE   VARCHAR2(2000)
);

INSERT INTO TYPEPAIEMENT (ID, VAL, DESCE) VALUES('TYPEAVC001', 'Paiement d''une avance', 'Paiement d''une avance');
INSERT INTO TYPEPAIEMENT (ID, VAL, DESCE) VALUES('TYPEHS001', 'Paiement d''une heure supplémentaire', 'Paiement d''une heure supplémentaire');


ALTER TABLE MOUVEMENTCAISSE
ADD IDTYPEPAIEMENT VARCHAR2(250) REFERENCES TYPEPAIEMENT(ID);

create or replace view REPORTCAISSEAVECHEURE as
select r.ID,
       IDCAISSE,
       MONTANT,
       MONTANTTHEORIQUE,
       TO_DATE(TO_CHAR(DATY, 'YYYY-MM-DD') || ' ' || NVL(HEURE, '00:00:00'), 'YYYY-MM-DD HH24:MI:SS') as DATY,
       ETAT,
       REMARQUE,
       HEURE
from REPORTCAISSE r;

alter table MOUVEMENTCAISSE add idReport VARCHAR2(50) ;

create or replace view MOUVEMENTCAISSEAVECHEURE as
SELECT
    m.ID,
    m.DESIGNATION,
    m.IDCAISSE,
    m.IDVENTEDETAIL,
    m.IDVIREMENT,
    CASE
        WHEN m.HEURE IS NOT NULL AND m.HEURE != '00:00:00'
        THEN m.DATY + (TO_NUMBER(SUBSTR(m.HEURE, 1, 2)) / 24)
                   + (TO_NUMBER(SUBSTR(m.HEURE, 4, 2)) / 1440)
                   + (TO_NUMBER(SUBSTR(m.HEURE, 7, 2)) / 86400)
        ELSE m.DATY
    END AS DATY,
    m.ETAT,
    m.IDOP,
    m.IDORIGINE,
    m.IDDEVISE,
    m.IDTIERS,
    m.COMPTE,
    m.IDPREVISION,
    m.IDTRAITE,
    m.ETATVERSEMENT,
    m.IDMODEPAIEMENT,
    m.IDMVTCAISSEMERE,
    m.REFERENCE,
    m.UPDATED_AT,
    m.DATYCOMPTABILISATION,
    m.ACQUEREUR,
    m.IDTYPEPAIEMENT,
    m.DEBIT,
    m.CREDIT,
    m.TAUX,
    m.HEURE,
    m.idReport
FROM MOUVEMENTCAISSE m;

create or replace view V_ETATCAISSE as
WITH MAX_INVENTAIRE AS (
    -- Etape 1 : On extrait la date maximale valide et la quantite par COUPLE produit/magasin
    SELECT REP.IDCAISSE,
           MAX(REP.DATY)                                             AS MAX_DATY,
           MAX(REP.MONTANT) KEEP (DENSE_RANK LAST ORDER BY REP.DATY) AS MONTANT_MAX_DATY
    FROM REPORTCAISSEAVECHEURE REP
    WHERE REP.ETAT >= 11 --and rep.DATY<=TO_DATE('27/07/2026','DD-MM-YYYY')
    GROUP BY REP.IDCAISSE),
     TAUXCHANGEMAX
         AS (SELECT MAX(TAU.TAUX) KEEP (DENSE_RANK LAST ORDER BY TAU.DATY) AS TAUX,
                    TAU.IDDEVISE                                           AS TAUXIDDEVISE,
                    MAX(TAU.DATY)                                          AS TAUXDATY
             FROM TAUXDECHANGE TAU
             GROUP BY IDDEVISE),
     SOMME_PRECALC AS (SELECT C.ID                              AS IDCAISSE,
                              C.VAL                             AS IDCAISSELIB,
                              NVL(SUM(CASE
                                          WHEN MFF.DATY > NVL(INV.MAX_DATY, DATE '2025-01-01') THEN MFF.CREDIT
                                          ELSE 0 END), 0)       AS CREDIT,

                              NVL(SUM(CASE
                                          WHEN MFF.DATY > NVL(INV.MAX_DATY, DATE '2025-01-01') THEN MFF.DEBIT
                                          ELSE 0 END), 0)       AS DEBIT,
                              MAX(INV.MAX_DATY)                 AS DATEDERNIERREPORT,
                              NVL(MAX(INV.MONTANT_MAX_DATY), 0) AS MONTANTDERNIERREPORT,
                              C.IDPOINT,
                              P.VAL                             AS IDPOINTLIB,
                              C.IDTYPECAISSE,
                              TYP.VAL                           AS IDTYPECAISSELIB,
                              C.IDDEVISE,
                              MAX(TAU.TAUX)                     AS TAUX
                       FROM CAISSE C
                                LEFT JOIN MOUVEMENTCAISSEAVECHEURE MFF
                                          ON MFF.IDCAISSE = C.ID AND MFF.ETAT >= 11 AND MFF.IDREPORT IS NOT NULL-- and mff.DATY<=TO_DATE('27/07/2026','DD-MM-YYYY')
                                JOIN MAX_INVENTAIRE INV ON INV.IDCAISSE = C.ID
                                LEFT JOIN TAUXCHANGEMAX TAU ON TAU.TAUXIDDEVISE = C.IDDEVISE
                                LEFT JOIN POINT P ON P.ID = C.IDPOINT
                                LEFT JOIN TYPECAISSE TYP ON TYP.ID = C.IDTYPECAISSE
                       GROUP BY C.ID, C.IDPOINT, P.VAL, C.IDTYPECAISSE, TYP.VAL, C.VAL, C.IDDEVISE)
-- Selection finale
SELECT IDCAISSE,
       IDCAISSELIB || ' (' || NVL(IDDEVISE, 'AR') || ')'                             AS IDCAISSELIB,
       CAST(CREDIT AS NUMBER(30, 2))                                                 AS CREDIT,
       CAST(DEBIT AS NUMBER(30, 2))                                                  AS DEBIT,
       CAST(MONTANTDERNIERREPORT + CREDIT - DEBIT AS NUMBER(30, 2))                  AS RESTE,
       CAST(NVL(TAUX, 1) AS NUMBER(30, 2))                                           AS TAUX,
       CAST((MONTANTDERNIERREPORT + CREDIT - DEBIT) * NVL(TAUX, 1) AS NUMBER(30, 2)) AS RESTEAR,
       DATE '2025-01-01'                                                             AS DATY,
       IDCAISSE                                                                      AS ID,
       DATEDERNIERREPORT,
       CAST(MONTANTDERNIERREPORT AS NUMBER(30, 2))                                   AS MONTANTDERNIERREPORT,
       IDPOINT,
       IDPOINTLIB,
       IDTYPECAISSE,
       IDTYPECAISSELIB,
       (IDCAISSELIB || ' | ' || IDPOINTLIB || ' | ' || IDTYPECAISSELIB || ' | ' || DATEDERNIERREPORT) AS MOTSCLESSS
FROM SOMME_PRECALC;

create or replace view MOUVEMENTCAISSEAUTOCOMPLETE as
SELECT
    mc.ID,
    mc.DESIGNATION,
    mc.IDCAISSE,
    mc.IDVENTEDETAIL,
    mc.IDVIREMENT,
    mc.DATY,
    mc.ETAT,
    mc.IDOP,
    mc.IDORIGINE,
    mc.IDDEVISE,
    CASE
        WHEN mc.IDTIERS IS NOT NULL
            THEN mc.IDTIERS||'---'||c.nom
        END AS IDTIERS,
    mc.COMPTE,
    CASE
        WHEN mc.IDPREVISION IS NOT NULL
            THEN mc.IDPREVISION||'---'||p.designation
        END AS IDPREVISION,
    mc.IDTRAITE,
    mc.ETATVERSEMENT,
    mc.IDMODEPAIEMENT,
    mc.IDMVTCAISSEMERE,
    mc.REFERENCE,
    mc.UPDATED_AT,
    mc.DATYCOMPTABILISATION,
    mc.ACQUEREUR,
    mc.IDTYPEPAIEMENT,
    mc.DEBIT,
    mc.CREDIT,
    mc.TAUX,
    mc.HEURE,
    mc.idReport,
    mc.idCaissier,
    mc.montantRetourner
FROM mouvementcaisse mc
     LEFT JOIN CLIENT c ON c.id=mc.IDTIERS
     LEFT JOIN prevision p ON p.id=mc.IDPREVISION;

create OR REPLACE view MOUVEMENTCAISSECPL AS
SELECT m.ID,
       m.DESIGNATION,
       m.IDCAISSE,
       c.VAL   AS IDCAISSELIB,
       m.IDVENTEDETAIL,
       m.IDVIREMENT,
       m.DEBIT,
       m.CREDIT,
       CAST(
               CASE
                   WHEN m.credit > 0 THEN NVL(m.CREDIT, 0) - NVL(l.MONTANT, 0)
                   ELSE 0
                   END AS NUMBER(36,5)
       ) AS soldecredit,
       CAST(
               CASE
                   WHEN m.debit > 0 THEN NVL(m.DEBIT, 0) - NVL(l.MONTANT, 0)
                   ELSE 0
                   END AS NUMBER(36,5)
       ) AS soldedebit,
       m.DATY,
       m.ETAT,
       CASE
           WHEN m.ETAT = 0
               THEN 'ANNULEE'
           WHEN m.ETAT = 1
               THEN 'CREEE'
           WHEN m.ETAT = 11
               THEN 'VALIDEE'
           WHEN m.ETAT = 8
               THEN 'A COMPTABILISER'
           END AS ETATLIB,
       vd.IDVENTE,
       m.IDORIGINE as idorigine,
       m.idtiers,
       t.NOM AS tiers,
       m.idPrevision,
       m.idOP,
       m.taux,
       m.COMPTE,
       m.IDDEVISE,
       m.idtraite,
       mp.VAL as idModePaiementLib,
       m.idmvtcaissemere,
       m.reference,
       m.datycomptabilisation,
       m.UPDATED_AT, m.heure,
       m.IDREPORT,
       m.ID || '' || m.DATY || '' || m.DESIGNATION || '' || t.NOM || '' || m.IDCAISSE || '' || c.VAL AS MOTSCLESS,
       cr.id as idecriture
FROM MOUVEMENTCAISSE m
         LEFT JOIN CAISSE c ON c.ID = m.IDCAISSE
         LEFT JOIN VENTE_DETAILS vd ON vd.ID = m.IDVENTEDETAIL
         LEFT JOIN tiers t ON t.ID = m.idtiers
         left join liaisonpaiementmvtcaissegrp l on l.idmvtcaisse=m.id
         left join modepaiement mp on m.idmodepaiement = mp.id
         LEFT JOIN COMPTA_ECRITURE cr on cr.IDOBJET=m.id;


create or replace view V_LIAISONPAIEMENT_FACTUREFOURN as
SELECT
    lp.ID ,
    lp.ID1 ,
    lp.ID2,
    lp.MONTANT ,
    lp.ETAT ,
    f.ID AS IDFACTUREFOURNISSEUR,
    f.IDFOURNISSEUR,
    f.IDMODEPAIEMENT,
    f.DATY,
    f.DESIGNATION,
    f.ETAT AS ETATFACTURE,
    f.REFERENCE,
    f.IDBC,
    f.DEVISE,
    f.TAUX,
    f.IDMAGASIN,
    f.NUMERO,
    f.TYPEACHAT,
    f.DATEECHEANCEPAIEMENT
FROM LIAISONPAIEMENT lp
JOIN FACTUREFOURNISSEUR f
    ON f.ID = lp.ID2
WHERE lp.ID2 LIKE 'FCF%';

create or replace view V_LIAISONPAIEMENT_VENTE as
SELECT
    lp.ID ,
    lp.ID1 ,
    lp.ID2,
    lp.MONTANT,
    lp.ETAT,

    v.ID AS IDVENTE,
    v.DESIGNATION,
    v.IDMAGASIN,
    v.DATY,
    v.REMARQUE,
    v.ETAT AS ETATVENTE,
    v.IDCLIENT,
    v.MODEPAIEMENT,
    v.IDMODEPAIEMENT,
    v.NUMEROFACTURE,
    v.REFERENCEFACT,
    v.REMISE,
    v.REMISEMONTANT,
    v.ECHEANCEFACTURE
FROM LIAISONPAIEMENT lp
JOIN VENTE v
    ON v.ID = lp.ID2
WHERE lp.ID2 LIKE 'VNT%';

create or replace view VIREMENTINTRACAISSECPL as
SELECT
    v.ID ,
    v.DESIGNATION ,
    v.IDCAISSEDEPART ,
    c.VAL AS IDCAISSEDEPARTLIB ,
    v.IDCAISSEARRIVE ,
    c2.VAL AS IDCAISSEARRIVELIB,
    CAST(v.MONTANT AS NUMBER(30,5)) AS MONTANT   ,
    v.DATY ,
    v.ETAT ,
    CASE
        WHEN v.ETAT = 0
            THEN 'ANNUL&Eacute;'
        WHEN v.ETAT = 1
            THEN 'CR&Eacute;&Eacute;'
        WHEN v.ETAT = 11
            THEN  'VIS&Eacute;'
        END AS ETATLIB
FROM VIREMENTINTRACAISSE v
         LEFT JOIN CAISSE c ON c.ID = v.IDCAISSEDEPART
         LEFT JOIN CAISSE c2 ON c2.ID  = v.IDCAISSEARRIVE;


ALTER TABLE COMPTA_JOURNAL ADD COMPTE VARCHAR(255);

create or replace view REPORTCAISSELIB as
SELECT
r.ID ,
r.IDCAISSE ,
c.VAL AS IDCAISSELIB,
CAST(r.MONTANT AS NUMBER(30,5)) AS MONTANT ,
CAST(r.MONTANTTHEORIQUE AS NUMBER(30,5)) AS MONTANTTHEORIQUE ,
r.DATY ,
r.ETAT ,r.heure,
CASE
	WHEN r.ETAT = 0
	THEN 'ANNULEE'
	WHEN r.ETAT = 1
	THEN 'CREE'
	WHEN r.ETAT = 11
	THEN 'VALIDEE'
END AS ETATLIB
FROM REPORTCAISSE r
LEFT JOIN CAISSE c ON c.ID  = r.IDCAISSE;


create or replace view CAISSECPL as
SELECT SQ.ID,SQ.VAL,SQ.DESCE,SQ.IDTYPECAISSE,SQ.IDTYPECAISSELIB,SQ.IDPOINT,SQ.IDPOINTLIB,SQ.IDPOMPISTE,SQ.ETAT,SQ.COMPTE,SQ.ETATLIB,SQ.IDCATEGORIECAISSE,SQ.IDCATEGORIECAISSELIB,SQ.IDMAGASIN,SQ.IDMAGASINLIB,
	       (NVL(TO_CHAR(ID),'') || ' | ' || NVL(TO_CHAR(VAL),'') || ' | ' || NVL(TO_CHAR(DESCE),'') || ' | ' || NVL(TO_CHAR(IDTYPECAISSE),'') || ' | ' || NVL(TO_CHAR(IDTYPECAISSELIB),'') || ' | ' || NVL(TO_CHAR(IDPOINT),'') || ' | ' || NVL(TO_CHAR(IDPOINTLIB),'') || ' | ' || NVL(TO_CHAR(IDPOMPISTE),'') || ' | ' || NVL(TO_CHAR(ETAT),'') || ' | ' || NVL(TO_CHAR(COMPTE),'') || ' | ' || NVL(TO_CHAR(ETATLIB),'') || ' | ' || NVL(TO_CHAR(IDCATEGORIECAISSE),'') || ' | ' || NVL(TO_CHAR(IDCATEGORIECAISSELIB),'') || ' | ' || NVL(TO_CHAR(IDMAGASIN),'') || ' | ' || NVL(TO_CHAR(IDMAGASINLIB),'')) AS MOTSCLESSS
FROM (
         SELECT c.ID,
                c.VAL,
                c.DESCE,
                c.IDTYPECAISSE,
                t.VAL   AS IDTYPECAISSELIB,
                c.IDPOINT,
                p.VAL   AS IDPOINTLIB,
                c.IDPOMPISTE,
                c.ETAT,
                cop.LIBELLE||'('||cop.COMPTE||')' as compte ,
                CASE
                    WHEN c.ETAT = 0
                        THEN 'ANNUL&Eacute;'
                    WHEN c.ETAT = 1
                        THEN 'CR&Eacute;&Eacute;'
                    WHEN c.ETAT = 11
                        THEN 'VIS&Eacute;'
                    END AS ETATLIB,
                c.idCategorieCaisse,
                c2.VAL  AS idCategorieCaisseLib,
                c.IDMAGASIN ,
                m.val AS idMagasinLib
         FROM CAISSE c
                  LEFT JOIN TYPECAISSE t ON t.ID = c.IDTYPECAISSE
                  LEFT JOIN POINT p ON p.ID = c.IDPOINT
                  LEFT JOIN CATEGORIECAISSE c2 ON c2.ID = c.idCategorieCaisse
                  LEFT JOIN COMPTA_COMPTE cop ON cop.COMPTE = c.COMPTE
                  LEFT JOIN MAGASIN2 m ON m.ID =c.IDMAGASIN


     ) SQ;



create table PARAMCOMPTA
(
    ID        VARCHAR2(100) not null
        constraint PARAMCOMPTA_PK
            primary key,
    VAL       VARCHAR2(100),
    DESCE     VARCHAR2(100)
);
insert into PARAMCOMPTA values('PARAM001','Perte de stock','671400');
insert into PARAMCOMPTA values('PARAM002','Gain de stock','771400');
insert into PARAMCOMPTA values('PARAMPERTE1','Perte sur report de caisse','671800');
insert into PARAMCOMPTA values('PARAMGAIN2','Gain sur report de caisse','771800');

insert into COMPTA_COMPTE values('COMCSOCSTOCK01','671400','perte sur stock',1,6,null,'COMP000067',null);
insert into COMPTA_COMPTE values('COMCSOCSTOCK02','771400','gain sur stock',1,6,null,'COMP000039',null);
insert into COMPTA_COMPTE values('COMCSOCPERTECAISSE01','671800','perte sur report de caisse',1,6,null,'COMP000067',null);
insert into COMPTA_COMPTE values('COMCSOCGAINCAISSE02','771800','gain sur report de caisse',1,6,null,'COMP000039',null);