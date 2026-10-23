--AJOUT BASE MENU 
insert into menudynamique (id,libelle,icone,href,rang,niveau,id_pere) values ('MNDNT2205001','Lettrage','fa-bar-chart',null,5,2,'MNDN274');
insert into menudynamique (id,libelle,icone,href,rang,niveau,id_pere) values ('MNDNT2205004','Compte','fa-bar-chart',null,6,2,'MNDN274');
insert into menudynamique (id,libelle,icone,href,rang,niveau,id_pere) values ('MNDNT2205007','Journal','fa-fa-list','module.jsp?but=compta/journal/journal.jsp',7,2,'MNDN274');
insert into menudynamique (id,libelle,icone,href,rang,niveau,id_pere) values ('MNDNT2205008','Exercice','fa-bar-chart','module.jsp?but=compta/exercice/ouvertureCloture.jsp#',8,2,'MNDN274');    

insert into menudynamique (id,libelle,icone,href,rang,niveau,id_pere) values ('MNDNT2205002','Liste','fa fa-list','module.jsp?but=compta/lettrage/lettrage-liste.jsp',2,3,'MNDNT2205001');
insert into menudynamique (id,libelle,icone,href,rang,niveau,id_pere) values ('MNDNT2205003','Saisie','fa fa-plus','module.jsp?but=compta/lettrage/lettrage-saisie.jsp',1,3,'MNDNT2205001');
insert into menudynamique (id,libelle,icone,href,rang,niveau,id_pere) values ('MNDNT2205005','Liste','fa fa-list','module.jsp?but=compta/compte/compte-liste.jsp',2,3,'MNDNT2205004');
insert into menudynamique (id,libelle,icone,href,rang,niveau,id_pere) values ('MNDNT2205006','Saisie','fa fa-plus','module.jsp?but=compta/compte/compte-saisie.jsp',1,3,'MNDNT2205004');


  CREATE OR REPLACE FORCE VIEW "V_BALANCE_DETAILS" ("ANNEE", "MOIS", "COMPTE", "LIBELLECOMPTE", "DEBIT", "CREDIT", "COMPTE3", "COMPTE2", "CUMULDEBIT", "CUMULCREDIT") AS
  WITH mois_annees AS (
    SELECT
        ADD_MONTHS(TRUNC(SYSDATE, 'MM'), LEVEL - 25) AS mois
    FROM DUAL
        CONNECT BY LEVEL <= 49
        ),
        base_comptes_periode AS (
        SELECT
        CAST(c.compte AS VARCHAR2(100)) AS compte,
        c.libelle AS libelleCompte,
        m.mois,
        EXTRACT(YEAR FROM m.mois) AS annee,
        EXTRACT(MONTH FROM m.mois) AS mois_num
        FROM
        compta_compte c
        CROSS JOIN mois_annees m
        ),
        ecritures_mensuelles AS (
    -- Excludes journal = 'COMP000015'
        SELECT
        CAST(cse.compte AS VARCHAR2(100)) AS compte,
        TRUNC(cse.daty, 'MM') AS mois,
        SUM(cse.debit) AS soldeDebit,
        SUM(cse.credit) AS soldeCredit
        FROM
        compta_sous_ecriture cse
        JOIN compta_ecriture ce ON ce.id = cse.idmere
        WHERE
        cse.daty IS NOT NULL
        AND cse.etat >= 11
        AND cse.journal != 'COMP000015'
        GROUP BY
        cse.compte, TRUNC(cse.daty, 'MM')
        ),
        ecritures_mensuelles_cumuls AS (
    -- Includes all journals, including 'COMP000015'
        SELECT
        CAST(cse.compte AS VARCHAR2(100)) AS compte,
        TRUNC(cse.daty, 'MM') AS mois,
        SUM(cse.debit) AS cumulDebit,
        SUM(cse.credit) AS cumulCredit
        FROM
        compta_sous_ecriture cse
        JOIN compta_ecriture ce ON ce.id = cse.idmere
        WHERE
        cse.daty IS NOT NULL
        AND cse.etat >= 11
        GROUP BY
        cse.compte, TRUNC(cse.daty, 'MM')
        ),
        fusion_comptes_mois AS (
        SELECT
        b.annee,
        b.mois_num AS mois,
        b.compte,
        b.libelleCompte,
        b.mois AS date_mois,
        NVL(em.soldeDebit, 0) AS soldeDebit,
        NVL(em.soldeCredit, 0) AS soldeCredit,
        NVL(ec.cumulDebit, 0) AS cumulDebit,
        NVL(ec.cumulCredit, 0) AS cumulCredit
        FROM
        base_comptes_periode b
        LEFT JOIN ecritures_mensuelles em ON b.compte = em.compte AND b.mois = em.mois
        LEFT JOIN ecritures_mensuelles_cumuls ec ON b.compte = ec.compte AND b.mois = ec.mois
        )
