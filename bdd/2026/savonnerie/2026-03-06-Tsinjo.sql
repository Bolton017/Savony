CREATE OR REPLACE VIEW OFABLIB AS
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
           WHEN ofl.etat = 9
               THEN 'CL&Ocirc;TUR&Eacute;'
           WHEN ofl.ETAT=11
               THEN 'VALID&Eacute;'
           WHEN ofl.ETAT=0
               THEN 'ANNUL&Eacute;'
           WHEN ofl.ETAT=21
               THEN 'ENTAM&Eacute;'
           WHEN ofl.ETAT=31
               THEN 'BLOQU&Eacute;'
           WHEN ofl.ETAT=41
               THEN 'TERMIN&Eacute;'
           END AS ETATLIB
FROM OFAB ofl
         LEFT JOIN MAGASINPOINT p1 ON p1.ID = ofl.LANCEPAR
         LEFT JOIN MAGASINPOINT p2 ON p2.ID = ofl.CIBLE


;

UPDATE USERMENU
SET REFUSER='*', IDMENU='MENUDYN00304001', IDROLE='magtransitmp', CODESERVICE=NULL, CODEDIR=NULL, INTERDIT=0
WHERE ID='USRMEN0003';
UPDATE USERMENU
SET REFUSER='*', IDMENU='MENUDYN00304001', IDROLE='magtransiteblg', CODESERVICE=NULL, CODEDIR=NULL, INTERDIT=0
WHERE ID='USRMEN0006';
UPDATE USERMENU
SET REFUSER='*', IDMENU='MENUDYN00304001', IDROLE='cheffab', CODESERVICE=NULL, CODEDIR=NULL, INTERDIT=0
WHERE ID='USRMENCHFAB00304001';
UPDATE USERMENU
SET REFUSER='*', IDMENU='MENUDYN00304001', IDROLE='ctrmaitre', CODESERVICE=NULL, CODEDIR=NULL, INTERDIT=0
WHERE ID='USRMENCTMTRE008040021';

UPDATE MENUDYNAMIQUE
SET LIBELLE='Fabrication', ICONE='precision_manufacturing', HREF='module.jsp?but=fabrication/fabrication-liste.jsp', RANG=2, NIVEAU=2, ID_PERE='MENUDYN00304001'
WHERE ID='MENUDYN00304002';

delete from USERMENU where idmenu='MENUDYN00304002';

CREATE OR REPLACE VIEW STOCKETDEPENSEOFFABTHEPOIDSTH AS
WITH totaux_categorie AS (
    SELECT
        sed.CATEGORIEINGREDIENT,
        sed.IDMERE,
        SUM(CAST(NVL(recFab.QUANTITE, 0) AS NUMBER(30,10))) AS totalCategorieTheorique,
        SUM(CAST(NVL(sed.SORTIE, 0) AS NUMBER(30,5))) AS totalCategoriePratique
    FROM stockDepenseOfFab sed
    FULL OUTER JOIN AS_RECFOFABLIBGROUPE recFab
        ON sed.IDOBJET = recFab.IDPRODUITS AND sed.IDPRODUIT = recFab.IDINGREDIENTS
    GROUP BY sed.CATEGORIEINGREDIENT, sed.IDMERE
),
base AS (
    SELECT
        sed.IDOBJET,
        sed.IDPRODUIT,
        NVL(recFab.LIBINGREDIENTS, ai.LIBELLE) AS designation,
        CAST(sed.ENTREE AS NUMBER(30,5)) AS ENTREE,
        CAST(sed.SORTIE AS NUMBER(30,5)) AS SORTIE,
        CAST(
            CASE
                WHEN NVL(sed.PU, 0) = 0 THEN recFab.pu
                ELSE NVL(sed.PU, 0)
            END AS NUMBER(30,2)
        ) AS PU,
        CAST(sed.MONTANENTREE AS NUMBER(30,5)) AS MONTANENTREE,
        CAST(
            CASE
                WHEN NVL(sed.PU, 0) = 0 THEN recFab.pu * sed.SORTIE
                ELSE NVL(sed.PU, 0) * sed.SORTIE
            END AS NUMBER(30,2)
        ) AS MONTANTSORTIE,
        sed.IDMERE,
        sed.ID,
        CAST(NVL(recFab.QUANTITE, 0) AS NUMBER(30,10)) AS qteTh,
        CAST(NVL(recFab.QTEAV, sed.pu) AS NUMBER(30,5)) AS puth,
        CAST(NVL(recFab.QUANTITE, 0) * NVL(recFab.QTEAV, 0) AS NUMBER(30,5)) AS montTh,
        sed.CATEGORIEINGREDIENT,
        sed.CATEGORIEINGREDIENTLIB
    FROM stockDepenseOfFab sed
    FULL OUTER JOIN AS_RECFOFABLIBGROUPE recFab
        ON sed.IDOBJET = recFab.IDPRODUITS AND sed.IDPRODUIT = recFab.IDINGREDIENTS
    LEFT JOIN AS_INGREDIENTS ai
        ON ai.ID = sed.IDOBJET OR ai.ID = sed.IDPRODUIT
)
SELECT
    base.*,
    totaux.totalCategorieTheorique,
    totaux.totalCategoriePratique,
    CAST(
            COALESCE(
                        (base.qteTh / NULLIF(totaux.totalCategorieTheorique, 0)) * 100,
                        0
                ) AS NUMBER(30,5)
        ) AS poidsTheorique
FROM base
         LEFT JOIN totaux_categorie totaux
                   ON base.CATEGORIEINGREDIENT = totaux.CATEGORIEINGREDIENT
                       AND base.IDMERE = totaux.IDMERE;

DELETE FROM SAVONNERIE0126.MENUDYNAMIQUE
WHERE ID='MENUDYN3204004';
DELETE FROM SAVONNERIE0126.MENUDYNAMIQUE
WHERE ID='MENUDYN0304005';