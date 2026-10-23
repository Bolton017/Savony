CREATE TABLE crconfig (
                          id VARCHAR2(100) PRIMARY KEY,
                          heureEnvoi VARCHAR2(5),
                          jourEnvoi VARCHAR2(10),
                          dateEnvoi int,
                          finMois int,
                          journaliere NUMBER(1) DEFAULT 0,
                          hebdomadaire NUMBER(1) DEFAULT 0,
                          mensuel NUMBER(1) DEFAULT 0
);

CREATE TABLE crcontent(
                          id VARCHAR2(100) PRIMARY KEY,
                          titre VARCHAR2(255),
                          paragraphe VARCHAR2(255),
                          mapping VARCHAR2(255),
                          vue VARCHAR2(255),
                          graphe int
);

CREATE table crcontentfille(
                               id VARCHAR2(100) PRIMARY KEY,
                               idCrContent VARCHAR2(100),
                               libEntete VARCHAR2(255),
                               libEnteteAfficher VARCHAR2(255),
                               colSomme int DEFAULT 0,
                               colDate int DEFAULT 0,
                               FOREIGN KEY (idCrContent) REFERENCES crcontent(id)
);

CREATE table ouinon(
                       id VARCHAR2(100) PRIMARY KEY,
                       val VARCHAR2(255),
                       desce VARCHAR2(255)
);

create or replace view crDateFormu as
SELECT
    '' as daty
FROM DUAL;

CREATE OR REPLACE VIEW crContentLib as
SELECT
    c.*,
    CASE
        WHEN c.graphe = 0 THEN 'Non'
        WHEN c.graphe = 1 THEN 'Oui'
        END AS grapheLib
FROM CRCONTENT c ;

CREATE OR REPLACE VIEW crContentFilleLib as
SELECT
    c.*,
    CASE
        WHEN c.colSomme = 1 THEN 'Oui'
        WHEN c.colSomme = 2 THEN 'Non'
        END AS colSommeLib,
    CASE
        WHEN c.colDate = 1 THEN 'Oui'
        WHEN c.colDate = 2 THEN 'Non'
        END AS colDateLib
FROM CRCONTENTFILLE c ;

create sequence seqMailRapport
    minvalue 1
    maxvalue 999999999999
    start with 1
    increment by 1
    cache 20;

CREATE OR REPLACE FUNCTION getseqMailRapport
   RETURN NUMBER
IS
   retour   NUMBER;
BEGIN
SELECT seqMailRapport.NEXTVAL INTO retour FROM DUAL;
RETURN retour;
END;

create sequence seqCRContent
    minvalue 1
    maxvalue 999999999999
    start with 1
    increment by 1
    cache 20;


CREATE OR REPLACE FUNCTION getseqCRContent
   RETURN NUMBER
IS
   retour   NUMBER;
BEGIN
SELECT seqCRContent.NEXTVAL INTO retour FROM DUAL;

RETURN retour;
END;

create sequence seqCRContentFille
    minvalue 1
    maxvalue 999999999999
    start with 1
    increment by 1
    cache 20;

CREATE OR REPLACE FUNCTION getseqCRContentFille
   RETURN NUMBER
IS
    retour   NUMBER;
BEGIN
SELECT seqCRContentFille.NEXTVAL INTO retour FROM DUAL;
RETURN retour;
END;

INSERT INTO CRCONFIG
(ID, HEUREENVOI, JOURENVOI, DATEENVOI, FINMOIS, JOURNALIERE, HEBDOMADAIRE, MENSUEL)
VALUES('CRCF000001', '05:10', 'Vendredi', 28, 0, 0, 0, 0);

insert into ouinon (id, val, desce) values ('1', 'Oui', 'Oui');
insert into ouinon (id, val, desce) values ('2', 'Non', 'Non');

-- Insert Menu Dynamique
INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MENUDYNC003', 'Rapport', 'fa fa-history', NULL, 16, 1, NULL);

-- ------------------
INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MENUDYNC005', 'Config', 'fa fa-cog', NULL, 1, 2, 'MENUDYNC003');

-- ------------------

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MENUDYNC006', 'Destinataire/Cc', 'fa fa-users', NULL, 1, 3, 'MENUDYNC005');

-- ------------------

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MENUDYNC007', 'Saisie', 'fa fa-plus', 'module.jsp?but=rapport/configuration/mailrapport/mailrapport-saisie.jsp', 1, 4, 'MENUDYNC006');
INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MENUDYNC008', 'Liste', 'fa fa-list', 'module.jsp?but=rapport/configuration/mailrapport/mailrapport-liste.jsp', 2, 4, 'MENUDYNC006');

-- ------------------

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MENUDYNC009', 'Compte Rendu', 'fa fa-file', NULL, 2, 3, 'MENUDYNC005');

-- ------------------

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MENUDYNC0010', 'Envoi', 'fa fa-cog', 'module.jsp?but=rapport/configuration/cr/config-envoi.jsp&acte=update&id=CRCF000001', 1, 4, 'MENUDYNC009');

-- ------------------

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MENUDYNC0021', 'Contenus', 'fa fa-cog', '', 2, 4, 'MENUDYNC009');

