
create or replace view TARIF_INGREDIENTS_MAX as
select IDINGREDIENT,UNITE,IDTYPECLIENT,PRIXUNITAIRE,max(DATY) as daty from TARIF_INGREDIENTS group by IDINGREDIENT,UNITE,IDTYPECLIENT,PRIXUNITAIRE;

create or replace view AS_INGREDIENT_VENTE_LIB as
select ing.*,ting.PRIXUNITAIRE,TING.IDTYPECLIENT,tc.VAL as idtypeclientlib,un.id as idunite,un.VAL as idunitelib,eq.POIDS,eq.QTE from AS_INGREDIENTS ing
      join TARIF_INGREDIENTS_MAX ting on ing.ID=TING.IDINGREDIENT
      join AS_UNITE un on un.ID=TING.UNITE
      join TYPECLIENT tc on tc.ID=TING.IDTYPECLIENT
      join EQUIVALENCE eq on eq.IDPRODUIT=ting.IDINGREDIENT and eq.IDUNITE=ting.UNITE;


alter table AS_INGREDIENTS add idmagasin varchar2(50);

create view PROFORMA_DETAILS_VIDE as
select p.*,'' as unitelib,0 as punet,0 as montantht,0 as montantttc from PROFORMA_DETAILS p;

create view BONDECOMMANDE_CLIENT_FILLE_V as
select p.*,'' as unitelib,0 as punet,0 as montantht,0 as montantttc  from BONDECOMMANDE_CLIENT_FILLE p;

alter table VENTE_DETAILS add unite varchar(50);

alter table VENTE add modepaiement varchar(50);

create or replace view BC_CLIENT_FILLE_CPL_LIBB as
SELECT
    bcf.ID,
    bcf.PRODUIT,
    bcf.IDBC,
    bcf.QUANTITE,
    bcf.PU,
    (nvl(nvl(bcf.QUANTITE,0)*nvl(bcf.PU,0),0)*bcf.REMISE)/100 as montantremise,
    nvl(bcf.QUANTITE,0)*nvl(bcf.PU,0)-((nvl(nvl(bcf.QUANTITE,0)*nvl(bcf.PU,0),0)*bcf.REMISE)/100)+((((nvl(bcf.QUANTITE,0)*nvl(bcf.PU,0)-(nvl(nvl(bcf.QUANTITE,0)*nvl(bcf.PU,0),0)*bcf.REMISE)/100)*bcf.tva)/100)) as montanttotal,
    bcf.MONTANT as montant,
    bcf.TVA,
    (((nvl(bcf.QUANTITE,0)*nvl(bcf.PU,0)-(nvl(nvl(bcf.QUANTITE,0)*nvl(bcf.PU,0),0)*bcf.REMISE)/100)*bcf.tva)/100) as montanttva,
    bcf.REMISE,
    bcf.IDDEVISE,
    bcf.UNITE,
    u.VAL AS unitelib,
    i.LIBELLE AS PRODUITlib,
    i.compte_vente AS compte,
    GREATEST(NVL(bcf.quantite, 0) - NVL(vdbc.qte, 0), 0) AS qtereste
FROM
    bondecommande_client_fille bcf
        JOIN as_ingredients i ON i.id = bcf.PRODUIT
        join AS_UNITE u ON u.id = bcf.unite
        LEFT JOIN vente_details_qte_grp vdbc ON bcf.id = vdbc.idbcfille
        /


create or replace view BC_CLIENT_FILLE_CPL_LIB as
SELECT
    bcf.ID,
    bcf.PRODUIT,
    bcf.IDBC,
    bcf.QUANTITE,
    bcf.PU,
    (nvl(nvl(bcf.QUANTITE,0)*nvl(bcf.PU,0)+(nvl(bcf.QUANTITE,0)*nvl(bcf.PU,0)*bcf.tva)/100,0)*bcf.REMISE)/100 as montantremise,
    nvl(bcf.QUANTITE,0)*nvl(bcf.PU,0)+(nvl(bcf.QUANTITE,0)*nvl(bcf.PU,0)*bcf.tva)/100-((nvl(nvl(bcf.QUANTITE,0)*nvl(bcf.PU,0)+(nvl(bcf.QUANTITE,0)*nvl(bcf.PU,0)*bcf.tva)/100,0)*bcf.REMISE)/100) as montant,
    bcf.MONTANT as montantbc,
    bcf.TVA,
    (nvl(bcf.QUANTITE,0)*nvl(bcf.PU,0)*bcf.tva)/100 as montanttva,
    bcf.REMISE,
    bcf.IDDEVISE,
    bcf.UNITE,
    u.VAL AS unitelib,
    i.LIBELLE AS PRODUITlib,
    i.compte_vente AS compte,
    GREATEST(NVL(bcf.quantite, 0) - NVL(vdbc.qte, 0), 0) AS qtereste
