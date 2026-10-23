
alter table AS_BONDELIVRAISON_CLIENT add description varchar(250);
alter table AS_BONDELIVRAISON_CLIENT add vehicule varchar(250);
alter table AS_BONDELIVRAISON_CLIENT add chauffeur varchar(250);


create or replace view AS_BONDELIVRAISON_CLIENT_CPL as
SELECT bl.id, bl.remarque,
v.id AS idvente,
v.designation,
bl.idbc, bl.daty, bl.etat,
m.id AS idmagasin,
m.val AS magasin,
v.IDRESERVATION,
c.nom AS IDCLIENTlib,
bl.vehicule,
bl.chauffeur,
bl.description
FROM AS_BONDELIVRAISON_CLIENT bl
LEFT JOIN MAGASINPOINT m ON bl.magasin=m.id
LEFT JOIN vente v ON v.id=bl.idvente
LEFT JOIN client c ON c.ID = bl.IDCLIENT;


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
       v.IDORIGINE,
       bl.id as idbl
FROM VENTE v
         LEFT JOIN CLIENT c ON c.ID = v.IDCLIENT
         LEFT JOIN MAGASIN m ON m.ID = v.IDMAGASIN
         JOIN VENTEMONTANT v2 ON v2.ID = v.ID
         LEFT JOIN mouvementcaisseGroupeFacture mv ON v.id=mv.IDORIGINE
         LEFT JOIN AVOIRFCLIB_CPL_GRP ACG on ACG.IDVENTE = v.ID
         left join AS_BONDELIVRAISON_CLIENT bl on bl.IDVENTE = v.id
where v.ETAT = 11
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
       cast(V2.MONTANTTTC-nvl(mv.montant,0) AS NUMBER(30,2)) AS montantreste,
       cast(nvl(ACG.MONTANTTTC_avr, 0) as number(30,2)) as avoir,
       v2.tauxDeChange AS tauxDeChange,v2.MONTANTREVIENT,cast((V2.MONTANTTTCAR-v2.MONTANTREVIENT) as number(20,2))  as margeBrute,
       v.IDRESERVATION,
       case when v.DATYPREVU is null then v.daty else V.DATYPREVU end as datyprevu,
       rf.REFERENCE as referencefacture,
       v2.MONTANTREMISE,
       nvl(v2.MONTANTTOTAL,0)+nvl(v2.MONTANTREMISE,0) as montant,
       extract(month from v.DATY) as mois,
       extract(year from v.DATY) as annee,
       vp.poids,
       v.modepaiement,
       mp.VAL as modepaiementlib,
       nvl(v.fraislivraison,0)*nvl(vp.poids,0) as fraislivraison,
       v.modelivraison,
       CASE
            WHEN v.modelivraison = 1 THEN '<span style=color: green;>LIVRAISON</span>'
            WHEN v.modelivraison = 2 THEN '<span style=color: green;>RECUPERATION</span>'
        END AS modelivraisonlib,
       vr.reste,
       pv.id as idprovince,
       pv.val as provincelib,
       bl.id as idbl,
       v.IDORIGINE
FROM VENTE v
         LEFT JOIN CLIENT c ON c.ID = v.IDCLIENT
        left join PROVINCE pv on pv.id = c.IDPROVINCE
         LEFT JOIN MAGASINPOINT m ON m.ID = v.IDMAGASIN
         JOIN VENTEMONTANT v2 ON v2.ID = v.ID
         LEFT JOIN LIAISONPAIEMENTTOTAL mv ON v.id=mv.id2
         LEFT JOIN AVOIRFCLIB_CPL_GRP ACG on ACG.IDVENTE = v.ID
         LEFT JOIN REFERENCEFACTURE rf ON rf.idfacture=v.Id
         left join vente_poids vp on vp.idvente=v.id
         left join MODEPAIEMENT mp on mp.id=v.modepaiement
         left join vente_reste vr on vr.idvente=v.id
left join AS_BONDELIVRAISON_CLIENT bl on bl.IDVENTE = v.id
/

