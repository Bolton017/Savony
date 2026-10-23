--creer table FamilleProduit avec sequence
--colonne
--id
--val
--desce
--asio donne kely
--val : Tchido
--desce : Tchido

create table FamilleProduit(
                               id varchar(100) constraint FamilleProduit_pk primary key ,
                               val varchar(255) ,
                               desce varchar(255)
);


create sequence seqFamilleProduit
    minvalue 1
    maxvalue 999999999999
    start with 1
    increment by 1
    cache 20;



CREATE OR REPLACE FUNCTION getseqFamilleProduit
   RETURN NUMBER
IS
   retour   NUMBER;
BEGIN
SELECT seqFamilleProduit.NEXTVAL INTO retour FROM DUAL;

RETURN retour;
END;


INSERT INTO FamilleProduit VALUES('FAMPROD00'||getseqFamilleProduit(),'Tchido','Tchido');

--add colonne table
--AS_INGREDIENTS
--add colonne idfamille

ALTER TABLE AS_INGREDIENTS ADD idfamille varchar(100);


create or replace view VENTE_DETAILS_POIDS
            (ID, IDVENTE, IDPRODUIT, IDORIGINE, QTE, PU, REMISE, TVA, PUACHAT, PUVENTE, IDDEVISE, TAUXDECHANGE,
             DESIGNATION, COMPTE, PUREVIENT, IDBCFILLE, UNITE, UNITELIB, PUNET, MONTANTHT, MONTANTTTC, MONTANTTVA,
             MONTANTREMISE, MONTANT, POIDS, RESTE, FRAIS, IDPRODUITLIB, DATY, DATYPREVU, IDDEVISELIB, IDCATEGORIELIB,
             CATEGORIEPRODUITLIB, PUTOTAL, IDCLIENTLIB,IDFAMILLE,familleproduitlib)
as
SELECT
    v.ID,
    v.IDVENTE,
    v.IDPRODUIT,
    v.IDORIGINE,
    CAST(v.QTE as number(38,2)),
    v.PU,
    v.REMISE,
    v.TVA,
    v.PUACHAT,
    v.PUVENTE,
    v.IDDEVISE,
    v.TAUXDECHANGE,
    v.DESIGNATION,
    v.COMPTE,
    v.PUREVIENT,
    v.IDBCFILLE,
    v.UNITE,
    v.UNITELIB,
    v.PUNET,
    v.MONTANTHT,
    v.MONTANTTTC,
    v.MONTANTTVA,
    v.MONTANTREMISE,
    v.MONTANT,
    CAST(nvl(e.POIDS, 0)* nvl(v.QTE, 0) as number(30,2)) AS poids,
    vc.reste AS reste,
    ve.fraislivraison * nvl(e.POIDS, 0)* nvl(v.QTE, 0) AS frais,
    ing.LIBELLE AS idproduitlib,
    vm.DATY,
    vm.DATYPREVU AS DATYPREVU,
    v.IDDEVISE AS IDDEVISELIB,
    c.VAL AS IDCATEGORIELIB,
    c.VAL AS categorieproduitlib,
    CAST(nvl(v.PU * v.QTE*(1-nvl(v.REMISE,0)/100), 0) +nvl(v.PU * v.QTE*(1-nvl(v.REMISE,0)/100) *(v.TVA/100), 0) AS number(30,2)) AS puTotal,
    cl.nom AS idclientlib,
    ing.IDFAMILLE,
    fp.val AS familleproduitlib
FROM
    VENTE_DETAILS_VIDE v
        LEFT JOIN EQUIVALENCE e ON
        (e.IDPRODUIT = v.IDPRODUIT
            AND e.IDUNITE = v.unite)
        LEFT JOIN VENTE_DETAILS_RESTE vc ON
        vc.ID = v.ID
        LEFT JOIN Vente ve ON
        ve.ID = v.IDVENTE
        LEFT JOIN AS_INGREDIENTS ing ON
        ing.ID = v.IDPRODUIT
        LEFT JOIN VENTE vm ON vm.ID = v.IDVENTE
        LEFT JOIN CATEGORIEINGREDIENT c  ON ing.CATEGORIEINGREDIENT  = c.ID
        LEFT JOIN CLIENT cl  ON vm.idclient  = cl.ID
        left join FamilleProduit fp on fp.ID = ing.IDFAMILLE
        /



CREATE OR REPLACE VIEW V_STAT_VENTE_FAMILLE AS
SELECT
    IDFAMILLE                 ,
    familleproduitlib              AS familleproduitlib,
    EXTRACT(YEAR FROM DATY)                  AS annee,
    EXTRACT(MONTH FROM DATY)                 AS mois,
    SUM(NVL(QTE,0))                          AS qte_totale,
    SUM(NVL(MONTANTHT,0))                    AS montant_ht,
    SUM(NVL(MONTANTTVA,0))                   AS montant_tva,
    SUM(NVL(MONTANTTTC,0))                   AS montant_ttc,
    SUM(NVL(MONTANTREMISE,0))                AS montant_remise,
    SUM(NVL(POIDS,0))                        AS poids_total,
    SUM(NVL(FRAIS,0))                        AS frais_total
FROM VENTE_DETAILS_POIDS
GROUP BY IDFAMILLE,familleproduitlib,
         EXTRACT(YEAR FROM DATY), EXTRACT(MONTH FROM DATY);