-- ------------------

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MENUDYNC0023', 'Saisie', 'fa fa-plus', 'module.jsp?but=rapport/configuration/cr/contenus/config-contenus.jsp', 1, 5, 'MENUDYNC0021');
INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MENUDYNC0024', 'Liste', 'fa fa-list', 'module.jsp?but=rapport/configuration/cr/contenus/config-contenus-liste.jsp', 2, 5, 'MENUDYNC0021');

-- ------------------

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MENUDYNC0022', 'Synchronisation', 'fa fa-history', 'module.jsp?but=rapport/configuration/cr/syncClasseJson.jsp', 3, 4, 'MENUDYNC009');

-- ------------------

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MENUDYNC0020', 'Gestionaire de fichier', 'fa fa-folder-open', 'module.jsp?but=rapport/ged/ged.jsp', 2, 2, 'MENUDYNC003');

-- ------------------
INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MENUDYNC004', 'Envoyer', 'fa fa-exchange', 'module.jsp?but=rapport/rapport.jsp', 3, 2, 'MENUDYNC003');

-- ------------------

INSERT INTO USERMENU
(ID, REFUSER, IDMENU, IDROLE, CODESERVICE, CODEDIR, INTERDIT)
VALUES('USRMENC019', '*', 'MENUDYNC003', NULL, NULL, NULL, NULL);

INSERT INTO CRCONTENT
(ID, TITRE, PARAGRAPHE, MAPPING, VUE, GRAPHE)
VALUES('CRC000001', 'Production Journalier', NULL, 'production.CrProdJournalierAvecCumul', 'CRPRODJOURNALIERAVECCUMUL', 0);

INSERT INTO CRCONTENTFILLE
(ID, IDCRCONTENT, LIBENTETE, LIBENTETEAFFICHER, COLSOMME, COLDATE)
VALUES('CRCF000001', 'CRC000001', 'daty', 'Date', 2, 1);
INSERT INTO CRCONTENTFILLE
(ID, IDCRCONTENT, LIBENTETE, LIBENTETEAFFICHER, COLSOMME, COLDATE)
VALUES('CRCF000002', 'CRC000001', 'libelle', 'Ingredient', 2, 2);
INSERT INTO CRCONTENTFILLE
(ID, IDCRCONTENT, LIBENTETE, LIBENTETEAFFICHER, COLSOMME, COLDATE)
VALUES('CRCF000003', 'CRC000001', 'qteCarton', 'Quantit&eacute; pr&eacute;vue', 2, 2);
INSERT INTO CRCONTENTFILLE
(ID, IDCRCONTENT, LIBENTETE, LIBENTETEAFFICHER, COLSOMME, COLDATE)
VALUES('CRCF000004', 'CRC000001', 'qteFabrique', 'Quantit&eacute; Fabriqu&eacute; (Carton)', 2, 2);
INSERT INTO CRCONTENTFILLE
(ID, IDCRCONTENT, LIBENTETE, LIBENTETEAFFICHER, COLSOMME, COLDATE)
VALUES('CRCF000005', 'CRC000001', 'qteKg', 'Quantit&eacute; pr&eacute;vue (Kg)', 2, 2);
INSERT INTO CRCONTENTFILLE
(ID, IDCRCONTENT, LIBENTETE, LIBENTETEAFFICHER, COLSOMME, COLDATE)
VALUES('CRCF000006', 'CRC000001', 'qteFabriqueKg', 'Quantit&eacute; Fabriqu&eacute; (Kg)', 2, 2);
INSERT INTO CRCONTENTFILLE
(ID, IDCRCONTENT, LIBENTETE, LIBENTETEAFFICHER, COLSOMME, COLDATE)
VALUES('CRCF000007', 'CRC000001', 'objectif', 'Objectif (Carton)', 2, 2);
INSERT INTO CRCONTENTFILLE
(ID, IDCRCONTENT, LIBENTETE, LIBENTETEAFFICHER, COLSOMME, COLDATE)
VALUES('CRCF000008', 'CRC000001', 'ecartObjectif', '&Eacute;cart Objectif (Carton)', 2, 2);
INSERT INTO CRCONTENTFILLE
(ID, IDCRCONTENT, LIBENTETE, LIBENTETEAFFICHER, COLSOMME, COLDATE)
VALUES('CRCF000009', 'CRC000001', 'cumulMois', 'Cumul Mois (Carton)', 2, 2);

