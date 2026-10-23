-- Stefan

CREATE OR REPLACE VIEW "AS_BONDELIVRAISON_LIB" AS
select bl.ID,
       bl.REMARQUE,
       bl.IDBC,
       bl.DATY,
       bl.ETAT,
       bl.MAGASIN,
       m.VAL as MAGASINlib,
       case
           when bl.etat = 1 then 'CR&Eacute;&Eacute;(E)'
           when bl.etat = 11 then 'VIS&Eacute;(E)'
           end as etatlib,
       bl.idfournisseur,
       f.nom AS idfournisseurlib,
       bl.IDFACTUREFOURNISSEUR,
       UPPER(
               NVL(bl.REMARQUE, '') || ' ' ||
               NVL(bl.IDBC, '') || ' ' ||
               NVL(f.nom, '') || ' ' ||
               NVL(m.VAL, '') || ' ' ||
               NVL(bl.IDFACTUREFOURNISSEUR, '') || ' ' ||
               TO_CHAR(bl.DATY, 'DD/MM/YYYY') || ' ' ||
               NVL(
                       CASE
                           WHEN bl.etat = 1 THEN 'CREE'
                           WHEN bl.etat = 11 THEN 'VISEE'
                           END
                   , '')
       ) AS MOTSCLESSS

from AS_BONDELIVRAISON bl
         left join MAGASIN2 m on bl.MAGASIN = m.ID
         LEFT JOIN fournisseur f ON f.id=bl.idfournisseur
;

CREATE OR REPLACE FORCE VIEW "FACTUREFOURNISSEURCPL" AS
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
               THEN 'CRÉÉE'
           WHEN f.ETAT = 0
               THEN 'ANNULÉE'
           WHEN f.ETAT = 11
               THEN 'VISÉE'
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
         left join type_facture tf on tf.id = f.IDTYPEFACTURE


;

CREATE OR REPLACE VIEW "MOUVEMENTCAISSECPL"  AS
SELECT m.ID,
       m.DESIGNATION,
       m.IDCAISSE,
       c.VAL   AS IDCAISSELIB,
       m.IDVENTEDETAIL,
       m.IDVIREMENT,
       m.DEBIT,
       m.CREDIT,
       case when m.credit > 0 then cast(nvl(m.CREDIT, 0) - nvl(l.MONTANT, 0) as number(30,2)) else 0 end as soldecredit,
       case when m.debit > 0 then cast(nvl(m.debit, 0) - nvl(l.MONTANT, 0) as number(30,2)) else 0 end as soldedebit,
       m.DATY,
       m.ETAT,
       CASE
           WHEN m.ETAT = 0
               THEN 'ANNULÉE'
           WHEN m.ETAT = 1
               THEN 'CRÉÉE'
           WHEN m.ETAT = 11
               THEN 'VALIDÉE'
           WHEN m.ETAT = 8
               THEN 'À COMPTABILISER'
           END AS ETATLIB,
       vd.IDVENTE,
       m.IDORIGINE as idorigine,
       m.idtiers,
       t.NOM AS tiers,
       m.idPrevision,
       m.idOP,
       m.taux,
       m.COMPTE,
       m.IDDEVISE,
       m.idtraite,
       mp.VAL as idModePaiementLib,
       m.idmvtcaissemere,
       m.reference,
       m.datycomptabilisation,
       m.UPDATED_AT
FROM MOUVEMENTCAISSE m
         LEFT JOIN CAISSE c ON c.ID = m.IDCAISSE
         LEFT JOIN VENTE_DETAILS vd ON vd.ID = m.IDVENTEDETAIL
         LEFT JOIN tiers t ON t.ID = m.idtiers
         left join liaisonpaiementmvtcaissegrp l on l.idmvtcaisse=m.id
         left join modepaiement mp on m.idmodepaiement = mp.id




;

-- SAVONNERIE0204.FACTUREFOURNISSEURCPL2 source

CREATE OR REPLACE VIEW "FACTUREFOURNISSEURCPL2" AS
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

       CAST(
               f3.MONTANT_HT -
               CASE
                   WHEN NVL(f.REMISE, 0) > 0 THEN f3.MONTANT_HT * (NVL(f.REMISE, 0) / 100)
                   WHEN NVL(f.REMISEMONTANT, 0) > 0 THEN  NVL(f.REMISEMONTANT, 0)
                   ELSE 0
                   END
           AS NUMBER(30,2)) AS MONTANTHT,

       CAST(
               f3.MONTANTTTC -
               CASE
                   WHEN NVL(f.REMISE, 0) > 0 THEN f3.MONTANTTTC * (NVL(f.REMISE, 0) / 100)
                   WHEN NVL(f.REMISEMONTANT, 0) > 0 THEN  NVL(f.REMISEMONTANT, 0)
                   ELSE 0
                   END
           AS NUMBER(30,2)) AS MONTANTTTC,
       cast(
               f3.tauxdechange * (f3.MONTANTTTC -
                                  CASE
                                      WHEN NVL(f.REMISE, 0) > 0 THEN f3.MONTANTTTC * (NVL(f.REMISE, 0) / 100)
                                      WHEN NVL(f.REMISEMONTANT, 0) > 0 THEN  NVL(f.REMISEMONTANT, 0)
                                      ELSE 0
                                      END
                   ) as number(30,2)) as MONTANTTTCAR,
       cast(nvl(mv.debit,0) AS NUMBER(30,2)) AS montantpaye,
       cast(f3.MONTANTTTC -
            CASE
                WHEN NVL(f.REMISE, 0) > 0 THEN f3.MONTANTTTC * (NVL(f.REMISE, 0) / 100)
                WHEN NVL(f.REMISEMONTANT, 0) > 0 THEN  NVL(f.REMISEMONTANT, 0)
                ELSE 0
                END
                -
            nvl(mv.debit,0) AS NUMBER(30,2)) AS montantreste,
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
       f.typeachat,
       f.remise,
       f.remisemontant
FROM FACTUREFOURNISSEUR f
         LEFT JOIN FOURNISSEUR f2 ON f2.ID = f.IDFOURNISSEUR
         LEFT JOIN MODEPAIEMENT m ON m.ID = f.IDMODEPAIEMENT
         LEFT JOIN MAGASIN2 p ON p.ID = f.IDMAGASIN
         JOIN FACTUREFOURNISSEURMONTANT2 f3 ON f.ID = f3.id
         LEFT JOIN mouvementcaisseGroupeFacture mv ON f.id=mv.IDORIGINE
         LEFT JOIN prevision prev ON prev.idfacture=f.id
         left join type_facture tf on tf.id = f.IDTYPEFACTURE


;