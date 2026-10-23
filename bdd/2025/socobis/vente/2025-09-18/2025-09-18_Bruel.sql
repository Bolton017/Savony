
create table TYPE_PIECE
(
    ID    VARCHAR2(100) not null
        constraint TYPE_PIECE_PK
            primary key,
    VAL   VARCHAR2(100),
    DESCE VARCHAR2(100)
)
/

INSERT INTO TYPE_PIECE (ID, VAL, DESCE) VALUES ('TP01', 'Traite', 'Traite');
INSERT INTO TYPE_PIECE (ID, VAL, DESCE) VALUES ('TP02', 'Chèque', 'Chèque');


create table TRAITE
(
    ID                  VARCHAR2(100) not null
        constraint TRAITE_PK
            primary key,
    DATY                DATE,
    TIERS               VARCHAR2(100),
    BANQUE              VARCHAR2(100),
    DATEECHEANCE        DATE,
    REFERENCE           VARCHAR2(100),
    ETAT                NUMBER,
    MONTANT             NUMBER(30, 2),
    IDTYPEPIECE         VARCHAR2(100),
    IDFINALEDESTINATION VARCHAR2(100),
    NUMCHEQUE           VARCHAR2(100),
    NUMPIECE            VARCHAR2(100)
)
/

-- auto-generated definition
create sequence seq_traite
/


create FUNCTION getseqtraite
    RETURN NUMBER
    IS
    retour   NUMBER;
BEGIN
    SELECT seq_traite.NEXTVAL INTO retour FROM DUAL;

    RETURN retour;
END;
/

create table BANQUE
(
    ID    VARCHAR2(100) not null
        constraint PK_BANQUE
            primary key,
    VAL   VARCHAR2(500),
    DESCE VARCHAR2(500)
)
/

INSERT INTO BANQUE (ID, VAL, DESCE) VALUES ('BQ001A', 'MCB', 'MCB');
INSERT INTO BANQUE (ID, VAL, DESCE) VALUES ('BQU00007', 'BAOBAB', 'BAOBAB');
INSERT INTO BANQUE (ID, VAL, DESCE) VALUES ('BANQ0000000050163234', 'BNI', 'BNI');
INSERT INTO BANQUE (ID, VAL, DESCE) VALUES ('BANQ0000000070150316', 'BNI', null);
INSERT INTO BANQUE (ID, VAL, DESCE) VALUES ('BANQ000030', 'TRESOR', 'TRESORERIE GENERALE DE MADAGASCAR');
INSERT INTO BANQUE (ID, VAL, DESCE) VALUES ('BANQ000000', '-', '-');
INSERT INTO BANQUE (ID, VAL, DESCE) VALUES ('BQU00001', 'BMOI', 'BMOI');
INSERT INTO BANQUE (ID, VAL, DESCE) VALUES ('BQU00002', 'BRED', 'BRED');
INSERT INTO BANQUE (ID, VAL, DESCE) VALUES ('BQU00003', 'SBM', 'SBM');
INSERT INTO BANQUE (ID, VAL, DESCE) VALUES ('BQU00004', 'BGFI', 'BGFI');
INSERT INTO BANQUE (ID, VAL, DESCE) VALUES ('BQU00005', 'BNI', 'BNI');
INSERT INTO BANQUE (ID, VAL, DESCE) VALUES ('BQU00006', 'BOA', 'BOA');
INSERT INTO BANQUE (ID, VAL, DESCE) VALUES ('BQ001', 'BMM', 'BMM');
INSERT INTO BANQUE (ID, VAL, DESCE) VALUES ('BQU00008', 'SIPEM', 'SIPEM');
INSERT INTO BANQUE (ID, VAL, DESCE) VALUES ('BQU00009', 'AFG BANK', 'AFG BANK');


create table ESCOMPTE
(
    ID       VARCHAR2(100) not null
        constraint ESCOMPTE_PK
            primary key,
    IDTRAITE VARCHAR2(100),
    FRAIS    NUMBER,
    ETAT     NUMBER,
    DATY     DATE
)
/
-- Sequenece mila bataina
create sequence seq_escompte
/


create FUNCTION getseqescompte
    RETURN NUMBER
    IS
    retour   NUMBER;
BEGIN
    SELECT seq_escompte.NEXTVAL INTO retour FROM DUAL;

    RETURN retour;
END;
/

create view ESCOMPTE_LIBV as
SELECT ID,IDTRAITE,FRAIS,ETAT,DATY FROM ESCOMPTE el WHERE etat=11
/

