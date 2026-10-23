ALTER table AS_INGREDIENTS add PARFUMS VARCHAR2(100);
ALTER TABLE AS_INGREDIENTS ADD IDFAMILLE VARCHAR2(100);

create table FamilleProduit(
    id varchar(100) constraint FamilleProduit_pk primary key ,
    val varchar(255) ,
    desce varchar(255)
);
 
 
create sequence seqFamilleProduit
      minvalue 1
      maxvalue 999999999999
      start with 1
      increment by 1
      cache 20;
     
     
 
CREATE OR REPLACE FUNCTION getseqFamilleProduit
   RETURN NUMBER
IS
   retour   NUMBER;
BEGIN
   SELECT seqFamilleProduit.NEXTVAL INTO retour FROM DUAL;
 
   RETURN retour;
END;
 
 
INSERT INTO FamilleProduit VALUES('FAMPROD00'||getseqFamilleProduit(),'Tchido','Tchido');

CREATE OR REPLACE VIEW AS_INGREDIENTS_LIB  AS 
  SELECT ing.id,
       ing.LIBELLE,
       ing.PARFUMS,
       ing.SEUIL,
       au.VAL AS unite,
       ing.QUANTITEPARPACK,
       ing.pu,
       ing.ACTIF,
       ing.PHOTO,
       ing.CALORIE,
       ing.DURRE,
       ing.COMPOSE,
       CAST(
               CASE
                   WHEN ing.COMPOSE = 1 THEN 'OUI'
                   WHEN ing.COMPOSE = 0 THEN 'NON'
                   END AS VARCHAR2(100)
       ) AS COMPOSELIB,
       cating.id AS IDCATEGORIEINGREDIENT ,
       catIng.VAL AS CATEGORIEINGREDIENT,
       ing.CATEGORIEINGREDIENT AS idcategorie,
       ing.idfournisseur,
       ing.daty,
       catIng.desce as bienOuServ,
       CASE WHEN ing.id IN (SELECT idproduit FROM INDISPONIBILITE i )
                THEN 'INDISPONIBLE'
            WHEN ing.id NOT IN (SELECT idproduit FROM INDISPONIBILITE i )
                THEN 'DISPONIBLE'
           END AS etatlib,
       ing.COMPTE_VENTE,
       ing.COMPTE_ACHAT,
       ing.pv,
       ing.tva,
       ing.TYPESTOCK,
       ing.UNITE as idunite,
       ing.REFPOST,
       ing.REFQUALIFICATION ,
       p.VAL AS REFPOSTLIB,
       qp.VAL AS REFQUALIFICATIONLIB,
       fp.val AS idfamilleLib
       
FROM as_ingredients ing
         LEFT JOIN AS_UNITE AU ON ing.UNITE = AU.ID
         LEFT JOIN CATEGORIEINGREDIENTLIB catIng
                   ON catIng.id = ing.CATEGORIEINGREDIENT
         LEFT JOIN POSTE p ON p.id = ing.REFPOST
         LEFT JOIN FAMILLEPRODUIT fp ON fp.id=ing.idfamille
         LEFT JOIN QUALIFICATION_PAIE qp ON qp.id = ing.REFQUALIFICATION;

CREATE OR REPLACE  VIEW AS_INGREDIENTS_LIB2  AS 
  SELECT ing.id,
       concat(concat(ing.LIBELLE,' '),ing.PARFUMS) as LIBELLE,
       ing.PARFUMS,
       ing.SEUIL,
       au.VAL AS unitelib,
       ing.QUANTITEPARPACK,
       ing.pu,
       ing.ACTIF,
       ing.PHOTO,
       ing.CALORIE,
       ing.DURRE,
       ing.COMPOSE,
       CAST(
               CASE
                   WHEN ing.COMPOSE = 1 THEN 'OUI'
                   WHEN ing.COMPOSE = 0 THEN 'NON'
                   END AS VARCHAR2(100)
       ) AS COMPOSELIB,
       cating.id AS IDCATEGORIEINGREDIENT ,
       catIng.VAL AS CATEGORIEINGREDIENT,
       ing.CATEGORIEINGREDIENT AS idcategorie,
       ing.idfournisseur,
       ing.daty,
       catIng.desce as bienOuServ,
       CASE WHEN ing.id IN (SELECT idproduit FROM INDISPONIBILITE i )
                THEN 'INDISPONIBLE'
            WHEN ing.id NOT IN (SELECT idproduit FROM INDISPONIBILITE i )
                THEN 'DISPONIBLE'
           END AS etatlib,
       ing.COMPTE_VENTE,
       ing.COMPTE_ACHAT,
       ing.pv,
       ing.tva,
       ing.TYPESTOCK,
       ing.UNITE as unite,
       ing.REFPOST,
       ing.REFQUALIFICATION ,
       p.VAL AS REFPOSTLIB,
       qp.VAL AS REFQUALIFICATIONLIB
