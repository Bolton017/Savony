-- SAVONNERIE2809.FABRICATIONCPL source

CREATE OR REPLACE  VIEW FABRICATIONCPL  AS 
  SELECT
    f.ID,f.LANCEPAR,f.CIBLE,f.REMARQUE,f.LIBELLE,f.BESOIN,f.DATY,f.idOffille,nvl(f.idof, off.idmere) AS idof,
    p.val AS lanceparLib,
    p2.val AS cibleLib,
    f.etat AS etat,
    f.fabricationsuiv,
    f.FABRICATIONPREC,
    CASE
        WHEN f.ETAT=1
            THEN 'CRÉÉ'
        WHEN f.ETAT=11
            THEN 'VALIDÉ'
        WHEN f.ETAT=0
            THEN 'ANNULÉ'
        WHEN f.ETAT=21
            THEN 'ENTAMÉ'
        WHEN f.ETAT=31
            THEN 'BLOQUÉ'
        WHEN f.ETAT=41
            THEN 'TERMINÉ'
        END AS ETATLIB,
        f.estUnProjet,
        f.lanceur
FROM FABRICATION f
         LEFT JOIN MAGASIN2 p ON p.id = f.lancepar
         LEFT JOIN MAGASIN2 p2 ON p2.id = f.cible
         LEFT JOIN offille off ON f.idoffille = off.id
 
 ;