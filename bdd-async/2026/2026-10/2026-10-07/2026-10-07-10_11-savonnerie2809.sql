----Edouardo

create or replace view PROCESSLIB as
SELECT
    p.IDHISTORIQUE,
    p.DATEHISTORIQUE,
    p.HEURE,
    p.OBJET,
    p.ACTION,
    p.IDUTILISATEUR,
    p.REFOBJET,
    pers.NOM || ' ' || pers.TELEPHONE AS acteur,
    p.REMARQUE,
    NVL(p.ECART,0) AS ECART,
    NVL(p.ECART,0) / 60 AS ECARTMINUTES
FROM
    PROCESS p
        LEFT JOIN PERSONNEL pers ON
        p.acteur = pers.id;