INSERT INTO AS_INGREDIENTS (ID, LIBELLE, SEUIL, UNITE, QUANTITEPARPACK, PU, ACTIF, PHOTO, CALORIE, DURRE, COMPOSE, CATEGORIEINGREDIENT, IDFOURNISSEUR, DATY, QTELIMITE, PV, LIBELLEVENTE, SEUILMIN, SEUILMAX, PUACHATUSD, PUACHATEURO, PUACHATAUTREDEVISE, PUVENTEUSD, PUVENTEEURO, PUVENTEAUTREDEVISE, ISVENTE, ISACHAT, COMPTE_VENTE, COMPTE_ACHAT, LIBELLEEXTACTE, TVA, FILEPATH, RESTE, TYPESTOCK, REFPOST, REFQUALIFICATION, IDCHAMBRE, ISPERISHABLE, PV2, IDMAGASIN) VALUES ('ING00V00001', '06 Petits beurre/lait', 0.00, 'UNT00005', 0.00, 0.00, 1, null, 0.00, null, 1, 'CAT008', null, null, 0.00, 0.00, null, null, null, null, null, null, null, 0.00, null, null, null, '707110', '602100', null, 0.00, null, 0.00, 'CUMP', 'EX000041', 'QUAL0032', null, null, null, 'PHARM005');
INSERT INTO AS_INGREDIENTS (ID, LIBELLE, SEUIL, UNITE, QUANTITEPARPACK, PU, ACTIF, PHOTO, CALORIE, DURRE, COMPOSE, CATEGORIEINGREDIENT, IDFOURNISSEUR, DATY, QTELIMITE, PV, LIBELLEVENTE, SEUILMIN, SEUILMAX, PUACHATUSD, PUACHATEURO, PUACHATAUTREDEVISE, PUVENTEUSD, PUVENTEEURO, PUVENTEAUTREDEVISE, ISVENTE, ISACHAT, COMPTE_VENTE, COMPTE_ACHAT, LIBELLEEXTACTE, TVA, FILEPATH, RESTE, TYPESTOCK, REFPOST, REFQUALIFICATION, IDCHAMBRE, ISPERISHABLE, PV2, IDMAGASIN) VALUES ('ING00V00002', 'Goldy', 0.00, 'UNT00005', 0.00, 0.00, 1, null, 0.00, null, 1, 'CAT008', null, null, 0.00, 0.00, null, null, null, null, null, null, null, 0.00, null, null, null, '707110', '602100', null, 0.00, null, 0.00, 'CUMP', 'EX000041', 'QUAL0032', null, null, null, 'PHARM005');
INSERT INTO AS_INGREDIENTS (ID, LIBELLE, SEUIL, UNITE, QUANTITEPARPACK, PU, ACTIF, PHOTO, CALORIE, DURRE, COMPOSE, CATEGORIEINGREDIENT, IDFOURNISSEUR, DATY, QTELIMITE, PV, LIBELLEVENTE, SEUILMIN, SEUILMAX, PUACHATUSD, PUACHATEURO, PUACHATAUTREDEVISE, PUVENTEUSD, PUVENTEEURO, PUVENTEAUTREDEVISE, ISVENTE, ISACHAT, COMPTE_VENTE, COMPTE_ACHAT, LIBELLEEXTACTE, TVA, FILEPATH, RESTE, TYPESTOCK, REFPOST, REFQUALIFICATION, IDCHAMBRE, ISPERISHABLE, PV2, IDMAGASIN) VALUES ('ING00V00003', '18 Petits beurre/lait', 0.00, 'UNT00005', 0.00, 0.00, 1, null, 0.00, null, 1, 'CAT008', null, null, 0.00, 0.00, null, null, null, null, null, null, null, 0.00, null, null, null, '707110', '602100', null, 0.00, null, 0.00, 'CUMP', 'EX000041', 'QUAL0032', null, null, null, 'PHARM005');
INSERT INTO AS_INGREDIENTS (ID, LIBELLE, SEUIL, UNITE, QUANTITEPARPACK, PU, ACTIF, PHOTO, CALORIE, DURRE, COMPOSE, CATEGORIEINGREDIENT, IDFOURNISSEUR, DATY, QTELIMITE, PV, LIBELLEVENTE, SEUILMIN, SEUILMAX, PUACHATUSD, PUACHATEURO, PUACHATAUTREDEVISE, PUVENTEUSD, PUVENTEEURO, PUVENTEAUTREDEVISE, ISVENTE, ISACHAT, COMPTE_VENTE, COMPTE_ACHAT, LIBELLEEXTACTE, TVA, FILEPATH, RESTE, TYPESTOCK, REFPOST, REFQUALIFICATION, IDCHAMBRE, ISPERISHABLE, PV2, IDMAGASIN) VALUES ('ING00V00004', 'Kip coco', 0.00, 'UNT00005', 0.00, 0.00, 1, null, 0.00, null, 1, 'CAT008', null, null, 0.00, 0.00, null, null, null, null, null, null, null, 0.00, null, null, null, '707110', '602100', null, 0.00, null, 0.00, 'CUMP', 'EX000041', 'QUAL0032', null, null, null, 'PHARM005');
INSERT INTO AS_INGREDIENTS (ID, LIBELLE, SEUIL, UNITE, QUANTITEPARPACK, PU, ACTIF, PHOTO, CALORIE, DURRE, COMPOSE, CATEGORIEINGREDIENT, IDFOURNISSEUR, DATY, QTELIMITE, PV, LIBELLEVENTE, SEUILMIN, SEUILMAX, PUACHATUSD, PUACHATEURO, PUACHATAUTREDEVISE, PUVENTEUSD, PUVENTEEURO, PUVENTEAUTREDEVISE, ISVENTE, ISACHAT, COMPTE_VENTE, COMPTE_ACHAT, LIBELLEEXTACTE, TVA, FILEPATH, RESTE, TYPESTOCK, REFPOST, REFQUALIFICATION, IDCHAMBRE, ISPERISHABLE, PV2, IDMAGASIN) VALUES ('ING00V00005', 'Smack', 0.00, 'UNT00005', 0.00, 0.00, 1, null, 0.00, null, 1, 'CAT008', null, null, 0.00, 0.00, null, null, null, null, null, null, null, 0.00, null, null, null, '707110', '602100', null, 0.00, null, 0.00, 'CUMP', 'EX000041', 'QUAL0032', null, null, null, 'PHARM005');
INSERT INTO AS_INGREDIENTS (ID, LIBELLE, SEUIL, UNITE, QUANTITEPARPACK, PU, ACTIF, PHOTO, CALORIE, DURRE, COMPOSE, CATEGORIEINGREDIENT, IDFOURNISSEUR, DATY, QTELIMITE, PV, LIBELLEVENTE, SEUILMIN, SEUILMAX, PUACHATUSD, PUACHATEURO, PUACHATAUTREDEVISE, PUVENTEUSD, PUVENTEEURO, PUVENTEAUTREDEVISE, ISVENTE, ISACHAT, COMPTE_VENTE, COMPTE_ACHAT, LIBELLEEXTACTE, TVA, FILEPATH, RESTE, TYPESTOCK, REFPOST, REFQUALIFICATION, IDCHAMBRE, ISPERISHABLE, PV2, IDMAGASIN) VALUES ('ING00V00006', 'Tchido', 0.00, 'UNT00005', 0.00, 0.00, 1, null, 0.00, null, 1, 'CAT008', null, null, 0.00, 0.00, null, null, null, null, null, null, null, 0.00, null, null, null, '707110', '602100', null, 0.00, null, 0.00, 'CUMP', 'EX000041', 'QUAL0032', null, null, null, 'PHARM005');
INSERT INTO AS_INGREDIENTS (ID, LIBELLE, SEUIL, UNITE, QUANTITEPARPACK, PU, ACTIF, PHOTO, CALORIE, DURRE, COMPOSE, CATEGORIEINGREDIENT, IDFOURNISSEUR, DATY, QTELIMITE, PV, LIBELLEVENTE, SEUILMIN, SEUILMAX, PUACHATUSD, PUACHATEURO, PUACHATAUTREDEVISE, PUVENTEUSD, PUVENTEEURO, PUVENTEAUTREDEVISE, ISVENTE, ISACHAT, COMPTE_VENTE, COMPTE_ACHAT, LIBELLEEXTACTE, TVA, FILEPATH, RESTE, TYPESTOCK, REFPOST, REFQUALIFICATION, IDCHAMBRE, ISPERISHABLE, PV2, IDMAGASIN) VALUES ('ING00V00007', 'Zook', 0.00, 'UNT00005', 0.00, 0.00, 1, null, 0.00, null, 1, 'CAT008', null, null, 0.00, 0.00, null, null, null, null, null, null, null, 0.00, null, null, null, '707110', '602100', null, 0.00, null, 0.00, 'CUMP', 'EX000041', 'QUAL0032', null, null, null, 'PHARM005');
INSERT INTO AS_INGREDIENTS (ID, LIBELLE, SEUIL, UNITE, QUANTITEPARPACK, PU, ACTIF, PHOTO, CALORIE, DURRE, COMPOSE, CATEGORIEINGREDIENT, IDFOURNISSEUR, DATY, QTELIMITE, PV, LIBELLEVENTE, SEUILMIN, SEUILMAX, PUACHATUSD, PUACHATEURO, PUACHATAUTREDEVISE, PUVENTEUSD, PUVENTEEURO, PUVENTEAUTREDEVISE, ISVENTE, ISACHAT, COMPTE_VENTE, COMPTE_ACHAT, LIBELLEEXTACTE, TVA, FILEPATH, RESTE, TYPESTOCK, REFPOST, REFQUALIFICATION, IDCHAMBRE, ISPERISHABLE, PV2, IDMAGASIN) VALUES ('ING00V00008', 'Cool', 0.00, 'UNT00005', 0.00, 0.00, 1, null, 0.00, null, 1, 'CAT008', null, null, 0.00, 0.00, null, null, null, null, null, null, null, 0.00, null, null, null, '707110', '602100', null, 0.00, null, 0.00, 'CUMP', 'EX000041', 'QUAL0032', null, null, null, 'PHARM005');
INSERT INTO AS_INGREDIENTS (ID, LIBELLE, SEUIL, UNITE, QUANTITEPARPACK, PU, ACTIF, PHOTO, CALORIE, DURRE, COMPOSE, CATEGORIEINGREDIENT, IDFOURNISSEUR, DATY, QTELIMITE, PV, LIBELLEVENTE, SEUILMIN, SEUILMAX, PUACHATUSD, PUACHATEURO, PUACHATAUTREDEVISE, PUVENTEUSD, PUVENTEEURO, PUVENTEAUTREDEVISE, ISVENTE, ISACHAT, COMPTE_VENTE, COMPTE_ACHAT, LIBELLEEXTACTE, TVA, FILEPATH, RESTE, TYPESTOCK, REFPOST, REFQUALIFICATION, IDCHAMBRE, ISPERISHABLE, PV2, IDMAGASIN) VALUES ('ING00V00009', 'Contre tout', 0.00, 'UNT00005', 0.00, 0.00, 1, null, 0.00, null, 1, 'CAT008', null, null, 0.00, 0.00, null, null, null, null, null, null, null, 0.00, null, null, null, '707110', '602100', null, 0.00, null, 0.00, 'CUMP', 'EX000041', 'QUAL0032', null, null, null, 'PHARM005');
INSERT INTO AS_INGREDIENTS (ID, LIBELLE, SEUIL, UNITE, QUANTITEPARPACK, PU, ACTIF, PHOTO, CALORIE, DURRE, COMPOSE, CATEGORIEINGREDIENT, IDFOURNISSEUR, DATY, QTELIMITE, PV, LIBELLEVENTE, SEUILMIN, SEUILMAX, PUACHATUSD, PUACHATEURO, PUACHATAUTREDEVISE, PUVENTEUSD, PUVENTEEURO, PUVENTEAUTREDEVISE, ISVENTE, ISACHAT, COMPTE_VENTE, COMPTE_ACHAT, LIBELLEEXTACTE, TVA, FILEPATH, RESTE, TYPESTOCK, REFPOST, REFQUALIFICATION, IDCHAMBRE, ISPERISHABLE, PV2, IDMAGASIN) VALUES ('ING00V000010', 'Robin ravintsara', 0.00, 'UNT00005', 0.00, 0.00, 1, null, 0.00, null, 1, 'CAT008', null, null, 0.00, 0.00, null, null, null, null, null, null, null, 0.00, null, null, null, '707110', '602100', null, 0.00, null, 0.00, 'CUMP', 'EX000041', 'QUAL0032', null, null, null, 'PHARM005');
INSERT INTO AS_INGREDIENTS (ID, LIBELLE, SEUIL, UNITE, QUANTITEPARPACK, PU, ACTIF, PHOTO, CALORIE, DURRE, COMPOSE, CATEGORIEINGREDIENT, IDFOURNISSEUR, DATY, QTELIMITE, PV, LIBELLEVENTE, SEUILMIN, SEUILMAX, PUACHATUSD, PUACHATEURO, PUACHATAUTREDEVISE, PUVENTEUSD, PUVENTEEURO, PUVENTEAUTREDEVISE, ISVENTE, ISACHAT, COMPTE_VENTE, COMPTE_ACHAT, LIBELLEEXTACTE, TVA, FILEPATH, RESTE, TYPESTOCK, REFPOST, REFQUALIFICATION, IDCHAMBRE, ISPERISHABLE, PV2, IDMAGASIN) VALUES ('ING00V000011', 'Robin menthe', 0.00, 'UNT00005', 0.00, 0.00, 1, null, 0.00, null, 1, 'CAT008', null, null, 0.00, 0.00, null, null, null, null, null, null, null, 0.00, null, null, null, '707110', '602100', null, 0.00, null, 0.00, 'CUMP', 'EX000041', 'QUAL0032', null, null, null, 'PHARM005');