FROM
    bondecommande_client_fille bcf
        JOIN as_ingredients i ON i.id = bcf.PRODUIT
        join AS_UNITE u ON u.id = bcf.unite
        LEFT JOIN vente_details_qte_grp vdbc ON bcf.id = vdbc.idbcfille
        /

create or replace view INSERTION_VENTE as
SELECT
    v.ID,
    v.DESIGNATION,
    v.IDMAGASIN,
    v.DATY,
    v.REMARQUE,
    v.ETAT,
    v.IDORIGINE,
    v.IDCLIENT,
    CAST(' ' AS varchar(100)) AS iddevise,
    v.ESTPREVU,
    v.DATYPREVU,
    v.IDRESERVATION,
    v.echeancefacture,
    v.modepaiement
FROM VENTE v


create or replace view VENTE_DETAILS_VIDE as
select p.*,u.VAL as unitelib,pu - (pu * remise / 100) + ((pu * tva / 100)) as punet,(pu - (pu * remise / 100)) * qte as montantht,(pu - (pu * remise / 100) + ((pu * tva / 100)))*qte as montantttc,(pu * tva / 100)*qte as montanttva,(pu * remise / 100)*qte as montantremise,(pu)*qte as montant   from VENTE_DETAILS p
join AS_UNITE u on u.id = p.unite;


create or replace view VENTE_DETAILS_POIDS as
select v.*,nvl(e.POIDS,0)*nvl(v.QTE,0) as poids from VENTE_DETAILS_VIDE v join EQUIVALENCE e on e.IDPRODUIT = v.IDPRODUIT and e.IDUNITE = v.unite;

create view VENTE_POIDS as
select IDVENTE,sum(poids) as poids from VENTE_DETAILS_POIDS group by IDVENTE;

select * from VENTE_CPL;

create or replace view VENTE_CPL as
SELECT v.ID,
       v.DESIGNATION,
       v.IDMAGASIN,
       m.VAL AS IDMAGASINLIB,
       v.DATY,
       v.REMARQUE,
       v.ETAT,
       CASE
           WHEN v.ETAT = 1 THEN 'CREE'
           WHEN v.ETAT = 11 THEN 'VISE'
           WHEN v.ETAT = 0 THEN 'ANNULE'
           END
             AS ETATLIB,
       v2.MONTANTTOTAL,
       v2.IDDEVISE,
       v.IDCLIENT,
       c.NOM AS IDCLIENTLIB,
       cast(V2.MONTANTTVA as number(30,2)) as MONTANTTVA,
       cast(V2.MONTANTTTC as number(30,2)) as montantttc,
       cast(V2.MONTANTTTCAR as number(30,2)) as MONTANTTTCAR,
       cast(nvl(mv.montant,0)-nvl(ACG.MONTANTPAYE, 0) AS NUMBER(30,2)) AS montantpaye,
       cast(V2.MONTANTTTC-nvl(mv.montant,0)-nvl(ACG.resteapayer_avr, 0) AS NUMBER(30,2)) AS montantreste,
       cast(nvl(ACG.MONTANTTTC_avr, 0) as number(30,2))  as avoir,
       v2.tauxDeChange AS tauxDeChange,v2.MONTANTREVIENT,cast((V2.MONTANTTTCAR-v2.MONTANTREVIENT) as number(20,2))  as margeBrute,
       v.IDRESERVATION,
       case when v.DATYPREVU is null then daty else V.DATYPREVU end as datyprevu,
       rf.REFERENCE as referencefacture,
       v2.MONTANTREMISE,
       nvl(v2.MONTANTTOTAL,0)+nvl(v2.MONTANTREMISE,0) as montant,
       extract(month from DATY) as mois,
       extract(year from DATY) as annee,
       vp.poids,
       v.modepaiement,
       mp.VAL as modepaiementlib
