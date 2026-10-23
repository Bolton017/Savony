CREATE OR REPLACE FORCE VIEW "STOCKETDEPENSEOFFABTHE" ("IDOBJET", "IDPRODUIT", "DESIGNATION", "ENTREE", "SORTIE", "PU", "MONTANENTREE", "MONTANTSORTIE", "IDMERE", "ID", "QTETH", "PUTH", "MONTTH", "CATEGORIEINGREDIENT", "CATEGORIEINGREDIENTLIB") AS
select
    sed."IDOBJET",
    sed."IDPRODUIT",
    nvl(recFab.LIBINGREDIENTS,ai.LIBELLE) AS designation,
    CAST(sed."ENTREE" as number(30,5)) AS ENTREE ,
    CAST(sed."SORTIE" as number(30,5))  AS SORTIE ,
    CAST(
            CASE
                WHEN nvl(sed."PU",0) = 0 THEN recFab.pu
                ELSE nvl(sed."PU",0)
                END
        as number(30,2)) AS PU,
    CAST(sed."MONTANENTREE" as number(30,5)) AS MONTANENTREE ,
    CAST(
            CASE
                WHEN nvl(sed."PU",0) = 0 THEN recFab.pu * sed."SORTIE"
                ELSE nvl(sed."PU",0) * sed."SORTIE"
                END
        as number(30,2))  AS MONTANTSORTIE,
    sed."IDMERE",
    sed."ID",
    cast(nvl(recFab.QUANTITE,0) as number(30,10)) as qteTh,
    cast(nvl(recFab.QTEAV,sed.pu) as number(30,5)) as puth,
    cast(nvl(recFab.QUANTITE,0)*nvl(recFab.QTEAV,0) as number(30,5)) as montTh,
    sed.CATEGORIEINGREDIENT,
    sed.CATEGORIEINGREDIENTLIB
from stockDepenseOfFab sed full
                               outer join AS_RECFOFABLIBGROUPE recFab
                                          on sed.IDOBJET=recFab.IDPRODUITS and sed.IDPRODUIT=recFab.IDINGREDIENTS
                           LEFT JOIN AS_INGREDIENTS ai ON ai.ID = sed.IDOBJET OR ai.ID =  sed.IDPRODUIT
;

CREATE OR REPLACE force VIEW STOCKETDEPENSEOFFABTHECAT as
SELECT
    std."IDOBJET",
    std."IDPRODUIT",
    std."ENTREE",
    std."SORTIE",
    std."PU",
    std."MONTANENTREE",
    std."MONTANTSORTIE",
    std."IDMERE",
    std."ID",
    std."QTETH",
    std."PUTH",
    std."MONTTH",
    ing.CATEGORIEINGREDIENT  as CATEGORIEINGREDIENT,
    ing.IDCATEGORIEINGREDIENT  AS idcategorieingredient,
    ing.libelle
from stockEtDepenseOfFabThe std
         join AS_INGREDIENTS_LIB ing on std.IDPRODUIT=ing.id;

