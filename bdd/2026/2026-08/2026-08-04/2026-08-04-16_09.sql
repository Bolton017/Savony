UPDATE FOURNISSEUR
SET COMPTE = '401001'
WHERE COMPTE IN (
    SELECT f.compte
    FROM FOURNISSEUR f
    WHERE f.compte NOT IN (
        SELECT c.compte
        FROM COMPTA_COMPTE c
        WHERE c.compte IS NOT NULL
    )
    GROUP BY f.compte
);
