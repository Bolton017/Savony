CREATE TABLE CA_ANNEE_ANTERIEUR
(	ANNEE VARCHAR2(100),
     MOIS VARCHAR2(100),
     MONTANT NUMBER(38,2)
);

CREATE OR REPLACE VIEW CA_ANNEE_VIEW AS
  WITH deja AS (
  SELECT
    SUM(montant) AS montant,
    TO_NUMBER(annee) AS annee,
    TO_NUMBER(mois)  AS mois
  FROM ca_annee_anterieur
  GROUP BY TO_NUMBER(annee), TO_NUMBER(mois)
),
recalc AS (
  SELECT
    EXTRACT(YEAR  FROM daty) AS annee,
    EXTRACT(MONTH FROM daty) AS mois,
    SUM(putotal) AS montant
  FROM vente_details_cpl_2_visee
  GROUP BY EXTRACT(YEAR  FROM daty), EXTRACT(MONTH FROM daty)
),
manquants AS (
  SELECT r.montant, r.annee, r.mois
  FROM recalc r
  WHERE NOT EXISTS (
    SELECT 1
    FROM deja d
    WHERE d.annee = r.annee
      AND d.mois  = r.mois
  )
)
SELECT montant, annee, mois FROM deja
UNION ALL
SELECT montant, annee, mois FROM manquants;

CREATE OR REPLACE VIEW CA_ANNEE_MOIS AS
SELECT
    annee,
    SUM(CASE WHEN mois = 1 THEN montant ELSE 0 END) AS janvier,
    SUM(CASE WHEN mois = 2 THEN montant ELSE 0 END) AS fevrier,
    SUM(CASE WHEN mois = 3 THEN montant ELSE 0 END) AS mars,
    SUM(CASE WHEN mois = 4 THEN montant ELSE 0 END) AS avril,
    SUM(CASE WHEN mois = 5 THEN montant ELSE 0 END) AS mai,
    SUM(CASE WHEN mois = 6 THEN montant ELSE 0 END) AS juin,
    SUM(CASE WHEN mois = 7 THEN montant ELSE 0 END) AS juillet,
    SUM(CASE WHEN mois = 8 THEN montant ELSE 0 END) AS aout,
    SUM(CASE WHEN mois = 9 THEN montant ELSE 0 END) AS septembre,
    SUM(CASE WHEN mois = 10 THEN montant ELSE 0 END) AS octobre,
    SUM(CASE WHEN mois = 11 THEN montant ELSE 0 END) AS novembre,
    SUM(CASE WHEN mois = 12 THEN montant ELSE 0 END) AS decembre
FROM CA_ANNEE_VIEW
GROUP BY annee
ORDER BY annee;