FROM VENTE v
         LEFT JOIN CLIENT c ON c.ID = v.IDCLIENT
         LEFT JOIN MAGASINPOINT m ON m.ID = v.IDMAGASIN
         JOIN VENTEMONTANT v2 ON v2.ID = v.ID
         LEFT JOIN LIAISONPAIEMENTTOTAL mv ON v.id=mv.id2
         LEFT JOIN AVOIRFCLIB_CPL_GRP ACG on ACG.IDVENTE = v.ID
         LEFT JOIN REFERENCEFACTURE rf ON rf.idfacture=v.Id
         left join vente_poids vp on vp.idvente=v.id
         left join MODEPAIEMENT mp on mp.id=v.modepaiement
    /



create or replace view vente_origine as
select IDORIGINE,count(*) as nombre from VENTE where ETAT>=11 group by IDORIGINE;

alter table BONDECOMMANDE_CLIENT add modelivraison number;

create or replace view BONDECOMMANDE_CLIENT_CPL as
SELECT
    bc.ID,
    bc.DATY,
    bc.ETAT,
    bc.REMARQUE,
    bc.DESIGNATION,
    bc.MODEPAIEMENT,
    m.VAL AS MODEPAIEMENTLIB,
    bc.IDCLIENT,
    c.NOM AS IDCLIENTLIB,
    bc.REFERENCE,
    m2.VAL AS IDMAGASINLIB,
    CASE
        WHEN bc.ETAT = 0 THEN '<span style=color: green;>ANNULEE</span>'
        WHEN bc.ETAT = 1 THEN '<span style=color: green;>CREEE</span>'
        WHEN bc.ETAT = 11 THEN '<span style=color: green;>VALIDEE</span>'
        END AS ETATLIB,
    bc.IDPROFORMA,
    nvl(vo.nombre,0) as nbfacture,
    CASE
        WHEN bc.modelivraison = 1 THEN '<span style=color: green;>LIVRAISON</span>'
        WHEN bc.modelivraison = 2 THEN '<span style=color: green;>RECUPERATION</span>'
        END AS modelivraisonlib
FROM BONDECOMMANDE_CLIENT bc
         LEFT JOIN CLIENT c ON c.id = bc.IDCLIENT
         LEFT JOIN MODEPAIEMENT m ON m.id = bc.MODEPAIEMENT
         LEFT JOIN MAGASIN2 m2 ON m2.id = bc.IDMAGASIN
         left join vente_origine vo on vo.IDORIGINE=bc.id
    /


create or replace view VENTE_CPL as
SELECT v.ID,
       v.DESIGNATION,
       v.IDMAGASIN,
       m.VAL AS IDMAGASINLIB,
       v.DATY,
       v.REMARQUE,
       v.ETAT,
       CASE
           WHEN v.ETAT = 1 THEN 'CREE'
           WHEN v.ETAT = 11 THEN 'VISE'
           WHEN v.ETAT = 0 THEN 'ANNULE'
           END
             AS ETATLIB,
       v2.MONTANTTOTAL,
       v2.IDDEVISE,
       v.IDCLIENT,
       c.NOM AS IDCLIENTLIB,
       cast(V2.MONTANTTVA as number(30,2)) as MONTANTTVA,
       cast(V2.MONTANTTTC as number(30,2)) as montantttc,
       cast(V2.MONTANTTTCAR as number(30,2)) as MONTANTTTCAR,
       cast(nvl(mv.montant,0)-nvl(ACG.MONTANTPAYE, 0) AS NUMBER(30,2)) AS montantpaye,
       cast(V2.MONTANTTTC-nvl(mv.montant,0)-nvl(ACG.resteapayer_avr, 0) AS NUMBER(30,2)) AS montantreste,
       cast(nvl(ACG.MONTANTTTC_avr, 0) as number(30,2))  as avoir,
       v2.tauxDeChange AS tauxDeChange,v2.MONTANTREVIENT,cast((V2.MONTANTTTCAR-v2.MONTANTREVIENT) as number(20,2))  as margeBrute,
       v.IDRESERVATION,
       case when v.DATYPREVU is null then daty else V.DATYPREVU end as datyprevu,
       rf.REFERENCE as referencefacture,
       v2.MONTANTREMISE,
       nvl(v2.MONTANTTOTAL,0)+nvl(v2.MONTANTREMISE,0) as montant,
       extract(month from DATY) as mois,
       extract(year from DATY) as annee,
       vp.poids,
       v.modepaiement,
       mp.VAL as modepaiementlib,
       nvl(v.fraislivraison,0)*nvl(vp.poids,0) as fraislivraison,
       v.modelivraison,
       CASE
           WHEN v.modelivraison = 1 THEN '<span style=color: green;>LIVRAISON</span>'
           WHEN v.modelivraison = 2 THEN '<span style=color: green;>RECUPERATION</span>'
           END AS modelivraisonlib
