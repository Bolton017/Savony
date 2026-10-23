--base Tiavina
--creer table demandetransfert
--dupliquerna ilay table transfert

CREATE TABLE demandetransfert 
   (	ID VARCHAR2(255), 
	DESIGNATION VARCHAR2(300), 
	IDMAGASINDEPART VARCHAR2(255), 
	IDMAGASINARRIVE VARCHAR2(255), 
	DATY DATE, 
	ETAT NUMBER(*,0), 
	IDOF VARCHAR2(255), 
	 CONSTRAINT demandetransfert_PK PRIMARY KEY (ID), 
	 CONSTRAINT demandetransfert_OF_FK FOREIGN KEY (IDOF)
	  REFERENCES OFAB (ID) 
   );

   CREATE SEQUENCE SEQdemandetransfert INCREMENT BY 1 MINVALUE 1 MAXVALUE 999999999999 NOCYCLE CACHE 20 NOORDER ;


   CREATE OR REPLACE FUNCTION getSeqdemandetransfert
   RETURN NUMBER
IS
   retour   NUMBER;
BEGIN
   SELECT seqdemandetransfert.NEXTVAL INTO retour FROM DUAL;

   RETURN retour;
END;


--creer table demandetransfertfille
--dupliquerna ilay table transfertdetails

CREATE TABLE demandetransfertfille 
   (	ID VARCHAR2(255), 
	IDdemandetransfert VARCHAR2(255), 
	IDPRODUIT VARCHAR2(255), 
	REMARQUE VARCHAR2(255), 
	IDSOURCE VARCHAR2(255), 
	PU NUMBER(30,2), 
	QUANTITE NUMBER(30,2), 
	 CONSTRAINT demandetransfertfille_PK PRIMARY KEY (ID), 
	 CONSTRAINT demandetransfert_MEREFILLE_FK FOREIGN KEY (IDdemandetransfert)
	  REFERENCES demandetransfert (ID) 
   );

   CREATE SEQUENCE SEQdemandetransfertfille INCREMENT BY 1 MINVALUE 1 MAXVALUE 999999999999 NOCYCLE CACHE 20 NOORDER ;


CREATE OR REPLACE FUNCTION getSeqdemandetransfertfille
   RETURN NUMBER
IS
   retour   NUMBER;
BEGIN
   SELECT seqdemandetransfertfille.NEXTVAL INTO retour FROM DUAL;

   RETURN retour;
END;


--creer vue demandetransfertcpl
--mitovy amin’ny transfertcpl

CREATE VIEW demandetransfertcpl
AS 
 SELECT
t.ID ,
t.DESIGNATION ,
t.IDMAGASINDEPART ,
m.VAL AS IDMAGASINDEPARTLIB,
t.IDMAGASINARRIVE ,
m2.VAL AS IDMAGASINARRIVELIB,
t.DATY ,
t.ETAT ,
CASE
	WHEN t.ETAT = 0
	THEN 'ANNULEE'
	WHEN t.ETAT = 1
	THEN 'CREE'
	WHEN t.ETAT = 11
	THEN 'VISEE'
END AS ETATLIB
FROM demandetransfert t
LEFT JOIN MAGASINPOINT m ON m.ID = t.IDMAGASINDEPART
LEFT JOIN MAGASINPOINT m2 ON m2.ID = t.IDMAGASINARRIVE ;


--creer vue demandetransfertfillecpl
--mitovy amin’ny transfertdetailscpl

CREATE VIEW demandetransfertfillecpl 
AS 
  SELECT
    t.ID ,
    t.IDdemandetransfert ,
    t2.DESIGNATION AS IDdemandetransfertLIB,
    t.IDPRODUIT ,
    p.libelle AS IDPRODUITLIB,
    CAST (t.QUANTITE AS NUMBER(30,2)) AS QUANTITE
FROM demandetransfertfille t
         LEFT JOIN demandetransfert t2 ON t2.ID = t.IDdemandetransfert
         LEFT JOIN AS_INGREDIENTS  p ON p.ID = t.IDPRODUIT;