SELECT
    annee,
    mois,
    compte,
    libelleCompte,
    ROUND(soldeDebit, 2) AS debit,
    ROUND(soldeCredit, 2) AS credit,
    TO_NUMBER(SUBSTR(compte, 1, 3)) AS compte3,
    TO_NUMBER(SUBSTR(compte, 1, 2)) AS compte2,
    ROUND(
            SUM(cumulDebit) OVER (
            PARTITION BY compte ORDER BY date_mois
            ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
        ), 2
    ) AS cumulDebit,
    ROUND(
            SUM(cumulCredit) OVER (
            PARTITION BY compte ORDER BY date_mois
            ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
        ), 2
    ) AS cumulCredit
FROM
    fusion_comptes_mois
ORDER BY
    compte, annee, mois;

 


  CREATE OR REPLACE FORCE VIEW "V_BALANCE_DETAILS_ANALYTIQUE" ("ANNEE", "MOIS", "COMPTE", "LIBELLECOMPTE", "DEBIT", "CREDIT", "COMPTE3", "COMPTE2", "CUMULDEBIT", "CUMULCREDIT") AS
  WITH mois_annees AS (
    SELECT
        ADD_MONTHS(TRUNC(SYSDATE, 'MM'), LEVEL - 25) AS mois
    FROM DUAL
        CONNECT BY LEVEL <= 49
        ),
        base_comptes_periode AS (
        SELECT
        CAST(c.compte AS VARCHAR2(100)) AS compte,
        c.libelle AS libelleCompte,
        m.mois,
        EXTRACT(YEAR FROM m.mois) AS annee,
        EXTRACT(MONTH FROM m.mois) AS mois_num
        FROM
        compta_compte c
        CROSS JOIN mois_annees m
        WHERE
        c.typecompte = '3'
        ),
        ecritures_mensuelles AS (
    -- For monthly values: EXCLUDE journal = 'COMP000015'
        SELECT
        CAST(cse.compte AS VARCHAR2(100)) AS compte,
        TRUNC(cse.daty, 'MM') AS mois,
        SUM(cse.debit) AS soldeDebit,
        SUM(cse.credit) AS soldeCredit
        FROM
        compta_sous_ecriture cse
        JOIN compta_ecriture ce ON ce.id = cse.idmere
        WHERE
        cse.daty IS NOT NULL
        AND cse.etat >= 11
        AND ce.journal != 'COMP000015'
        GROUP BY
        cse.compte, TRUNC(cse.daty, 'MM')
        ),
        ecritures_mensuelles_cumuls AS (
    -- For cumulative values: INCLUDE everything
        SELECT
        CAST(cse.compte AS VARCHAR2(100)) AS compte,
        TRUNC(cse.daty, 'MM') AS mois,
        SUM(cse.debit) AS cumulDebit,
        SUM(cse.credit) AS cumulCredit
        FROM
        compta_sous_ecriture cse
        JOIN compta_ecriture ce ON ce.id = cse.idmere
        WHERE
        cse.daty IS NOT NULL
        AND cse.etat >= 11
        GROUP BY
        cse.compte, TRUNC(cse.daty, 'MM')
        ),
        fusion_comptes_mois AS (
        SELECT
        b.annee,
        b.mois_num AS mois,
        b.compte,
        b.libelleCompte,
        b.mois AS date_mois,
        NVL(em.soldeDebit, 0) AS soldeDebit,
        NVL(em.soldeCredit, 0) AS soldeCredit,
        NVL(ec.cumulDebit, 0) AS cumulDebit,
        NVL(ec.cumulCredit, 0) AS cumulCredit
        FROM
        base_comptes_periode b
        LEFT JOIN ecritures_mensuelles em ON b.compte = em.compte AND b.mois = em.mois
        LEFT JOIN ecritures_mensuelles_cumuls ec ON b.compte = ec.compte AND b.mois = ec.mois
        )