UPDATE menudynamique SET rang = 1 WHERE id = 'MNDN00001';
UPDATE menudynamique SET rang = 2 WHERE id = 'ELM00T3004001';
UPDATE menudynamique SET rang = 3 WHERE id = 'MNDN000000001';
UPDATE menudynamique SET rang = 4 WHERE id = 'MNDN000000002';
UPDATE menudynamique SET rang = 5 WHERE id = 'MNDNMT01';
UPDATE menudynamique SET rang = 6 WHERE id = 'MNDN000000003';
UPDATE menudynamique SET rang = 7 WHERE id = 'ELM000010';
UPDATE menudynamique SET rang = 8 WHERE id = 'MENUDYN001';
UPDATE menudynamique SET rang = 9 WHERE id = 'MNDN274';
UPDATE menudynamique SET rang = 10 WHERE id = 'MENUDYN002';
UPDATE menudynamique SET rang = 11 WHERE id = 'ELM000904001';
UPDATE menudynamique SET rang = 12 WHERE id = 'MNDN00000002111';
UPDATE menudynamique SET rang = 13 WHERE id = 'MDT021030017';
UPDATE menudynamique SET rang = 14 WHERE id = 'MNDN00002';
UPDATE menudynamique SET rang = 15 WHERE id = 'MENUP001V';
UPDATE menudynamique SET rang = 16 WHERE id = 'MENUDYN00304001';
UPDATE menudynamique SET rang = 17 WHERE id = 'MENUDYN00304002';
UPDATE menudynamique SET rang = 18 WHERE id = 'ELM000011';
UPDATE menudynamique SET rang = 4, niveau = 2, id_pere = 'MENUDYN00304001' WHERE id = 'MENUDYN00304002';
UPDATE menudynamique SET niveau = 3 WHERE id = 'MENUDYN0304008';
UPDATE menudynamique SET niveau = 3 WHERE id = 'MENUDYN0304009';
UPDATE menudynamique SET rang = 17 WHERE id = 'ELM000011';
UPDATE menudynamique SET rang = 6 WHERE id = 'MENUDYN00304001';
UPDATE menudynamique SET rang = 7 WHERE id = 'MNDN000000003';
UPDATE menudynamique SET rang = 8 WHERE id = 'ELM000010';
UPDATE menudynamique SET rang = 1, niveau = 2, id_pere = 'MENUDYN00304001' WHERE id = 'ELM00T3004001';
UPDATE menudynamique SET rang = 2 WHERE id = 'MENUDYN00304003';
UPDATE menudynamique SET rang = 3 WHERE id = 'MENUDYN01908001';
UPDATE menudynamique SET rang = 4 WHERE id = 'MENUDYN02108001';
UPDATE menudynamique SET rang = 5, niveau = 2, id_pere = 'MENUDYN00304001' WHERE id = 'MENUDYN00304002';
UPDATE menudynamique SET niveau = 3 WHERE id = 'ELM00T3004002';
UPDATE menudynamique SET niveau = 3 WHERE id = 'MENDYN1756281961904';
UPDATE menudynamique SET niveau = 3 WHERE id = 'MENDYN1756300444397-505';
UPDATE menudynamique SET niveau = 4 WHERE id = 'MENDYN1756281918079-243';
UPDATE menudynamique SET niveau = 4 WHERE id = 'MENDYN1756300524012-253';
UPDATE menudynamique SET niveau = 3 WHERE id = 'MENDYN1756371601724688';
UPDATE menudynamique SET niveau = 4 WHERE id = 'MENDYN1756282017293-463';
UPDATE menudynamique SET niveau = 4 WHERE id = 'MENDYN1756371621833614';
UPDATE menudynamique SET niveau = 3 WHERE id = 'MENDYN1758268441447570';
UPDATE menudynamique SET niveau = 3 WHERE id = 'MENDYN1758268474616469';
UPDATE menudynamique SET niveau = 3 WHERE id = 'MENDYN1758268499623140';
UPDATE menudynamique SET rang = 2 WHERE id = 'MNDN000000001';
UPDATE menudynamique SET rang = 3 WHERE id = 'MNDN000000002';
UPDATE menudynamique SET rang = 4 WHERE id = 'MNDNMT01';
UPDATE menudynamique SET rang = 5 WHERE id = 'MENUDYN00304001';
UPDATE menudynamique SET rang = 6 WHERE id = 'MNDN000000003';
UPDATE menudynamique SET rang = 7 WHERE id = 'ELM000010';
UPDATE menudynamique SET rang = 8 WHERE id = 'MENUDYN001';
UPDATE menudynamique SET rang = 9 WHERE id = 'MNDN274';
UPDATE menudynamique SET rang = 10 WHERE id = 'MENUDYN002';
UPDATE menudynamique SET rang = 11 WHERE id = 'ELM000904001';
UPDATE menudynamique SET rang = 12 WHERE id = 'MNDN00000002111';
UPDATE menudynamique SET rang = 13 WHERE id = 'MDT021030017';
UPDATE menudynamique SET rang = 14 WHERE id = 'MNDN00002';
UPDATE menudynamique SET rang = 15 WHERE id = 'MENUP001V';
UPDATE menudynamique SET rang = 16 WHERE id = 'ELM000011';
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1765468433191661', 'Par catégorie', 'fa fa-chart-pie', 'module.jsp?but=stat/repartition-cout-production.jsp', 8, 3, 'ELM00T3004001');
UPDATE menudynamique SET rang = 4, niveau = 3 WHERE id = 'MENDYN1756371601724688';
UPDATE menudynamique SET rang = 7, niveau = 3 WHERE id = 'MENDYN1758268474616469';
UPDATE menudynamique SET rang = 8, niveau = 3 WHERE id = 'MENDYN1758268499623140';
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1765468461881419', 'Par catégorie', 'fa fa-chart-pie', 'module.jsp?but=stat/repartition-cout-production.jsp', 1, 4, 'MENDYN1758268441447570');
DELETE FROM menudynamique WHERE id = 'MENDYN1765468433191661';
UPDATE menudynamique SET niveau = 3 WHERE id = 'MENDYN1758268474616469';
UPDATE menudynamique SET niveau = 3 WHERE id = 'MENDYN1758268499623140';
UPDATE menudynamique SET href = '#', niveau = 3 WHERE id = 'MENDYN1758268441447570';
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1765468496617698', 'Global', 'fa fa-chart-line', 'module.jsp?but=stat/cout-fab-chart.jsp', 2, 4, 'MENDYN1758268441447570');

-- script pour l'usermenu

DELETE FROM usermenu WHERE id = 'USRMENADM03004001'; -- 1 rows
DELETE FROM usermenu WHERE id = 'USRMENCHFAB03004001'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMB4E638A4'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM1BD8CB2B'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM4452E80A'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMF445DA46'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM50A56099'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM23C38A07'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMEDB2C007'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM9F6E0114'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM713A1E66'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM3EDF1511'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMA83B36DC'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM58AD527E'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM18E2C129'; -- 1 rows
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMCDDDC558', 'MDT021030017', '*', NULL, 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM0F7C4278', 'MNDN00002', '*', NULL, 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMAC218939', 'ELM00T3004001', NULL, 'magtransitmp', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMC6865CDC', 'ELM00T3004001', NULL, 'magtransiteblg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMA533DFC4', 'ELM00T3004001', NULL, 'ctrmaitre', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMC277E859', 'MENUDYN00304002', NULL, 'magtransitmp', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM39A19A26', 'MENUDYN00304002', NULL, 'magtransiteblg', 1);

CREATE OR REPLACE FORCE VIEW "PROCESSLIB"  AS
SELECT
    p.IDHISTORIQUE ,
    p.DATEHISTORIQUE ,
    p.HEURE ,
    p.OBJET ,
    p.REFOBJET ,
    p.REMARQUE ,
    p.IDUTILISATEUR ,
    p."ACTION" ,
    p.ECART ,
    p.ecart / 60 AS ecartMinutes,
    pers.NOM || ' ' || pers.TELEPHONE AS acteur
FROM
    PROCESS p
        LEFT JOIN PERSONNEL pers ON
        p.acteur = pers.id;