create or replace view INVENTAIRELIB as
SELECT
    i.ID ,
    i.DATY ,
    i.DESIGNATION ,
    i.IDMAGASIN ,
    m.VAL AS IDMAGASINLIB,
    i.ETAT ,
    CASE
        WHEN i.ETAT = 0
            THEN 'ANNULEE'
        WHEN i.ETAT = 1
            THEN 'CREE'
        WHEN i.ETAT = 11
            THEN 'VALIDEE'
        END AS ETATLIB
FROM INVENTAIRE i
         LEFT JOIN MAGASINPOINT m ON m.ID = i.IDMAGASIN;