create or replace view TARIF_INGREDIENTS_LIB as
SELECT
	ti."ID",ti."IDTYPECLIENT",ti."IDINGREDIENT",ti."DATY",ti."PRIXUNITAIRE" ,
	t.VAL AS idtypeclientlib,
	ai.LIBELLE AS idingredientlib,
	ti.UNITE,
	u.VAL as unitelib
FROM TARIF_INGREDIENTS ti
LEFT JOIN TYPECLIENT t
ON ti.IDTYPECLIENT = t.ID
LEFT JOIN AS_INGREDIENTS ai
ON ti.IDINGREDIENT = ai.ID
left join AS_UNITE u on u.id=ti.UNITE
/


INSERT INTO EQUIVALENCE (ID, IDPRODUIT, IDUNITE, QTE, POIDS) VALUES ('EUI3', 'ING00V00001', 'UNT00010', 1.00, 0.11);
INSERT INTO EQUIVALENCE (ID, IDPRODUIT, IDUNITE, QTE, POIDS) VALUES ('EUI4', 'ING00V00001', 'UNT005042', 120.00, 5.00);


INSERT INTO EQUIVALENCE (ID, IDPRODUIT, IDUNITE, QTE, POIDS) VALUES ('EUI5', 'ING00V00002', 'UNT00010', 1.00, 0.11);
INSERT INTO EQUIVALENCE (ID, IDPRODUIT, IDUNITE, QTE, POIDS) VALUES ('EUI6', 'ING00V00002', 'UNT005042', 54.00, 4.00);