create view TRAITE_LIB as
select
    tr.id,
    tr.daty,
    ti.nom as tiers,
    ba.val as banque,
    tr.dateEcheance,
    tr.etat,
    tr.montant,
    tr.REFERENCE,
    '' as CDCLT,
    ba.ID AS idbanque,
    IDTYPEPIECE ,
    tp.val AS typepiece
from traite tr
         left join client ti on tr.tiers = ti.id
         left join banque ba on tr.banque = ba.id
         LEFT JOIN type_piece tp ON tp.id=tr.IDTYPEPIECE
/



create view TRAITE_LIBMTT as
select t.ID,t.DATY,t.TIERS,t.BANQUE,t.DATEECHEANCE,t.ETAT,t.MONTANT,
       sum(nvl(e.FRAIS,0)) AS escompte,
       montant - sum(nvl(e.FRAIS, 0)) AS total, t.reference,
       t.CDCLT,
       t.idbanque,
       t.idtypepiece,
       t.typepiece
from traite_lib t
         LEFT JOIN ESCOMPTE_LIBV e ON e.IDTRAITE = t.id
GROUP BY t.id, t.DATY ,t.TIERS ,t.BANQUE ,t.DATEECHEANCE ,t.ETAT ,t.MONTANT,t.REFERENCE, t.CDCLT, t.idbanque,t.idtypepiece,
         t.typepiece
/

alter table MOUVEMENTCAISSE add idtraite varchar2(100) references TRAITE;
alter table MOUVEMENTCAISSE add etatversement number(2);

create view TRAITEMTTFC as
SELECT
    t.ID,
    cast(nvl(sum(f.CREDIT),0) as number(30,2)) AS montantenlevetraite
FROM traite t
         LEFT JOIN MOUVEMENTCAISSE f ON t.ID = f.IDTRAITE
WHERE f.ETATVERSEMENT = 0
GROUP BY t.ID
/

create table MVTINTRACAISSE
(
    ID                  VARCHAR2(100) not null
        constraint MVTINTRACAISSE_PK
            primary key,
    DATY                DATE,
    CAISSEDEPART        VARCHAR2(100),
    CAISSEARRIVEE       VARCHAR2(100),
    MONTANT             NUMBER(20, 2),
    MODEPAIEMENT        VARCHAR2(100),
    REMARQUE            VARCHAR2(4000),
    ETAT                NUMBER(10),
    DESIGNATION         VARCHAR2(500),
    IDTRAITE            VARCHAR2(100),
    ETATVERSEMENT       NUMBER,
    IDFINALEDESTINATION VARCHAR2(100)
)
/
-- sequence bataina
create sequence seq_mvtinstracaisse
/


create FUNCTION getseqmvtintracaisse
    RETURN NUMBER
    IS
    retour   NUMBER;
BEGIN
    SELECT seq_mvtinstracaisse.NEXTVAL INTO retour FROM DUAL;

    RETURN retour;
END;
/

create view TRAITEETATVERSEMENT as
select IDTRAITE, cast(-2 as number) as etatversement
from MVTINTRACAISSE
where IDTRAITE is not null
  and ETATVERSEMENT = -2
group by IDTRAITE
UNION ALL
select idtraite, cast(11 as number) as etatversement
from MVTINTRACAISSE
where idtraite is not null
  and ETATVERSEMENT = 11
  and IDTRAITE not in
      (select IDTRAITE from MVTINTRACAISSE where IDTRAITE is not null and ETATVERSEMENT = -2 group by IDTRAITE)
group by idtraite
/



create view TRAITEMTTRESTE as
SELECT t.ID,
       t.DATY,
       t.TIERS,
       t.BANQUE,
       t.DATEECHEANCE,
       t.ETAT,
       CAST(nvl(t.MONTANT,0) AS NUMBER(30, 2))                          AS montant,
       t.ESCOMPTE,
       CAST(nvl(t.TOTAL,0) AS NUMBER(30, 2))                            AS total,
       t.REFERENCE,
       CAST((nvl(t.total,0) - nvl(tf.montantenlevetraite, 0)) AS NUMBER(30, 2)) AS montantreste,
       t.cdclt,
       t.idbanque,
       t.idtypepiece,
       t.typepiece,
       nvl(te.etatversement, 1)                                  as etatversement,
       case
           when te.etatversement = -2 then 'Encaissee'
           when te.etatversement = 11 then 'Versee'
           else
               'Non Versee' end                                  as etatversementlib
FROM TRAITE_LIBMTT t
         LEFT JOIN traitemttfc tf ON tf.id = t.id
         LEFT JOIN traiteetatversement te on te.IDTRAITE = t.ID
