create or replace view AVOIRFCLIB as
SELECT a.ID,
       a.DESIGNATION,
       a.IDMAGASIN,
       m.VAL         AS IDMAGASINLIB,
       a.DATY,
       a.REMARQUE,
       a.ETAT,
       a.IDORIGINE,
       a.IDCLIENT,
       t.COMPTE,
       t.compteauxiliaire,
       a.IDVENTE,
       v.DESIGNATION AS IDVENTELIB,
       a.IDMOTIF,
       ma.VAL        AS IDMOTIFLIB,
       a.IDCATEGORIE,
       c.VAL         AS IDCATEGORIELIB,
       ag.IDDEVISE,
       ag.TAUXDECHANGE,
       ag.MONTANTHT,
       ag.MONTANTTVA,
       ag.MONTANTTTC,
       ag.MONTANTHTAR,
       ag.MONTANTTVAAR,
       ag.MONTANTTTCAR,
       v.IDRESERVATION,
       ta.val        as Typeavoir,
       t.NOM         as clientlib,
       UPPER(
               NVL(a.DESIGNATION, '') || ' ' ||
               NVL(a.REMARQUE, '') || ' ' ||
               NVL(t.NOM, '') || ' ' ||
               NVL(m.VAL, '') || ' ' ||
               NVL(v.DESIGNATION, '') || ' ' ||
               NVL(ma.VAL, '') || ' ' ||
               NVL(c.VAL, '') || ' ' ||
               NVL(ta.val, '') || ' ' ||
               NVL(t.COMPTE, '') || ' ' ||
               TO_CHAR(a.DATY, 'DD/MM/YYYY')
       ) AS MOTSCLESSS,
       CASE
           WHEN a.ETAT = 1 THEN 'CR&Eacute;&Eacute;E'
           WHEN a.ETAT = 11 THEN 'VIS&Eacute;E'
           WHEN a.ETAT = 0 THEN 'ANNUL&Eacute;E'
           END AS ETATLIB

FROM AVOIRFC a
         LEFT JOIN magasin2 m ON m.id = a.IDMAGASIN
         LEFT JOIN VENTE v ON v.id = a.IDVENTE
         LEFT JOIN MOTIFAVOIRFC ma ON ma.id = a.IDMOTIF
         LEFT JOIN CATEGORIEAVOIRFC c ON c.id = a.IDCATEGORIE
         JOIN AVOIRFCFILLE_GRP ag ON ag.idavoirfc = a.id
         LEFT JOIN TIERS T ON T.ID = A.IDCLIENT
         left join TYPEAVOIR ta on ta.id = a.IDTYPEAVOIR;