SELECT
    annee,
    mois,
    compte,
    libelleCompte,
    ROUND(soldeDebit, 2) AS debit,
    ROUND(soldeCredit, 2) AS credit,
    TO_NUMBER(SUBSTR(compte, 1, 3)) AS compte3,
    TO_NUMBER(SUBSTR(compte, 1, 2)) AS compte2,
    ROUND(
            SUM(cumulDebit) OVER (
            PARTITION BY compte ORDER BY date_mois
            ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
        ), 2
    ) AS cumulDebit,
    ROUND(
            SUM(cumulCredit) OVER (
            PARTITION BY compte ORDER BY date_mois
            ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
        ), 2
    ) AS cumulCredit
FROM
    fusion_comptes_mois
ORDER BY
    compte, annee, mois;
 


CREATE OR REPLACE FORCE VIEW "V_BILAN_SECTION_COMPTE_COMPLET" ("ID", "IDBILANSECTION", "EXERCICE", "COMPTE", "DEBIT", "CREDIT") AS
SELECT 
bsc.ID ,
bsc.IDBILANSECTION ,
ce.ID AS exercice ,
bsc.COMPTE ,
sum(nvl(cse.DEBIT,0)) AS debit,
sum(nvl(cse.CREDIT,0)) AS credit
FROM BILAN_SECTION_COMPTE bsc
JOIN COMPTA_EXERCICE ce ON 1=1
JOIN BILANSECTION b ON b.ID = bsc.IDBILANSECTION 
LEFT JOIN COMPTA_SOUS_ECRITURE cse ON cse.COMPTE = bsc.COMPTE AND EXTRACT(YEAR FROM cse.daty) = ce.id 
GROUP BY bsc.ID,bsc.IDBILANSECTION,ce.ID,bsc.COMPTE ;
 

-- table niova lasa nisy anle lettrage
  ALTER TABLE "COMPTA_ECRITURE"
ADD ("LETTRAGE" VARCHAR2(50));
 

  CREATE OR REPLACE FORCE VIEW "COMPTA_MOUVEMENT_ANAL_C" ("DEBIT", "CREDIT", "COMPTE", "ETAT", "LIBELLE_COMPTE", "TYPECOMPTE", "MOIS", "ANNEE", "CHIFFRE3", "CHIFFRE2") AS
  SELECT
    cma.DEBIT,cma.CREDIT,cma.COMPTE,cma.ETAT,cma.LIBELLE_COMPTE,cma.TYPECOMPTE,cma.MOIS,cma.ANNEE,cma.CHIFFRE3,cma.CHIFFRE2
FROM COMPTA_MOUVEMENT_ANALYTIQUE cma
WHERE cma.ETAT = 1;
 


  CREATE OR REPLACE FORCE VIEW "COMPTA_MOUVEMENT_ANAL_V" ("DEBIT", "CREDIT", "COMPTE", "ETAT", "LIBELLE_COMPTE", "TYPECOMPTE", "MOIS", "ANNEE", "CHIFFRE3", "CHIFFRE2") AS
  SELECT
    cma.DEBIT,cma.CREDIT,cma.COMPTE,cma.ETAT,cma.LIBELLE_COMPTE,cma.TYPECOMPTE,cma.MOIS,cma.ANNEE,cma.CHIFFRE3,cma.CHIFFRE2
FROM COMPTA_MOUVEMENT_ANALYTIQUE cma
WHERE cma.ETAT = 11;
 


  CREATE OR REPLACE FORCE VIEW "COMPTA_MOUVEMENT_DETAILS_GEN_2" ("ID", "CONTREP", "COMPTE", "DEBIT", "CREDIT", "LIBELLEPIECE", "REMARQUE", "IDMERE", "REFERENCE_ENGAGEMENT", "COMPTE_AUX", "LETTRAGE", "JOURNAL", "EXERCICE", "ETAT", "DATY", "FOLIO", "COURSDEVISE", "MONTANTDEVISE") AS
  SELECT
    ID,
    CONTREP,
    COMPTE,
    DEBIT,
    CREDIT,
    LIBELLEPIECE,
    REMARQUE,
    MERE AS IDMERE,
    REFERENCE_ENGAGEMENT,
    COMPTE_AUX,
    LETTRAGE,
    JOURNAL,
    EXERCICE,
    ETAT,
    DATY,
    FOLIO,
    CAST(COURSDEVISE AS NUMBER(20,
        2)) AS COURSDEVISE,
    CAST(MONTANTDEVISE AS NUMBER(20,
        2)) AS MONTANTDEVISE