/


--module.jsp?but=
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES ('MDO0000056', 'Traite', 'fa fa-list-alt', '#', 16, 2, 'MNDN000000001');
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES ('MENTRA001', 'Transfert Multiple', 'fa fa-list', 'module.jsp?but=facture/visa-traite-multiple.jsp', 3, 3, 'MDO0000056');
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES ('MEN000692', 'Reçu', 'fa fa-money', 'module.jsp?but=facture/traite-recu-liste.jsp', 5, 3, 'MDO0000056');
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES ('MEN000690', 'Saisie', 'fa fa-plus', 'module.jsp?but=facture/traite-saisie.jsp', 1, 3, 'MDO0000056');
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES ('MEN000691', 'Liste', 'fa fa-list', 'module.jsp?but=facture/traite-liste.jsp', 2, 3, 'MDO0000056');
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES ('MENTRA002', 'En attente Avis Credit', 'fa fa-list', 'module.jsp?but=facture/traite-encaissement-versee-liste.jsp', 4, 3, 'MDO0000056');

create view TRAITE_FC as
select
    fc.ID,tl.id AS IDTRAITE,fc.id AS IDFC, FC.MONTANTTTC as MONTANTFACTURE, j.CREDIT as MONTANTJC, pf.MONTANT,fc.DATY,fc.ETAT,'' as CODE,
    tl.tiers,
    tl.banque,
    fc.designation as factureclientlib,
    fc.IDCLIENTLIB as TIERSLIB,
    CASE
        WHEN j.etat = 1
            THEN 'Créé'
        WHEN j.ETAT >= 11
            THEN 'visée'
        WHEN j.ETAT =0
            THEN 'Annulée'
        END AS etatlib
from LIAISONPAIEMENT pf
         LEFT JOIN MOUVEMENTCAISSE j ON j.ID  = pf.id2
         JOIN traite tl on tl.id = j.idtraite
         left join VENTE_CPL fc on pf.id1  = fc.id

/

create view MONTANT_TRAITE_FC as
select
    ID,IDTRAITE,
    sum(montant) AS montanttraite
from TRAITE_FC
GROUP BY ID,IDTRAITE
/


create view TRAITE_FCSUM (ID, FACTURECLIENTLIB, TIERSLIB, DATY, MONTANTFACTURE, ETATLIB, IDTRAITE, MONTANTTRAITE) as
SELECT
    t.id,
    t.factureclientlib,
    t.tierslib,
    t.daty,
    cast(t.montantfacture as number(30,2)),
    t.etatLib,
    t.idTraite,
    cast(m.montanttraite as number(30,2))
FROM TRAITE_FC t
         LEFT JOIN montant_traite_fc m ON m.id=t.id AND m.idtraite=t.IDTRAITE
/

create view TRAITE_LIBC as
SELECT ID,DATY,TIERS,BANQUE,DATEECHEANCE,ETAT,MONTANT, etatversement, etatversementlib,MONTANTRESTE,reference  from TRAITEMTTRESTE where etat = 1
/

create view TRAITE_LIBV as
select ID,DATY,TIERS,BANQUE,DATEECHEANCE,ETAT,MONTANT, etatversement, etatversementlib,MONTANTRESTE,reference from TRAITEMTTRESTE where etat = 11
/

create view TRAITE_LIBESC as
select ID,DATY,TIERS,BANQUE,DATEECHEANCE,ETAT,MONTANT, etatversement, etatversementlib,MONTANTRESTE,reference from TRAITEMTTRESTE where id in (select idtraite from escompte where etat = 11)
/

create view TRAITE_LIBVER as
select ID,DATY,TIERS,BANQUE,DATEECHEANCE,ETAT,MONTANT, etatversement, etatversementlib,MONTANTRESTE,reference from TRAITEMTTRESTE where etatversement= 11
/

create view TRAITE_LIBNONENC as
select ID,DATY,TIERS,BANQUE,DATEECHEANCE,ETAT,MONTANT, etatversement, etatversementlib,MONTANTRESTE,reference from TRAITEMTTRESTE where etatversement= 11
/

create view TRAITE_LIBENC as
select ID,DATY,TIERS,BANQUE,DATEECHEANCE,ETAT,MONTANT, etatversement, etatversementlib,MONTANTRESTE, reference from TRAITEMTTRESTE where etatversement = -2
/