INSERT INTO EQUIVALENCE (ID, IDPRODUIT, IDUNITE, QTE, POIDS) VALUES ('EUI7', 'ING00V00003', 'UNT00010', 1.00, 0.11);
INSERT INTO EQUIVALENCE (ID, IDPRODUIT, IDUNITE, QTE, POIDS) VALUES ('EUI8', 'ING00V00003', 'UNT005042', 40.00, 4.50);


INSERT INTO EQUIVALENCE (ID, IDPRODUIT, IDUNITE, QTE, POIDS) VALUES ('EUI9', 'ING00V00004', 'UNT00010', 1.00, 0.11);
INSERT INTO EQUIVALENCE (ID, IDPRODUIT, IDUNITE, QTE, POIDS) VALUES ('EUI10', 'ING00V00004', 'UNT005042', 48.00, 2.50);


INSERT INTO EQUIVALENCE (ID, IDPRODUIT, IDUNITE, QTE, POIDS) VALUES ('EUI11', 'ING00V00005', 'UNT00010', 1.00, 0.11);
INSERT INTO EQUIVALENCE (ID, IDPRODUIT, IDUNITE, QTE, POIDS) VALUES ('EUI12', 'ING00V00005', 'UNT005042', 20.00, 3.00);


INSERT INTO EQUIVALENCE (ID, IDPRODUIT, IDUNITE, QTE, POIDS) VALUES ('EUI13', 'ING00V00006', 'UNT00010', 1.00, 0.11);
INSERT INTO EQUIVALENCE (ID, IDPRODUIT, IDUNITE, QTE, POIDS) VALUES ('EUI14', 'ING00V00006', 'UNT005042', 24.00, 4.50);


INSERT INTO EQUIVALENCE (ID, IDPRODUIT, IDUNITE, QTE, POIDS) VALUES ('EUI15', 'ING00V00007', 'UNT00010', 1.00, 0.11);
INSERT INTO EQUIVALENCE (ID, IDPRODUIT, IDUNITE, QTE, POIDS) VALUES ('EUI16', 'ING00V00007', 'UNT005042', 16.00, 4.25);