FROM VENTE v
         LEFT JOIN CLIENT c ON c.ID = v.IDCLIENT
         LEFT JOIN MAGASINPOINT m ON m.ID = v.IDMAGASIN
         JOIN VENTEMONTANT v2 ON v2.ID = v.ID
         LEFT JOIN LIAISONPAIEMENTTOTAL mv ON v.id=mv.id2
         LEFT JOIN AVOIRFCLIB_CPL_GRP ACG on ACG.IDVENTE = v.ID
         LEFT JOIN REFERENCEFACTURE rf ON rf.idfacture=v.Id
         left join vente_poids vp on vp.idvente=v.id
         left join MODEPAIEMENT mp on mp.id=v.modepaiement
    /



alter table vente add modelivraison number;
alter table vente add fraislivraison number(30,2);

create or replace view INSERTION_VENTE as
SELECT
    v.ID,
    v.DESIGNATION,
    v.IDMAGASIN,
    v.DATY,
    v.REMARQUE,
    v.ETAT,
    v.IDORIGINE,
    v.IDCLIENT,
    CAST(' ' AS varchar(100)) AS iddevise,
    v.ESTPREVU,
    v.DATYPREVU,
    v.IDRESERVATION,
    v.echeancefacture,
    v.modepaiement,
    v.modelivraison,
    v.fraislivraison
FROM VENTE v
    /


create or replace view VENTE_CPL as
SELECT v.ID,
       v.DESIGNATION,
       v.IDMAGASIN,
       m.VAL AS IDMAGASINLIB,
       v.DATY,
       v.REMARQUE,
       v.ETAT,
       CASE
           WHEN v.ETAT = 1 THEN 'CREE'
           WHEN v.ETAT = 11 THEN 'VISE'
           WHEN v.ETAT = 0 THEN 'ANNULE'
           END
             AS ETATLIB,
       v2.MONTANTTOTAL,
       v2.IDDEVISE,
       v.IDCLIENT,
       c.NOM AS IDCLIENTLIB,
       cast(V2.MONTANTTVA as number(30,2)) as MONTANTTVA,
       cast(V2.MONTANTTTC as number(30,2)) as montantttc,
       cast(V2.MONTANTTTCAR as number(30,2)) as MONTANTTTCAR,
       cast(nvl(mv.montant,0)-nvl(ACG.MONTANTPAYE, 0) AS NUMBER(30,2)) AS montantpaye,
       cast(V2.MONTANTTTC-nvl(mv.montant,0)-nvl(ACG.resteapayer_avr, 0) AS NUMBER(30,2)) AS montantreste,
       cast(nvl(ACG.MONTANTTTC_avr, 0) as number(30,2))  as avoir,
       v2.tauxDeChange AS tauxDeChange,v2.MONTANTREVIENT,cast((V2.MONTANTTTCAR-v2.MONTANTREVIENT) as number(20,2))  as margeBrute,
       v.IDRESERVATION,
       case when v.DATYPREVU is null then daty else V.DATYPREVU end as datyprevu,
       rf.REFERENCE as referencefacture,
       v2.MONTANTREMISE,
       nvl(v2.MONTANTTOTAL,0)+nvl(v2.MONTANTREMISE,0) as montant,
       extract(month from DATY) as mois,
       extract(year from DATY) as annee,
       vp.poids,
       v.modepaiement,
       mp.VAL as modepaiementlib,
       nvl(v.fraislivraison,0)*nvl(vp.poids,0) as fraislivraison,
       v.modelivraison,
       CASE
           WHEN v.modelivraison = 1 THEN '<span style=color: green;>LIVRAISON</span>'
           WHEN v.modelivraison = 2 THEN '<span style=color: green;>RECUPERATION</span>'
           END AS modelivraisonlib
FROM VENTE v
         LEFT JOIN CLIENT c ON c.ID = v.IDCLIENT
         LEFT JOIN MAGASINPOINT m ON m.ID = v.IDMAGASIN
         JOIN VENTEMONTANT v2 ON v2.ID = v.ID
         LEFT JOIN LIAISONPAIEMENTTOTAL mv ON v.id=mv.id2
         LEFT JOIN AVOIRFCLIB_CPL_GRP ACG on ACG.IDVENTE = v.ID
         LEFT JOIN REFERENCEFACTURE rf ON rf.idfacture=v.Id
         left join vente_poids vp on vp.idvente=v.id
         left join MODEPAIEMENT mp on mp.id=v.modepaiement
    /


