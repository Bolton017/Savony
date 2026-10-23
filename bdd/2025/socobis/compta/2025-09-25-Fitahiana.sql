select * from MENUDYNAMIQUE where ID_PERE='MNDN285'

ALTER TABLE Client
    ADD compteauxiliaire VARCHAR(20) UNIQUE;

ALTER TABLE Fournisseur
    ADD compteauxiliaire VARCHAR(20) UNIQUE;

create or replace view TIERS as
select ID, NOM, COMPTE, compteauxiliaire from FOURNISSEUR
UNION ALL
select ID, NOM, COMPTE, compteauxiliaire from CLIENT;

create or replace view FACTUREFOURNISSEUR_CPL as
select ff."ID",ff."IDFOURNISSEUR",ff."IDMODEPAIEMENT",ff."DATY",ff."DESIGNATION",ff."DATEECHEANCEPAIEMENT",ff."ETAT",ff."REFERENCE",ff."IDBC",ff."DEVISE",ff."TAUX",ff."IDMAGASIN",
       f.NOM as fournisseurlib,
       mp.VAL as modedepaimentlib,
       f.COMPTE,
       f.compteauxiliaire
from FACTUREFOURNISSEUR ff
         left join FOURNISSEUR f on ff.IDFOURNISSEUR = f.ID
         left join MODEPAIEMENT mp on ff.IDMODEPAIEMENT = mp.ID;

create or replace view FACTUREFOURNISSEUR_MERECMPT as
select ff."ID",
       ff."IDFOURNISSEUR",
       ff."IDMODEPAIEMENT",
       ff."DATY",
       ff."DESIGNATION",
       ff."DATEECHEANCEPAIEMENT",
       ff."ETAT",
       ff."REFERENCE",
       ff."IDBC",
       ff."DEVISE",
       ff."TAUX",
       ff."IDMAGASIN",
       ff."FOURNISSEURLIB",
       ff."MODEDEPAIMENTLIB",
       ff."COMPTE",
       ff.compteauxiliaire,
       fm.MONTANTHT,
       fm.MONTANTTVA,
       fm.MONTANTTTC
from FACTUREFOURNISSEUR_CPL ff
         left join FACTUREFOURNISSEUR_FILLECOMPTE fm on fm.IDFACTUREFOURNISSEUR = ff.id;


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
       v.IDRESERVATION
FROM AVOIRFC a
         LEFT JOIN MAGASIN m ON m.id = a.IDMAGASIN
         LEFT JOIN VENTE v ON v.id = a.IDVENTE
         LEFT JOIN MOTIFAVOIRFC ma ON ma.id = a.IDMOTIF
         LEFT JOIN CATEGORIEAVOIRFC c ON c.id = a.IDCATEGORIE
         JOIN AVOIRFCFILLE_GRP ag ON ag.idavoirfc = a.id
         LEFT JOIN TIERS T ON T.ID = A.IDCLIENT;


create or replace view COMPTA_SOUSECRITURE_SANSPG
            (ID, NUMERO, COMPTE, JOURNAL, IDJOURNAL, ECRITURE, DATY, CREDIT, DEBIT, DATECOMPTABLE, EXERCICE, REMARQUE,
             ETAT, HORSEXERCICE, OD, ORIGINE, TIERS, LIBELLEPIECE, COMPTE_AUX, RAISONSOCIAL,FOLIO, LETTRAGE, ANALYTIQUE, IDOBJET)
as
select
    sousecr.id,
    cpt.LIBELLE,
    cpt.COMPTE,
    jrn.val||'| '|| jrn.DESCE ,
    jrn.id,
    sousecr.REMARQUE as DESIGNATION,
    sousecr.DATY,
    sousecr.CREDIT,
    sousecr.DEBIT,
    sousecr.DATY AS DATECOMPTABLE,
    sousecr.EXERCICE,
    sousecr.REMARQUE,
    sousecr.ETAT,
    cast(0 as number) AS HORSEXERCICE,
    cast('-' as varchar(50)) AS OD,
    cast('' as varchar(50)) AS ORIGINE,
    cast('' as varchar2(50)) as tiers,
    sousecr.LIBELLEPIECE,
    sousecr.COMPTE_AUX,
    cast('' as varchar(100)) as RAISONSOCIAL ,
    sousecr.folio ,
    sousecr.LETTRAGE ,
    ANALYTIQUE,
    CASE
        WHEN ce.IDOBJET= pe.id THEN pe.idorigine
        ELSE ce.idobjet
        END
        AS idobjet
from
    COMPTA_SOUS_ECRITURE sousecr
        join COMPTA_COMPTE cpt on  sousecr.COMPTE = cpt.COMPTE
        join COMPTA_JOURNAL jrn on sousecr.JOURNAL = jrn.ID
        JOIN COMPTA_ECRITURE ce ON ce.id = sousecr.IDMERE
        LEFT JOIN PERTEGAINIMPREVUE pe ON ce.idobjet=pe.id;


create or replace view COMPTA_SOUSECRITURE_LIB
            (ID, NUMERO, COMPTE, JOURNAL, IDJOURNAL, ECRITURE, DATY, CREDIT, DEBIT, DATECOMPTABLE, EXERCICE, REMARQUE,
             ETAT, IDMERE, HORSEXERCICE, OD, ORIGINE, TIERS, LIBELLEPIECE, COMPTE_AUX,RAISONSOCIAL, FOLIO, LETTRAGE, ANALYTIQUE)
as
select
    sousecr.id,
    cpt.LIBELLE,
    cpt.COMPTE,
    jrn.val||'| '|| jrn.DESCE ,
    jrn.id,
    sousecr.REMARQUE as DESIGNATION,
    sousecr.DATY,
    sousecr.CREDIT,
    sousecr.DEBIT,
    sousecr.DATY AS DATECOMPTABLE,
    sousecr.EXERCICE,
    sousecr.REMARQUE,
    sousecr.ETAT,
    sousecr.idmere,
    cast(0 as number) AS HORSEXERCICE,
    cast('-' as varchar(50)) AS OD,
    cast('' as varchar(50)) AS ORIGINE,
    cast('' as varchar2(50)) as tiers,
    sousecr.LIBELLEPIECE,
    sousecr.COMPTE_AUX,
    cast('' as varchar(100)) as RAISONSOCIAL ,
    sousecr.folio ,
    sousecr.LETTRAGE ,
    sousecr.ANALYTIQUE
from
    COMPTA_SOUS_ECRITURE sousecr
        join COMPTA_COMPTE cpt on  sousecr.COMPTE = cpt.COMPTE
        join COMPTA_JOURNAL jrn on sousecr.JOURNAL = jrn.ID
        /


