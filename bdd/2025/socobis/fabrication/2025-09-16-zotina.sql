CREATE OR REPLACE VIEW cout_fab_par_of AS 
SELECT 
    base.IDMERE,
    base.DATYBESOIN,
    base.IDINGREDIENTS AS INGREDIENTS,
    ROUND(
        SUM(
            CASE 
                WHEN base.QTEFABRIQUE = 0 OR base.QTEFABRIQUE IS NULL THEN 0
                ELSE base.MONTANTSORTIE / base.QTEFABRIQUE
            END
        ) , 2
    ) / 1000000 AS COUTDEPRODUCTION
FROM 
    OFFILLELIBSTOCK base
    JOIN OFAB fb ON fb.id = base.idmere AND fb.etat >= 11
GROUP BY 
    base.IDMERE,
    base.DATYBESOIN,
    base.IDINGREDIENTS
ORDER BY 
    base.IDMERE;


CREATE OR REPLACE VIEW stat_depense_cat AS 
SELECT 
	
	ffc.daty,
	ai.CATEGORIEINGREDIENT ,
	cat.val AS CATEGORIEINGREDIENTLIB,
	EXTRACT(MONTH FROM ffc.daty) as MOISINT,
    TRIM(TO_CHAR(ffc.daty, 'Month', 'NLS_DATE_LANGUAGE=FRENCH')) AS MOISSTRING,
    EXTRACT(YEAR FROM ffc.daty) as ANNEE,
	sum(ffc.montant) / 1000000 AS depense
	
FROM FACTUREFOURNISSEURFILLECPL  ffc
    JOIN FACTUREFOURNISSEUR fc on fc.id = ffc.idfacturefournisseur and etat >= 11 
	JOIN AS_INGREDIENTS ai ON ffc.IDPRODUIT = ai.id
	LEFT JOIN CATEGORIEINGREDIENT cat ON ai.CATEGORIEINGREDIENT  = cat.id
GROUP BY 
	ai.CATEGORIEINGREDIENT,
	ffc.daty,
	cat.val;

CREATE OR REPLACE VIEW duree_cycle_fab AS 
SELECT 
    off.IDMERE,
    ROUND(SUM(p.ecart) / 60, 2) AS temps 
FROM 
    PROCESS p
    JOIN FABRICATION fab ON fab.id = p.refobjet AND fab.etat >= 11
    JOIN OFFILLE off ON off.id = fab.IDOFFILLE
    JOIN OFAB o ON o.id = off.IDMERE
GROUP BY 
    off.IDMERE;


INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1758268441447570', 'Co&ucirc;t de production par OF', 'fa fa-chart-line', 'module.jsp?but=stat/cout-fab-chart.jsp', 5, 2, 'ELM00T3004001');
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1758268474616469', 'D&eacute;penses par cat&eacute;gorie', 'fa fa-chart-line', 'module.jsp?but=stat/stat-depense-cat-chart.jsp', 6, 2, 'ELM00T3004001');
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1758268499623140', 'Dur&eacute;e du cycle de fabrication', 'fa fa-chart-line', 'module.jsp?but=stat/duree-cycle-chart.jsp', 7, 2, 'ELM00T3004001');

DELETE FROM usermenu WHERE id = 'USRM007'; 
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM8A2E6C78', 'ELM000010', '*', NULL, 0);

-- MAROUSSIA

CREATE OR REPLACE FORCE VIEW "COUT_FAB_PAR_OF"AS
SELECT
    base.IDMERE,
    base.DATYBESOIN,
    base.IDINGREDIENTS AS INGREDIENTS,
    ROUND(
            SUM(
                    CASE
                        WHEN base.QTEFABRIQUE = 0 OR base.QTEFABRIQUE IS NULL THEN 0
                        ELSE base.MONTANTSORTIE / base.QTEFABRIQUE
                        END
            ) , 2
    ) / 1000000 AS COUT_AVANT,
    SUM(MONTANTSORTIE) AS COUTDEPRODUCTION

FROM
    OFFILLELIBSTOCK base
        JOIN OFAB fb ON fb.id = base.idmere AND fb.etat >= 11
GROUP BY
    base.IDMERE,
    base.DATYBESOIN,
    base.IDINGREDIENTS
ORDER BY
    base.IDMERE;