FROM
    COMPTA_MOUVEMENT_DETAILGEN;
 


  CREATE OR REPLACE FORCE VIEW "COMPTAMOUVEMENTDETAILS_GEN_2_C" ("ID", "CONTREP", "COMPTE", "DEBIT", "CREDIT", "LIBELLEPIECE", "REMARQUE", "IDMERE", "REFERENCE_ENGAGEMENT", "COMPTE_AUX", "LETTRAGE", "JOURNAL", "EXERCICE", "ETAT", "DATY", "FOLIO", "COURSDEVISE", "MONTANTDEVISE") AS
  SELECT "ID","CONTREP","COMPTE","DEBIT","CREDIT","LIBELLEPIECE","REMARQUE","IDMERE","REFERENCE_ENGAGEMENT","COMPTE_AUX","LETTRAGE","JOURNAL","EXERCICE","ETAT","DATY","FOLIO","COURSDEVISE","MONTANTDEVISE" FROM COMPTA_MOUVEMENT_DETAILS_GEN_2 where etat =1;
 


  CREATE OR REPLACE FORCE VIEW "COMPTAMOUVEMENTDETAILS_GEN_2_V" ("ID", "CONTREP", "COMPTE", "DEBIT", "CREDIT", "LIBELLEPIECE", "REMARQUE", "IDMERE", "REFERENCE_ENGAGEMENT", "COMPTE_AUX", "LETTRAGE", "JOURNAL", "EXERCICE", "ETAT", "DATY", "FOLIO", "COURSDEVISE", "MONTANTDEVISE") AS
  SELECT "ID","CONTREP","COMPTE","DEBIT","CREDIT","LIBELLEPIECE","REMARQUE","IDMERE","REFERENCE_ENGAGEMENT","COMPTE_AUX","LETTRAGE","JOURNAL","EXERCICE","ETAT","DATY","FOLIO","COURSDEVISE","MONTANTDEVISE" FROM COMPTA_MOUVEMENT_DETAILS_GEN_2 where etat =11;
 


  CREATE OR REPLACE FORCE VIEW "REPORTSOLDE" ("ID", "COMPTE", "LIBELLE_COMPTE", "DEBIT", "CREDIT", "DATY", "TYPECOMPTE", "MOIS", "ANNEE") AS
  SELECT ce.id, cse.COMPTE, cc.libelle, cse.debit, cse.credit, ce.daty, cc.typecompte,
       EXTRACT(MONTH from ce.daty), EXTRACT(YEAR from ce.daty)
from
    compta_sous_ecriture cse, compta_ecriture ce, compta_compte cc, compta_journal jrn
where
    cse.idmere = ce.id and cc.COMPTE = cse.compte and ce.journal = 'COMP000015'
  and ce.etat = 11 and jrn.id = cse.journal
UNION
SELECT ce.id, cse.ANALYTIQUE, cc.libelle, cse.debit, cse.credit, ce.daty, cc.typecompte,
       EXTRACT(MONTH from ce.daty), EXTRACT(YEAR from ce.daty)
from
    compta_sous_ecriture cse, compta_ecriture ce, compta_compte cc, compta_journal jrn
where
    cse.idmere = ce.id and cc.COMPTE = cse.analytique and ce.journal = 'COMP000015'
  and ce.etat = 11 and jrn.id = cse.journal;
 

 
  CREATE OR REPLACE FORCE VIEW "REPORTSOLDE_ANALYTIQUE" ("COMPTE", "LIBELLE_COMPTE", "DEBIT", "CREDIT", "TYPECOMPTE", "MOIS", "ANNEE", "CHIFFRE3", "CHIFFRE2") AS
  SELECT
    COMPTE,
    LIBELLE,
    CAST(DEBIT AS NUMBER(30,
        2)),
    CAST(CREDIT AS NUMBER(30,
        2)),
    TYPECOMPTE,
    MOIS,
    ANNEE,
    CHIFFRE3,
    CHIFFRE2
