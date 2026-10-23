--INVENTAIRELIB Tiavina
--soloina magasinpoint fa tsy magasin


CREATE OR REPLACE  VIEW INVENTAIRELIB (ID, DATY, DESIGNATION, IDMAGASIN, IDMAGASINLIB, ETAT, ETATLIB, IDCATEGORIE, IDCATEGORIELIB) AS 
  SELECT
i.ID ,
i.DATY ,
i.DESIGNATION ,
i.IDMAGASIN ,
m.VAL AS IDMAGASINLIB,
i.ETAT ,
CASE
	WHEN i.ETAT = 0
	THEN 'ANNULEE'
	WHEN i.ETAT = 1
	THEN 'CREE'
	WHEN i.ETAT = 11
	THEN 'VALIDEE'
END AS ETATLIB,
i.idcategorie,
c.VAL AS idcategorieLib
FROM INVENTAIRE i
LEFT JOIN MAGASINPOINT m ON m.ID = i.IDMAGASIN
LEFT JOIN CATEGORIEINGREDIENT c ON c.id = i.idcategorie;

--mamorona table equivalencecarton
--id
--idpetris (fk ingredients(id))
--idcarton (fk ingredients(id))
--nbcarton

create table equivalencecarton (
    id varchar(255) constraint equivalencecarton_pk primary key,
   	idpetris varchar(50) CONSTRAINT equivalencecarton_petris_fk REFERENCES AS_INGREDIENTS(id) ,
   	idcarton varchar(50) CONSTRAINT equivalencecarton_carton_fk REFERENCES AS_INGREDIENTS(id) ,
   	nbcarton int  
);

create sequence seqequivalencecarton
      minvalue 1
      maxvalue 999999999999
      start with 1
      increment by 1
      cache 20;
      
      

CREATE OR REPLACE FUNCTION getSeqequivalencecarton
   RETURN NUMBER
IS
   retour   NUMBER;
BEGIN
   SELECT seqequivalencecarton.NEXTVAL INTO retour FROM DUAL;

   RETURN retour;
END; 



--creer vue equivalencecartonlib
--equivalencecarton.*
--idpetrislib (ingredients.libelle)
--idcartonlib (ingredients.libelle)

CREATE VIEW equivalencecartonlib 
AS 
SELECT 
e.*,
a.LIBELLE AS idpetrislib,
p.LIBELLE AS idcartonlib
FROM equivalencecarton e
LEFT JOIN AS_INGREDIENTS a ON a.id = e.idpetris
LEFT JOIN AS_INGREDIENTS p ON p.id = e.idcarton
; 

--ampiana menu 
--Configuration
--Equivalence carton
--Saisie: /pages/module.jsp?but=annexe/equivalence/equivalence-carton-saisie.jsp
--Liste: /pages/module.jsp?but=annexe/equivalence/equivalence-carton-liste.jsp

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MNDN0000408001', 'Equivalence carton', 'fa fa-file-text', NULL, 6, 2, 'MNDN00000002111');


INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MNDN0000408002', 'Saisie', 'fa fa-plus', 'module.jsp?but=annexe/equivalence/equivalence-carton-saisie.jsp', 1, 3, 'MNDN0000408001');
INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MNDN0000408003', 'Liste', 'fa fa-list', 'module.jsp?but=annexe/equivalence/equivalence-carton-liste.jsp', 2, 3, 'MNDN0000408001');








