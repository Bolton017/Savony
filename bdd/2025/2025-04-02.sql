--sequence et fonction
--SEQFAB: getSeqFab
--SEQFABF: getSeqFabF

create sequence SEQFAB
      minvalue 1
      maxvalue 999999999999
      start with 1
      increment by 1
      cache 20;
      
      

CREATE OR REPLACE FUNCTION getSeqFab
   RETURN NUMBER
IS
   retour   NUMBER;
BEGIN
   SELECT SEQFAB.NEXTVAL INTO retour FROM DUAL;

   RETURN retour;
END; 


create sequence SEQFABF
      minvalue 1
      maxvalue 999999999999
      start with 1
      increment by 1
      cache 20;
      
      

CREATE OR REPLACE FUNCTION getSeqFabF
   RETURN NUMBER
IS
   retour   NUMBER;
BEGIN
   SELECT SEQFABF.NEXTVAL INTO retour FROM DUAL;

   RETURN retour;
END;

-- ajout menu
-- menu Ordre de Fabrication
-- fabrication/ordre-fabrication-saisie.jsp
-- fabrication/ordre-fabrication-modif.jsp
-- fabrication/ordre-fabrication-liste.jsp
-- fabrication/ordre-fabrication-fiche.jsp


INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MENUDYN0204001', 'Ordre de Fabrication', 'fa fa-tags', NULL, 10, 1, NULL);

INSERT INTO USERMENU
(ID, REFUSER, IDMENU, IDROLE, CODESERVICE, CODEDIR, INTERDIT)
VALUES('USRMEN0204001', '*', 'MENUDYN0204001', NULL, NULL, NULL, NULL);

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MENUDYN0204002', 'Saisie', 'fa fa-plus', 'module.jsp?but=fabrication/ordre-fabrication-saisie.jsp', 1, 2, 'MENUDYN0204001');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MENUDYN0204004', 'Liste', 'fa fa-list', 'module.jsp?but=fabrication/ordre-fabrication-liste.jsp', 3, 2, 'MENUDYN0204001');


-- ajout menu
-- menu Ingredients
-- fabrication/as-ingredients-saisie.jsp
-- fabrication/as-ingredients-modif.jsp
-- fabrication/as-ingredients-liste.jsp
-- fabrication/as-ingredients-fiche.jsp


INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MENUDYN0204006', 'Ingredients', 'fa fa-tags', NULL, 11, 1, NULL);

INSERT INTO USERMENU
(ID, REFUSER, IDMENU, IDROLE, CODESERVICE, CODEDIR, INTERDIT)
VALUES('USRMEN0204006', '*', 'MENUDYN0204006', NULL, NULL, NULL, NULL);

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MENUDYN0204007', 'Saisie', 'fa fa-plus', 'module.jsp?but=produits/as-ingredients-saisie.jsp', 1, 2, 'MENUDYN0204006');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MENUDYN0204009', 'Liste', 'fa fa-list', 'module.jsp?but=produits/as-ingredients-liste.jsp', 3, 2, 'MENUDYN0204006');


-- ajout colonne etat dans OFAB
ALTER TABLE OFAB ADD etat int ; 