create or replace view COMPTA_SOUSECRITURE_LIB_J as
select cse.*,ce.DESIGNATION as designationmere,
       EXTRACT(DAY FROM cse.DATY)   AS jour,
       EXTRACT(MONTH FROM cse.DATY) AS mois,
       EXTRACT(YEAR FROM cse.DATY)  AS annee  from COMPTA_SOUSECRITURE_LIB cse join COMPTA_ECRITURE ce on cse.IDMERE=ce.ID;


create view SousEcritureCompteExtrait as
select
    compte,
    SUBSTR(COMPTE, 1, 1) as compte1,
    SUBSTR(COMPTE, 1, 2) as compte2,
    SUBSTR(COMPTE, 1, 3) as compte3,
    SUBSTR(COMPTE, 1, 4) as compte4,
    DEBIT,
    CREDIT,
    EXERCICE as annee,
    etat
from COMPTA_SOUS_ECRITURE;


create or replace view SousEcritureGroupCompte as
select
    compte,
    sum(DEBIT) as DEBIT,
    sum(CREDIT) AS CREDIT,
    annee  as exercice,
    etat
from SousEcritureCompteExtrait group by compte, annee, etat;

create or replace view SousEcritureGroupCompte1 as
select
    compte1,
    sum(DEBIT) as DEBIT,
    sum(CREDIT) AS CREDIT,
    annee as exercice,
    etat
from SousEcritureCompteExtrait group by compte1, annee, etat;

create or replace view SousEcritureGroupCompte2 as
select
    compte2,
    sum(DEBIT) as DEBIT,
    sum(CREDIT) AS CREDIT,
    annee as exercice,
    etat
from SousEcritureCompteExtrait group by compte2, annee, etat;

create or replace view SousEcritureGroupCompte3 as
select
    compte3,
    sum(DEBIT) as DEBIT,
    sum(CREDIT) AS CREDIT,
    annee as exercice,
    etat
from SousEcritureCompteExtrait group by compte3, annee, etat;


create or replace view SousEcritureGroupCompte4 as
select
    compte4,
    sum(DEBIT) as DEBIT,
    sum(CREDIT) AS CREDIT,
    annee as exercice,
    etat
from SousEcritureCompteExtrait group by compte4, annee, etat;


create or replace view SousEcritureGroupeByUnionVise as
select t.compte,c.LIBELLE,t.DEBIT,t.CREDIT,t.exercice,t.etat from
    (
        select *
        from SousEcritureGroupCompte
        UNION
        select *
        from SousEcritureGroupCompte1
        UNION
        select *
        from SousEcritureGroupCompte2
        UNION
        select *
        from SousEcritureGroupCompte3
        UNION
        select *
        from SousEcritureGroupCompte4
    ) t join compta_compte c on c.COMPTE = t.compte order by compte desc;



create sequence seqCompteClient
    minvalue 1
    maxvalue 999999999999
    start with 60000
    increment by 1
    cache 20;

CREATE OR REPLACE FUNCTION getseqCompteClient
   RETURN NUMBER
IS
   retour   NUMBER;
BEGIN
SELECT seqCompteClient.NEXTVAL INTO retour FROM DUAL;

RETURN retour;
END;


create sequence seqCompteFournisseur
    minvalue 1
    maxvalue 999999999999
    start with 60000
    increment by 1
    cache 20;


CREATE OR REPLACE FUNCTION getseqCompteFournisseur
   RETURN NUMBER
IS
   retour   NUMBER;
BEGIN
SELECT seqCompteFournisseur.NEXTVAL INTO retour FROM DUAL;

RETURN retour;
END;


    create or replace view PERTEGAINIMPREVUELIB as
SELECT pgi.ID,pgi.DESIGNATION,pgi.IDTYPEGAINPERTE,pgi.PERTE,pgi.GAIN,pgi.IDORIGINE,pgi.DATY,pgi.ETAT,pgi.TVA,pgi.TIERS,
       tgp.val                                                                             AS TYPE,
       tgp.desce                                                                           AS compte,
       case when perte > 0 then perte * tva / 100 else gain * tva / 100 end                as montanttva,
       case when perte > 0 then perte else gain end                                        as montantht,
       case when perte > 0 then perte + perte * tva / 100 else gain + gain * tva / 100 end as montantttc,
       t.nom as TIERSLIB,
       t.COMPTE as tierscompte,
       t.COMPTEAUXILIAIRE
FROM pertegainimprevue pgi
         LEFT JOIN typegainperte tgp on pgi.idtypegainperte = tgp.id
         LEFT JOIN tiers t on t.id = pgi.tiers
    /
-- auto-generated definition
create or replace view COMPTA_SOUSECRITURE_ECRITURE
            (ID, NUMERO, COMPTE, JOURNAL, IDJOURNAL, ECRITURE, DATY, CREDIT, DEBIT, DATECOMPTABLE, EXERCICE, REMARQUE,
             ETAT, HORSEXERCICE, OD, ORIGINE, TIERS, LIBELLEPIECE, COMPTE_AUX,RAISONSOCIAL, FOLIO, LETTRAGE, ANALYTIQUE, IDOBJET)
as
select
    sousecr.id,
    cpt.LIBELLE,
    cpt.COMPTE,
    jrn.val||'| '|| jrn.DESCE ,
    jrn.id,
    sousecr.REMARQUE as DESIGNATION,
    sousecr.DATY,
    sousecr.CREDIT,
    sousecr.DEBIT,
    sousecr.DATY AS DATECOMPTABLE,
    sousecr.EXERCICE,
    sousecr.REMARQUE,
    sousecr.ETAT,
    cast(0 as number) AS HORSEXERCICE,
    cast('-' as varchar(50)) AS OD,
    cast('' as varchar(50)) AS ORIGINE,
    cast('' as varchar2(50)) as tiers,
    sousecr.LIBELLEPIECE,
    sousecr.COMPTE_AUX,
    cast('' as varchar(100)) as RAISONSOCIAL ,
    sousecr.folio ,
    sousecr.LETTRAGE ,
    ANALYTIQUE,
    ce.IDOBJET
from
    COMPTA_SOUS_ECRITURE sousecr
        join COMPTA_COMPTE cpt on  sousecr.COMPTE = cpt.COMPTE
        join COMPTA_JOURNAL jrn on sousecr.JOURNAL = jrn.ID
        JOIN COMPTA_ECRITURE ce ON ce.id = sousecr.IDMERE
        /


select * from SousEcritureGroupeByUnionVise;