FROM as_ingredients ing
         LEFT JOIN AS_UNITE AU ON ing.UNITE = AU.ID
         LEFT JOIN CATEGORIEINGREDIENTLIB catIng
                   ON catIng.id = ing.CATEGORIEINGREDIENT
         LEFT JOIN POSTE p ON p.id = ing.REFPOST
         LEFT JOIN QUALIFICATION_PAIE qp ON qp.id = ing.REFQUALIFICATION;

INSERT INTO TYPECLIENT
(ID, VAL, DESCE)
VALUES('TYPE001', 'GMS', 'GMS');
INSERT INTO TYPECLIENT
(ID, VAL, DESCE)
VALUES('TYPE002', 'GROSSISTE', 'GROSSISTE');



CREATE OR REPLACE  VIEW AS_INGREDIENT_VENTE_LIB AS 
  select ing."ID",
       concat(concat(ing.LIBELLE,' '),ing.PARFUMS) as LIBELLE,
       ing."SEUIL",ing."UNITE",ing."QUANTITEPARPACK",ing."PU",ing."ACTIF",ing."PHOTO",ing."CALORIE",ing."DURRE",ing."COMPOSE",ing."CATEGORIEINGREDIENT",ing."IDFOURNISSEUR",ing."DATY",ing."QTELIMITE",ing."PV",ing."LIBELLEVENTE",ing."SEUILMIN",ing."SEUILMAX",ing."PUACHATUSD",ing."PUACHATEURO",ing."PUACHATAUTREDEVISE",ing."PUVENTEUSD",ing."PUVENTEEURO",ing."PUVENTEAUTREDEVISE",ing."ISVENTE",ing."ISACHAT",ing."COMPTE_VENTE",ing."COMPTE_ACHAT",ing."LIBELLEEXTACTE",ing."TVA",ing."FILEPATH",ing."RESTE",ing."TYPESTOCK",ing."REFPOST",ing."REFQUALIFICATION",ing."IDCHAMBRE",ing."ISPERISHABLE",ing."PV2",ing."IDMAGASIN",ting.PRIXUNITAIRE,TING.IDTYPECLIENT,tc.VAL as idtypeclientlib,un.id as idunite,un.VAL as idunitelib,eq.POIDS,eq.QTE from AS_INGREDIENTS ing
      join TARIF_INGREDIENTS_MAX ting on ing.ID=TING.IDINGREDIENT
      join AS_UNITE un on un.ID=TING.UNITE
      join TYPECLIENT tc on tc.ID=TING.IDTYPECLIENT
      left join EQUIVALENCE eq on eq.IDPRODUIT=ting.IDINGREDIENT and eq.IDUNITE=ting.UNITE;

UPDATE CLIENT
SET NOM='SORAKO', TELEPHONE='0344554547', MAIL='randriatsarafara.tv@gmail.com', ADRESSE='IIB 216 Mahalavolona', REMARQUE=NULL, COMPTE='41120010056', IDNATIONALITE=NULL, COMPTEAUXILIAIRE=NULL, ECHEANCE=5, IDTYPECLIENT='TYPE002', TELFIXE='034', IDPROVINCE=NULL, NIF='50302457383945', STAT='1888202112016010800', CARTE='2457', DATECARTE=TIMESTAMP '2025-10-03 00:00:00.000000', TAXE=0, CODECLIENT=NULL
WHERE ID='CLI00SOC01968';

