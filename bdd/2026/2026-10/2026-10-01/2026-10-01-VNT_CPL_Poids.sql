create or replace view VENTE_POIDS as
SELECT
    IDVENTE,
    SUM(poids) AS poids,
    SUM(
            CASE
                WHEN unite = 'UNT005042' THEN QTE
                ELSE CEIL(QTE / 15)
                END
    ) AS colis
FROM VENTE_DETAILS_POIDS where IDPRODUIT <> 'DEP0001'
GROUP BY IDVENTE;
