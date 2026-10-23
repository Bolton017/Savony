
create view VENTECPLJOUR_V2 as
select v.daty,
       v.idprovince,
       v.provincelib,
       sum(v.MONTANTTTC) as montant
from VENTE_CPL v
where v.ETAT >= 11
group by v.daty, v.idprovince, v.provincelib;



create view CA_JOUR_DETAILS_CA_V2 as
select vj2n.DATY,
       vj2n.JOUR,
       vj2n.semainemois,
       vj2n.MOIS,
       vj2n.ANNEE,
       vj2n.JOURLIB,
       cast(nvl(cj.MONTANT, 0) as number(38, 2)) as montant,
       js.id as idjoursemaine,
       vj2n.numerojoursemaine,
       cj.idprovince,
       cj.provincelib
from V_JOURS_2016_now vj2n
         left join VENTECPLJOUR_V2 cj on cj.DATY = vj2n.DATY
         left join joursemaine js on js.numsemaine = vj2n.semainemois and js.numjour = vj2n.numerojoursemaine;

create view VENTEDETCALC as
select vd."ID",vd."IDVENTE",vd."IDPRODUIT",vd."IDORIGINE",vd."QTE",vd."IDDEVISE",vd."TAUXDECHANGE",vd."DESIGNATION",vd."COMPTE",vd."IDBCFILLE",vd."UNITE",vd."POIDS",vd."RISTOURNE",vd."IDPREVISION",vd."PU",vd."REMISE",vd."TVA",vd."PUACHAT",vd."PUVENTE",vd."PUREVIENT",vd."REMISEMONTANT",vd."PHOTO",vd."REFERENCE",vd."MONTANT",
--         vd."IDREMISE",vd."QTE_TMP",
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
from VENTE_DETAILS vd join vente v on v.id=vd.IDVENTE;

create view VENTEDETCALCREMGLOVISE as
select vd.ID,
       IDVENTE,
       vd.DESIGNATION as idventeLib,
       vd.IDPRODUIT,
       ing.LIBELLE as idProduitLib,
       vd.IDORIGINE,
       QTE,
       qte as sum_qte,
       IDDEVISE,
       TAUXDECHANGE,
       vd.DESIGNATION,
       ing.CATEGORIEINGREDIENT as idcategorie,
       cat.VAL as idCategorieLib,
       v.DATY,
       v.IDMAGASIN,
       mag.VAL as idmagasinLib,
       mag.IDPOINT,
       p1.VAL as idpointLib,
       vd.IDDEVISE as idDeviseLib,
       v.IDRESERVATION,
       vd.COMPTE,
       IDBCFILLE,
       vd.UNITE,
       POIDS,
       RISTOURNE,
       IDPREVISION,
       vd.PU,
       vd.REMISE,
       vd.TVA,
       PUACHAT,
       PUVENTE,
       PUREVIENT,
--        IDREMISE,
       vd.REMISEMONTANT,
       vd.PHOTO,
--        QTE_TMP,
       vd.REFERENCE,
       ing.idTYPEPRODUIT,tp.VAL as TYPEPRODUITLIB,
       cli.IDPROVINCE,pro.VAL as IDPROVINCELIB,
       MONTANT,
       montantNonRemise,
       montantRemiseSansTva,
       montantHT,
       puRemise,
       montantHTAr,
       montantTva,
       montantTvaAr,
       montantTTC,
       montantTTCAr,
       montantTTCAr as montantTotal,
       montantTTCAr as montant_Total,
       cast((montantHTAr - NVL(v.FRAISLIVRAISON, 0) * NVL(ing.CALORIE, 0) * NVL(vd.QTE, 0))*(1+(nvl(vd.TVA,0)/100))*(1-(nvl(v.REMISE,0)/100)) as number(30,2)) as putotal,
       montantRevient,
       cast((NVL(v.FRAISLIVRAISON, 0) * NVL(ing.CALORIE, 0) * NVL(vd.QTE, 0))*(1+(nvl(vd.TVA,0)/100)) as number(30,2)) as montantlivraison,
       montantRevient as total_achat,
       cast(margeBrute as number(30,2)) as margeBrute,v.REMISE as remiseGlobal,v.IDCLIENT,cli.NOM as idclientlib,
       EXTRACT(MONTH FROM v.DATY) AS mois,
       TO_CHAR(v.DATY, 'Month', 'NLS_DATE_LANGUAGE = FRENCH') AS libelle_mois,
       EXTRACT(YEAR FROM v.DATY)  AS annee
from VenteDetCalc vd
         join vente v on v.ID = vd.IDVENTE
         left join AS_INGREDIENTS ing on vd.IDPRODUIT=ing.id
         left join categorieIngredient cat on ing.CATEGORIEINGREDIENT=cat.id
         left join magasin2 mag on mag.ID=v.IDMAGASIN
         left join point p1 on mag.IDPOINT=p1.ID
         left join CLIENT cli on cli.id=v.IDCLIENT
         left join PROVINCE pro on pro.ID=cli.IDPROVINCE
         left join TYPE_PRODUIT tp on tp.id=ing.idTYPEPRODUIT
where v.ETAT>=11 order by annee desc,EXTRACT(MONTH FROM v.DATY) desc;

