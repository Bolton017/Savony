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
               THEN 'CR&Eacute;&Eacute;E'
           WHEN f.ETAT = 0
               THEN 'ANNUL&Eacute;E'
           WHEN f.ETAT = 11
               THEN 'VIS&Eacute;E'
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
           prev.id as idPrevision
FROM FACTUREFOURNISSEUR f
         LEFT JOIN FOURNISSEUR f2 ON f2.ID = f.IDFOURNISSEUR
         LEFT JOIN MODEPAIEMENT m ON m.ID = f.IDMODEPAIEMENT
         LEFT JOIN MAGASIN p ON p.ID = f.IDMAGASIN
         JOIN FACTUREFOURNISSEURMONTANT f3 ON f.ID = f3.id
         LEFT JOIN mouvementcaisseGroupeFacture mv ON f.id=mv.IDORIGINE
         LEFT JOIN prevision prev ON prev.idfacture=f.id;