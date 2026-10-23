CREATE OR REPLACE VIEW PERIODEPAIELIB AS 
SELECT 
    p.id,
    p.mois,
    p.datedebut,
    p.datefin,
    p.idcategoriepaie,
    p.annee,
    p.etat,
    TO_CHAR(
            TO_DATE(TO_CHAR(p.mois, 'FM00'), 'MM'),
            'FMMonth',
            'NLS_DATE_LANGUAGE=FRENCH'
    ) AS moisLib
FROM PERIODEPAIE p;