create or replace view VENTE_DETAILS_RESTE as
SELECT
    vd.id AS id,
    vd.idProduit,
    vd.UNITE as idunite,
    u.VAL AS unitelib,
    vd.qte AS QTE,
    nvl(vd.QTE,0) - nvl(bl.QUANTITE,0) AS reste,
    vd.IDVENTE AS IDVENTE
FROM
    VENTE_DETAILS vd LEFT JOIN
    BL_CLIENT_FILLE_grp_vente bl ON vd.ID = bl.idventedetail
                     LEFT JOIN AS_INGREDIENTS p ON
        p.id = vd.IDPRODUIT
                     left join AS_UNITE u on u.id = vd.unite
        /

create or replace view AS_BLCLFILLEGRP_VENTE_CPL_V as
SELECT
    a.PRODUIT ,
    a.IDPRODUITLIB,
    a.IDVENTE,
    abc.daty,
    nvl( sum(QUANTITE) ,0) AS QUANTITE,
    a.UNITE,
    u.VAL AS unitelib
FROM AS_BONLIVRFILLE_CLIENT_CPL a
         LEFT JOIN AS_BONDELIVRAISON_CLIENT abc ON abc.id = a.numbl
         left join AS_UNITE u on u.id = a.unite
WHERE abc.etat = 11
GROUP BY a.IDPRODUITLIB,
         a.IDVENTE,a.PRODUIT,abc.daty, a.UNITE,u.val
             /


create or replace view VENTEMONTANT as
SELECT v.ID,
       cast(SUM ((1-nvl(vd.remise/100,0))*(NVL (vd.QTE, 0) * NVL (vd.PU, 0)) - (nvl(v.fraislivraison,0)*nvl(vp.poids,0))) as number(30,2)) AS montanttotal,
       cast(SUM ((NVL (vd.QTE, 0) * NVL (vd.PU, 0))) - SUM ((1-nvl(vd.remise/100,0))*(NVL (vd.QTE, 0) * NVL (vd.PU, 0))) as number(30,2)) AS montantremise,
       cast(nvl(v.fraislivraison,0)*nvl(vp.poids,0) as number(30,2)) as frais,
       cast(SUM ( (NVL (vd.QTE, 0) * NVL (vd.PuAchat, 0))) as number(30,2)) AS montanttotalachat,
       cast(SUM ((1-nvl(vd.remise/100,0))* (NVL (vd.QTE, 0) * NVL (vd.PU, 0))* (NVL (VD.TVA , 0))/100) as number(30,2)) AS montantTva,
       cast(SUM ((1-nvl(vd.remise/100,0))* (NVL (vd.QTE, 0) * NVL (vd.PU, 0))* (NVL (VD.TVA , 0))/100)+SUM ((1-nvl(vd.remise/100,0))* (NVL (vd.QTE, 0) * NVL (vd.PU, 0))) - (nvl(v.fraislivraison,0)*nvl(vp.poids,0)) as number(30,2))  as montantTTC,
       NVL (vd.IDDEVISE,'AR') AS IDDEVISE,
       NVL(avg(vd.tauxDeChange),1 ) AS tauxDeChange,
       cast(SUM ( (1-nvl(vd.remise/100,0))*(NVL (vd.QTE, 0) * NVL (vd.PU, 0)*NVL(VD.TAUXDECHANGE,1) )* (NVL (VD.TVA , 0))/100)+SUM ((1-nvl(vd.remise/100,0))* (NVL (vd.QTE, 0) * NVL (vd.PU, 0)*NVL(VD.TAUXDECHANGE,1)) - (nvl(v.fraislivraison,0)*NVL(VD.TAUXDECHANGE,1)*nvl(vp.poids,0)))as number(30,2)) as montantTTCAR,
       cast(sum(vd.PUREVIENT*vd.QTE) as number(20,2)) as montantRevient  ,
       v.IDRESERVATION
FROM VENTE_DETAILS vd LEFT JOIN VENTE v ON v.ID = vd.IDVENTE
                      left join vente_poids vp on vp.idvente=v.id
GROUP BY v.ID, vd.IDDEVISE,v.IDRESERVATION,v.fraislivraison,
         vp.poids
             /