-- Correction Menu
UPDATE menudynamique
SET icone = CASE
    -- 1. Actions Standards
                WHEN UPPER(icone) LIKE '%PLUS%' THEN 'add'
                WHEN UPPER(icone) LIKE '%MINUS%' THEN 'remove'
                WHEN UPPER(icone) LIKE '%EDIT%' OR UPPER(icone) LIKE '%PENCIL%' THEN 'edit'
                WHEN UPPER(icone) LIKE '%CHECK%' THEN 'check_circle'
                WHEN UPPER(icone) LIKE '%SEARCH%' THEN 'search'
                WHEN UPPER(icone) LIKE '%REFRESH%' THEN 'refresh'
                WHEN UPPER(icone) LIKE '%STOPWATCH%' THEN 'timer'
                WHEN UPPER(icone) LIKE '%LOCK%' THEN 'lock'

    -- 2. Listes, Tableaux et Documents
                WHEN UPPER(icone) LIKE '%LIST-ALT%' THEN 'assignment'
                WHEN UPPER(icone) LIKE '%LIST%' THEN 'list_alt'
                WHEN UPPER(icone) LIKE '%TABLE%' THEN 'table_view'
                WHEN UPPER(icone) LIKE '%FILE%' OR UPPER(icone) LIKE '%BOOK%' THEN 'description'
                WHEN UPPER(icone) LIKE '%FOLDER%' THEN 'folder'
                WHEN UPPER(icone) LIKE '%NEWSPAPER%' THEN 'newspaper' -- Type Emission

    -- 3. Média et Diffusion
                WHEN UPPER(icone) LIKE '%MICROPHONE%' THEN 'mic' -- Plateau
                WHEN UPPER(icone) LIKE '%TV%' THEN 'tv' -- Émission
                WHEN UPPER(icone) LIKE '%CAMERA%' OR UPPER(icone) LIKE '%VIDEO%' THEN 'videocam'
                WHEN UPPER(icone) LIKE '%TOWER%' THEN 'cell_tower' -- Parrainage / Broadcast
                WHEN UPPER(icone) LIKE '%PLAY-CIRCLE%' THEN 'play_circle'
                WHEN UPPER(icone) LIKE '%LAYER-GROUP%' THEN 'layers' -- Type Media

    -- 4. Finance et Compta
                WHEN UPPER(icone) LIKE '%MONEY%' OR UPPER(icone) LIKE '%USD%' OR UPPER(icone) LIKE '%COINS%' THEN 'attach_money'
                WHEN UPPER(icone) LIKE '%CREDIT-CARD%' THEN 'credit_card'
                WHEN UPPER(icone) LIKE '%BANK%' THEN 'account_balance'
                WHEN UPPER(icone) LIKE '%FONT%' THEN 'text_fields' -- Lettrage
                WHEN UPPER(icone) LIKE '%HANDSHAKE%' THEN 'handshake' -- Tiers/Partenaires

    -- 5. Stock, Logistique et Matériel
                WHEN UPPER(icone) LIKE '%TRUCK%' THEN 'local_shipping'
                WHEN UPPER(icone) LIKE '%SHOPPING-CART%' THEN 'shopping_cart'
                WHEN UPPER(icone) LIKE '%BOX%' OR UPPER(icone) LIKE '%INBOX%' OR UPPER(icone) LIKE '%ARCHIVE%' THEN 'inventory_2'
                WHEN UPPER(icone) LIKE '%INDUSTRY%' THEN 'factory'
                WHEN UPPER(icone) LIKE '%WRENCH%' THEN 'build' -- Opérations
                WHEN UPPER(icone) LIKE '%EXCHANGE%' THEN 'swap_horiz'
                WHEN UPPER(icone) LIKE '%TAGS%' THEN 'label'

    -- 6. Hôtellerie / Réservation
                WHEN UPPER(icone) LIKE '%BED%' THEN 'hotel' -- Occupation / Lit

    -- 7. Administration et Système
                WHEN UPPER(icone) LIKE '%HOME%' THEN 'home' -- Site / Accueil
                WHEN UPPER(icone) LIKE '%GLOBE%' THEN 'public' -- Immo groupé
                WHEN UPPER(icone) LIKE '%COGS%' OR UPPER(icone) LIKE '%COG%' OR UPPER(icone) LIKE '%GEAR%' OR UPPER(icone) LIKE '%SLIDERS%' THEN 'settings'
                WHEN UPPER(icone) LIKE '%USER%' THEN 'person'
                WHEN UPPER(icone) LIKE '%CHILD%' THEN 'child_care' -- Attribution
                WHEN UPPER(icone) LIKE '%CAR%' THEN 'directions_car'
                WHEN UPPER(icone) LIKE '%CLOCK%' THEN 'schedule'
                WHEN UPPER(icone) LIKE '%CALENDAR%' THEN 'calendar_today'
                WHEN UPPER(icone) LIKE '%GAVEL%' THEN 'gavel'
                WHEN UPPER(icone) LIKE '%MAIL-REPLY%' THEN 'reply'

    -- 8. Graphiques
                WHEN UPPER(icone) LIKE '%CHART%' OR UPPER(icone) LIKE '%BAR-CHART%' THEN 'bar_chart'
                WHEN UPPER(icone) LIKE '%PIE%' THEN 'pie_chart'
                WHEN UPPER(icone) LIKE '%HISTORY%' THEN 'history'

    -- 9. Formes
                WHEN UPPER(icone) LIKE '%CIRCLE-O%' THEN 'radio_button_unchecked'
                WHEN UPPER(icone) LIKE '%CIRCLE%' OR UPPER(icone) LIKE '%DOT%' THEN 'lens'

                ELSE icone
    END
WHERE UPPER(icone) LIKE '%FA%';