FROM
    (
        SELECT
            cse.ANALYTIQUE AS COMPTE,
            cc.libelle,
            sum(cse.debit) AS DEBIT,
            sum(cse.credit) AS CREDIT,
            cc.typecompte,
            EXTRACT(MONTH FROM cse.daty) AS MOIS,
            EXTRACT(YEAR FROM cse.daty) AS ANNEE,
            substr(analytique, 1, 3)|| substr(analytique, 5, 1) AS chiffre3,
            substr(cse.ANALYTIQUE, 1, 2) AS chiffre2
        FROM
            compta_sous_ecriture cse,
            compta_compte cc,
            compta_journal jrn
        WHERE
            cc.COMPTE = cse.ANALYTIQUE
          AND cse.etat = 11
          AND cse.JOURNAL = jrn.id
        GROUP BY
            cse.ANALYTIQUE,
            cc.libelle,
            cc.typecompte,
            EXTRACT(MONTH FROM cse.daty),
            EXTRACT(YEAR FROM cse.daty));
 



  CREATE OR REPLACE FORCE VIEW "REPORTSOLDE_GENERAL" ("COMPTE", "LIBELLE_COMPTE", "DEBIT", "CREDIT", "TYPECOMPTE", "MOIS", "ANNEE", "CHIFFRE3", "CHIFFRE2") AS
  SELECT
    COMPTE,
    LIBELLE,
    CAST(DEBIT AS NUMBER(30,
        2)),
    CAST(CREDIT AS NUMBER(30,
        2)),
    TYPECOMPTE,
    MOIS,
    ANNEE,
    CHIFFRE3,
    CHIFFRE2
FROM
    (
        SELECT
            cse.COMPTE,
            cc.libelle,
            sum(cse.debit) AS debit,
            sum(cse.credit) AS credit,
            cc.typecompte,
            EXTRACT(MONTH FROM cse.daty) AS mois,
            EXTRACT(YEAR FROM cse.daty) AS annee,
            CASE
                WHEN substr(cse.compte, 1, 4) = '4007' THEN '407'
                ELSE substr(cse.compte, 1, 2)|| substr(cse.compte, 5, 1)
                END AS CHIFFRE3,
            substr(cse.compte, 1, 2) AS CHIFFRE2
        FROM
            compta_sous_ecriture cse,
            compta_compte cc,
            compta_journal jrn
        WHERE
            cc.COMPTE = cse.compte
          AND cse.etat = 11
          AND cse.JOURNAL = jrn.id
        GROUP BY
            cse.COMPTE,
            cc.libelle,
            cc.typecompte,
            EXTRACT(MONTH FROM cse.daty),
            EXTRACT(YEAR FROM cse.daty)
    );
 


  CREATE OR REPLACE FORCE VIEW "COMPTA_LETTRAGE_LIB" ("ID", "LETTRE", "DATE_LETTRAGE", "COMPTE", "MONTANT", "REMARQUE", "JOURNAL") AS
  SELECT cl.id, cl.LETTRE, cl.DATE_LETTRAGE, cc.COMPTE, cl.montant, cl.remarque,
  jrn.desce as journal
FROM compta_lettrage cl
         LEFT JOIN COMPTA_SOUS_ECRITURE cse ON cse.LETTRAGE = cl.ID
         LEFT JOIN COMPTA_COMPTE cc ON cc.COMPTE = cse.compte
         LEFT JOIN COMPTA_JOURNAL jrn ON cse.JOURNAL = jrn.ID;

 


  CREATE OR REPLACE FORCE VIEW "COMPTA_ECRITURE_MF" ("ID", "DATY", "DATECOMPTABLE", "EXERCICE", "DESIGNATION", "REMARQUE", "ETAT", "HORSEXERCICE", "JOURNAL", "OD", "ORIGINE", "IDUSER", "PERIODE", "TRIMESTRE", "ANNEE", "IDOBJET", "LETTRAGE", "COMPTE", "DEBIT", "CREDIT") AS
  SELECT
    ce.ID,
    ce.DATY,
    ce.DATECOMPTABLE,
    ce.EXERCICE,
    ce.DESIGNATION,
    ce.REMARQUE,
    ce.ETAT,
    ce.HORSEXERCICE,
    ce.JOURNAL,
    ce.OD,
    ce.ORIGINE,
    ce.IDUSER,
    ce.PERIODE,
    ce.TRIMESTRE,
    ce.ANNEE,
    ce.IDOBJET,
    ce.LETTRAGE,
    cse.COMPTE ,
    CAST( SUM(cse.DEBIT) AS NUMBER(30,2))  AS DEBIT,
    CAST( SUM(cse.CREDIT) AS NUMBER(30,2)) AS CREDIT
