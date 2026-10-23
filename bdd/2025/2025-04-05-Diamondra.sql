
-- INDISPONIBILITE definition

CREATE TABLE INDISPONIBILITE 
   (	
    ID VARCHAR2(50), 
	IDPOINT VARCHAR2(50), 
	IDPRODUIT VARCHAR2(50), 
	 PRIMARY KEY (ID) 
   );
   
  CREATE SEQUENCE SEQ_INDISPONIBILITE INCREMENT BY 1 MINVALUE 1 MAXVALUE 999999999999999999999999999 NOCYCLE CACHE 20 NOORDER ;
  
 CREATE OR REPLACE FUNCTION GETSEQINDISPONIBILITE
  RETURN NUMBER IS
  retour NUMBER;
BEGIN
  SELECT seq_indisponibilite.nextval INTO retour FROM dual;
  return retour;
END;


--ajout disponibilite produit
-- ASYNC.AS_INGREDIENTS_LIB source

CREATE OR REPLACE  VIEW AS_INGREDIENTS_LIB   AS 
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
	      END AS etatlib
            
     FROM as_ingredients ing
          JOIN AS_UNITE AU ON ing.UNITE = AU.ID
          JOIN CATEGORIEINGREDIENTLIB catIng
             ON catIng.id = ing.CATEGORIEINGREDIENT;