INSERT INTO EQUIVALENCE (ID, IDPRODUIT, IDUNITE, QTE, POIDS) VALUES ('EUI17', 'ING00V00008', 'UNT00010', 1.00, 0.11);
INSERT INTO EQUIVALENCE (ID, IDPRODUIT, IDUNITE, QTE, POIDS) VALUES ('EUI18', 'ING00V00008', 'UNT005042', 16.00, 4.50);


INSERT INTO EQUIVALENCE (ID, IDPRODUIT, IDUNITE, QTE, POIDS) VALUES ('EUI19', 'ING00V00009', 'UNT00010', 1.00, 0.11);
INSERT INTO EQUIVALENCE (ID, IDPRODUIT, IDUNITE, QTE, POIDS) VALUES ('EUI20', 'ING00V00009', 'UNT005042', 40.00, 5.50);


INSERT INTO EQUIVALENCE (ID, IDPRODUIT, IDUNITE, QTE, POIDS) VALUES ('EUI21', 'ING00V000010', 'UNT00010', 1.00, 0.11);
INSERT INTO EQUIVALENCE (ID, IDPRODUIT, IDUNITE, QTE, POIDS) VALUES ('EUI22', 'ING00V000010', 'UNT005042', 20.00, 6.50);


INSERT INTO EQUIVALENCE (ID, IDPRODUIT, IDUNITE, QTE, POIDS) VALUES ('EUI23', 'ING00V000011', 'UNT00010', 1.00, 0.11);
INSERT INTO EQUIVALENCE (ID, IDPRODUIT, IDUNITE, QTE, POIDS) VALUES ('EUI24', 'ING00V000011', 'UNT005042', 20.00, 3.50);




create or replace view VENTE_DETAILS_VIDE as
select p.ID,
       p.IDVENTE,
       p.IDPRODUIT,
       p.IDORIGINE,
       p.QTE,
       p.PU,
       p.REMISE,
       p.TVA,
       p.PUACHAT,
       p.PUVENTE,
       p.IDDEVISE,
       p.TAUXDECHANGE,
       p.DESIGNATION,
       p.COMPTE,
       p.PUREVIENT,
       p.IDBCFILLE,
       p.UNITE,
       u.VAL                                                 as unitelib,
       pu - (pu * remise / 100) + ((pu * tva / 100))         as punet,
       (pu - (pu * remise / 100)) * qte                      as montantht,
       (pu - (pu * remise / 100)) * qte + ( ((pu * qte)-(pu * remise / 100) * qte) * tva / 100 ) as montantttc,
       ( ((pu * qte)-(pu * remise / 100) * qte) * tva / 100 )                                as montanttva,
       (pu * remise / 100) * qte                             as montantremise,
       (pu) * qte                                            as montant
from VENTE_DETAILS p
         left join AS_UNITE u on u.id = p.unite
/


create or replace view VENTE_DETAILS_POIDS as
select v.ID,v.IDVENTE,v.IDPRODUIT,v.IDORIGINE,v.QTE,v.PU,v.REMISE,v.TVA,v.PUACHAT,v.PUVENTE,v.IDDEVISE,v.TAUXDECHANGE,v.DESIGNATION,v.COMPTE,v.PUREVIENT,v.IDBCFILLE,v.UNITE,v.UNITELIB,v.PUNET,v.MONTANTHT,v.MONTANTTTC,v.MONTANTTVA,v.MONTANTREMISE,v.MONTANT,
       nvl(e.POIDS,0)*nvl(v.QTE,0) as poids,
        vc.reste as reste,
        ve.fraislivraison*nvl(e.POIDS,0)*nvl(v.QTE,0) as frais,
        ing.LIBELLE as idproduitlib
from VENTE_DETAILS_VIDE v left join EQUIVALENCE e on (e.IDPRODUIT = v.IDPRODUIT and e.IDUNITE = v.unite)
left join VENTE_DETAILS_RESTE vc on vc.ID = v.ID
left join Vente ve on ve.ID = v.IDVENTE
left join AS_INGREDIENTS ing on ing.ID = v.IDPRODUIT
/



create or replace view VENTENONPAYE as
select ID,
       DESIGNATION,
       IDMAGASIN,
       IDMAGASINLIB,
       DATY,
       REMARQUE,
       ETAT,
       ETATLIB,
       MONTANTTOTAL,
       IDDEVISE,
       IDCLIENT,
       IDCLIENTLIB,
       MONTANTTVA,
       MONTANTTTC,
       MONTANTTTCAR,
       MONTANTPAYE,
       MONTANTRESTE,
       AVOIR,
       TAUXDECHANGE,
       MONTANTREVIENT,
       MARGEBRUTE,
       IDRESERVATION,
       DATYPREVU,
       mois,
       annee
from VENTE_CPL
where MONTANTRESTE > 0
  and ETAT >= 11
/



alter table RISTOURNE add mois number(2);
alter table RISTOURNE add annee number(5);

CREATE OR REPLACE VIEW VENTE_EDITEES AS
SELECT v.id,
       v.daty,
       r.idristourne
FROM VENTE_CPL v
JOIN (
    SELECT id as idristourne,
           REGEXP_SUBSTR(idorigine, '[^,]+', 1, LEVEL) AS idvente_explose
    FROM ristourne
    CONNECT BY REGEXP_SUBSTR(idorigine, '[^,]+', 1, LEVEL) IS NOT NULL
           AND PRIOR id = id
           AND PRIOR SYS_GUID() IS NOT NULL
) r
ON v.id = r.idvente_explose;