FROM COMPTA_ECRITURE ce
         LEFT JOIN COMPTA_SOUS_ECRITURE cse ON ce.ID = cse.IDMERE
GROUP BY
    ce.ID,
    ce.DATY,
    ce.DATECOMPTABLE,
    ce.EXERCICE,
    ce.DESIGNATION,
    ce.REMARQUE,
    ce.ETAT,
    ce.HORSEXERCICE,
    ce.JOURNAL,
    ce.OD,
    ce.ORIGINE,
    ce.IDUSER,
    ce.PERIODE,
    ce.TRIMESTRE,
    ce.ANNEE,
    ce.IDOBJET,
    ce.LETTRAGE,
    cse.COMPTE;
 


  CREATE OR REPLACE FORCE VIEW "REPORTSOLDE_JANVIER" ("COMPTE", "LIBELLE_COMPTE", "DEBIT", "CREDIT", "TYPECOMPTE", "MOIS", "ANNEE", "CHIFFRE3", "CHIFFRE2") AS
  SELECT COMPTE,
       LIBELLE,
       CAST(sum(DEBIT) AS NUMBER(30, 2)),
       CAST(sum(CREDIT) AS NUMBER(30, 2)),
       TYPECOMPTE,
       MOIS,
       ANNEE,
       CHIFFRE3,
       CHIFFRE2
FROM (SELECT cse.COMPTE,
             cc.libelle,
             cse.debit,
             cse.credit,
             cc.typecompte,
             EXTRACT(MONTH from cse.daty)                                      AS MOIS,
             EXTRACT(YEAR from cse.daty)                                       AS ANNEE,
             CASE
                 WHEN TYPECOMPTE = 3 THEN SUBSTR(CSE.COMPTE, 1, 3) || SUBSTR(CSE.COMPTE, 5, 1)
                 WHEN TYPECOMPTE = 1 AND SUBSTR(CSE.COMPTE, 1, 4) = '4007' THEN '407'
                 ELSE SUBSTR(CSE.COMPTE, 1, 2) || SUBSTR(CSE.COMPTE, 5, 1) END as chiffre3,
             substr(cse.compte, 1, 2)                                          as chiffre2
      from compta_sous_ecriture cse,
           compta_compte cc,
           compta_journal jrn
      where cc.COMPTE = cse.compte
        and cse.journal = 'COMP000015'
        AND cse.etat = 11
        AND jrn.id = cse.journal
      UNION
      SELECT cse.ANALYTIQUE,
             cc.libelle,
             cse.debit                                                                 as debit,
             cse.credit                                                                as credit,
             cc.typecompte,
             EXTRACT(MONTH from cse.daty),
             EXTRACT(YEAR from cse.daty),
             CASE
                 WHEN TYPECOMPTE = 3 THEN SUBSTR(cse.ANALYTIQUE, 1, 3) || SUBSTR(cse.ANALYTIQUE, 5, 1)
                 ELSE SUBSTR(cse.ANALYTIQUE, 1, 2) || SUBSTR(cse.ANALYTIQUE, 5, 1) END as chiffre3,
             substr(cse.ANALYTIQUE, 1, 2)                                              as chiffre2
      from compta_sous_ecriture cse,
           compta_compte cc,
           compta_journal jrn
      where cc.COMPTE = cse.analytique
        and cse.journal = 'COMP000015'
        and cse.etat = 11
        and jrn.id = cse.journal)
group by COMPTE, LIBELLE, TYPECOMPTE, MOIS, ANNEE, CHIFFRE3, CHIFFRE2;
 


  CREATE OR REPLACE FORCE VIEW "COMPTA_MOUVEMENT_ANALYTIQUE" ("DEBIT", "CREDIT", "COMPTE", "ETAT", "LIBELLE_COMPTE", "TYPECOMPTE", "MOIS", "ANNEE", "CHIFFRE3", "CHIFFRE2") AS
  SELECT
    CAST(sum(debit) AS NUMBER(30,
        2)) AS debit,
    CAST(sum(credit) AS NUMBER(30,
        2)) AS credit,
    compte,
    etat,
    libelle_compte,
    typecompte,
    mois,
    annee,
    chiffre3,
    chiffre2