-- auto-generated definition
create table ETATSORTIE
(
    ID        VARCHAR2(255) not null
        constraint PK_ETATSORTIE
            primary key,
    LIBELLE   VARCHAR2(255),
    FORMULE1  VARCHAR2(900),
    FORMULE2  VARCHAR2(900),
    NOM       VARCHAR2(255),
    CATEGORIE VARCHAR2(255),
    RANG      NUMBER,
    NIVEAU    NUMBER,
    IDPARENT  VARCHAR2(255)
);


INSERT INTO ETATSORTIE (ID, LIBELLE, FORMULE1, FORMULE2, NOM, CATEGORIE, RANG, NIVEAU, IDPARENT) VALUES ('ETAT000059', 'Autres charges opérationnelles', '[651]+[652]+[653]+[654]+[655]+[656]+[657]+[658]', null, 'Compte de resultat', 'Excédent brut d’exploitation', 14, 1, 'ETAT000057');
INSERT INTO ETATSORTIE (ID, LIBELLE, FORMULE1, FORMULE2, NOM, CATEGORIE, RANG, NIVEAU, IDPARENT) VALUES ('ETAT000060', 'Dotations aux amortissements, provisions et pertes de valeur', '[681]+[685]', null, 'Compte de resultat', 'Excédent brut d’exploitation', 15, 1, 'ETAT000057');
INSERT INTO ETATSORTIE (ID, LIBELLE, FORMULE1, FORMULE2, NOM, CATEGORIE, RANG, NIVEAU, IDPARENT) VALUES ('ETAT000061', 'Reprise sur provisions et pertes de valeur', '[781]+[785]', null, 'Compte de resultat', 'Excédent brut d’exploitation', 16, 1, 'ETAT000057');
INSERT INTO ETATSORTIE (ID, LIBELLE, FORMULE1, FORMULE2, NOM, CATEGORIE, RANG, NIVEAU, IDPARENT) VALUES ('ETAT000062', 'V - Résultat opérationnel', '[741]+[748]+[701]+[702]+[703]+[704]+[705]+[706]+[707]+[708]+[713..credit]+[714]+[721]+[722]-[601]-[602]-[603..debit]-[604]-[605]-[606]-[607]-[608]-[611]-[612]-[613]-[614]-[615]-[616]-[617]-[618]-[621]-[622]-[623]-[624]-[625]-[626]-[627]-[628]-[641]-[644]-[645]-[646]-[647]-[648]-[631]-[635]-[638]+[751]+[752]+[753]+[754]+[755]+[756]+[757]+[758]-[651]-[652]-[653]-[654]-[655]-[656]-[657]-[658]-[681]-[685]-[781]-[785]', '[7091]+[7092]+[7093]+[7094]+[7095]+[7096]+[7097]+[7098]+[713..debit]-[603..credit]-[6091]-[6092]-[6094]-[6095]-[6096]-[6097]-[6098]-[6111]-[6112]-[6113]-[6114]-[6115]-[6116]-[6117]-[6118]-[6191]-[6192]-[6197]-[6198]-[6291]-[6292]-[6295]-[6296]-[6297]-[6298]', 'Compte de resultat', ' Résultat opérationnel', 18, 1, null);
INSERT INTO ETATSORTIE (ID, LIBELLE, FORMULE1, FORMULE2, NOM, CATEGORIE, RANG, NIVEAU, IDPARENT) VALUES ('ETAT000063', 'Produits financiers', '[761]+[762]+[763]+[764]+[765]+[766]+[767]+[768]+[786]', null, 'Compte de resultat', 'Résultat opérationnel', 19, 2, 'ETAT000062');
INSERT INTO ETATSORTIE (ID, LIBELLE, FORMULE1, FORMULE2, NOM, CATEGORIE, RANG, NIVEAU, IDPARENT) VALUES ('ETAT000064', 'Charges financières', '[661]+[662]+[663]+[664]+[665]+[666]+[667]+[668]+[686]', null, 'Compte de resultat', 'Résultat opérationnel', 20, 2, 'ETAT000062');
INSERT INTO ETATSORTIE (ID, LIBELLE, FORMULE1, FORMULE2, NOM, CATEGORIE, RANG, NIVEAU, IDPARENT) VALUES ('ETAT000065', 'VI - Résultat financier', '[761]+[762]+[763]+[764]+[765]+[766]+[767]+[768]+[786]-[661]-[662]-[663]-[664]-[665]-[666]-[667]-[668]-[686]', null, 'Compte de resultat', 'Résultat financier', 21, 1, null);
INSERT INTO ETATSORTIE (ID, LIBELLE, FORMULE1, FORMULE2, NOM, CATEGORIE, RANG, NIVEAU, IDPARENT) VALUES ('ETAT000066', 'VII - Résultat avant impôts (V + VI)', '[741]+[748]+[701]+[702]+[703]+[704]+[705]+[706]+[707]+[708]+[713..credit]+[714]+[721]+[722]-[601]-[602]-[603..debit]-[604]-[605]-[606]-[607]-[608]-[611]-[612]-[613]-[614]-[615]-[616]-[617]-[618]-[621]-[622]-[623]-[624]-[625]-[626]-[627]-[628]-[641]-[644]-[645]-[646]-[647]-[648]-[631]-[635]-[638]+[751]+[752]+[753]+[754]+[755]+[756]+[757]+[758]-[651]-[652]-[653]-[654]-[655]-[656]-[657]-[658]-[681]-[685]-[781]-[785]+[761]+[762]+[763]+[764]+[765]+[766]+[767]+[768]+[786]-[661]-[662]-[663]-[664]-[665]-[666]-[667]-[668]-[686]', '[7091]+[7092]+[7093]+[7094]+[7095]+[7096]+[7097]+[7098]+[713..debit]-[603..credit]-[6091]-[6092]-[6094]-[6095]-[6096]-[6097]-[6098]-[6111]-[6112]-[6113]-[6114]-[6115]-[6116]-[6117]-[6118]-[6191]-[6192]-[6197]-[6198]-[6291]-[6292]-[6295]-[6296]-[6297]-[6298]', 'Compte de resultat', 'Résultat avant impôts', 22, 1, null);
INSERT INTO ETATSORTIE (ID, LIBELLE, FORMULE1, FORMULE2, NOM, CATEGORIE, RANG, NIVEAU, IDPARENT) VALUES ('ETAT000067', 'Impôts exigibles sur résultats', '[695]+[698]', '[698]', 'Compte de resultat', 'Résultat avant impôts', 23, 1, 'ETAT000066');
INSERT INTO ETATSORTIE (ID, LIBELLE, FORMULE1, FORMULE2, NOM, CATEGORIE, RANG, NIVEAU, IDPARENT) VALUES ('ETAT000068', 'Impôts différés (variations)', '[692]+[693..variation]', null, 'Compte de resultat', 'Résultat avant impôts', 24, 1, 'ETAT000066');
INSERT INTO ETATSORTIE (ID, LIBELLE, FORMULE1, FORMULE2, NOM, CATEGORIE, RANG, NIVEAU, IDPARENT) VALUES ('ETAT000069', 'VIII - Résultat net des activités ordinaires', '[741]+[748]+[701]+[702]+[703]+[704]+[705]+[706]+[707]+[708]+[713..credit]+[714]+[721]+[722]-[601]-[602]-[603..debit]-[604]-[605]-[606]-[607]-[608]-[611]-[612]-[613]-[614]-[615]-[616]-[617]-[618]-[621]-[622]-[623]-[624]-[625]-[626]-[627]-[628]-[641]-[644]-[645]-[646]-[647]-[648]-[631]-[635]-[638]+[751]+[752]+[753]+[754]+[755]+[756]+[757]+[758]-[651]-[652]-[653]-[654]-[655]-[656]-[657]-[658]-[681]-[685]-[781]-[785]+[761]+[762]+[763]+[764]+[765]+[766]+[767]+[768]+[786]-[661]-[662]-[663]-[664]-[665]-[666]-[667]-[668]-[686]-[695]-[698]-[692]-[693..variation]', '[7091]+[7092]+[7093]+[7094]+[7095]+[7096]+[7097]+[7098]+[713..debit]-[603..credit]-[6091]-[6092]-[6094]-[6095]-[6096]-[6097]-[6098]-[6111]-[6112]-[6113]-[6114]-[6115]-[6116]-[6117]-[6118]-[6191]-[6192]-[6197]-[6198]-[6291]-[6292]-[6295]-[6296]-[6297]-[6298]-[698]', 'Compte de resultat', 'Résultat net des activités ordinaires', 25, 1, null);
INSERT INTO ETATSORTIE (ID, LIBELLE, FORMULE1, FORMULE2, NOM, CATEGORIE, RANG, NIVEAU, IDPARENT) VALUES ('ETAT000070', 'Eléments extraordinaires (produits)', '[77]', null, 'Compte de resultat', 'Résultat net des activités ordinaires', 26, 1, 'ETAT000069');
INSERT INTO ETATSORTIE (ID, LIBELLE, FORMULE1, FORMULE2, NOM, CATEGORIE, RANG, NIVEAU, IDPARENT) VALUES ('ETAT000071', 'Eléments extraordinaires (charges)', '[67]', null, 'Compte de resultat', 'Résultat net des activités ordinaires', 27, 1, 'ETAT000069');
INSERT INTO ETATSORTIE (ID, LIBELLE, FORMULE1, FORMULE2, NOM, CATEGORIE, RANG, NIVEAU, IDPARENT) VALUES ('ETAT000072', 'IX - Résultat extraordinaire', '[77]-[67]', null, 'Compte de resultat', 'Résultat extraordinaire', 28, 1, null);
INSERT INTO ETATSORTIE (ID, LIBELLE, FORMULE1, FORMULE2, NOM, CATEGORIE, RANG, NIVEAU, IDPARENT) VALUES ('ETAT000073', 'X - Résultat net de l’exercice', '[741]+[748]+[701]+[702]+[703]+[704]+[705]+[706]+[707]+[708]+[713..credit]+[714]+[721]+[722]-[601]-[602]-[603..debit]-[604]-[605]-[606]-[607]-[608]-[611]-[612]-[613]-[614]-[615]-[616]-[617]-[618]-[621]-[622]-[623]-[624]-[625]-[626]-[627]-[628]-[641]-[644]-[645]-[646]-[647]-[648]-[631]-[635]-[638]+[751]+[752]+[753]+[754]+[755]+[756]+[757]+[758]-[651]-[652]-[653]-[654]-[655]-[656]-[657]-[658]-[681]-[685]-[781]-[785]+[761]+[762]+[763]+[764]+[765]+[766]+[767]+[768]+[786]-[661]-[662]-[663]-[664]-[665]-[666]-[667]-[668]-[686]-[695]-[698]-[692]-[693..variation]+[77]-[67]', '[7091]+[7092]+[7093]+[7094]+[7095]+[7096]+[7097]+[7098]+[713..debit]-[603..credit]-[6091]-[6092]-[6094]-[6095]-[6096]-[6097]-[6098]-[6111]-[6112]-[6113]-[6114]-[6115]-[6116]-[6117]-[6118]-[6191]-[6192]-[6197]-[6198]-[6291]-[6292]-[6295]-[6296]-[6297]-[6298]-[698]', 'Compte de resultat', 'Résultat net de l’exercice', 29, 1, null);
INSERT INTO ETATSORTIE (ID, LIBELLE, FORMULE1, FORMULE2, NOM, CATEGORIE, RANG, NIVEAU, IDPARENT) VALUES ('ETAT000074', 'XI - Résultat net de l’ensemble consolidé', null, null, 'Compte de resultat', 'Résultat net de l’ensemble consolidé', 30, 1, null);
INSERT INTO ETATSORTIE (ID, LIBELLE, FORMULE1, FORMULE2, NOM, CATEGORIE, RANG, NIVEAU, IDPARENT) VALUES ('ETAT000035', 'Résultat net – part du groupe', '[741]+[748]+[701]+[702]+[703]+[704]+[705]+[706]+[707]+[708]+[713..credit]+[714]+[721]+[722]-[601]-[602]-[603..debit]-[604]-[605]-[606]-[607]-[608]-[611]-[612]-[613]-[614]-[615]-[616]-[617]-[618]-[621]-[622]-[623]-[624]-[625]-[626]-[627]-[628]-[641]-[644]-[645]-[646]-[647]-[648]-[631]-[635]-[638]+[751]+[752]+[753]+[754]+[755]+[756]+[757]+[758]-[651]-[652]-[653]-[654]-[655]-[656]-[657]-[658]-[681]-[685]-[781]-[785]+[761]+[762]+[763]+[764]+[765]+[766]+[767]+[768]+[786]-[661]-[662]-[663]-[664]-[665]-[666]-[667]-[668]-[686]-[695]-[698]-[692]-[693..variation]+[77]-[67]-[7091]-[7092]-[7093]-[7094]-[7095]-[7096]-[7097]-[7098]-[713..debit]+[603..credit]+[6091]+[6092]+[6094]+[6095]+[6096]+[6097]+[6098]+[6111]+[6112]+[6113]+[6114]+[6115]+[6116]+[6117]+[6118]+[6191]+[6192]+[6197]+[6198]+[6291]+[6292]+[6295]+[6296]+[6297]+[6298]+[698]', '[129..debit]', 'Bilan Capitaux Propres et Passif', 'capitaux propres', 5, 1, null);
INSERT INTO ETATSORTIE (ID, LIBELLE, FORMULE1, FORMULE2, NOM, CATEGORIE, RANG, NIVEAU, IDPARENT) VALUES ('ETAT000050', 'II - Consommation de l’exercice', '[601]+[602]+[603..debit]+[604]+[605]+[606]+[607]+[608]+[611]+[612]+[613]+[614]+[615]+[616]+[617]+[618]+[621]+[622]+[623]+[624]+[625]+[626]+[627]+[628]', '[603..credit]+[6091]+[6092]+[6094]+[6095]+[6096]+[6097]+[6098]+[6111]+[6112]+[6113]+[6114]+[6115]+[6116]+[6117]+[6118]+[6191]+[6192]+[6197]+[6198]+[6291]+[6292]+[6295]+[6296]+[6297]+[6298]', 'Compte de resultat', 'Consommation de l’exercice', 7, 1, null);
INSERT INTO ETATSORTIE (ID, LIBELLE, FORMULE1, FORMULE2, NOM, CATEGORIE, RANG, NIVEAU, IDPARENT) VALUES ('ETAT000057', 'IV - Excédent brut d’exploitation', '[741]+[748]+[701]+[702]+[703]+[704]+[705]+[706]+[707]+[708]+[713..credit]+[714]+[721]+[722]-[601]-[602]-[603..debit]-[604]-[605]-[606]-[607]-[608]-[611]-[612]-[613]-[614]-[615]-[616]-[617]-[618]-[621]-[622]-[623]-[624]-[625]-[626]-[627]-[628]-[641]-[644]-[645]-[646]-[647]-[648]-[631]-[635]-[638]', '[7091]+[7092]+[7093]+[7094]+[7095]+[7096]+[7097]+[7098]+[713..debit]-[603..credit]-[6091]-[6092]-[6094]-[6095]-[6096]-[6097]-[6098]-[6111]-[6112]-[6113]-[6114]-[6115]-[6116]-[6117]-[6118]-[6191]-[6192]-[6197]-[6198]-[6291]-[6292]-[6295]-[6296]-[6297]-[6298]', 'Compte de resultat', 'Excédent brut d’exploitation', 12, 1, null);
INSERT INTO ETATSORTIE (ID, LIBELLE, FORMULE1, FORMULE2, NOM, CATEGORIE, RANG, NIVEAU, IDPARENT) VALUES ('ETAT000001', 'Ecart d’acquisition (ou goodwill)', '[206]+[207]', '[2906]+[2807]', 'Bilan Actif', 'actifs non courants', 1, 1, null);
INSERT INTO ETATSORTIE (ID, LIBELLE, FORMULE1, FORMULE2, NOM, CATEGORIE, RANG, NIVEAU, IDPARENT) VALUES ('ETAT000002', 'Immobilisations incorporelles', null, null, 'Bilan Actif', 'actifs non courants', 2, 1, null);
INSERT INTO ETATSORTIE (ID, LIBELLE, FORMULE1, FORMULE2, NOM, CATEGORIE, RANG, NIVEAU, IDPARENT) VALUES ('ETAT000003', 'Frais de développement immobilier', '[203]', '[2803]', 'Bilan Actif', 'actifs non courants', 2, 2, 'ETAT000002');
INSERT INTO ETATSORTIE (ID, LIBELLE, FORMULE1, FORMULE2, NOM, CATEGORIE, RANG, NIVEAU, IDPARENT) VALUES ('ETAT000004', 'Concession, brevets, licences, logiciels et valeurs similaires', '[204]+[205]', '[2804]+[2805]', 'Bilan Actif', 'actifs non courants', 2, 3, 'ETAT000002');
INSERT INTO ETATSORTIE (ID, LIBELLE, FORMULE1, FORMULE2, NOM, CATEGORIE, RANG, NIVEAU, IDPARENT) VALUES ('ETAT000005', 'Autres', '[208]', '[2808]', 'Bilan Actif', 'actifs non courants', 2, 4, 'ETAT000002');
INSERT INTO ETATSORTIE (ID, LIBELLE, FORMULE1, FORMULE2, NOM, CATEGORIE, RANG, NIVEAU, IDPARENT) VALUES ('ETAT000006', 'Immobilisations corporelles', null, null, 'Bilan Actif', 'actifs non courants', 3, 1, null);
INSERT INTO ETATSORTIE (ID, LIBELLE, FORMULE1, FORMULE2, NOM, CATEGORIE, RANG, NIVEAU, IDPARENT) VALUES ('ETAT000007', 'Terrains', '[211]+[212]', '[2811]+[2812]', 'Bilan Actif', 'actifs non courants', 3, 2, 'ETAT000006');
INSERT INTO ETATSORTIE (ID, LIBELLE, FORMULE1, FORMULE2, NOM, CATEGORIE, RANG, NIVEAU, IDPARENT) VALUES ('ETAT000008', 'Construction', '[213]', '[2813]', 'Bilan Actif', 'actifs non courants', 3, 3, 'ETAT000006');
INSERT INTO ETATSORTIE (ID, LIBELLE, FORMULE1, FORMULE2, NOM, CATEGORIE, RANG, NIVEAU, IDPARENT) VALUES ('ETAT000009', 'Installation technique', '[215]', '[2815]', 'Bilan Actif', 'actifs non courants', 3, 4, 'ETAT000006');
INSERT INTO ETATSORTIE (ID, LIBELLE, FORMULE1, FORMULE2, NOM, CATEGORIE, RANG, NIVEAU, IDPARENT) VALUES ('ETAT000010', 'Autres', '[218]', '[2818]', 'Bilan Actif', 'actifs non courants', 3, 5, 'ETAT000006');
INSERT INTO ETATSORTIE (ID, LIBELLE, FORMULE1, FORMULE2, NOM, CATEGORIE, RANG, NIVEAU, IDPARENT) VALUES ('ETAT000011', 'Immobilisation mise en concession', '[22]', '[282]+[292]', 'Bilan Actif', 'actifs non courants', 4, 1, null);
INSERT INTO ETATSORTIE (ID, LIBELLE, FORMULE1, FORMULE2, NOM, CATEGORIE, RANG, NIVEAU, IDPARENT) VALUES ('ETAT000012', 'Immobilisations en cours', '[232]+[237]+[238]', '[2932]+[2937]+[2938]', 'Bilan Actif', 'actifs non courants', 5, 1, null);
INSERT INTO ETATSORTIE (ID, LIBELLE, FORMULE1, FORMULE2, NOM, CATEGORIE, RANG, NIVEAU, IDPARENT) VALUES ('ETAT000013', 'Immobilisations financières', null, null, 'Bilan Actif', 'actifs non courants', 6, 1, null);
INSERT INTO ETATSORTIE (ID, LIBELLE, FORMULE1, FORMULE2, NOM, CATEGORIE, RANG, NIVEAU, IDPARENT) VALUES ('ETAT000014', 'Titres mis en équivalence', '[261]+[262]+[265]', '[2961]+[2962]+[2965]', 'Bilan Actif', 'actifs non courants', 6, 2, 'ETAT000013');
INSERT INTO ETATSORTIE (ID, LIBELLE, FORMULE1, FORMULE2, NOM, CATEGORIE, RANG, NIVEAU, IDPARENT) VALUES ('ETAT000015', 'Autres participations et créances rattachées', '[266]+[267]+[268]+[269]', '[2966]+[2967]+[2968]', 'Bilan Actif', 'actifs non courants', 6, 3, 'ETAT000013');
INSERT INTO ETATSORTIE (ID, LIBELLE, FORMULE1, FORMULE2, NOM, CATEGORIE, RANG, NIVEAU, IDPARENT) VALUES ('ETAT000016', 'Autres titres immobilisés', '[271]+[272]+[273]', '[2971]+[2972]+[2973]', 'Bilan Actif', 'actifs non courants', 6, 4, 'ETAT000013');
INSERT INTO ETATSORTIE (ID, LIBELLE, FORMULE1, FORMULE2, NOM, CATEGORIE, RANG, NIVEAU, IDPARENT) VALUES ('ETAT000017', 'Prêts et autres immobilisations financières', '[274]+[275]+[276]+[277]+[279]', '[2974]+[2975]+[2976]+[2977]+[2979]', 'Bilan Actif', 'actifs non courants', 6, 5, 'ETAT000013');
INSERT INTO ETATSORTIE (ID, LIBELLE, FORMULE1, FORMULE2, NOM, CATEGORIE, RANG, NIVEAU, IDPARENT) VALUES ('ETAT000018', 'Impôts différés actifs – non courants', '[133]', null, 'Bilan Actif', 'actifs non courants', 6, 6, null);
INSERT INTO ETATSORTIE (ID, LIBELLE, FORMULE1, FORMULE2, NOM, CATEGORIE, RANG, NIVEAU, IDPARENT) VALUES ('ETAT000019', 'Stocks et en cours', '[31]+[32]', '[391]+[392]', 'Bilan Actif', 'actifs courants', 7, 1, null);
INSERT INTO ETATSORTIE (ID, LIBELLE, FORMULE1, FORMULE2, NOM, CATEGORIE, RANG, NIVEAU, IDPARENT) VALUES ('ETAT000020', 'Matière première', '[33]+[34]', '[393]+[394]', 'Bilan Actif', 'actifs courants', 7, 2, null);
INSERT INTO ETATSORTIE (ID, LIBELLE, FORMULE1, FORMULE2, NOM, CATEGORIE, RANG, NIVEAU, IDPARENT) VALUES ('ETAT000021', 'En cours de production', '[35]', '[395]', 'Bilan Actif', 'actifs courants', 7, 3, null);
INSERT INTO ETATSORTIE (ID, LIBELLE, FORMULE1, FORMULE2, NOM, CATEGORIE, RANG, NIVEAU, IDPARENT) VALUES ('ETAT000022', 'Produits finis', '[37]', '[397]', 'Bilan Actif', 'actifs courants', 7, 4, null);
INSERT INTO ETATSORTIE (ID, LIBELLE, FORMULE1, FORMULE2, NOM, CATEGORIE, RANG, NIVEAU, IDPARENT) VALUES ('ETAT000023', 'Marchandises', '[38]', '[398]', 'Bilan Actif', 'actifs courants', 7, 5, null);
INSERT INTO ETATSORTIE (ID, LIBELLE, FORMULE1, FORMULE2, NOM, CATEGORIE, RANG, NIVEAU, IDPARENT) VALUES ('ETAT000024', 'A l’extérieur', null, null, 'Bilan Actif', 'actifs courants', 7, 6, null);
INSERT INTO ETATSORTIE (ID, LIBELLE, FORMULE1, FORMULE2, NOM, CATEGORIE, RANG, NIVEAU, IDPARENT) VALUES ('ETAT000025', 'Créances et emplois assimilés', null, null, 'Bilan Actif', 'actifs courants', 8, 1, null);
INSERT INTO ETATSORTIE (ID, LIBELLE, FORMULE1, FORMULE2, NOM, CATEGORIE, RANG, NIVEAU, IDPARENT) VALUES ('ETAT000026', 'Clients et autres débiteurs', '[409]+[411]+[413]+[416]+[417]+[418]', '[491]', 'Bilan Actif', 'actifs courants', 8, 2, 'ETAT000025');
INSERT INTO ETATSORTIE (ID, LIBELLE, FORMULE1, FORMULE2, NOM, CATEGORIE, RANG, NIVEAU, IDPARENT) VALUES ('ETAT000027', 'Autres créances et actifs assimilés', '[422]+[424]+[425]+[428]+[441..debit]+[443..debit]+[445..debit]+[447..debit]+[448..debit]+[458..debit]+[462..debit]+[465..debit]+[467..debit]+[4687..debit]+[486]', '[495]+[496]', 'Bilan Actif', 'actifs courants', 8, 3, 'ETAT000025');
INSERT INTO ETATSORTIE (ID, LIBELLE, FORMULE1, FORMULE2, NOM, CATEGORIE, RANG, NIVEAU, IDPARENT) VALUES ('ETAT000028', 'Trésorerie et équivalents de trésorerie', null, null, 'Bilan Actif', 'actifs courants', 9, 1, null);
INSERT INTO ETATSORTIE (ID, LIBELLE, FORMULE1, FORMULE2, NOM, CATEGORIE, RANG, NIVEAU, IDPARENT) VALUES ('ETAT000029', 'Placements et autres équivalents de trésorerie', '[50]', '[59]', 'Bilan Actif', 'actifs courants', 9, 2, 'ETAT000028');
INSERT INTO ETATSORTIE (ID, LIBELLE, FORMULE1, FORMULE2, NOM, CATEGORIE, RANG, NIVEAU, IDPARENT) VALUES ('ETAT000030', 'Trésorerie (fonds en caisse et dépôts à vue)', '[511]+[512]+[515]+[517]+[518]+[53]+[54]', null, 'Bilan Actif', 'actifs courants', 9, 3, 'ETAT000028');
INSERT INTO ETATSORTIE (ID, LIBELLE, FORMULE1, FORMULE2, NOM, CATEGORIE, RANG, NIVEAU, IDPARENT) VALUES ('ETAT000031', 'Capital émis', '[101]+[108..credit]', '[108..debit]+[109]', 'Bilan Capitaux Propres et Passif', 'capitaux propres', 1, 1, null);
INSERT INTO ETATSORTIE (ID, LIBELLE, FORMULE1, FORMULE2, NOM, CATEGORIE, RANG, NIVEAU, IDPARENT) VALUES ('ETAT000032', 'Primes et réserves consolidées', '[104]+[106]', null, 'Bilan Capitaux Propres et Passif', 'capitaux propres', 2, 1, null);
INSERT INTO ETATSORTIE (ID, LIBELLE, FORMULE1, FORMULE2, NOM, CATEGORIE, RANG, NIVEAU, IDPARENT) VALUES ('ETAT000033', 'Ecarts d’évaluation', '[105]', null, 'Bilan Capitaux Propres et Passif', 'capitaux propres', 3, 1, null);
INSERT INTO ETATSORTIE (ID, LIBELLE, FORMULE1, FORMULE2, NOM, CATEGORIE, RANG, NIVEAU, IDPARENT) VALUES ('ETAT000034', 'Ecart d’équivalence', '[107]', null, 'Bilan Capitaux Propres et Passif', 'capitaux propres', 4, 1, null);
INSERT INTO ETATSORTIE (ID, LIBELLE, FORMULE1, FORMULE2, NOM, CATEGORIE, RANG, NIVEAU, IDPARENT) VALUES ('ETAT000036', 'Autres capitaux propres – report à nouveau', '[110..credit]', '[119..debit]', 'Bilan Capitaux Propres et Passif', 'capitaux propres', 6, 1, null);
INSERT INTO ETATSORTIE (ID, LIBELLE, FORMULE1, FORMULE2, NOM, CATEGORIE, RANG, NIVEAU, IDPARENT) VALUES ('ETAT000037', 'Produits différés : subventions d’investissement', '[131]+[132]', null, 'Bilan Capitaux Propres et Passif', 'passifs non courants', 7, 1, null);
INSERT INTO ETATSORTIE (ID, LIBELLE, FORMULE1, FORMULE2, NOM, CATEGORIE, RANG, NIVEAU, IDPARENT) VALUES ('ETAT000038', 'Impôts différés', '[134]+[138..credit]', null, 'Bilan Capitaux Propres et Passif', 'passifs non courants', 8, 1, null);
INSERT INTO ETATSORTIE (ID, LIBELLE, FORMULE1, FORMULE2, NOM, CATEGORIE, RANG, NIVEAU, IDPARENT) VALUES ('ETAT000039', 'Emprunts et dettes financières', '[16]+[17]', null, 'Bilan Capitaux Propres et Passif', 'passifs non courants', 9, 1, null);
INSERT INTO ETATSORTIE (ID, LIBELLE, FORMULE1, FORMULE2, NOM, CATEGORIE, RANG, NIVEAU, IDPARENT) VALUES ('ETAT000040', 'Provisions et produits constatés d’avance', '[15]', null, 'Bilan Capitaux Propres et Passif', 'passifs non courants', 10, 1, null);
INSERT INTO ETATSORTIE (ID, LIBELLE, FORMULE1, FORMULE2, NOM, CATEGORIE, RANG, NIVEAU, IDPARENT) VALUES ('ETAT000041', 'Dettes CT – partie CT de dettes LT', '[516]', null, 'Bilan Capitaux Propres et Passif', 'passifs courants', 11, 1, null);
INSERT INTO ETATSORTIE (ID, LIBELLE, FORMULE1, FORMULE2, NOM, CATEGORIE, RANG, NIVEAU, IDPARENT) VALUES ('ETAT000042', 'Fournisseurs et comptes rattachés', '[401]+[403]+[408]+[419]+[421]+[422..credit]+[426]+[427]+[4286]+[431]+[432]+[438]+[444]+[445..credit]+[446]+[447]+[4486]+[451..credit]+[455]+[456..credit]+[457]+[458..credit]+[464]+[467..credit]+[4686]', null, 'Bilan Capitaux Propres et Passif', 'passifs courants', 12, 1, null);
INSERT INTO ETATSORTIE (ID, LIBELLE, FORMULE1, FORMULE2, NOM, CATEGORIE, RANG, NIVEAU, IDPARENT) VALUES ('ETAT000043', 'Provisions et produits constatés d’avance – passifs courants', '[481]+[487]', null, 'Bilan Capitaux Propres et Passif', 'passifs courants', 13, 1, null);
INSERT INTO ETATSORTIE (ID, LIBELLE, FORMULE1, FORMULE2, NOM, CATEGORIE, RANG, NIVEAU, IDPARENT) VALUES ('ETAT000044', 'Autres dettes', '[404]+[405]', null, 'Bilan Capitaux Propres et Passif', 'passifs courants', 14, 1, null);
INSERT INTO ETATSORTIE (ID, LIBELLE, FORMULE1, FORMULE2, NOM, CATEGORIE, RANG, NIVEAU, IDPARENT) VALUES ('ETAT000045', 'Comptes de trésorerie (découverts bancaires)', '[519]', null, 'Bilan Capitaux Propres et Passif', 'passifs courants', 15, 1, null);
INSERT INTO ETATSORTIE (ID, LIBELLE, FORMULE1, FORMULE2, NOM, CATEGORIE, RANG, NIVEAU, IDPARENT) VALUES ('ETAT000046', 'I - Production de l’exercice', '[701]+[702]+[703]+[704]+[705]+[706]+[707]+[708]+[713..credit]+[714]+[721]+[722]', '[7091]+[7092]+[7093]+[7094]+[7095]+[7096]+[7097]+[7098]+[713..debit]', 'Compte de resultat', null, 4, 1, null);
INSERT INTO ETATSORTIE (ID, LIBELLE, FORMULE1, FORMULE2, NOM, CATEGORIE, RANG, NIVEAU, IDPARENT) VALUES ('ETAT000047', 'Chiffre d’affaires', '[701]+[702]+[703]+[704]+[705]+[706]+[707]+[708]', '[7091]+[7092]+[7093]+[7094]+[7095]+[7096]+[7097]+[7098]', 'Compte de resultat', null, 1, 1, null);
INSERT INTO ETATSORTIE (ID, LIBELLE, FORMULE1, FORMULE2, NOM, CATEGORIE, RANG, NIVEAU, IDPARENT) VALUES ('ETAT000048', 'Production stockée', '[713..credit]+[714]', '[713..debit]', 'Compte de resultat', null, 2, 1, null);
INSERT INTO ETATSORTIE (ID, LIBELLE, FORMULE1, FORMULE2, NOM, CATEGORIE, RANG, NIVEAU, IDPARENT) VALUES ('ETAT000049', 'Production immobilisée', '[721]+[722]', null, 'Compte de resultat', null, 3, 1, null);
INSERT INTO ETATSORTIE (ID, LIBELLE, FORMULE1, FORMULE2, NOM, CATEGORIE, RANG, NIVEAU, IDPARENT) VALUES ('ETAT000051', 'Achats consommés', '[601]+[602]+[603..debit]+[604]+[605]+[606]+[607]+[608]', '[603..credit]+[6091]+[6092]+[6094]+[6095]+[6096]+[6097]+[6098]', 'Compte de resultat', 'Production de l’exercice', 5, 1, 'ETAT000046');
INSERT INTO ETATSORTIE (ID, LIBELLE, FORMULE1, FORMULE2, NOM, CATEGORIE, RANG, NIVEAU, IDPARENT) VALUES ('ETAT000052', 'Services extérieurs et autres consommations', '[611]+[612]+[613]+[614]+[615]+[616]+[617]+[618]+[621]+[622]+[623]+[624]+[625]+[626]+[627]+[628]', '[6111]+[6112]+[6113]+[6114]+[6115]+[6116]+[6117]+[6118]+[6191]+[6192]+[6197]+[6198]+[6291]+[6292]+[6295]+[6296]+[6297]+[6298]', 'Compte de resultat', 'Production de l’exercice', 6, 1, 'ETAT000046');
INSERT INTO ETATSORTIE (ID, LIBELLE, FORMULE1, FORMULE2, NOM, CATEGORIE, RANG, NIVEAU, IDPARENT) VALUES ('ETAT000053', 'III - Valeur ajoutée d’exploitation', '[701]+[702]+[703]+[704]+[705]+[706]+[707]+[708]+[713..credit]+[714]+[721]+[722]-[601]-[602]-[603..debit]-[604]-[605]-[606]-[607]-[608]-[611]-[612]-[613]-[614]-[615]-[616]-[617]-[618]-[621]-[622]-[623]-[624]-[625]-[626]-[627]-[628]', '[7091]+[7092]+[7093]+[7094]+[7095]+[7096]+[7097]+[7098]+[713..debit]-[603..credit]-[6091]-[6092]-[6094]-[6095]-[6096]-[6097]-[6098]-[6111]-[6112]-[6113]-[6114]-[6115]-[6116]-[6117]-[6118]-[6191]-[6192]-[6197]-[6198]-[6291]-[6292]-[6295]-[6296]-[6297]-[6298]', 'Compte de resultat', 'Valeur ajoutée d’exploitation', 8, 1, null);
INSERT INTO ETATSORTIE (ID, LIBELLE, FORMULE1, FORMULE2, NOM, CATEGORIE, RANG, NIVEAU, IDPARENT) VALUES ('ETAT000054', 'Subvention d’exploitation', '[741]+[748]', null, 'Compte de resultat', 'Valeur ajoutée d’exploitation', 9, 1, 'ETAT000053');
INSERT INTO ETATSORTIE (ID, LIBELLE, FORMULE1, FORMULE2, NOM, CATEGORIE, RANG, NIVEAU, IDPARENT) VALUES ('ETAT000055', 'Charges de personnel (A)', '[641]+[644]+[645]+[646]+[647]+[648]', null, 'Compte de resultat', 'Valeur ajoutée d’exploitation', 10, 1, 'ETAT000053');
INSERT INTO ETATSORTIE (ID, LIBELLE, FORMULE1, FORMULE2, NOM, CATEGORIE, RANG, NIVEAU, IDPARENT) VALUES ('ETAT000056', 'Impôts, taxes et versements assimilés', '[631]+[635]+[638]', null, 'Compte de resultat', 'Valeur ajoutée d’exploitation', 11, 1, 'ETAT000053');
INSERT INTO ETATSORTIE (ID, LIBELLE, FORMULE1, FORMULE2, NOM, CATEGORIE, RANG, NIVEAU, IDPARENT) VALUES ('ETAT000058', 'Autres produits opérationnels', '[751]+[752]+[753]+[754]+[755]+[756]+[757]+[758]', null, 'Compte de resultat', 'Excédent brut d’exploitation', 13, 1, 'ETAT000057');