CREATE TABLE CA_JOUR
(	ID VARCHAR2(100),
     JOURLIB VARCHAR2(200),
     JOUR NUMBER(*,0),
     MOIS NUMBER(*,0),
     ANNEE NUMBER(*,0),
     DATY DATE,
     MONTANT NUMBER(30,2),
     IDCATEGORIE VARCHAR2(100),
     CONSTRAINT CA_JOUR_PK PRIMARY KEY (ID)
         USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
         STORAGE(INITIAL 196608 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
         PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
         TABLESPACE "USERS"  ENABLE,
     FOREIGN KEY (IDCATEGORIE)
         REFERENCES CATEGORIEINGREDIENT (ID) ENABLE
) SEGMENT CREATION IMMEDIATE
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 655360 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;

CREATE OR REPLACE VIEW CA_MENSUEL AS
  WITH agg AS (
  SELECT
    TRUNC(daty) AS jour,
    SUM(putotal) AS montant
  FROM vente_details_cpl_2_visee
  GROUP BY TRUNC(daty)
),
agg_mois AS (
  SELECT
    EXTRACT(YEAR FROM jour)  AS annee,
    EXTRACT(MONTH FROM jour) AS mois,
    TO_CHAR(jour, 'Month', 'NLS_DATE_LANGUAGE=FRENCH') AS moislib,
    SUM(montant) AS montant
  FROM agg
  GROUP BY
    EXTRACT(YEAR FROM jour),
    EXTRACT(MONTH FROM jour),
    TO_CHAR(jour, 'Month', 'NLS_DATE_LANGUAGE=FRENCH')
)
SELECT ANNEE,MOIS,MOISLIB,MONTANT
FROM agg_mois m
WHERE NOT EXISTS (
    SELECT 1
    FROM ca_jour j
    WHERE EXTRACT(YEAR  FROM j.daty) = m.annee
      AND EXTRACT(MONTH FROM j.daty) = m.mois
);

CREATE OR REPLACE VIEW CA_JOURNALIER AS
  WITH agg AS (
  SELECT
    TRUNC(daty) AS jour,
    SUM(putotal) AS montant
  FROM vente_details_cpl_2_visee
  GROUP BY TRUNC(daty)
)
SELECT
    a.montant,
    EXTRACT(YEAR  FROM a.jour) AS annee,
    EXTRACT(MONTH FROM a.jour) AS mois,
    TO_CHAR(a.jour, 'Month', 'NLS_DATE_LANGUAGE=FRENCH') AS moislib,
    a.jour AS daty
FROM agg a
WHERE NOT EXISTS (
    SELECT 1
    FROM ca_jour j
    WHERE j.daty = a.jour
);

CREATE OR REPLACE VIEW V_JOURS_2016_NOW AS
SELECT
    d AS DATY,
    EXTRACT(DAY FROM d) AS JOUR,
    CEIL((TO_CHAR(d, 'DD') + TO_CHAR(TRUNC(d, 'MM'), 'D') - 1) / 7) as semainemois,
    EXTRACT(MONTH FROM d) AS MOIS,
    EXTRACT(YEAR FROM d) AS ANNEE,
    TO_CHAR(d, 'D') as numerojoursemaine,
    TO_CHAR(d, 'Day', 'NLS_DATE_LANGUAGE=FRENCH') AS JOURLIB
FROM (
         SELECT TO_DATE('2016-12-01', 'YYYY-MM-DD') + LEVEL - 1 AS d
         FROM dual
             CONNECT BY LEVEL <= LAST_DAY(SYSDATE) - TO_DATE('2016-12-01', 'YYYY-MM-DD') + 1
     );
CREATE OR REPLACE VIEW VENTECPLJOUR AS
select v.daty,sum(v.MONTANTTTC) as montant from VENTE_CPL v
group by v.daty;

CREATE TABLE JOURSEMAINE
(	ID VARCHAR2(100),
     NUMSEMAINE NUMBER(2,0),
     NUMJOUR NUMBER(2,0),
     LIBJOUR VARCHAR2(20),
     PRIMARY KEY ("ID")
         USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
         STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
         PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
         TABLESPACE "USERS"  ENABLE
) SEGMENT CREATION IMMEDIATE
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 589824 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;

CREATE OR REPLACE FORCE VIEW CA_JOUR_DETAILS_CA AS
select vj2n.DATY,
       vj2n.JOUR,
       vj2n.semainemois,
       vj2n.MOIS,
       vj2n.ANNEE,
       vj2n.JOURLIB,
       cast(nvl(cj.MONTANT, 0) as number(38, 2)) as montant,
       js.id as idjoursemaine,
       vj2n.numerojoursemaine
from V_JOURS_2016_now vj2n
         left join Ventecpljour cj on cj.DATY = vj2n.DATY
         left join joursemaine js on js.numsemaine = vj2n.semainemois and js.numjour = vj2n.numerojoursemaine;


-- SOCOBISPROD.VENTE_CPL_ANALYSE source

CREATE OR REPLACE VIEW VENTE_CPL_ANALYSE AS
SELECT v.ID,
       v.DESIGNATION,
       v.IDMAGASIN,
       m.VAL   AS IDMAGASINLIB,
       v.DATY,
       v.REMARQUE,
       v.ETAT,
       CASE
           WHEN v.ETAT = 1
               THEN 'CREE'
           WHEN v.ETAT = 11
               THEN 'EN ATTENTE LIVRAISON ET PAIEMENT'
           WHEN v.ETAT = 0
               THEN 'ANNULEE'
           WHEN v.ETAT = 12
               THEN 'LIVRE NON PAYE'
           WHEN v.ETAT = 13
               THEN 'PAYE NON LIVRE'
           WHEN v.ETAT = 14
               THEN 'PAYE ET LIVRE'
           END AS ETATLIB,
       v2.MONTANTTOTAL,
       v2.MONTANTTOTALACHAT,
       p.ID AS IDPOINT,
       p.VAL AS IDPOINTLIB,
       v2.MONTANTTOTAL - v2.MONTANTTOTALACHAT AS MONTANTREVIENT,
       v.IDRESERVATION
FROM VENTE v
         LEFT JOIN MAGASIN m ON m.ID = v.IDMAGASIN
         LEFT JOIN POINT p ON m.IDPOINT = p.ID
         JOIN VENTEMONTANT v2 ON v2.ID = v.ID;

CREATE OR REPLACE VIEW VENTE_CPL_ANALYSEF AS
select vd.ID,
       vd.IDVENTE,
       vd.IDVENTELIB,
       vd.IDPRODUIT,
       ai.libelle as idproduitlib,
       vd.IDORIGINE,
       vd.QTE,
       vd.PU,
       vd.PUTOTAL,
       vd.PUTOTALACHAT,
       vd.PUREVIENT,
       ai.CATEGORIEINGREDIENT,
       cat.val as idCategorieLib,
       vd.IDMAGASIN,
       vd.IDMAGASINLIB,
       vd.IDPOINT,
       vd.IDPOINTLIB,
       vd.IDDEVISE,
       vd.IDDEVISELIB,
       vd.IDRESERVATION,
       v.DATY
from VENTE_DETAILS_CPL_2 vd
         LEFT JOIN VENTE v ON v.ID = vd.IDVENTE
         LEFT JOIN AS_INGREDIENTS ai ON ai.id = vd.IDPRODUIT
         LEFT JOIN CATEGORIEINGREDIENT cat ON cat.id = ai.CATEGORIEINGREDIENT
WHERE v.ETAT >= 11;

CREATE OR REPLACE VIEW VENTE_DETAILS_CPL_2 AS
SELECT vd.ID,
       vd.IDVENTE,
       v.DESIGNATION          AS IDVENTELIB,
       vd.IDPRODUIT,
       p.LIBELLE                  AS IDPRODUITLIB,
       vd.IDORIGINE,
       vd.QTE,
       nvl(vd.PU, 0)          AS PU,
       CAST(nvl(vd.PU * vd.QTE*(1-nvl(vd.REMISE,0)/100), 0) +nvl(vd.PU * vd.QTE*(1-nvl(vd.REMISE,0)/100) *(vd.TVA/100), 0) AS number(30,2)) AS puTotal,
       CAST(nvl(vd.PUACHAT * vd.QTE, 0) AS number(30,2)) AS puTotalAchat,
       CAST(nvl(vd.PU * vd.QTE, 0) - nvl(vd.PUACHAT * vd.QTE, 0) AS number(30,2)) AS puRevient,
       c.ID  AS IDCATEGORIE,
       c.VAL AS IDCATEGORIELIB,
       v.DATY AS daty,
       m.ID AS IDMAGASIN,
       m.VAL AS IDMAGASINLIB,
       p1.ID AS IDPOINT,
       p1.VAL AS IDPOINTLIB,
       vd.IDDEVISE,
       vd.IDDEVISE AS IDDEVISELIB,
       v.IDRESERVATION,
       vd.IDBCFILLE
FROM VENTE_DETAILS vd
         LEFT JOIN VENTE v ON v.ID = vd.IDVENTE
         LEFT JOIN MAGASIN2 m ON m.ID = v.IDMAGASIN
         LEFT JOIN AS_INGREDIENTS p ON p.ID = vd.IDPRODUIT
         LEFT JOIN POINT p1 ON p1.ID = m.IDPOINT
         LEFT JOIN CATEGORIE c  ON p.CATEGORIEINGREDIENT  = c.ID;


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
            THEN 'ANNUL&Eacute;(E)'
        WHEN da.ETAT = 1
            THEN 'CR&Eacute;&Eacute;(E)'
        WHEN da.ETAT = 11
            THEN 'VIS&Eacute;(E) par Directeur'
        WHEN da.ETAT = 3
            THEN 'VIS&Eacute;(E) par Chef de Fabrication'
        WHEN da.ETAT = 4
            THEN 'VIS&Eacute;(E) par Responsable achat'
        END AS etatlib
FROM DMDACHAT da
         LEFT JOIN FOURNISSEUR f ON f.ID = da.fournisseur
         LEFT JOIN MAGASIN2 m ON da.idMagasin = m.ID
         LEFT JOIN categorieIngredient ci ON da.idCategorie = ci.id
/