create or replace view SITUATION_SALAIRE_AUTRE as
SELECT
    idpersonnel,
    idedition,
    mois,
    annee,
    SUM(CASE WHEN IDELEMENTPAIE = 'PR0000130'  THEN gain ELSE 0 END) AS heuresupp30ni,
    SUM(CASE WHEN IDELEMENTPAIE = 'PR0000130I' THEN gain ELSE 0 END) AS heuresupp30i,
    SUM(CASE WHEN IDELEMENTPAIE = 'PR0000150'  THEN gain ELSE 0 END) AS heuresupp50ni,
    SUM(CASE WHEN IDELEMENTPAIE = 'PR0000150I'  THEN gain ELSE 0 END) AS heuresupp50i,
    SUM(CASE WHEN IDELEMENTPAIE = 'PR0000221' THEN gain ELSE 0 END) AS majnuit,
    SUM(CASE WHEN IDELEMENTPAIE = 'PR0000222'  THEN gain ELSE 0 END) AS majferie,
    SUM(CASE WHEN IDELEMENTPAIE = 'PR0000223'  THEN gain ELSE 0 END) AS majweekend,
    SUM(CASE WHEN IDELEMENTPAIE = 'PR000181'  THEN gain ELSE 0 END) AS abbatement
FROM PAIE_EDITION pe
GROUP BY
    idpersonnel,idedition,mois,annee;

create or replace view V_PAIE_RECAP as
SELECT
    p.idpersonnel AS id,
    p.mois,
    p.annee,
    p.idedition,
    SUM(NVL(CASE WHEN p.regroupement = 1  THEN p.gain END, 0)) AS SALAIRE,
    SUM(NVL(CASE WHEN p.regroupement = 2  THEN p.gain END, 0)) AS HS_M,
    SUM(NVL(CASE WHEN p.regroupement = 3  THEN p.gain END, 0)) AS INDEM,
    SUM(NVL(CASE WHEN p.regroupement = 4  THEN p.gain END, 0)) AS ANCIEN,
    SUM(NVL(CASE WHEN p.regroupement = 5  THEN p.gain END, 0)) AS PRIME,
    SUM(NVL(CASE WHEN p.regroupement = 6  THEN p.gain END, 0)) AS AUTRES,
    SUM(NVL(CASE WHEN p.regroupement = 7  THEN p.gain END, 0)) AS TOTAL,
    SUM(NVL(CASE WHEN p.regroupement = 8  THEN p.retenue END, 0)) AS CNAPS,
    SUM(NVL(CASE WHEN p.regroupement = 9  THEN p.retenue END, 0)) AS OSTIE,
    SUM(NVL(CASE WHEN p.regroupement = 10 THEN p.retenue END, 0)) AS IRSA_E,
    SUM(NVL(CASE WHEN p.regroupement = 11 THEN p.retenue END, 0)) AS IRSA_S,
    SUM(NVL(CASE WHEN p.regroupement = 12 THEN p.retenue END, 0)) AS AV_SPE,
    SUM(NVL(CASE WHEN p.regroupement = 13 THEN p.retenue END, 0)) AS AUTRES2,
    SUM(NVL(CASE WHEN p.regroupement = 14 THEN p.gain END, 0)) AS A_PAYER
FROM
    PAIE_EDITION p
        LEFT JOIN log_personnel l ON l.id = p.idpersonnel
GROUP BY
    p.idedition,p.idpersonnel, p.mois, p.annee;

create or replace view SITUATION_SALAIRE_EDITION as
SELECT
    pinfo.matricule AS matricule,
    log.nom AS nom,
    v."ID",v."MOIS",v."ANNEE",v."IDEDITION",v."SALAIRE",v."HS_M",v."INDEM",v."ANCIEN",v."PRIME",v."AUTRES",v."TOTAL",v."CNAPS",v."OSTIE",v."IRSA_E",v."IRSA_S",v."AV_SPE",v."AUTRES2",v."A_PAYER"
FROM
    V_PAIE_RECAP v
        LEFT JOIN paie_info_personnel pinfo
                  ON v.id = pinfo.id
        LEFT JOIN log_personnel log
                  ON v.id = log.id;

create or replace view SITUATION_SALAIRE_AUTRE as
SELECT
    idpersonnel,
    idedition,
    mois,
    annee,
    SUM(CASE WHEN IDELEMENTPAIE = 'PR0000130'  THEN gain ELSE 0 END) AS heuresupp30ni,
    SUM(CASE WHEN IDELEMENTPAIE = 'PR0000130I' THEN gain ELSE 0 END) AS heuresupp30i,
    SUM(CASE WHEN IDELEMENTPAIE = 'PR0000150'  THEN gain ELSE 0 END) AS heuresupp50ni,
    SUM(CASE WHEN IDELEMENTPAIE = 'PR0000150I'  THEN gain ELSE 0 END) AS heuresupp50i,
    SUM(CASE WHEN IDELEMENTPAIE = 'PR0000221' THEN gain ELSE 0 END) AS majnuit,
    SUM(CASE WHEN IDELEMENTPAIE = 'PR0000222'  THEN gain ELSE 0 END) AS majferie,
    SUM(CASE WHEN IDELEMENTPAIE = 'PR0000223'  THEN gain ELSE 0 END) AS majweekend,
    SUM(CASE WHEN IDELEMENTPAIE = 'PR000181'  THEN gain ELSE 0 END) AS abbatement
FROM PAIE_EDITION pe
GROUP BY
    idpersonnel,idedition,mois,annee;


create or replace view SITUATION_SALAIRE_COMPLET as
SELECT se.MATRICULE,se.NOM,(se.ID||'//'||sa.idedition) AS id,se.MOIS,se.ANNEE,se.IDEDITION,se.SALAIRE,se.HS_M,se.INDEM,se.ANCIEN,se.PRIME,se.AUTRES,se.TOTAL,se.CNAPS,se.OSTIE,se.IRSA_E,se.IRSA_S,se.AV_SPE,se.AUTRES2,se.A_PAYER,sa.heuresupp30ni,heuresupp30i,heuresupp50ni,heuresupp50i,majnuit,majferie,majweekend,abbatement
FROM SITUATION_SALAIRE_EDITION se
         LEFT JOIN SITUATION_SALAIRE_AUTRE sa
                   ON se.idedition =sa.idedition
                       AND se.id = sa.idpersonnel;