create view COMPTA_ECRITURE_FICHE as
select ce."ID",ce."DATY",ce."DATECOMPTABLE",ce."EXERCICE",ce."DESIGNATION",ce."REMARQUE",ce."ETAT",ce."HORSEXERCICE",ce."JOURNAL",ce."OD",ce."ORIGINE",ce."CREDIT",ce."DEBIT",ce."IDUSER",ce."PERIODE",ce."TRIMESTRE",ce."ANNEE",ce."IDOBJET",ce."LETTRAGE",vc.FICHE as lien from COMPTA_ECRITURE ce
                                                                                                                                                                                                                                                                                      left join V_CLASSEETFICHE vc on substr(ce.IDOBJET,1,3)=vc.LIBELLE

create or replace view COMPTA_ECRITURE_LIB as
SELECT
    ce.ID,ce.DATY,ce.DATECOMPTABLE,ce.EXERCICE,ce.DESIGNATION,ce.REMARQUE,ce.ETAT,ce.HORSEXERCICE,ce.JOURNAL,ce.OD,ce.ORIGINE,ce.CREDIT,ce.DEBIT,ce.IDUSER,ce.PERIODE,ce.TRIMESTRE,ce.ANNEE,ce.IDOBJET ,
    CAST(cm.montant AS NUMBER(38,2)) AS montant,
    cj.desce AS JOURNALLIB,
    CASE
        WHEN ce.ETAT = 1  THEN 'Créer'
        WHEN ce.ETAT = 11 THEN 'Validée'
        ELSE 'Autre'
        END AS etatlib
FROM COMPTA_ECRITURE ce
         JOIN COMPTA_MONTANT cm ON ce.id = cm.IDMERE
         LEFT JOIN COMPTA_JOURNAL cj ON cj.id = ce.JOURNAL;
