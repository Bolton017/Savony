-- 2026-08-12-10_00-savonnerie0508

ALTER TABLE vente ADD nomclientdivers varchar(255) ;

CREATE OR REPLACE VIEW INSERTION_VENTE_PERSONNEL AS
SELECT v.ID,
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
       v.idCommercial,
       v.idmodepaiement,
       v.remise,
       v.remiseMontant,
       v.HEURESAISIE,
       v.IDRESPONSABLE,
       v.NOMCLIENTDIVERS
FROM VENTE v;

CREATE OR REPLACE VIEW INSERTION_VENTE_PERSONNEL_VIDE AS
SELECT id,daty,designation,idmagasin,remarque,etat,idorigine,idclient,iddevise,estprevu,datyprevu,idreservation,idcommercial,idmodepaiement,remise,remisemontant,HEURESAISIE, IDRESPONSABLE, NOMCLIENTDIVERS FROM INSERTION_VENTE_PERSONNEL;

ALTER TABLE Client ADD idPoint varchar(255);

CREATE OR REPLACE VIEW ST_INGVENTEPOS_STANDARD_SAV AS
SELECT
    ai.ID,
    ai.LIBELLE AS LIBELLE,
    ai.SEUIL,
    ai.UNITE,
    ai.QUANTITEPARPACK,
    ai.PU,
    ai.ACTIF,
    ai.PHOTO,
    ai.CALORIE,
    ai.DURRE,
    ai.COMPOSE,
    ai.CATEGORIEINGREDIENT,
    ai.IDFOURNISSEUR,
    ai.DATY,
    ai.QTELIMITE,
    ai.PV,
    ai.LIBELLEVENTE,
    ai.SEUILMIN,
    ai.SEUILMAX,
    ai.PUACHATUSD,
    ai.PUACHATEURO,
    ai.PUACHATAUTREDEVISE,
    ai.PUVENTEUSD,
    ai.PUVENTEEURO,
    ai.PUVENTEAUTREDEVISE,
    ai.ISVENTE,
    ai.ISACHAT,
    ai.COMPTE_VENTE,
    ai.COMPTE_ACHAT,
    ai.TVA,
    1 AS TAUX,
    ai.COMPTE_VENTE AS COMPTE,
    ai.LIBELLE || ' ' || ai.COULEUR || ' ' || ai.TAILLE AS LIBELLECOMPOSANT,
    ai.COULEUR,
    ai.CODEBARRE,
    ai.REFERENCE,
    ai.CODEGROS,
    ai.PVGROS,
    u.VAL AS UNITELIB,
    CONCAT(CONCAT(ai.LIBELLE, ' - '), u.VAL) AS DESIGNATION,
    ai.TYPESTOCK,
    CAST(ai.PV * (1 + ai.TVA / 100) AS NUMBER(30,2)) AS PVTVA,
    CAST(ai.PV * (1 + ai.TVA / 100) AS NUMBER(30,2)) AS montantTTC
FROM AS_INGREDIENTS ai
         LEFT JOIN AS_RECETTE ar
                   ON ar.IDPRODUITS = ai.ID
         LEFT JOIN AS_INGREDIENTS cps
                   ON cps.ID = ar.IDINGREDIENTS
         LEFT JOIN AS_UNITE u
                   ON ai.UNITE = u.ID
WHERE ai.PV <> 0
  AND ai.ACTIF = 1
