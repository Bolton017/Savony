--UPDATE ETAT SOCOBISPREPRODPAIE1401.INVENTAIRELIB source

CREATE OR REPLACE VIEW INVENTAIRELIB  AS 
  SELECT
i.ID ,
i.DATY ,
i.DESIGNATION ,
i.IDMAGASIN ,
m.VAL AS IDMAGASINLIB,
i.ETAT ,
CASE
	WHEN i.ETAT = 0
	THEN 'ANNUL&Eacute;E'
	WHEN i.ETAT = 1
	THEN 'CR&Eacute;&Eacute;E'
	WHEN i.ETAT = 11
	THEN 'VALID&Eacute;E'
END AS ETATLIB,
i.idcategorie,
c.VAL AS idcategorieLib
FROM INVENTAIRE i
LEFT JOIN MAGASINPOINT m ON m.ID = i.IDMAGASIN
LEFT JOIN CATEGORIEINGREDIENT c ON c.id = i.idcategorie;


-- UPDATE ETAT SOCOBISPREPRODPAIE1401.MVTSTOCKLIB source

CREATE OR REPLACE VIEW MVTSTOCKLIB AS 
  SELECT
m.ID ,
m.DESIGNATION ,
m.IDMAGASIN ,
m.IDOBJET ,
m2.VAL  AS idMagasinlib,
m.IDVENTE ,
v.DESIGNATION  AS idVentelib,
m.IDTRANSFERT ,
CAST('' AS VARCHAR2(255)) AS idTransfertlib,
m.IDTYPEMVSTOCK ,
t.VAL AS idTypeMvStocklib ,
m.DATY ,
m.ETAT ,
CASE
	WHEN m.ETAT = 0
	THEN 'ANNUL&Eacute;E'
	WHEN m.ETAT = 1
	THEN 'CR&Eacute;&Eacute;E'
	WHEN m.ETAT = 11
	THEN 'VALID&Eacute;E'
END AS etatlib,
v.IDRESERVATION,
gm.montantEntree,
gm.montantSortie
FROM MVTSTOCK m
LEFT JOIN TYPEMVTSTOCK t ON t.ID = m.IDTYPEMVSTOCK
LEFT JOIN VENTE v ON v.ID = m.IDVENTE
LEFT JOIN MAGASIN2 m2 ON m2.ID = m.IDMAGASIN
left join mvtStockFilleGroupeMere gm on gm.IDMVTSTOCK=m.ID;


--update libelle etat  SOCOBISPREPRODPAIE1401.DMDACHATLIB source

CREATE OR REPLACE  VIEW DMDACHATLIB  AS 
  SELECT
    da.id,
    da.daty,
    da.fournisseur,
    f.nom AS fournisseurlib,
    da.remarque,
    da.dateLimite,
    m.val AS idMagasinLib,
    ci.val AS idCategorieLib,
    da.etat,
    CASE
        WHEN da.ETAT = 0
            THEN 'ANNUL&Eacute;E'
        WHEN da.ETAT = 1
            THEN 'CR&Eacute;&Eacute;E'
        WHEN da.ETAT = 11
            THEN 'VIS&Eacute;(E) par Directeur'
        WHEN da.ETAT = 3
            THEN 'VIS&Eacute;(E) par Chef de Fabrication'
        WHEN da.ETAT = 4
            THEN 'VIS&Eacute;(E) par Responsable achat'
        END AS etatlib,
    da.idObjet
FROM DMDACHAT da
         LEFT JOIN FOURNISSEUR f ON f.ID = da.fournisseur
         LEFT JOIN MAGASIN2 m ON da.idMagasin = m.ID
         LEFT JOIN categorieIngredient ci ON da.idCategorie = ci.id;


-- update libelle etat SOCOBISPREPRODPAIE1401.OFABLIB source

CREATE OR REPLACE  VIEW OFABLIB AS 
  SELECT ofl.ID,
	p1.VAL  AS LANCEPAR,
	p2.VAL  AS CIBLE,
	ofl.REMARQUE,
	ofl.LIBELLE,
	ofl.BESOIN,
	ofl.DATY,
	ofl.ETAT,
	CASE
		WHEN ofl.ETAT=1
		THEN 'CR&Eacute;&Eacute;E'
		WHEN ofl.ETAT=11
		THEN 'Valid&eacute;'
		WHEN ofl.ETAT=0
		THEN 'ANNULEE'
	    WHEN ofl.ETAT=21
		THEN 'ENTAME'
	    WHEN ofl.ETAT=31
		THEN 'BLOQUE'
	    WHEN ofl.ETAT=41
		THEN 'TERMINEE'
	END AS ETATLIB
FROM OFAB ofl
	LEFT JOIN MAGASINPOINT p1 ON p1.ID = ofl.LANCEPAR
	LEFT JOIN MAGASINPOINT p2 ON p2.ID = ofl.CIBLE;


    --update libelle etat SOCOBISPREPRODPAIE1401.DEMANDETRANSFERTCPL source

CREATE OR REPLACE  VIEW DEMANDETRANSFERTCPL  AS 
  SELECT
    t.ID ,
    t.DESIGNATION ,
    t.IDMAGASINDEPART ,
    m.VAL AS IDMAGASINDEPARTLIB,
    t.IDMAGASINARRIVE ,
    m2.VAL AS IDMAGASINARRIVELIB,
    t.DATY ,
    t.ETAT ,
    t.idof,
    t.CATEGORIEINGREDIENT,
    c.VAL  AS CATEGORIEINGREDIENTLIB,
    CASE
        WHEN t.ETAT = 0
            THEN 'ANNULEE'
        WHEN t.ETAT = 1
            THEN 'Cr&eacute;&eacute;'
        WHEN t.ETAT = 11
            THEN 'Vis&eacute;'
        END AS ETATLIB
FROM demandetransfert t
         LEFT JOIN MAGASINPOINT m ON m.ID = t.IDMAGASINDEPART
         LEFT JOIN MAGASINPOINT m2 ON m2.ID = t.IDMAGASINARRIVE
         LEFT JOIN CATEGORIEINGREDIENT c ON c.ID = t.CATEGORIEINGREDIENT;