UPDATE AS_INGREDIENTS
SET  IDMAGASIN='PHARM005'
WHERE ID='IG000649';

CREATE OR REPLACE VIEW BONDECOMMANDE_CLIENT_CPL  AS 
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
        WHEN bc.ETAT = 0 THEN '<span style=color: green;>ANNUL&Eacute;</span>'
        WHEN bc.ETAT = 1 THEN '<span style=color: green;>CR&Eacute;&Eacute;</span>'
        WHEN bc.ETAT = 11 THEN '<span style=color: green;>VALID&Eacute;</span>'
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
;

alter table vente add NUMEROFACTURE varchar(100);

CREATE OR REPLACE VIEW V_NUMEROFACTURE_EN_COURS  AS 
  SELECT
    EXTRACT(YEAR FROM SYSDATE) AS ANNEE_EN_COURS,
    NVL(MAX(TO_NUMBER(SUBSTR(NUMEROFACTURE, 1, INSTR(NUMEROFACTURE, '/') - 1))), 0) AS DERNIER_NUM,
    NVL(MAX(TO_NUMBER(SUBSTR(NUMEROFACTURE, 1, INSTR(NUMEROFACTURE, '/') - 1))), 0) + 1 AS PROCHAIN_NUM,
    LPAD(NVL(MAX(TO_NUMBER(SUBSTR(NUMEROFACTURE, 1, INSTR(NUMEROFACTURE, '/') - 1))), 0) + 1, 4, '0')
    || '/' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE)) AS PROCHAIN_NUM_FORMAT
FROM VENTE
WHERE SUBSTR(NUMEROFACTURE, INSTR(NUMEROFACTURE, '/') + 1) = TO_CHAR(EXTRACT(YEAR FROM SYSDATE))
;

CREATE OR REPLACE  VIEW VENTE_CPL AS 
  SELECT v.ID,
       v.DESIGNATION,
       v.IDMAGASIN,
       m.VAL AS IDMAGASINLIB,
       v.DATY,
       v.REMARQUE,
       v.ETAT,
       CASE
           WHEN v.ETAT = 1 THEN 'CR&Eacute;&Eacute;E'
           WHEN v.ETAT = 11 THEN 'VIS&Eacute;E'
           WHEN v.ETAT = 0 THEN 'ANNUL&Eacute;E'
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
       CAST(vp.poids as number(30,2)) as poids,
       CAST(vp.colis as number(30,2)) as colis,
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
       v.IDORIGINE,
       v.FRAISLIVRAISON as frais,
       v.REFERENCEFACT,
       v.NUMEROFACTURE
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


CREATE OR REPLACE FUNCTION getseqreferencefacture
      RETURN NUMBER
IS
   retour   NUMBER;
BEGIN
   SELECT SEQREFERENCEFACTURE.NEXTVAL INTO retour FROM DUAL;

   RETURN retour;
END;


alter table AVOIRFC add IDTYPEAVOIR varchar(255) constraint FK_avoir_typeavoir REFERENCES TYPEAVOIR(id);

CREATE OR REPLACE  VIEW AVOIRFCLIB  AS 
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
        left join TYPEAVOIR ta on ta.id = a.IDTYPEAVOIR;


CREATE OR REPLACE VIEW AVOIRFCLIB_CPL  AS 
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


CREATE OR REPLACE VIEW DMDACHATLIB  AS 
  SELECT
    da.id,
    da.daty,
    da.fournisseur,
    f.nom AS fournisseurlib,
    da.remarque,
    da.etat,
    CASE
        WHEN da.ETAT = 0
            THEN 'ANNUL&Eacute;(E)'
        WHEN da.ETAT = 1
            THEN 'CR&Eacute;&Eacute;(E)'
        WHEN da.ETAT = 11
            THEN 'VIS&Eacute;(E)'
        END AS etatlib
FROM DMDACHAT da
         LEFT JOIN FOURNISSEUR f ON f.ID = da.fournisseur;