-- CODAL2109.VENTEDETCALC source

CREATE OR REPLACE  VIEW VENTEDETCALC   AS 
  select vd.ID,vd.IDVENTE,vd.IDPRODUIT,vd.IDORIGINE,vd.QTE,vd.IDDEVISE,vd.TAUXDECHANGE,vd.DESIGNATION,vd.COMPTE,vd.IDBCFILLE,vd.UNITE,vd.POIDS,vd.RISTOURNE,vd.IDPREVISION,vd.PU,vd.REMISE,vd.TVA,vd.PUACHAT,vd.PUVENTE,vd.PUREVIENT,vd.REMISEMONTANT,vd.PHOTO,vd.REFERENCE,vd.MONTANT,
       --         vd.IDREMISE,vd.QTE_TMP,
       cast(vd.QTE * vd.pu as number(30, 2))                                     as montantNonRemise,
       cast(vd.QTE * vd.pu *
            ((nvl(vd.REMISE, 0) + nvl(vd.RISTOURNE, 0)) / 100) as number(30, 2)) as montantRemiseSansTva,
       cast((vd.QTE * vd.pu * (1 - (nvl(vd.REMISE, 0) / 100)) *
             (1 - (nvl(vd.RISTOURNE, 0) / 100))- NVL(v.fraislivraison, 0) * NVL(vd.POIDS, 0) * NVL(vd.QTE, 0)) as number(30, 2))                 as montantHT,
       cast(vd.pu * (1 - (nvl(vd.REMISE, 0) / 100)) *
            (1 - (nvl(vd.RISTOURNE, 0) / 100)) as number(30, 2))                 as puRemise,
       cast((vd.QTE * vd.pu * (1 - (nvl(vd.REMISE, 0) / 100)) * (1 - (nvl(vd.RISTOURNE, 0) / 100))- NVL(v.fraislivraison, 0) * NVL(vd.POIDS, 0) * NVL(vd.QTE, 0)) *
            nvl(vd.TAUXDECHANGE, 1) as number(30, 2))                            as montantHTAr,
       cast((vd.QTE * vd.pu * (1 - (nvl(vd.REMISE, 0) / 100)) * (1 - (nvl(vd.RISTOURNE, 0) / 100))- NVL(v.fraislivraison, 0) * NVL(vd.POIDS, 0) * NVL(vd.QTE, 0)) * nvl(vd.tva, 0) /
            100 as number(30, 2))                                                as montantTva,
       cast((vd.QTE * vd.pu * (1 - (nvl(vd.REMISE, 0) / 100)) * (1 - (nvl(vd.RISTOURNE, 0) / 100))- NVL(v.fraislivraison, 0) * NVL(vd.POIDS, 0) * NVL(vd.QTE, 0)) *
            nvl(vd.TAUXDECHANGE, 1) * nvl(vd.tva, 0) /
            100 as number(30, 2))                                                as montantTvaAr,
       cast((vd.QTE * vd.pu * (1 - (nvl(vd.REMISE, 0) / 100)) * (1 - (nvl(vd.RISTOURNE, 0) / 100))- NVL(v.fraislivraison, 0) * NVL(vd.POIDS, 0) * NVL(vd.QTE, 0)) *
            (1 + (nvl(vd.tva, 0) / 100)) as number(30, 2))                       as montantTTC,
       cast((vd.QTE * vd.pu * (1 - (nvl(vd.REMISE, 0) / 100)) * (1 - (nvl(vd.RISTOURNE, 0) / 100))- NVL(v.fraislivraison, 0) * NVL(vd.POIDS, 0) * NVL(vd.QTE, 0)) *
            (1 + (nvl(vd.tva, 0) / 100)) *
            nvl(vd.TAUXDECHANGE, 1) as number(30, 2))                            as montantTTCAr,
       cast(nvl(vd.PUREVIENT * vd.QTE, 0) as number(30, 2))                      as montantRevient,
       cast((vd.QTE * vd.pu * (1 - (nvl(vd.REMISE, 0) / 100)) * (1 - (nvl(vd.RISTOURNE, 0) / 100))- NVL(v.fraislivraison, 0) * NVL(vd.POIDS, 0) * NVL(vd.QTE, 0)) *
            (1 + (nvl(vd.tva, 0) / 100)) *
            nvl(vd.TAUXDECHANGE, 1) -
            nvl(vd.PUREVIENT * vd.QTE, 0) as number(30, 2))                    as margeBrute,v.ETAT
from VENTE_DETAILS vd join vente v on v.id=vd.IDVENTE
 ;



 
create or replace view VENTEMONTANT as
SELECT vd.IDVENTE as ID,
       cast(SUM((vd.MONTANTHT)) as number(30, 2))                          AS montanttotal,
       cast(SUM(vd.MONTANTREMISESANSTVA) as number(30, 2))                  AS montantremise,
       0                                                                                                    as frais,
       cast(SUM(MONTANTNONREMISE) as number(30, 2))                                             AS montanttotalachat,
       cast(SUM(MONTANTTVA) as number(30, 2))                                                                               AS montantTva,
       cast(SUM(MONTANTTTC) as number(30, 2))                          as montantTTC,
       NVL(vd.IDDEVISE, 'AR')                                                                                        AS IDDEVISE,
       NVL(avg(vd.tauxDeChange), 1)                                                                                  AS tauxDeChange,
       cast(SUM(MONTANTTTCAR) as number(30, 2))                        as montantTTCAR,
       cast(sum(vd.PUREVIENT * vd.QTE) as number(20, 2))                                                             as montantRevient,
       '' as IDRESERVATION
FROM VENTEDETCALC vd
GROUP BY vd.IDVENTE, vd.IDDEVISE
;

create or replace view VENTE_GRP_TOUS as
select IDVENTE,
       compte,
       cast(sum(montantHT) as NUMBER(30, 2)) as montantHT,
       cast(sum(montantTVA) as NUMBER(30, 2)) as montantTVA,
       cast(sum(montantTTC) as NUMBER(30, 2)) as montantTTC,
       cast(sum(montantTTCAr) as NUMBER(30, 2)) as montantTTCAr,
       cast(sum(MONTANTHTAR) as NUMBER(30, 2)) as MONTANTHTAR,
       cast(sum(MONTANTTVAAR) as NUMBER(30, 2)) as MONTANTTVAAR,
       ETAT,
       max(TAUXDECHANGE) AS TAUXDECHANGE
from VENTEDETCALC
group by IDVENTE, compte, etat;