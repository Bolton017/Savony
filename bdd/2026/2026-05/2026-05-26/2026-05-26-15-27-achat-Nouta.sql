INSERT INTO TYPEACHAT
(ID, VAL, DESCE)
VALUES('TA0004', 'Maintenance', 'Maintenance');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MNDN00001234', 'Article', 'package_2', 'module.jsp?but=annexe/produit/produit-liste.jsp', 8, 2, 'MENUDYN00304001');

CREATE OR REPLACE VIEW matierepremier as
SELECT *
FROM AS_INGREDIENTS_LIB
WHERE IDCATEGORIEINGREDIENT  = 'CAT004';

UPDATE MENUDYNAMIQUE
SET LIBELLE='Matières Premières', ICONE='package_2', HREF='module.jsp?but=annexe/produit/matiere-premieres-liste.jsp', RANG=6, NIVEAU=2, ID_PERE='MENUDYN00304001'
WHERE ID='MNDN00001';

