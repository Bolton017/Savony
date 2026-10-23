--vue AS_INGREDIENTS_PRODUIT_FINIE
--raisina ao amin’ny condition ny categorie produit fabriqué


CREATE OR REPLACE  VIEW AS_INGREDIENTS_PRODUIT_FINIE (ID, LIBELLE, SEUIL, UNITE, QUANTITEPARPACK, PU, ACTIF, PHOTO, CALORIE, DURRE, COMPOSE, IDCATEGORIEINGREDIENT, CATEGORIEINGREDIENT, IDCATEGORIE, IDFOURNISSEUR, DATY, BIENOUSERV, ETATLIB, COMPTE_VENTE, COMPTE_ACHAT, PV, TVA, TYPESTOCK, IDUNITE, REFPOST, REFQUALIFICATION) AS 
  SELECT 
  	   ing.id,
       ing.LIBELLE,
       ing.SEUIL,
       au.VAL AS unite,
       ing.QUANTITEPARPACK,
       ing.pu,
       ing.ACTIF,
       ing.PHOTO,
       ing.CALORIE,
       ing.DURRE,
       ing.COMPOSE,
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
       ing.REFQUALIFICATION 
FROM as_ingredients ing
     JOIN AS_UNITE AU 
     ON ing.UNITE = AU.ID
     JOIN CATEGORIEINGREDIENTLIB catIng
     ON catIng.id = ing.CATEGORIEINGREDIENT
WHERE ing.CATEGORIEINGREDIENT in ('CAT008','CAT001') ;


--Configuration (ty efa misy)
--Client
--Saisie: module.jsp?but=client/client-saisie.jsp
--Liste: module.jsp?but=client/client-liste.jsp
--

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MNDN0000508001', 'Client', 'fa fa-file-text', NULL, 7, 2, 'MNDN00000002111');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MNDN0000508002', 'Saisie', 'fa fa-plus', 'module.jsp?but=client/client-saisie.jsp', 1, 3, 'MNDN0000508001');
INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MNDN0000508003', 'Liste', 'fa fa-list', 'module.jsp?but=client/client-liste.jsp', 2, 3, 'MNDN0000508001');
--
--Fournisseur
--Saisie: module.jsp?but=fournisseur/fournisseur-saisie.jsp
--Liste: module.jsp?but=fournisseur/fournisseur-liste.jsp

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MNDN0000508004', 'Fournisseur', 'fa fa-file-text', NULL, 8, 2, 'MNDN00000002111');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MNDN0000508005', 'Saisie', 'fa fa-plus', 'module.jsp?but=fournisseur/fournisseur-saisie.jsp', 1, 3, 'MNDN0000508004');
INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MNDN0000508006', 'Liste', 'fa fa-list', 'module.jsp?but=fournisseur/fournisseur-liste.jsp', 2, 3, 'MNDN0000508004');

--Caisse
--Saisie: module.jsp?but=caisse/caisse-saisie.jsp
--Liste: module.jsp?but=caisse/caisse-liste.jsp

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MNDN0000508007', 'Caisse', 'fa fa-file-text', NULL, 9, 2, 'MNDN00000002111');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MNDN0000508008', 'Saisie', 'fa fa-plus', 'module.jsp?but=caisse/caisse-saisie.jsp', 1, 3, 'MNDN0000508007');
INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MNDN0000508009', 'Liste', 'fa fa-list', 'module.jsp?but=caisse/caisse-liste.jsp', 2, 3, 'MNDN0000508007');



--vue CAISSECPL
--soloina magasin2 ny magasin 
CREATE OR REPLACE  VIEW CAISSECPL (ID, VAL, DESCE, IDTYPECAISSE, IDTYPECAISSELIB, IDPOINT, IDPOINTLIB, IDPOMPISTE, ETAT, COMPTE, ETATLIB, IDCATEGORIECAISSE, IDCATEGORIECAISSELIB, IDMAGASIN, IDMAGASINLIB) AS 
  SELECT c.ID,
       c.VAL,
       c.DESCE,
       c.IDTYPECAISSE,
       t.VAL   AS IDTYPECAISSELIB,
       c.IDPOINT,
       p.VAL   AS IDPOINTLIB,
       c.IDPOMPISTE,
       c.ETAT,
       cop.LIBELLE||'('||cop.COMPTE||')' as compte ,
       CASE
           WHEN c.ETAT = 0
               THEN 'ANNULEE'
           WHEN c.ETAT = 1
               THEN 'CREE'
           WHEN c.ETAT = 11
               THEN 'VISEE'
           END AS ETATLIB,
       c.idCategorieCaisse,
       c2.VAL  AS idCategorieCaisseLib,
       c.IDMAGASIN ,
       m.val AS idMagasinLib
FROM CAISSE c
         LEFT JOIN TYPECAISSE t ON t.ID = c.IDTYPECAISSE
         LEFT JOIN POINT p ON p.ID = c.IDPOINT
         LEFT JOIN CATEGORIECAISSE c2 ON c2.ID = c.idCategorieCaisse
         LEFT JOIN COMPTA_COMPTE cop ON cop.ID = c.COMPTE
         LEFT JOIN MAGASIN2 m ON m.ID =c.IDMAGASIN 
       ;