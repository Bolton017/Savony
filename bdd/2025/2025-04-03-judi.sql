-- creation sequence categorie ingredient
create sequence seq_categ_ing
    minvalue 1
    maxvalue 999999999999
    start with 1
    increment by 1
    cache 20;

-- fonction maka ilay sequence categorie ingredient
CREATE OR REPLACE FUNCTION GETSEQCATEGING
   RETURN NUMBER
IS
   retour   NUMBER;
BEGIN
SELECT seq_categ_ing.NEXTVAL INTO retour FROM DUAL;

RETURN retour;
END;

--mba asiana sous menu categorie ingredient ao amin'ny ingredients azafady
--ireto avy ny chemin any
--liste : categorieingredient/categorie-ingredient-liste.jsp
--saisie : categorieingredient/categorie-ingredient-saisie.jsp

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MENUDYN0304153001', 'categorie ingredient', 'fa fa-list', NULL , 4, 2, 'MENUDYN0204006');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MENUDYN0304153002', 'Saisie', 'fa fa-plus', 'module.jsp?but=categorieingredient/categorie-ingredient-saisie.jsp', 1, 3, 'MENUDYN0304153001');
INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MENUDYN0304153003', 'Liste', 'fa fa-list', 'module.jsp?but=categorieingredient/categorie-ingredient-liste.jsp', 2, 3, 'MENUDYN0304153001');