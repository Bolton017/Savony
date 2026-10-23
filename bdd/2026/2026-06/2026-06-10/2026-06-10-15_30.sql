@ -0,0 +1,26 @@
UPDATE TYPEMVTSTOCK
SET VAL='Entrée', DESCE='Entrée'
WHERE ID='TPMVST000001';

CREATE OR REPLACE VIEW TransfertStockCpl_cree AS (
	SELECT
		t.*
	FROM
	TransfertStockCpl t
	WHERE t.etat=1
);

CREATE OR REPLACE VIEW TransfertStockCpl_visee AS (
	SELECTs
		t.*
	FROM
	TransfertStockCpl t
	WHERE t.etat=11
);
CREATE OR REPLACE VIEW TransfertStockCpl_annulee AS (
	SELECT
		t.*
	FROM
	TransfertStockCpl t
	WHERE t.etat=0
);