CREATE OR REPLACE VIEW vente_sans_ristourne AS
SELECT v.ID,
       v.DESIGNATION,
       v.IDMAGASIN,
       v.IDMAGASINLIB,
       v.DATY,
       v.REMARQUE,
       v.ETAT,
       v.ETATLIB,
       v.MONTANTTOTAL,
       v.IDDEVISE,
       v.IDCLIENT,
       v.IDCLIENTLIB,
       v.MONTANTTVA,
       v.MONTANTTTC,
       v.MONTANTTTCAR,
       v.MONTANTPAYE,
       v.MONTANTRESTE,
       v.AVOIR,
       v.TAUXDECHANGE,
       v.MONTANTREVIENT,
       v.MARGEBRUTE,
       v.IDRESERVATION,
       v.DATYPREVU,
       v.mois,
       v.annee
FROM VENTE_CPL v
WHERE v.ETAT >= 11
  AND NOT EXISTS (
        SELECT 1
        FROM VENTE_EDITEES e
        WHERE e.id = v.id
  );


create or replace view MOUVEMENTCAISSEGRPAVOIR_LP as
select m.id1 as idorigine, sum(montant) as montant, 'AR' as IDDEVISE from LIAISONPAIEMENT m
  where m.etat>=11 and id1 is not null
group by m.id1
/

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
       ta.val as Typeavoir,
       t.NOM as clientlib
FROM AVOIRFC a
         LEFT JOIN MAGASIN m ON m.id = a.IDMAGASIN
         LEFT JOIN VENTE v ON v.id = a.IDVENTE
         LEFT JOIN MOTIFAVOIRFC ma ON ma.id = a.IDMOTIF
         LEFT JOIN CATEGORIEAVOIRFC c ON c.id = a.IDCATEGORIE
         JOIN AVOIRFCFILLE_GRP ag ON ag.idavoirfc = a.id
         LEFT JOIN TIERS T ON T.ID = A.IDCLIENT
        left join TYPEAVOIR ta on ta.id = a.IDTYPEAVOIR
/

create or replace view VENTE_CPL_SANSAVOIR as
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
       cast(nvl(mv.montant,0) AS NUMBER(30,2)) AS montantpaye,
       cast(V2.MONTANTTTC-nvl(mv.montant,0) AS NUMBER(30,2)) AS montantreste,
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
       vr.reste,
       pv.id as idprovince,
       pv.val as provincelib
FROM VENTE v
         LEFT JOIN CLIENT c ON c.ID = v.IDCLIENT
        left join PROVINCE pv on pv.id = c.IDPROVINCE
         LEFT JOIN MAGASINPOINT m ON m.ID = v.IDMAGASIN
         JOIN VENTEMONTANT v2 ON v2.ID = v.ID
         LEFT JOIN LIAISONPAIEMENTTOTAL mv ON v.id=mv.id2
         LEFT JOIN REFERENCEFACTURE rf ON rf.idfacture=v.Id
         left join vente_poids vp on vp.idvente=v.id
         left join MODEPAIEMENT mp on mp.id=v.modepaiement
         left join vente_reste vr on vr.idvente=v.id;
/*
create or replace view AVOIRFCLIB_CPL as
SELECT AL.ID,
       AL.DESIGNATION,
       AL.IDMAGASIN,
       AL.IDMAGASINLIB,
       AL.DATY,
       AL.REMARQUE,
       AL.ETAT,
       AL.IDORIGINE,
       AL.IDCLIENT,
       AL.COMPTE,
       AL.IDVENTE,
       AL.IDVENTELIB,
       AL.IDMOTIF,
       AL.IDMOTIFLIB,
       AL.IDCATEGORIE,
       AL.IDCATEGORIELIB,
       AL.IDDEVISE,
       AL.TAUXDECHANGE,
       AL.MONTANTHT,
       AL.MONTANTTVA,
       AL.MONTANTTTC,
       AL.MONTANTHTAR,
       AL.MONTANTTVAAR,
       AL.MONTANTTTCAR,
       M.montant as MONTANTPAYE,
       nvl(M.montant, 0)*nvl(AL.TAUXDECHANGE, 0) as MONTANTPAYEAR,
       case when nvl(vc.MONTANTRESTE, 0) - nvl(AL.MONTANTTTCAR, 0) < 0 then (nvl(vc.MONTANTRESTE, 0) - nvl(AL.MONTANTTTCAR, 0))*-1 else 0 end as RESTEAPAYER,
       --AL.MONTANTTTC - nvl(case when vc.MONTANTRESTE < 0 then vc.MONTANTRESTE*-1 else 0 end, 0) as RESTEAPAYER,
       --AL.MONTANTTTCAR - (nvl(case when vc.MONTANTRESTE < 0 then vc.MONTANTRESTE*-1 else 0 end, 0)*nvl(AL.TAUXDECHANGE, 0)) as RESTEAPAYERAR,
       case when nvl(vc.MONTANTRESTE, 0) - nvl(AL.MONTANTTTCAR, 0) < 0 then (nvl(vc.MONTANTRESTE, 0) - nvl(AL.MONTANTTTCAR, 0))*-1 else 0 end as RESTEAPAYERAR,
       clientlib,
       Typeavoir
from AVOIRFCLIB AL
LEFT JOIN MOUVEMENTCAISSEGRPAVOIR_LP M on AL.ID = M.IDORIGINE
LEFT JOIN VENTE_CPL_SANSAVOIR vc on vc.id = al.idvente;
*/