FROM
    (
        SELECT
            cse.id,
            cse.debit AS debit,
            cse.credit AS credit,
            cse.analytique AS compte,
            cc.LIBELLE AS libelle_compte,
            cse.daty AS daty,
            cse.etat,
            cc.typecompte AS typecompte,
            EXTRACT(MONTH FROM cse.daty) AS mois,
            EXTRACT(YEAR FROM cse.daty) AS annee,
            substr(analytique, 1, 3)|| substr(analytique, 5, 1) AS chiffre3,
            substr(analytique, 1, 2) AS chiffre2
        FROM
            compta_sous_ecriture cse
                JOIN compta_compte cc ON
                cc.compte = cse.analytique
        WHERE
            cse.journal!='COMP000015'
          AND (cse.debit + cse.credit)>0
          AND cse.etat = 11
          AND NOT EXISTS(
            SELECT
                rs.id
            FROM
                reportsolde rs
            WHERE
                rs.id = cse.id
        )

        --group by   ce.id, cse.analytique, ce.daty, cse.etat, cc.LIBELLE, cc.typecompte , extract(month from cse.daty),
        --extract(year from cse.daty)
    )
GROUP BY compte,
         etat,
         libelle_compte,
         typecompte,
         mois,
         annee,
         chiffre3,
         chiffre2
ORDER BY
    chiffre3 ASC;
 


  CREATE OR REPLACE FORCE VIEW "COMPTA_MOUVEMENT_GENERAL" ("DEBIT", "CREDIT", "COMPTE", "ETAT", "LIBELLE_COMPTE", "TYPECOMPTE", "MOIS", "ANNEE", "CHIFFRE3", "CHIFFRE2") AS
  SELECT
    CAST(sum(debit)AS NUMBER(30,
        2)) AS debit,
    CAST(sum(credit) AS NUMBER(30,
        2)) AS credit,
    compte,
    etat,
    libelle_compte,
    typecompte,
    mois,
    annee,
    chiffre3,
    chiffre2
FROM
    (
        SELECT
            cse.id,
            cse.debit AS debit,
            cse.credit AS credit,
            cse.compte AS compte,
            cc.LIBELLE AS libelle_compte,
            cse.daty AS daty,
            cse.etat,
            cc.typecompte AS typecompte,
            EXTRACT(MONTH FROM cse.daty) AS mois,
            EXTRACT(YEAR FROM cse.daty) AS annee,
            CASE
                WHEN substr(cse.compte, 1, 4) = '4007' THEN '407'
                ELSE substr(cse.compte, 1, 2)|| substr(cse.compte, 5, 1)
                END AS chiffre3,
            substr(cse.compte, 1, 2) AS chiffre2
        FROM
            compta_sous_ecriture cse
                JOIN compta_compte cc ON
                cc.compte = cse.compte
                JOIN compta_journal cj ON
                cj.id = cse.JOURNAL
        WHERE
            (cse.debit + cse.credit)>0
          AND NOT EXISTS(
            SELECT
                rs.id
            FROM
                reportsolde rs
            WHERE
                rs.id = cse.id
        )
    )
GROUP BY compte,
         etat,
         libelle_compte,
         typecompte,
         mois,
         annee,
         chiffre3,
         chiffre2
ORDER BY
    chiffre3 ASC;
 


  CREATE OR REPLACE FORCE VIEW "REPORTSOLDE_ANALYTIQUE" ("COMPTE", "LIBELLE_COMPTE", "DEBIT", "CREDIT", "TYPECOMPTE", "MOIS", "ANNEE", "CHIFFRE3", "CHIFFRE2") AS
  SELECT
    COMPTE,
    LIBELLE,
    CAST(DEBIT AS NUMBER(30,
        2)),
    CAST(CREDIT AS NUMBER(30,
        2)),
    TYPECOMPTE,
    MOIS,
    ANNEE,
    CHIFFRE3,
    CHIFFRE2
