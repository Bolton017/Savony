-- ajout idbcfille
create or replace view FABRICATIONFILLEPU as
select f.id, f.idingredients, f.libelle, f.remarque, f.idmere, f.datybesoin, f.qte, f.idunite, a.pu, f.IDBCFILLE from FABRICATIONFILLE f left join AS_INGREDIENTS a on f.IDINGREDIENTS=a.id;


-- ajout idbcfille
create or replace view OFFILLELIBQTERESTE as
SELECT
    ofll.ID,
    ofll.IDINGREDIENTS,
    ai.LIBELLE ||' '|| ofll.LIBELLE as LIBELLE,
    ai.LIBELLE as remarque,
    ofll.IDMERE,
    ofll.DATYBESOIN,
    (ofll.qte-nvl(fmf.qte,0)) as QTE,
    nvl(au.VAL,'unite') AS IDUNITE,
    fmf.qte AS qteFabrique,(ofll.qte-fmf.qte) AS qteReste,
    ofa.LIBELLE as libelleMere,fmf.daty,
    ofll.IDBCFILLE

FROM OFFILLE ofll
         LEFT JOIN AS_INGREDIENTS ai ON ai.ID = ofll.IDINGREDIENTS
         LEFT JOIN AS_UNITE au ON au.ID = ofll.IDUNITE
         LEFT JOIN FabricationMereFille fmf on fmf.IDOF=ofll.IDMERE and fmf.IDINGREDIENTS=ofll.IDINGREDIENTS
         left join OFAB ofa on ofa.id=ofll.IDMERE;



-- ajout unite
create or replace view BONDECOMMANDE_CLIENT_FILLE_CPL as
SELECT
    bcf.id,
    bcf.IDBC,
    bcf.IDDEVISE,
    avg(bcf.MONTANT) as montant,
    bcf.PRODUIT,
    avg(bcf.PU) as pu,
    avg(bcf.QUANTITE) as quantite,
    avg(bcf.REMISE) as remise,
    avg(bcf.TVA) as tva,
    ing.UNITE as unite,

    nvl(avg(o.QTE),0) AS QTEOF,
    NVL(sum(bcf.QUANTITE) - nvl(avg(o.QTE),0), 0) AS QTEOFRESTANTE,

    nvl(avg(f.QTE),0) AS QTEFAB,
    NVL(sum(bcf.QUANTITE) - nvl(avg(f.QTE),0), 0) AS QTEFABRESTANTE,

    AVG(NVL(abcf.QUANTITE, 0)) AS QTELIVRE,
    NVL(avg(bcf.QUANTITE) - AVG(NVL(abcf.QUANTITE,0)), 0) AS QTENONLIVRE,
    ing.LIBELLE as libelleProduit

FROM BONDECOMMANDE_CLIENT_FILLE bcf

         LEFT JOIN OfGroupByIdbc o ON o.IDBCFILLE = bcf.ID


         LEFT JOIN fabrGroupByIdbc f ON f.IDBCFILLE = bcf.ID

         LEFT JOIN BLGroupByIdbc abcf ON abcf.IDBC_FILLE = bcf.ID

         left join AS_INGREDIENTS_LIB ing on ing.id=bcf.PRODUIT

GROUP BY
    bcf.IDBC,
    bcf.id,
    bcf.IDDEVISE,
    bcf.PRODUIT,
    ing.LIBELLE, ing.UNITE;


CREATE OR REPLACE VIEW BC_CLIENT_FILLE_CPL_LIB
AS 
SELECT bcf.*, i.LIBELLE AS PRODUITlib FROM	
bondecommande_client_fille bcf
JOIN as_ingredients i ON i.id = bcf.PRODUIT;


CREATE OR REPLACE VIEW AS_BONLIVRFILLE_CLIENT_CPL AS 
  SELECT
	abcf.ID,
	abcf.PRODUIT,
	abcf.NUMBL,
	abcf.QUANTITE,
	abcf.IDVENTEDETAIL,
	abcf.UNITE,
	abcf.IDBC_FILLE,
	p.LIBELLEEXTACTE AS idproduitlib,
	vd.idvente,
	abc.idbc,
	CAST(nvl(s.qtelivree ,0)AS NUMBER(30,2)) AS qtelivree,
	CAST(nvl(abcf.QUANTITE - CAST(nvl(s.qtelivree ,0)AS NUMBER(30,2))  ,0)AS NUMBER(30,2)) AS qteResteALivrer
FROM AS_BONDELIVRAISON_CLIENT_FILLE abcf 
LEFT JOIN as_ingredients p ON p.id = abcf.produit
LEFT JOIN VENTE_DETAILS vd ON vd.id = abcf.IDVENTEDETAIL
LEFT JOIN AS_BONDELIVRAISON_CLIENT abc ON abc.id = abcf.numbl
LEFT JOIN sortiestockfille s ON s.IDPRODUIT = abcf.produit AND s.IDVENTEDETAIL =abcf.IDVENTEDETAIL ;


--00:38
DELETE FROM AS_BONDELIVRAISON_CLIENT_FILLE
WHERE ID='BLCF000153';
DELETE FROM AS_BONDELIVRAISON_CLIENT_FILLE
WHERE ID='BLCF00000';
DELETE FROM AS_BONDELIVRAISON_CLIENT_FILLE
WHERE ID='BLCF000164';
DELETE FROM AS_BONDELIVRAISON_CLIENT_FILLE
WHERE ID='BLCF000165';