INSERT INTO CATEGORIECAISSE (ID, VAL, DESCE, IDTYPECAISSE) VALUES ('CTC009', 'Traite', 'Traite', 'TCA001');
INSERT INTO CAISSE (ID, VAL, DESCE, IDTYPECAISSE, IDPOINT, IDPOMPISTE, ETAT, IDCATEGORIECAISSE, COMPTE, IDMAGASIN, IDDEVISE) VALUES ('CAIS000017', 'EFFETS A RECEVOIR REMIS A L ENCAISSEMENT', 'EFFETS A RECEVOIR REMIS A L ENCAISSEMENT', 'TCA004', null, null, 11, 'CTC009', '5300000000000', null, 'AR');
INSERT INTO CAISSE (ID, VAL, DESCE, IDTYPECAISSE, IDPOINT, IDPOMPISTE, ETAT, IDCATEGORIECAISSE, COMPTE, IDMAGASIN, IDDEVISE) VALUES ('CAIS00000T00016', 'TRAITE', 'TRAITE', 'TCA004', null, null, 11, 'CTC009', '5300000000000', null, 'AR');

UPDATE REPORTCAISSE SET IDCAISSE = 'CAI000234', MONTANT = 0.00, MONTANTTHEORIQUE = 0.00, DATY = DATE '2024-07-17', ETAT = 11, REMARQUE = null WHERE ID = 'REC000255';
UPDATE REPORTCAISSE SET IDCAISSE = 'CAI000236', MONTANT = 0.00, MONTANTTHEORIQUE = 0.00, DATY = DATE '2024-07-17', ETAT = 11, REMARQUE = null WHERE ID = 'REC000258';
UPDATE REPORTCAISSE SET IDCAISSE = 'CAI000235', MONTANT = 0.00, MONTANTTHEORIQUE = 0.00, DATY = DATE '2024-07-17', ETAT = 11, REMARQUE = null WHERE ID = 'REC000256';
UPDATE REPORTCAISSE SET IDCAISSE = 'CAI000237', MONTANT = 0.00, MONTANTTHEORIQUE = 0.00, DATY = DATE '2024-07-17', ETAT = 11, REMARQUE = null WHERE ID = 'REC000257';
UPDATE REPORTCAISSE SET IDCAISSE = 'CAI000236', MONTANT = 0.00, MONTANTTHEORIQUE = 0.00, DATY = DATE '2024-07-01', ETAT = 11, REMARQUE = null WHERE ID = 'REC000259';
UPDATE REPORTCAISSE SET IDCAISSE = 'CAI000229', MONTANT = 0.00, MONTANTTHEORIQUE = 0.00, DATY = DATE '2024-07-01', ETAT = 11, REMARQUE = null WHERE ID = 'REC000260';

INSERT INTO REPORTCAISSE (ID, IDCAISSE, MONTANT, MONTANTTHEORIQUE, DATY, ETAT, REMARQUE) VALUES ('RPRC0001', 'CAIS000017', 0.00, 0.00, DATE '2025-01-01', 11, null);
INSERT INTO REPORTCAISSE (ID, IDCAISSE, MONTANT, MONTANTTHEORIQUE, DATY, ETAT, REMARQUE) VALUES ('RPRC0002', 'CAIS00000T00016', 0.00, 0.00, DATE '2025-01-01', 11, null);

select * from V_ETATCAISSE_devise_AR;

create view V_ETATCAISSE as
SELECT r.ID,
       r.IDCAISSE,
       c.val    AS                                                idcaisseLib,
       c.idtypecaisse,
       tc.desce AS                                                idtypecaisselib,
       c.idpoint,
       p.desce  AS                                                idpointlib,
       r.DATY                                                     dateDernierReport,
       NVL(r.MONTANT, 0)                                          montantDernierReport,
       NVL(mvt.debit, 0)                                          debit,
       NVL(mvt.credit, 0)                                         credit,
       NVL(mvt.credit, 0) + NVL(r.MONTANT, 0) - NVL(mvt.debit, 0) reste
FROM REPORTCAISSE r,
     (
         SELECT r.IDCAISSE,
                MAX(r.DATY) maxDateReport
         FROM REPORTCAISSE r
         WHERE r.ETAT = 11
           AND r.DATY <= SYSDATE
         GROUP BY r.IDCAISSE
     ) rm,
     (
         SELECT m.IDCAISSE,
                SUM(nvl(m.DEBIT, 0))  DEBIT,
                SUM(nvl(m.CREDIT, 0)) CREDIT
         FROM MOUVEMENTCAISSE_VISE m,
              (
                  SELECT r.IDCAISSE,
                         MAX(r.DATY) maxDateReport
                  FROM REPORTCAISSE r
                  WHERE r.ETAT = 11
                    AND r.DATY <= SYSDATE
                  GROUP BY r.IDCAISSE
              ) rm
         WHERE m.IDCAISSE = rm.idcaisse(+)
           AND m.DATY > rm.maxDateReport
           AND m.DATY <= SYSDATE
         GROUP BY m.IDCAISSE
     ) mvt,
     caisse c,
     typecaisse tc,
     point p
