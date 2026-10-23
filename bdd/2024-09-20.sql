
  --------------update menu 
  UPDATE MENUDYNAMIQUE
SET  HREF='module.jsp?but=compta/ecriture/ecriture-liste.jsp' WHERE ID='MNDSN285';
  
  -----------soloina iainga @ ity COMPTA_ECRITURE_VALIDE ireto view manaraka ireto
  CREATE OR REPLACE  VIEW COMPTA_ECRITURE_VALIDE  AS 
  select  sousecr.*
from
    COMPTA_SOUS_ECRITURE sousecr
        WHERE 
       sousecr.ETAT < 11 
      ;


CREATE OR REPLACE  VIEW REPORTSOLDE_JANVIER (COMPTE, LIBELLE_COMPTE, DEBIT, CREDIT, TYPECOMPTE, MOIS, ANNEE, CHIFFRE3, CHIFFRE2) AS 
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
      from COMPTA_ECRITURE_VALIDE cse,
           compta_compte cc,
           compta_journal jrn
      where cc.COMPTE = cse.compte
        and cse.journal = 'COMP000015'
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
      from COMPTA_ECRITURE_VALIDE cse,
           compta_compte cc,
           compta_journal jrn
      where cc.COMPTE = cse.analytique
        and cse.journal = 'COMP000015'
        and jrn.id = cse.journal)
group by COMPTE, LIBELLE, TYPECOMPTE, MOIS, ANNEE, CHIFFRE3, CHIFFRE2;



-- PHARMACIE_GALLOIS.COMPTA_MOUVEMENT_ANALYTIQUE source

CREATE OR REPLACE  VIEW COMPTA_MOUVEMENT_ANALYTIQUE (DEBIT, CREDIT, COMPTE, ETAT, LIBELLE_COMPTE, TYPECOMPTE, MOIS, ANNEE, CHIFFRE3, CHIFFRE2) AS 
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
            COMPTA_ECRITURE_VALIDE cse
                JOIN compta_compte cc ON
                cc.compte = cse.analytique
        WHERE
            cse.journal!='COMP000015'
          AND (cse.debit + cse.credit)>0
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
    
 -- PHARMACIE_GALLOIS.COMPTA_MOUVEMENT_GENERAL source

CREATE OR REPLACE  VIEW COMPTA_MOUVEMENT_GENERAL (DEBIT, CREDIT, COMPTE, ETAT, LIBELLE_COMPTE, TYPECOMPTE, MOIS, ANNEE, CHIFFRE3, CHIFFRE2) AS 
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
            substr(cse.compte, 1, 3) AS chiffre3,
            substr(cse.compte, 1, 2) AS chiffre2
        FROM
            COMPTA_ECRITURE_VALIDE cse
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
    
   
-- PHARMACIE_GALLOIS.REPORTSOLDE source

CREATE OR REPLACE  VIEW REPORTSOLDE (ID, COMPTE, LIBELLE_COMPTE, DEBIT, CREDIT, DATY, TYPECOMPTE, MOIS, ANNEE) AS 
  SELECT ce.id, cse.COMPTE, cc.libelle, cse.debit, cse.credit, ce.daty, cc.typecompte,
       EXTRACT(MONTH from ce.daty), EXTRACT(YEAR from ce.daty)
from
    COMPTA_ECRITURE_VALIDE cse, compta_ecriture ce, compta_compte cc, compta_journal jrn
where
    cse.idmere = ce.id and cc.COMPTE = cse.compte and ce.journal = 'COMP000015'
 and jrn.id = cse.journal
UNION
SELECT ce.id, cse.ANALYTIQUE, cc.libelle, cse.debit, cse.credit, ce.daty, cc.typecompte,
       EXTRACT(MONTH from ce.daty), EXTRACT(YEAR from ce.daty)
from
    COMPTA_ECRITURE_VALIDE cse, compta_ecriture ce, compta_compte cc, compta_journal jrn
where
    cse.idmere = ce.id and cc.COMPTE = cse.analytique and ce.journal = 'COMP000015'
  and jrn.id = cse.journal;
  
 
 
 -- PHARMACIE_GALLOIS.REPORTSOLDE_ANALYTIQUE source

CREATE OR REPLACE  VIEW REPORTSOLDE_ANALYTIQUE (COMPTE, LIBELLE_COMPTE, DEBIT, CREDIT, TYPECOMPTE, MOIS, ANNEE, CHIFFRE3, CHIFFRE2) AS 
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
            COMPTA_ECRITURE_VALIDE cse,
            compta_compte cc,
            compta_journal jrn
        WHERE
            cc.COMPTE = cse.ANALYTIQUE
          AND cse.JOURNAL = jrn.id
        GROUP BY
            cse.ANALYTIQUE,
            cc.libelle,
            cc.typecompte,
            EXTRACT(MONTH FROM cse.daty),
            EXTRACT(YEAR FROM cse.daty));
            
   -- PHARMACIE_GALLOIS.REPORTSOLDE_GENERAL source

CREATE OR REPLACE  VIEW REPORTSOLDE_GENERAL (COMPTE, LIBELLE_COMPTE, DEBIT, CREDIT, TYPECOMPTE, MOIS, ANNEE, CHIFFRE3, CHIFFRE2) AS 
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
            COMPTA_ECRITURE_VALIDE cse,
            compta_compte cc,
            compta_journal jrn
        WHERE
            cc.COMPTE = cse.compte
          AND cse.JOURNAL = jrn.id
        GROUP BY
            cse.COMPTE,
            cc.libelle,
            cc.typecompte,
            EXTRACT(MONTH FROM cse.daty),
            EXTRACT(YEAR FROM cse.daty)
    );
    
   
   -------------
   --compta_exercice_lib de ampiana avy amin compta_exercice ampiana lib journal sy somme na debit na credit avy amin compta_sous_ecriture atao oe montant
-- colonne compta_ecriture + montant compta_sous_ecriture + JOURNALLIB
CREATE OR REPLACE VIEW compta_montant 
AS 
SELECT
sum(nvl(cse.DEBIT,0)) AS montant ,
cse.IDMERE
FROM COMPTA_SOUS_ECRITURE cse
GROUP BY IDMERE;

CREATE OR REPLACE  VIEW COMPTA_ECRITURE_LIB 
AS 
SELECT 
ce.* ,
cm.montant,
cj.desce AS JOURNALLIB
FROM COMPTA_ECRITURE ce 
JOIN COMPTA_MONTANT cm ON ce.id = cm.IDMERE
LEFT JOIN COMPTA_JOURNAL cj ON cj.id = ce.JOURNAL
;
   
   
   
   
