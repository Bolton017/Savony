-- Stef

CREATE OR REPLACE VIEW CLOTURE_MOIS_ANNEE_LIB AS
SELECT
    ID,
    MOIS,
    ANNEE,
    ETAT,
    CASE MOIS
        WHEN 1  THEN 'Janvier'
        WHEN 2  THEN 'Février'
        WHEN 3  THEN 'Mars'
        WHEN 4  THEN 'Avril'
        WHEN 5  THEN 'Mai'
        WHEN 6  THEN 'Juin'
        WHEN 7  THEN 'Juillet'
        WHEN 8  THEN 'Août'
        WHEN 9  THEN 'Septembre'
        WHEN 10 THEN 'Octobre'
        WHEN 11 THEN 'Novembre'
        WHEN 12 THEN 'Décembre'
        END AS MOISLIB
FROM CLOTURE_MOIS_ANNEE;

CREATE OR REPLACE VIEW RELEVERDETAILNRMVT AS
SELECT
    r.ID,
    r.DESIGNATION,
    CAST(r.DEBIT AS NUMBER(32,2)) AS DEBIT,
    CAST(r.CREDIT AS NUMBER(32,2)) AS CREDIT,
    r.DATYVALEUR,
    r.IDCAISSE,
    bc.val as iDCAISSELIB,
    r.COMPTE,
    CASE
        WHEN DEBIT > 0 THEN 1
        WHEN CREDIT > 0 THEN 2
        ELSE 0
        END AS MOUVEMENT
FROM RELEVERDETAILNR r
LEFT JOIN BANQUE_COMPTA bc ON bc.id = r.idCaisse;
