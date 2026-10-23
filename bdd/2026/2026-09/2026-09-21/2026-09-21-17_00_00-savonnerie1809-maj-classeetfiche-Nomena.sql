-- ========================================================================================
-- Date       : 2026-09-21 17:00:00
-- Base / Schéma : savonnerie1809
-- Auteur     : Nomena
-- Description: Mise a jour de la table CLASSEETFICHE pour la recherche globale (HistoInsert).
--              Ajout du routage fiche pour Vente, VentePaiement, Fournisseur, FactureFournisseur, Client.
-- ========================================================================================

-- ----------------------------------------------------------------------------------------
-- 1. Rectification de l'entree CLFC00006 existante
-- ----------------------------------------------------------------------------------------
-- BACKUP / ANCIENNE VALEUR POUR ROLLBACK EVENTUEL :
-- UPDATE CLASSEETFICHE 
-- SET CLASSE = 'faturefournisseur.Fournisseur', 
--     FICHE = 'faturefournisseur/faturefournisseur-fiche.jsp', 
--     LIBELLE = NULL 
-- WHERE ID = 'CLFC00006';

UPDATE CLASSEETFICHE
SET CLASSE = 'faturefournisseur.FactureFournisseur',
    FICHE = 'facturefournisseur/facturefournisseur-fiche.jsp',
    LIBELLE = 'Facture Fournisseur'
WHERE ID = 'CLFC00006';

-- ----------------------------------------------------------------------------------------
-- 2. Insertion des correspondances de fiches manquantes
-- ----------------------------------------------------------------------------------------
-- Fiche Fournisseur
INSERT INTO CLASSEETFICHE (ID, CLASSE, FICHE, LIBELLE)
VALUES ('CLFC00010', 'faturefournisseur.Fournisseur', 'fournisseur/fournisseur-fiche.jsp', 'Fournisseur');

-- Fiche Client
INSERT INTO CLASSEETFICHE (ID, CLASSE, FICHE, LIBELLE)
VALUES ('CLFC00011', 'client.Client', 'client/client-fiche.jsp', 'Client');

-- Fiche Vente standard
INSERT INTO CLASSEETFICHE (ID, CLASSE, FICHE, LIBELLE)
VALUES ('CLFC00012', 'vente.Vente', 'vente/vente-fiche.jsp', 'Vente');

-- Fiche Vente au comptant (VentePaiement)
INSERT INTO CLASSEETFICHE (ID, CLASSE, FICHE, LIBELLE)
VALUES ('CLFC00013', 'vente.VentePaiement', 'vente/vente-fiche.jsp', 'Vente au comptant');

COMMIT;
