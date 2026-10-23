create or replace view OFFILLELIBQTERESTE as
SELECT
    ofll.ID,
    ofll.IDINGREDIENTS,
    ai.LIBELLE ||' '|| ofll.LIBELLE as LIBELLE,
    ai.LIBELLE as remarque,
    ofll.IDMERE,
    ofll.DATYBESOIN,
    (ofll.qte-nvl(fmf.qte,0)) as QTE,
    nvl(au.ID,'UNT00005') AS IDUNITE,
    fmf.qte AS qteFabrique,(ofll.qte-fmf.qte) AS qteReste,
    ofa.LIBELLE as libelleMere,fmf.daty,
    ofll.IDBCFILLE

FROM OFFILLE ofll
         LEFT JOIN AS_INGREDIENTS ai ON ai.ID = ofll.IDINGREDIENTS
         LEFT JOIN AS_UNITE au ON au.ID = ofll.IDUNITE
         LEFT JOIN FabricationMereFille fmf on fmf.IDOF=ofll.IDMERE and fmf.IDINGREDIENTS=ofll.IDINGREDIENTS
         left join OFAB ofa on ofa.id=ofll.IDMERE;



create or replace view VENTE_CPL_VISEE as
SELECT v.ID,
       v.DESIGNATION,
       v.IDMAGASIN,
       m.VAL AS IDMAGASINLIB,
       v.DATY,
       v.REMARQUE,
       v.ETAT,
       CASE
           WHEN v.ETAT = 1 THEN 'CREE'
           WHEN v.ETAT = 11 THEN 'VISEE'
           WHEN v.ETAT = 0 THEN 'ANNULEE'
           END
             AS ETATLIB,
       v2.MONTANTTOTAL,
       v2.IDDEVISE,
       v.IDCLIENT,
       c.NOM AS CLIENTLIB,
       cast(V2.MONTANTTVA as number(30,2)) as MONTANTTVA,
       cast(V2.MONTANTTTC as number(30,2)) as montantttc,
       cast(V2.MONTANTTTCAR as number(30,2)) as MONTANTTTCAR,
       cast(nvl(mv.credit,0)-nvl(ACG.MONTANTPAYE, 0) AS NUMBER(30,2)) AS montantpaye,
       cast(V2.MONTANTTTC-nvl(mv.credit,0)-nvl(ACG.resteapayer_avr, 0) AS NUMBER(30,2)) AS montantreste,
       nvl(ACG.MONTANTTTC_avr, 0)  as avoir,
       v2.tauxDeChange AS tauxDeChange,v2.MONTANTREVIENT,cast((V2.MONTANTTTCAR-v2.MONTANTREVIENT) as number(20,2))  as margeBrute,
       v.IDRESERVATION,
       v.IDORIGINE
FROM VENTE v
         LEFT JOIN CLIENT c ON c.ID = v.IDCLIENT
         LEFT JOIN MAGASIN m ON m.ID = v.IDMAGASIN
         JOIN VENTEMONTANT v2 ON v2.ID = v.ID
         LEFT JOIN mouvementcaisseGroupeFacture mv ON v.id=mv.IDORIGINE
         LEFT JOIN AVOIRFCLIB_CPL_GRP ACG on ACG.IDVENTE = v.ID
where v.ETAT = 11;




create or replace view FABRICATIONFILLECPL as
SELECT
    f."ID",f."IDINGREDIENTS",f."LIBELLE",f."REMARQUE",f."IDMERE",f."DATYBESOIN",f."QTE",f."IDUNITE",f."PU",
    ai.LIBELLE AS idingredientsLib,
    p.NOM || ' - ' || p.TELEPHONE as operateur
FROM FABRICATIONFILLE f
         LEFT JOIN AS_INGREDIENTS ai ON ai.id = f.IDINGREDIENTS
         left join PERSONNEL p on p.ID = f.OPERATEUR;




create or replace view VENTE_CPL_BC_VISEE as
SELECT v.ID,
       v.DESIGNATION,
       v.IDMAGASIN,
       m.VAL AS IDMAGASINLIB,
       v.DATY,
       v.REMARQUE,
       v.ETAT,
       CASE
           WHEN v.ETAT = 1 THEN 'CREE'
           WHEN v.ETAT = 11 THEN 'VISEE'
           WHEN v.ETAT = 0 THEN 'ANNULEE'
           END
             AS ETATLIB,
       v2.MONTANTTOTAL,
       v2.IDDEVISE,
       v.IDCLIENT,
       c.NOM AS CLIENTLIB,
       cast(V2.MONTANTTVA as number(30,2)) as MONTANTTVA,
       cast(V2.MONTANTTTC as number(30,2)) as montantttc,
       cast(V2.MONTANTTTCAR as number(30,2)) as MONTANTTTCAR,
       cast(nvl(mv.credit,0)-nvl(ACG.MONTANTPAYE, 0) AS NUMBER(30,2)) AS montantpaye,
       cast(V2.MONTANTTTC-nvl(mv.credit,0)-nvl(ACG.resteapayer_avr, 0) AS NUMBER(30,2)) AS montantreste,
       nvl(ACG.MONTANTTTC_avr, 0)  as avoir,
       v2.tauxDeChange AS tauxDeChange,v2.MONTANTREVIENT,cast((V2.MONTANTTTCAR-v2.MONTANTREVIENT) as number(20,2))  as margeBrute,
       v.IDRESERVATION,
       asbl.IDBC as IDORIGINE
FROM VENTE v
         LEFT JOIN CLIENT c ON c.ID = v.IDCLIENT
         LEFT JOIN MAGASIN m ON m.ID = v.IDMAGASIN
         JOIN VENTEMONTANT v2 ON v2.ID = v.ID
         LEFT JOIN mouvementcaisseGroupeFacture mv ON v.id=mv.IDORIGINE
         LEFT JOIN AVOIRFCLIB_CPL_GRP ACG on ACG.IDVENTE = v.ID
         left join AS_BONDELIVRAISON_CLIENT asbl on asbl.ID = v.IDORIGINE
where v.ETAT = 11
    /