GROUP BY
    ai.ID,
    ai.LIBELLE,
    ai.SEUIL,
    ai.UNITE,
    ai.QUANTITEPARPACK,
    ai.PU,
    ai.ACTIF,
    ai.PHOTO,
    ai.CALORIE,
    ai.DURRE,
    ai.COMPOSE,
    ai.CATEGORIEINGREDIENT,
    ai.IDFOURNISSEUR,
    ai.DATY,
    ai.QTELIMITE,
    ai.PV,
    ai.LIBELLEVENTE,
    ai.SEUILMIN,
    ai.SEUILMAX,
    ai.PUACHATUSD,
    ai.PUACHATEURO,
    ai.PUACHATAUTREDEVISE,
    ai.PUVENTEUSD,
    ai.PUVENTEEURO,
    ai.PUVENTEAUTREDEVISE,
    ai.ISVENTE,
    ai.ISACHAT,
    ai.COMPTE_VENTE,
    ai.COMPTE_ACHAT,
    ai.TVA,
    ai.COULEUR,
    ai.TAILLE,
    ai.CODEBARRE,
    ai.REFERENCE,
    ai.CODEGROS,
    ai.PVGROS,
    u.VAL,
    ai.TYPESTOCK;


ALTER TABLE VENTE_DETAILS ADD REMISEMONTANT NUMBER(30, 2);

CREATE OR REPLACE VIEW VENTEDETAILS_POS_STANDARD_SAV AS
SELECT
    vd.ID,
    vd.IDVENTE,
    vd.IDPRODUIT,
    vd.DESIGNATION,
    vd.IDORIGINE,
    vd.QTE,
    vd.PU,
    vd.REMISE,
    NVL(vd.REMISEMONTANT, 0) AS REMISEMONTANT,
    vd.TVA,
    vd.PUACHAT,
    vd.PUVENTE,
    vd.IDDEVISE,
    vd.TAUXDECHANGE,
    vd.COMPTE,
    vd.PHOTO,
    vd.REFERENCE,
    vd.MONTANT,
    vd.UNITE,
    vd.RISTOURNE,
    CAST(ai.PV * (1 + ai.TVA / 100) AS NUMBER(30,2)) AS montantTTC
FROM VENTE_DETAILS vd
         LEFT JOIN AS_INGREDIENTS ai
                   ON ai.ID = vd.IDPRODUIT;


ALTER TABLE VENTE
    ADD (
    ADECLARER NUMBER(38,0),
    IDECHEANCEPAIEMENT VARCHAR2(255),
    DATEECHEANCE DATE,
    FACTUREECHANGE VARCHAR2(100)
);


-- 2026-08-12-14_00-savonnerie0508

CREATE TABLE REMISE (
                        ID VARCHAR2(255),
                        DATY DATE,
                        NOM VARCHAR2(155),
                        DATEDEBUT DATE,
                        DATEFIN DATE,
                        ETAT NUMBER,
                        PRIMARY KEY (ID)
);

CREATE TABLE REMISEFILLE (
                             ID VARCHAR2(255),
                             REMISE NUMBER(30,2),
                             IDCATEGORIECLIENT VARCHAR2(255),
                             IDPRODUIT VARCHAR2(255),
                             CATEGORIEPRODUIT VARCHAR2(255),
                             IDPOINT VARCHAR2(255),
                             IDREMISE VARCHAR2(255),

                             FOREIGN KEY (IDPRODUIT)
                                 REFERENCES AS_INGREDIENTS (ID),

                             FOREIGN KEY (IDCATEGORIECLIENT)
                                 REFERENCES TYPECLIENT (ID),

                             FOREIGN KEY (CATEGORIEPRODUIT)
                                 REFERENCES CATEGORIEINGREDIENT (ID),

                             FOREIGN KEY (IDREMISE)
                                 REFERENCES REMISE (ID),

                             FOREIGN KEY (IDPOINT)
                                 REFERENCES POINT (ID)
);

CREATE OR REPLACE VIEW REMISEFILLELIB AS
SELECT
    rf.id,
    rf.remise,
    rf.idCategorieClient,
    tp.val AS idCategorieClientlib,
    rf.idProduit,
    ai.libelle,
    rf.cateGorieProduit,
    cti.val AS CATEGORIEPRODUITLIB,
    rf.idPoint,
    p.val AS idPointLib,
    rf.idRemise