--vue AS_INGREDIENTS_LIB Tiavina
--atao left join daholo izay join
--de ampiana refpostlib (left join amin’ny poste)
--de ampiana refqualificationlib (leftjoin qualificiation_paie
-- 

CREATE OR REPLACE  VIEW AS_INGREDIENTS_LIB (ID, LIBELLE, SEUIL, UNITE, QUANTITEPARPACK, PU, ACTIF, PHOTO, CALORIE, DURRE, COMPOSE, IDCATEGORIEINGREDIENT, CATEGORIEINGREDIENT, IDCATEGORIE, IDFOURNISSEUR, DATY, BIENOUSERV, ETATLIB, COMPTE_VENTE, COMPTE_ACHAT, PV, TVA, TYPESTOCK, IDUNITE, REFPOST, REFQUALIFICATION,REFPOSTLIB,REFQUALIFICATIONLIB) AS 
  SELECT ing.id,
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
       ing.REFQUALIFICATION ,
       p.VAL AS REFPOSTLIB,
       qp.VAL AS REFQUALIFICATIONLIB
FROM as_ingredients ing
         LEFT JOIN AS_UNITE AU ON ing.UNITE = AU.ID
         LEFT JOIN CATEGORIEINGREDIENTLIB catIng
              ON catIng.id = ing.CATEGORIEINGREDIENT
         LEFT JOIN POSTE p ON p.id = ing.REFPOST 
         LEFT JOIN QUALIFICATION_PAIE qp ON qp.id = ing.REFQUALIFICATION ;

--DEMANDETRANSFERTFILLECPL
--ity vue ity asiana typestock amin’ny ingredients
--ity vue ity asiana unite amin’ny unite


CREATE OR REPLACE  VIEW DEMANDETRANSFERTFILLECPL (ID, IDDEMANDETRANSFERT, IDDEMANDETRANSFERTLIB, IDPRODUIT, IDPRODUITLIB, QUANTITE,TYPESTOCK,UNITE) AS 
  SELECT
    t.ID ,
    t.IDdemandetransfert ,
    t2.DESIGNATION AS IDdemandetransfertLIB,
    t.IDPRODUIT ,
    p.libelle AS IDPRODUITLIB,
    CAST (t.QUANTITE AS NUMBER(30,2)) AS QUANTITE,
    p.TYPESTOCK,
    p.UNITE
FROM demandetransfertfille t
         LEFT JOIN demandetransfert t2 ON t2.ID = t.IDdemandetransfert
         LEFT JOIN AS_INGREDIENTS  p ON p.ID = t.IDPRODUIT;


--VENTE_CPL
--soloina magasinpoint ny hijerevana an’ilat mafasin fa tsy magasin

CREATE OR REPLACE  VIEW VENTE_CPL (ID, DESIGNATION, IDMAGASIN, IDMAGASINLIB, DATY, REMARQUE, ETAT, ETATLIB, MONTANTTOTAL, IDDEVISE, IDCLIENT, IDCLIENTLIB, MONTANTTVA, MONTANTTTC, MONTANTTTCAR, MONTANTPAYE, MONTANTRESTE, AVOIR, TAUXDECHANGE, MONTANTREVIENT, MARGEBRUTE, IDRESERVATION) AS 
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
          c.NOM AS IDCLIENTLIB,
          cast(V2.MONTANTTVA as number(30,2)) as MONTANTTVA,
          cast(V2.MONTANTTTC as number(30,2)) as montantttc,
          cast(V2.MONTANTTTCAR as number(30,2)) as MONTANTTTCAR,
          cast(nvl(mv.credit,0)-nvl(ACG.MONTANTPAYE, 0) AS NUMBER(30,2)) AS montantpaye,
          cast(V2.MONTANTTTC-nvl(mv.credit,0)-nvl(ACG.resteapayer_avr, 0) AS NUMBER(30,2)) AS montantreste,
          nvl(ACG.MONTANTTTC_avr, 0)  as avoir,
          v2.tauxDeChange AS tauxDeChange,v2.MONTANTREVIENT,cast((V2.MONTANTTTCAR-v2.MONTANTREVIENT) as number(20,2))  as margeBrute,
          v.IDRESERVATION
     FROM VENTE v
          LEFT JOIN CLIENT c ON c.ID = v.IDCLIENT
          LEFT JOIN MAGASINPOINT m ON m.ID = v.IDMAGASIN
          JOIN VENTEMONTANT v2 ON v2.ID = v.ID
          LEFT JOIN mouvementcaisseGroupeFacture mv ON v.id=mv.IDORIGINE
		  LEFT JOIN AVOIRFCLIB_CPL_GRP ACG on ACG.IDVENTE = v.ID;


--AS_BONDELIVRAISON_CLIENT_CPL
--soloina magasinpoint ny hijerevana an’ilay  magasin fa tsy magasin

CREATE OR REPLACE  VIEW AS_BONDELIVRAISON_CLIENT_CPL (ID, REMARQUE, IDVENTE, DESIGNATION, IDBC, DATY, ETAT, IDMAGASIN, MAGASIN, IDRESERVATION, IDCLIENTLIB) AS 
  SELECT bl.id, bl.remarque,
v.id AS idvente,
v.designation,
bl.idbc, bl.daty, bl.etat,
m.id AS idmagasin,
m.val AS magasin,
v.IDRESERVATION,
c.nom AS IDCLIENTlib
FROM AS_BONDELIVRAISON_CLIENT bl
LEFT JOIN MAGASINPOINT m ON bl.magasin=m.id
LEFT JOIN vente v ON v.id=bl.idvente
LEFT JOIN client c ON c.ID = bl.IDCLIENT ;