CREATE OR REPLACE VIEW AVOIRFCLIB_CPL AS
SELECT
    AL.ID,
    AL.DESIGNATION,
    AL.IDMAGASIN,
    AL.IDMAGASINLIB,
    AL.DATY,
    AL.REMARQUE,
    AL.ETAT,
    AL.IDORIGINE,
    AL.IDCLIENT,
    AL.COMPTE,
    AL.IDVENTE,
    AL.IDVENTELIB,
    AL.IDMOTIF,
    AL.IDMOTIFLIB,
    AL.IDCATEGORIE,
    AL.IDCATEGORIELIB,
    AL.IDDEVISE,
    AL.TAUXDECHANGE,
    AL.MONTANTHT,
    AL.MONTANTTVA,
    AL.MONTANTTTC,
    AL.MONTANTHTAR,
    AL.MONTANTTVAAR,
    AL.MONTANTTTCAR,
    nvl(M.montant, 0) AS MONTANTPAYE,
    NVL(M.montant, 0) * NVL(AL.TAUXDECHANGE, 0) AS MONTANTPAYEAR,

    NVL(vc.MONTANTRESTE, 0) AS MONTANT_RESTE_FACTURE,

    NVL(SUM_PRECEDENTS.montant_avoirs_precedents, 0) AS MONTANT_AVOIRS_ANTERIEURS,
    -- Cas 1 : facture déjà soldée -> chaque avoir = crédit direct (exédent)
    CASE
        WHEN NVL(vc.MONTANTRESTE, 0) = 0 THEN 0
        ELSE NVL(vc.MONTANTRESTE, 0) - NVL(SUM_PRECEDENTS.montant_avoirs_precedents, 0) - NVL(AL.MONTANTTTCAR, 0)
    END AS RESTE_CALCULE,
    -- Excédent à rembourser ou à reporter
    CASE
        WHEN NVL(vc.MONTANTRESTE, 0) = 0 THEN NVL(AL.MONTANTTTCAR, 0)
        WHEN NVL(vc.MONTANTRESTE, 0) - NVL(SUM_PRECEDENTS.montant_avoirs_precedents, 0) - NVL(AL.MONTANTTTCAR, 0) < 0
        THEN ABS(NVL(vc.MONTANTRESTE, 0) - NVL(SUM_PRECEDENTS.montant_avoirs_precedents, 0) - NVL(AL.MONTANTTTCAR, 0))
        ELSE 0
    END AS EXCEDENT_AR,
    CASE
        WHEN NVL(vc.MONTANTRESTE, 0) = 0 THEN NVL(AL.MONTANTTTCAR, 0)
        WHEN NVL(vc.MONTANTRESTE, 0) - NVL(SUM_PRECEDENTS.montant_avoirs_precedents, 0) - NVL(AL.MONTANTTTCAR, 0) < 0
        THEN ABS(NVL(vc.MONTANTRESTE, 0) - NVL(SUM_PRECEDENTS.montant_avoirs_precedents, 0) - NVL(AL.MONTANTTTCAR, 0))
        ELSE 0
    END AS resteapayer,
    CASE
        WHEN NVL(vc.MONTANTRESTE, 0) = 0 THEN NVL(AL.MONTANTTTCAR, 0)
        WHEN NVL(vc.MONTANTRESTE, 0) - NVL(SUM_PRECEDENTS.montant_avoirs_precedents, 0) - NVL(AL.MONTANTTTCAR, 0) < 0
        THEN ABS(NVL(vc.MONTANTRESTE, 0) - NVL(SUM_PRECEDENTS.montant_avoirs_precedents, 0) - NVL(AL.MONTANTTTCAR, 0))
        ELSE 0
    END AS resteapayerar,
    AL.clientlib,
    AL.Typeavoir
FROM AVOIRFCLIB AL
LEFT JOIN MOUVEMENTCAISSEGRPAVOIR_LP M
       ON AL.ID = M.IDORIGINE
LEFT JOIN VENTE_CPL_SANSAVOIR vc
       ON vc.id = AL.idvente
-- Somme des avoirs précédents pour la même facture
LEFT JOIN (
    SELECT
        a2.idvente,
        a2.id AS idcourant,
        SUM(a1.MONTANTTTCAR) AS montant_avoirs_precedents
    FROM AVOIRFCLIB a1
    JOIN AVOIRFCLIB a2 ON a1.idvente = a2.idvente
    WHERE a1.ETAT <> 0
      AND (a1.DATY < a2.DATY OR (a1.DATY = a2.DATY AND a1.ID < a2.ID))
    GROUP BY a2.idvente, a2.id
) SUM_PRECEDENTS
    ON SUM_PRECEDENTS.idvente = AL.idvente
   AND SUM_PRECEDENTS.idcourant = AL.id;


create or replace view AVOIRFCLIB_CPL_VISEE as
select ID,
       DESIGNATION,
       IDMAGASIN,
       IDMAGASINLIB,
       DATY,
       REMARQUE,
       ETAT,
       IDORIGINE,
       IDCLIENT,
       COMPTE,
       IDVENTE,
       IDVENTELIB,
       IDMOTIF,
       IDMOTIFLIB,
       IDCATEGORIE,
       IDCATEGORIELIB,
       IDDEVISE,
       TAUXDECHANGE,
       MONTANTHT,
       MONTANTTVA,
       MONTANTTTC,
       MONTANTHTAR,
       MONTANTTVAAR,
       MONTANTTTCAR,
       MONTANTPAYE,
       MONTANTPAYEAR,
       RESTEAPAYER,
       RESTEAPAYERAR,
       MONTANTTTC - MONTANTPAYE as imputeefact,
       MONTANTTTCar - MONTANTPAYEar as imputeefactar