FROM RemiseFille rf
         LEFT JOIN typeclient tp ON tp.id = rf.idCategorieClient
         LEFT JOIN as_ingredients ai ON ai.id = rf.idProduit
         LEFT JOIN point p ON p.id = rf.idPoint
         LEFT JOIN categorieingredient cti ON cti.id = rf.CATEGORIEPRODUIT
;

CREATE OR REPLACE VIEW REMISEFILLEMERE AS
select rf."ID",rf."REMISE",rf."IDCATEGORIECLIENT",rf."IDPRODUIT",rf."CATEGORIEPRODUIT",rf."IDPOINT",rf."IDREMISE",r.nom,r.daty,r.dateDebut,r.dateFin,r.etat from remiseFille rf left join remise r on r.id=rf.idremise
;

CREATE OR REPLACE VIEW REMISEFILLEMERELIB AS
SELECT
    r.id AS idmere,
    rf.id AS idfille,
    r.daty,
    r.nom,
    r.datedebut,
    r.datefin,
    r.etat,
    rf.remise,
    rf.idCategorieClient,
    tp.val AS idCategorieClientLib,
    rf.idProduit,
    ai.libelle AS idProduitLib,
    rf.cateGorieProduit,
    cti.val AS cateGorieProduitLib,
    rf.idPoint,
    p.val AS idPointLib
FROM Remise r
         LEFT JOIN RemiseFille rf ON r.id = rf.idRemise
         LEFT JOIN typeclient tp ON tp.id = rf.idCategorieClient
         LEFT JOIN as_ingredients ai ON ai.id = rf.idProduit
         LEFT JOIN point p ON p.id = rf.idPoint
         LEFT JOIN categorieingredient cti ON cti.id = rf.CATEGORIEPRODUIT
;

CREATE OR REPLACE VIEW REMISEFILLEMEREVISE AS
select rf."ID",rf."REMISE",rf."IDCATEGORIECLIENT",rf."IDPRODUIT",rf."CATEGORIEPRODUIT",rf."IDPOINT",rf."IDREMISE",r.nom,r.daty,r.dateDebut,r.dateFin,r.etat from remiseFille rf left join remise r on r.id=rf.idremise where r.etat>=11
;

CREATE OR REPLACE VIEW ST_INGSPOS_REM_STANDARD_SAV AS
SELECT
    ai.ID,
    ai.LIBELLE AS libelle,
    ai.SEUIL,
    ai.UNITE,
    ai.QUANTITEPARPACK,
    ai.PU,
    ai.ACTIF,
    ai.PHOTO,
    ai.CALORIE,
    ai.DURRE,
    ai.COMPOSE,
    ai.CATEGORIEINGREDIENT,
    ai.IDFOURNISSEUR,
    ai.DATY,
    ai.QTELIMITE,
    ai.PV,
    ai.LIBELLEVENTE,
    ai.SEUILMIN,
    ai.SEUILMAX,
    ai.PUACHATUSD,
    ai.PUACHATEURO,
    ai.PUACHATAUTREDEVISE,
    ai.PUVENTEUSD,
    ai.PUVENTEEURO,
    ai.PUVENTEAUTREDEVISE,
    ai.ISVENTE,
    ai.ISACHAT,
    ai.COMPTE_VENTE,
    ai.COMPTE_ACHAT,
    ai.TVA,
    1 AS taux,
    ai.COMPTE_VENTE AS compte,
    ai.LIBELLE || ' ' || ai.COULEUR || ' ' || ai.TAILLE AS libellecomposant,
    ai.COULEUR,
    ai.TAILLE,
    ai.codebarre,
    ai.REFERENCE,
    ai.codegros,
    ai.pvgros,
    u.VAL AS UNITELIB,
    CONCAT(CONCAT(ai.libelle, ' - '), u.val) AS designation,
    CAST(ai.PV * (1 + ai.TVA / 100) AS NUMBER(30,2)) AS PVTVA,
    rfmv.remise,
    CAST((ai.PV * (1 + ai.TVA / 100)) * (1 - NVL(rfmv.remise, 0) / 100) AS NUMBER(30,2)) AS pvRemise,
    rfmv.IDCATEGORIECLIENT,
    rfmv.IDPOINT,
    rfmv.id AS idRemiseFille,
    rfmv.idRemise,
    rfmv.nom AS RemiseNom,
    rfmv.daty AS datyRemise,
    rfmv.DATEDEBUT AS datedebutRemise,
    rfmv.DATEFIN AS datefinRemise,
    ai.TYPESTOCK