create or replace view VENTE_RESTE as
select IDVENTE,sum(reste) reste from VENTE_DETAILS_RESTE group by IDVENTE;


create or replace view VENTE_CPL as
SELECT v.ID,
       v.DESIGNATION,
       v.IDMAGASIN,
       m.VAL AS IDMAGASINLIB,
       v.DATY,
       v.REMARQUE,
       v.ETAT,
       CASE
           WHEN v.ETAT = 1 THEN 'CREE'
           WHEN v.ETAT = 11 THEN 'VISE'
           WHEN v.ETAT = 0 THEN 'ANNULE'
           END
             AS ETATLIB,
       v2.MONTANTTOTAL,
       v2.IDDEVISE,
       v.IDCLIENT,
       c.NOM AS IDCLIENTLIB,
       cast(V2.MONTANTTVA as number(30,2)) as MONTANTTVA,
       cast(V2.MONTANTTTC as number(30,2)) as montantttc,
       cast(V2.MONTANTTTCAR as number(30,2)) as MONTANTTTCAR,
       cast(nvl(mv.montant,0)-nvl(ACG.MONTANTPAYE, 0) AS NUMBER(30,2)) AS montantpaye,
       cast(V2.MONTANTTTC-nvl(mv.montant,0)-nvl(ACG.resteapayer_avr, 0) AS NUMBER(30,2)) AS montantreste,
       cast(nvl(ACG.MONTANTTTC_avr, 0) as number(30,2))  as avoir,
       v2.tauxDeChange AS tauxDeChange,v2.MONTANTREVIENT,cast((V2.MONTANTTTCAR-v2.MONTANTREVIENT) as number(20,2))  as margeBrute,
       v.IDRESERVATION,
       case when v.DATYPREVU is null then daty else V.DATYPREVU end as datyprevu,
       rf.REFERENCE as referencefacture,
       v2.MONTANTREMISE,
       nvl(v2.MONTANTTOTAL,0)+nvl(v2.MONTANTREMISE,0) as montant,
       extract(month from DATY) as mois,
       extract(year from DATY) as annee,
       vp.poids,
       v.modepaiement,
       mp.VAL as modepaiementlib,
       nvl(v.fraislivraison,0)*nvl(vp.poids,0) as fraislivraison,
       v.modelivraison,
       CASE
           WHEN v.modelivraison = 1 THEN '<span style=color: green;>LIVRAISON</span>'
           WHEN v.modelivraison = 2 THEN '<span style=color: green;>RECUPERATION</span>'
           END AS modelivraisonlib,
       vr.reste
FROM VENTE v
         LEFT JOIN CLIENT c ON c.ID = v.IDCLIENT
         LEFT JOIN MAGASINPOINT m ON m.ID = v.IDMAGASIN
         JOIN VENTEMONTANT v2 ON v2.ID = v.ID
         LEFT JOIN LIAISONPAIEMENTTOTAL mv ON v.id=mv.id2
         LEFT JOIN AVOIRFCLIB_CPL_GRP ACG on ACG.IDVENTE = v.ID
         LEFT JOIN REFERENCEFACTURE rf ON rf.idfacture=v.Id
         left join vente_poids vp on vp.idvente=v.id
         left join MODEPAIEMENT mp on mp.id=v.modepaiement
         left join vente_reste vr on vr.idvente=v.id
    /


create or replace view VENTE_DETAILS_POIDS as
select v."ID",v."IDVENTE",v."IDPRODUIT",v."IDORIGINE",v."QTE",v."PU",v."REMISE",v."TVA",v."PUACHAT",v."PUVENTE",v."IDDEVISE",v."TAUXDECHANGE",v."DESIGNATION",v."COMPTE",v."PUREVIENT",v."IDBCFILLE",v."UNITE",v."UNITELIB",v."PUNET",v."MONTANTHT",v."MONTANTTTC",v."MONTANTTVA",v."MONTANTREMISE",v."MONTANT",
       nvl(e.POIDS,0)*nvl(v.QTE,0) as poids,
       vc.reste as reste,
       ve.fraislivraison*nvl(e.POIDS,0)*nvl(v.QTE,0) as frais
from VENTE_DETAILS_VIDE v join EQUIVALENCE e on e.IDPRODUIT = v.IDPRODUIT and e.IDUNITE = v.unite
                          left join VENTE_DETAILS_RESTE vc on vc.ID = v.ID
                          left join Vente ve on ve.ID = v.IDVENTE
    /