from avoirfclib_cpl
where ETAT >= 11
/

create or replace view AVOIRFCLIB_CPL_GRP as
SELECT AL.IDVENTE,
       AL.IDDEVISE,
       SUM(MONTANTHT) as MONTANTHT_avr,
       SUM(MONTANTTVA) as MONTANTTVA_avr,
       SUM(MONTANTTTC) as MONTANTTTC_avr,
       SUM(MONTANTHTAR) as MONTANTHTAR_avr,
       SUM(MONTANTTVAAR) as MONTANTTVAAR_avr,
       SUM(MONTANTTTCAR) as MONTANTTTCAR_avr,
       SUM(MONTANTPAYE) as MONTANTPAYE,
       SUM(MONTANTPAYEAR) as MONTANTPAYEAR,
       SUM(RESTEAPAYER) as resteapayer_avr,
       SUM(RESTEAPAYERAR) as resteapayerar_avr,
       SUM(imputeefact) as imputeefact,
       SUM(imputeefactar) as imputeefactar
from avoirfclib_cpl_visee AL
group by IDVENTE, IDDEVISE
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
       cast(nvl(mv.montant,0) AS NUMBER(30,2)) AS montantpaye,
       cast(nvl(V2.MONTANTTTC, 0)-nvl(mv.montant,0)-nvl(ACG.imputeefactar, 0) AS NUMBER(30,2)) AS montantreste,
       cast(nvl(ACG.MONTANTTTC_avr, 0) as number(30,2)) as avoir,
       v2.tauxDeChange AS tauxDeChange,v2.MONTANTREVIENT,cast((V2.MONTANTTTCAR-v2.MONTANTREVIENT) as number(20,2))  as margeBrute,
       v.IDRESERVATION,
       case when v.DATYPREVU is null then v.daty else V.DATYPREVU end as datyprevu,
       rf.REFERENCE as referencefacture,
       v2.MONTANTREMISE,
       nvl(v2.MONTANTTOTAL,0)+nvl(v2.MONTANTREMISE,0) as montant,
       extract(month from v.DATY) as mois,
       extract(year from v.DATY) as annee,
       vp.poids,
       v.modepaiement,
       mp.VAL as modepaiementlib,
       nvl(v.fraislivraison,0)*nvl(vp.poids,0) as fraislivraison,
       v.modelivraison,
       CASE
            WHEN v.modelivraison = 1 THEN '<span style=color: green;>LIVRAISON</span>'
            WHEN v.modelivraison = 2 THEN '<span style=color: green;>RECUPERATION</span>'
        END AS modelivraisonlib,
       vr.reste,
       pv.id as idprovince,
       pv.val as provincelib,
       bl.id as idbl,
       v.IDORIGINE
FROM VENTE v
         LEFT JOIN CLIENT c ON c.ID = v.IDCLIENT
        left join PROVINCE pv on pv.id = c.IDPROVINCE
         LEFT JOIN MAGASINPOINT m ON m.ID = v.IDMAGASIN
         JOIN VENTEMONTANT v2 ON v2.ID = v.ID
         LEFT JOIN LIAISONPAIEMENTTOTAL mv ON v.id=mv.id2
         LEFT JOIN AVOIRFCLIB_CPL_GRP ACG on ACG.IDVENTE = v.ID
         LEFT JOIN REFERENCEFACTURE rf ON rf.idfacture=v.Id
         left join vente_poids vp on vp.idvente=v.id
         left join MODEPAIEMENT mp on mp.id=v.modepaiement
         left join vente_reste vr on vr.idvente=v.id
         left join AS_BONDELIVRAISON_CLIENT bl on bl.IDVENTE = v.id
;



create or replace view MOUVEMENTCAISSECPL_VALIDER as
SELECT
			ID,DESIGNATION,IDCAISSE,IDCAISSELIB,IDVENTEDETAIL,IDVIREMENT,DEBIT,CREDIT,DATY,ETAT,ETATLIB,IDVENTE,IDORIGINE,IDTIERS,TIERS
		FROM
			MOUVEMENTCAISSECPL m
		WHERE
			m.etat > 7
/


create or replace view releveclient as
select relever.*, t.NOM as clientlib, t.COMPTE from (
    select id, ' ' as journal, id as reference, daty, 'NOTE DE CREDIT :'|| id as libelle, ' ' as lettre, 0 as debit, MONTANTTTCAR as credit, IDCLIENT
from AVOIRFCLIB_CPL_VISEE
UNION ALL
select id, ' ' as journal, id as reference, daty, ' ', ' ' as lettre, montantreste as debit, 0 as credit, IDCLIENT
from VENTE_CPL where ETAT >=7
union all
select lp.id, ' ' as journal, lp.id as reference, mc.daty, mc.DESIGNATION || ' par ' || mc.ID, ' ' as lettre, 0 as debit, lp.MONTANT as credit, mc.IDTIERS as idclient from LIAISONPAIEMENT lp left join MOUVEMENTCAISSE mc on mc.id = lp.id1)
relever left join tiers t on t.id = relever.IDCLIENT order by IDCLIENT,DATY
;

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MENUDYN0077', 'Paiement multiple facture vente', 'fa fa-list', 'module.jsp?but=vente/paiement-multiple-facture.jsp', 9, 2, 'MENUDYN001');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MENUDYN0077RC', 'Releve Client', 'fa fa-list', 'module.jsp?but=vente/releve-client.jsp', 10, 2, 'MENUDYN001');