FROM AS_INGREDIENTS ai

         LEFT JOIN AS_RECETTE ar
                   ON ar.IDPRODUITS = ai.ID

         LEFT JOIN AS_INGREDIENTS cps
                   ON cps.ID = ar.IDINGREDIENTS

         LEFT JOIN AS_UNITE u
                   ON ai.unite = u.id

         LEFT JOIN remiseFilleMereVise rfmv
                   ON (
                       (rfmv.idproduit IS NOT NULL
                           AND rfmv.idproduit = ai.id)

                           OR (rfmv.idproduit IS NULL
                           AND rfmv.CATEGORIEPRODUIT IS NOT NULL
                           AND rfmv.CATEGORIEPRODUIT = ai.CATEGORIEINGREDIENT)

                           OR (rfmv.idproduit IS NULL
                           AND rfmv.CATEGORIEPRODUIT IS NULL)
                       )

WHERE ai.PV != 0
AND ai.ACTIF = 1
GROUP BY
    ai.ID,
    ai.LIBELLE,
    ai.SEUIL,
    ai.UNITE,
    ai.QUANTITEPARPACK,
    ai.PU,
    ai.ACTIF,
    ai.PHOTO,
    ai.CALORIE,
    ai.DURRE,
    ai.COMPOSE,
    ai.CATEGORIEINGREDIENT,
    ai.IDFOURNISSEUR,
    ai.DATY,
    ai.QTELIMITE,
    ai.PV,
    ai.LIBELLEVENTE,
    ai.SEUILMIN,
    ai.SEUILMAX,
    ai.PUACHATUSD,
    ai.PUACHATEURO,
    ai.PUACHATAUTREDEVISE,
    ai.PUVENTEUSD,
    ai.PUVENTEEURO,
    ai.PUVENTEAUTREDEVISE,
    ai.ISVENTE,
    ai.ISACHAT,
    ai.COMPTE_VENTE,
    ai.COMPTE_ACHAT,
    ai.TVA,
    ai.COULEUR,
    ai.TAILLE,
    ai.REFERENCE,
    ai.codebarre,
    u.VAL,
    ai.codegros,
    ai.pvgros,
    rfmv.remise,
    rfmv.IDCATEGORIECLIENT,
    rfmv.IDPOINT,
    rfmv.id,
    rfmv.idRemise,
    rfmv.nom,
    rfmv.daty,
    rfmv.DATEDEBUT,
    rfmv.DATEFIN,
    ai.TYPESTOCK
;

INSERT INTO MODEPAIEMENT
(ID, VAL, DESCE)
VALUES('MP00023', 'Carte Cadeau', 'Carte Cadeau');
INSERT INTO MODEPAIEMENT
(ID, VAL, DESCE)
VALUES('MP00024', 'Bon d''achat', 'Bon d''achat');

INSERT INTO CATEGORIECAISSE
(ID, VAL, DESCE, IDTYPECAISSE)
VALUES('CTC0010', 'Carte Cadeau', 'Carte Cadeau', 'TCA004');
INSERT INTO CATEGORIECAISSE
(ID, VAL, DESCE, IDTYPECAISSE)
VALUES('CTC0011', 'Bon d''achat', 'Bon d''achat', 'TCA004');