FROM
    (
        SELECT
            cse.ANALYTIQUE AS COMPTE,
            cc.libelle,
            sum(cse.debit) AS DEBIT,
            sum(cse.credit) AS CREDIT,
            cc.typecompte,
            EXTRACT(MONTH FROM cse.daty) AS MOIS,
            EXTRACT(YEAR FROM cse.daty) AS ANNEE,
            substr(analytique, 1, 3)|| substr(analytique, 5, 1) AS chiffre3,
            substr(cse.ANALYTIQUE, 1, 2) AS chiffre2
        FROM
            compta_sous_ecriture cse,
            compta_compte cc,
            compta_journal jrn
        WHERE
            cc.COMPTE = cse.ANALYTIQUE
          AND cse.etat = 11
          AND cse.JOURNAL = jrn.id
        GROUP BY
            cse.ANALYTIQUE,
            cc.libelle,
            cc.typecompte,
            EXTRACT(MONTH FROM cse.daty),
            EXTRACT(YEAR FROM cse.daty));
 


  CREATE OR REPLACE FORCE VIEW "REPORTSOLDE_GENERAL" ("COMPTE", "LIBELLE_COMPTE", "DEBIT", "CREDIT", "TYPECOMPTE", "MOIS", "ANNEE", "CHIFFRE3", "CHIFFRE2") AS
  SELECT
    COMPTE,
    LIBELLE,
    CAST(DEBIT AS NUMBER(30,
        2)),
    CAST(CREDIT AS NUMBER(30,
        2)),
    TYPECOMPTE,
    MOIS,
    ANNEE,
    CHIFFRE3,
    CHIFFRE2
FROM
    (
        SELECT
            cse.COMPTE,
            cc.libelle,
            sum(cse.debit) AS debit,
            sum(cse.credit) AS credit,
            cc.typecompte,
            EXTRACT(MONTH FROM cse.daty) AS mois,
            EXTRACT(YEAR FROM cse.daty) AS annee,
            CASE
                WHEN substr(cse.compte, 1, 4) = '4007' THEN '407'
                ELSE substr(cse.compte, 1, 2)|| substr(cse.compte, 5, 1)
                END AS CHIFFRE3,
            substr(cse.compte, 1, 2) AS CHIFFRE2
        FROM
            compta_sous_ecriture cse,
            compta_compte cc,
            compta_journal jrn
        WHERE
            cc.COMPTE = cse.compte
          AND cse.etat = 11
          AND cse.JOURNAL = jrn.id
        GROUP BY
            cse.COMPTE,
            cc.libelle,
            cc.typecompte,
            EXTRACT(MONTH FROM cse.daty),
            EXTRACT(YEAR FROM cse.daty)
    );
 


  CREATE OR REPLACE FORCE VIEW "COMPTA_SOUS_ECRITURE_ANAL" ("ID", "COMPTE", "DEBIT", "CREDIT", "LIBELLEPIECE", "REMARQUE", "IDMERE", "REFERENCE_ENGAGEMENT", "COMPTE_AUX", "LETTRAGE", "JOURNAL", "EXERCICE", "ETAT", "DATY", "FOLIO") AS
  SELECT cse.id, cse.analytique as compte, cse.debit, cse.credit,cse.libellepiece, cse.remarque,cse.idMere, cse.reference_engagement, cse.compte_aux, lettre.lettre as lettrage,cj.val as journal,cse.exercice, cse.etat,cse.daty, cse.folio FROM COMPTA_SOUS_ECRITURE cse
join COMPTA_JOURNAL_VIEW cj on cj.id = cse.journal
join compta_compte cc on cse.analytique=cc.compte
join compta_type_compte ctc on cc.typecompte=ctc.id
left join COMPTA_LETTRAGE lettre on lettre.id = cse.lettrage;


 


  CREATE OR REPLACE FORCE VIEW "COMPTA_SOUS_ECRITURE_GEN" ("ID", "COMPTE", "DEBIT", "CREDIT", "LIBELLEPIECE", "REMARQUE", "IDMERE", "REFERENCE_ENGAGEMENT", "COMPTE_AUX", "LETTRAGE", "JOURNAL", "EXERCICE", "ETAT", "DATY", "FOLIO") AS
  SELECT cse.id, cse.compte, cse.debit, cse.credit,cse.libellepiece, cse.remarque,cse.idMere, cse.reference_engagement, cse.compte_aux, lettre.lettre as lettrage,cj.val as journal,cse.exercice, cse.etat,cse.daty, cse.folio FROM COMPTA_SOUS_ECRITURE cse
join COMPTA_JOURNAL_VIEW cj on cj.id = cse.journal
join compta_compte cc on cse.compte=cc.compte
join compta_type_compte ctc on cc.typecompte=ctc.id
left join COMPTA_LETTRAGE lettre on lettre.id = cse.lettrage;

 

