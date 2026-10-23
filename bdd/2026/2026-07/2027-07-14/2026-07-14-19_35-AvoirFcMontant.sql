
create or replace view AVOIRFCMONTANT as
SELECT '-' as ID,
       '-' as DESIGNATION,
       '-' as IDMAGASIN,
       ''         AS IDMAGASINLIB,
       '-' as DATY,
       '-' as REMARQUE,
       11 as ETAT,
       a.IDORIGINE,
       a.IDCLIENT,
       '' as COMPTE,
       '' as compteauxiliaire,
       a.IDVENTE,
       '' AS IDVENTELIB,
       '-' as IDMOTIF,
       ''        AS IDMOTIFLIB,
       '-' as IDCATEGORIE,
       ''         AS IDCATEGORIELIB,
       '-' as IDDEVISE,
       1 as TAUXDECHANGE,
       sum(ag.MONTANTHT) as MONTANTHT,
       sum(ag.MONTANTTVA) as MONTANTTVA,
       sum(ag.MONTANTTTC) as MONTANTTTC,
       sum(ag.MONTANTHTAR) as MONTANTHTAR,
       sum(ag.MONTANTTVAAR) as MONTANTTVAAR,
       sum(ag.MONTANTTTCAR) as MONTANTTTCAR,
       '' as IDRESERVATION,
       ''        as Typeavoir,
       ''         as clientlib,
       sum(NVL(M.montant, 0) * NVL(ag.TAUXDECHANGE, 0)  )            AS MONTANTPAYEAR
FROM AVOIRFC a
         --LEFT JOIN magasin2 m ON m.id = a.IDMAGASIN
         --LEFT JOIN VENTE v ON v.id = a.IDVENTE
         --LEFT JOIN MOTIFAVOIRFC ma ON ma.id = a.IDMOTIF
         --LEFT JOIN CATEGORIEAVOIRFC c ON c.id = a.IDCATEGORIE
         JOIN AVOIRFCFILLE_GRP ag ON ag.idavoirfc = a.id
    --LEFT JOIN TIERS T ON T.ID = A.IDCLIENT
         LEFT JOIN MOUVEMENTCAISSEGRPAVOIR_LP M
                   ON A.ID = M.IDORIGINE
where a.ETAT>=11 and a.IDORIGINE is not null
group by a.IDORIGINE, a.IDCLIENT, a.IDVENTE ;

