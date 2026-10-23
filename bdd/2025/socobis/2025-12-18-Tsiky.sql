CREATE TABLE TYPEACHAT
   (	
    ID VARCHAR2(100) NOT NULL ENABLE, 
	VAL VARCHAR2(100) NOT NULL ENABLE, 
	DESCE VARCHAR2(100) NOT NULL ENABLE, 
	 CONSTRAINT "TYPEACHAT_PK" PRIMARY KEY ("ID")
	);

INSERT INTO TYPEACHAT (ID, VAL, DESCE)
VALUES
('TA0001', 'Matiere premiere', 'MP');

INSERT INTO TYPEACHAT (ID, VAL, DESCE) 
VALUES
('TA0002', 'Fourniture de bureau', 'FB');

INSERT INTO TYPEACHAT (ID, VAL, DESCE) 
VALUES
('TA0003', 'Prestation service', 'PS');


CREATE OR REPLACE VIEW v_next_facture_fournisseur AS
SELECT
    type_achat || '-' || initial_client AS prefixe,
    date_facture,
    LPAD(COUNT(*) + 1, 2, '0') AS nextnum
FROM facturefournisseur
GROUP BY
    type_achat,
    initial_client,
    date_facture;


ALTER TABLE facturefournisseur 
ADD numero VARCHAR2(255);
AL

ALTER TABLE facturefournisseur 
ADD typeachat VARCHAR2(255);

UPDATE facturefournisseur
SET typeachat = 'MP'
WHERE typeachat IS NULL;

CREATE OR REPLACE VIEW FACTUREFOURNISSEURCPL AS 
SELECT f.ID,
       f.IDFOURNISSEUR,
       f2.NOM  AS IDFOURNISSEURLIB,
       f.IDMODEPAIEMENT,
       m.VAL   AS IDMODEPAIEMENTLIB,
       f.DATY,
       f.DESIGNATION,
       f.DATEECHEANCEPAIEMENT,
       f.ETAT,
       CASE
           WHEN f.ETAT = 1
               THEN 'CREEE'
           WHEN f.ETAT = 0
               THEN 'ANNULEE'
           WHEN f.ETAT = 11
               THEN 'VISEE'
           END AS ETATLIB,
       f.REFERENCE,
       f.IDBC,
       f.IDMAGASIN,
       f.DEVISE,
       case
           when f.TAUX=0 then 1
           else f.TAUX
           end as taux,
       p.VAL   AS idMagasinLib,
       f3.IDDEVISE,
       cast(f3.MONTANTTVA as number(30,2)) as MONTANTTVA,
       CAST(f3.MONTANTTTC-f3.MONTANTTVA as number(30,2)) AS MONTANTHT,
       cast(f3.MONTANTTTC as number(30,2)) as montantttc,
       cast(f3.MONTANTTTC*f3.tauxdechange as number(30,2)) as MONTANTTTCAR,
       cast(nvl(mv.debit,0) AS NUMBER(30,2)) AS montantpaye,
       cast(f3.MONTANTTTC-nvl(mv.debit,0) AS NUMBER(30,2)) AS montantreste,
       cast(nvl(f3.tauxdechange,0) AS  NUMBER(30,2)) AS tauxdechange,
       prev.id as idPrevision,
       CASE
           WHEN f.estprevu=0 THEN 'NON'
           ELSE 'OUI'
           END
           AS estprevulib,
       f.IDOBJET,
       f.IDREF,
       f.IDTYPEFACTURE,
       tf.VAL as typefacture,
       f.numero,
       f.typeachat
FROM FACTUREFOURNISSEUR f
         LEFT JOIN FOURNISSEUR f2 ON f2.ID = f.IDFOURNISSEUR
         LEFT JOIN MODEPAIEMENT m ON m.ID = f.IDMODEPAIEMENT
         LEFT JOIN MAGASIN p ON p.ID = f.IDMAGASIN
         JOIN FACTUREFOURNISSEURMONTANT f3 ON f.ID = f3.id
         LEFT JOIN mouvementcaisseGroupeFacture mv ON f.id=mv.IDORIGINE
         LEFT JOIN prevision prev ON prev.idfacture=f.id
left join type_facture tf on tf.id = f.IDTYPEFACTURE;

CREATE OR REPLACE VIEW v_next_facture_fournisseur AS
SELECT
    typeachat || '-' || SUBSTR(IDFOURNISSEURLIB, 1, 1) AS prefixe,
    daty AS date_facture,
    LPAD(COUNT(*) + 1, 2, '0') AS nextnum
FROM facturefournisseurcpl
WHERE etat>=11
GROUP BY
    typeachat || '-' || SUBSTR(IDFOURNISSEURLIB, 1, 1),
    daty;
