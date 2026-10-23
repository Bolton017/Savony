--V_ACCIDENT_STATS,  V_TAUX_GRAVITE.

CREATE OR REPLACE  VIEW V_ACCIDENT_STATS (ID, DATECOMPTAGE, DATEDERNIERACCIDENT, JOURSANSACCIDENT, RECORDJOURSANSACCIDENT) AS 
  SELECT
    ID,
    dateComptage,
    dateDernierAccident,
    jourSansAccident,
    recordJourSansAccident
FROM (
    SELECT
        '-' AS ID,
        finMois AS dateComptage,
        dateDernierAccident,
        (finMois - dateDernierAccident) AS jourSansAccident,
        MAX(finMois - dateDernierAccident)
            OVER (ORDER BY finMois) AS recordJourSansAccident
    FROM (
        SELECT
            m.finMois,
            MAX(a.DATY) AS dateDernierAccident
        FROM (
            SELECT LAST_DAY(ADD_MONTHS(DATE '2025-01-01', LEVEL - 1)) AS finMois
            FROM dual
            CONNECT BY LEVEL <= 24
        ) m
        LEFT JOIN ACCIDENT a
            ON a.DATY <= m.finMois
        GROUP BY m.finMois
    )
)
WHERE dateDernierAccident IS NOT NULL
  AND jourSansAccident IS NOT NULL
  AND recordJourSansAccident IS NOT NULL
 
 
 
 ;
 
 CREATE OR REPLACE  VIEW V_TAUX_GRAVITE (ID, DATY, MOIS, TOTALJOURPERDUE, TAUXGRAVITE) AS 
  SELECT
    '-' AS ID,
    TRUNC(t.DATY, 'MM') AS DATY,
    TRUNC(t.DATY, 'MM') AS MOIS,
    SUM(t.NBJOURPRIS) AS TOTALJOURPERDUE,
    ROUND(AVG(t.POURCENTAGEGRAVITE), 2) AS TAUXGRAVITE
FROM (
    SELECT
        a.ID,
        a.DATY,
        NVL(SUM(at.NOMBRE_JOUR), 0) AS NBJOURPRIS,
        ROUND(
            ((NVL(SUM(at.NOMBRE_JOUR), 0) * 8) / 173.33) * 100,
            2
        ) AS POURCENTAGEGRAVITE
    FROM ACCIDENT a
    LEFT JOIN ARRET_TRAVAIL at
        ON a.ID = at.ID_ACCIDENT
    GROUP BY
        a.ID,
        a.DATY
    HAVING NVL(SUM(at.NOMBRE_JOUR), 0) > 0
) t
GROUP BY TRUNC(t.DATY, 'MM')
ORDER BY MOIS
 
 
 
 ;
 
 