WHERE r.DATY = rm.maxDateReport
  AND r.IDCAISSE = rm.IDCAISSE
  AND r.IDCAISSE = c.ID(+)
  AND r.IDCAISSE = mvt.idcaisse(+)
  AND c.IDTYPECAISSE = tc.ID(+)
  AND c.IDPOINT = p.ID
/

create or replace view MOUVEMENTCAISSE_VISE as
select ID,DESIGNATION,IDCAISSE,IDVENTEDETAIL,IDVIREMENT,DEBIT,CREDIT,DATY,ETAT,IDOP,IDORIGINE,IDDEVISE,TAUX,IDTIERS,COMPTE,IDPREVISION from MOUVEMENTCAISSE
WHERE ETAT=11
/

UPDATE TAUXDECHANGE SET IDDEVISE = 'AR', TAUX = 1.00, DATY = DATE '2025-03-24' WHERE ID = 'TX000095';

create or replace view MOUVEMENTCAISSECPL as
SELECT m.ID,
       m.DESIGNATION,
       m.IDCAISSE,
       c.VAL   AS IDCAISSELIB,
       m.IDVENTEDETAIL,
       m.IDVIREMENT,
       m.DEBIT,
       m.CREDIT,
       m.DATY,
       m.ETAT,
       CASE
           WHEN m.ETAT = 0
               THEN 'ANNULEE'
           WHEN m.ETAT = 1
               THEN 'CREE'
           WHEN m.ETAT = 11
               THEN 'VALIDEE'
           END AS ETATLIB,
       vd.IDVENTE,
       case when l.id2 is null then m.IDORIGINE else l.ID2 end as idorigine,
       m.idtiers,
       t.NOM AS tiers,
       m.idPrevision,
       m.idOP,
       m.taux,
       m.COMPTE,
       m.IDDEVISE,
       m.idtraite
FROM MOUVEMENTCAISSE m
         LEFT JOIN CAISSE c ON c.ID = m.IDCAISSE
         LEFT JOIN VENTE_DETAILS vd ON vd.ID = m.IDVENTEDETAIL
         LEFT JOIN tiers t ON t.ID = m.idtiers
         left join LiaisonPaiement l on l.id1=m.id
/

create or replace view TRAITE_JC as
select
    jc.id,fc.ID AS idtraite,fc.MONTANT,fc.DATY,fc.ETAT,jc.id AS IDJC,
    jc.daty as datesaisie,
    jc.daty as DATEEFFET,
    '' as FOLIO,
    jc.IDCAISSE as caisse,
    '' as NUMPIECE,
    jc.DESIGNATION as libelle ,
    jc.DEBIT,
    jc.CREDIT,
    jc.DESIGNATION as REMARQUE,
    jc.ETAT AS etatjc,
    jc.IDTIERS as TIERS,
    '' as IDTYPECHEQUE,
    jc.DESIGNATION,
    '' as IDORDRE,
    jc.IDDEVISE,
    '' as IDMODE,
    '' as NUMCHEQUE,
    '' as TYPEMVT,
    '' as IDPLACEMENT,
    fc.BANQUE as IDBANQUE,
    '' as IDPLACEMENTVRAI,
    jc.ETATVERSEMENT,
    case
        when jc.etat = 1 then 'CREEE'
        when jc.etat >= 11 then 'VISEE'
        else '' end                           as etatlib,
    case
        when jc.etatversement = -2 then 'Encaissee'
        when jc.etatversement = 11 then 'Versee'
        else '' end                           as etatversementlib,
    c.VAL AS valcaisse
from MOUVEMENTCAISSE jc
         join traite fc on fc.id = jc.IDTRAITE
         LEFT JOIN caisse c ON c.id = jc.IDCAISSE
/

create table MVTINTRACAISSE_FILLE
(
    ID        VARCHAR2(100) not null
        constraint MVTINTRACAISSE_FILLE_PK
            primary key,
    IDMERE    VARCHAR2(100),
    REFERENCE VARCHAR2(100),
    REMARQUE  VARCHAR2(500)
)
/

