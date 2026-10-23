CREATE OR REPLACE VIEW "FACTUREFOURNISSEURFILLECPL"AS
SELECT f.ID,
       f.IDFACTUREFOURNISSEUR,
       f.IDPRODUIT,
       p.LIBELLE                                                         AS IDPRODUITLIB,
       f.QTE,
       f.PU,
       f.REMISES,
       f.IDBCDETAIL,
       f.TVA,
       f.IDDEVISE,
       f2.DATY,
       ----------------------------------------------------------
       -- 1 Montant HT brut
       ----------------------------------------------------------
       CAST(f.QTE * f.PU AS NUMBER(30, 2))                               AS montant,
       ----------------------------------------------------------
       -- 2 Montant remise (appliquee sur HT)
       ----------------------------------------------------------
       CAST((NVL(f.remises, 0) / 100) * (f.QTE * f.PU) AS NUMBER(30, 2)) AS montantRemise,
       ----------------------------------------------------------
       -- 3 Montant HT net apres remise
       ----------------------------------------------------------
       CAST((f.QTE * f.PU) - ((NVL(f.remises, 0) / 100) * (f.QTE * f.PU))
           AS NUMBER(30, 2))                                             AS montantht,
       ----------------------------------------------------------
       -- 4 TVA sur montant HT net
       ----------------------------------------------------------
       CAST(
               ((f.QTE * f.PU) - ((NVL(f.remises, 0) / 100) * (f.QTE * f.PU)))
                   * f.TVA / 100
           AS NUMBER(30, 2)
       )                                                                 AS montanttva,
       ----------------------------------------------------------
       -- 5 Montant TTC net (HT net + TVA)
       ----------------------------------------------------------
       CAST(
               ((f.QTE * f.PU) - ((NVL(f.remises, 0) / 100) * (f.QTE * f.PU)))
                   + (
                   ((f.QTE * f.PU) - ((NVL(f.remises, 0) / 100) * (f.QTE * f.PU)))
                       * f.TVA / 100
                   )
           AS NUMBER(30, 2)
       )                                                                 AS montantttc,
       ----------------------------------------------------------
       -- 6 Frais accessoires
       ----------------------------------------------------------
       NVL(MONTANTPERTEGAIN, 0)                                          AS fraisaccesoire,
       ----------------------------------------------------------
       -- 7 Montant total avec frais (TTC + accessoires)
       ----------------------------------------------------------
       CAST(
               (
                   ((f.QTE * f.PU * f.TAUXDECHANGE) - ((NVL(f.remises, 0) / 100) * (f.QTE * f.PU * f.TAUXDECHANGE)))
                   )
                   + NVL(MONTANTPERTEGAIN, 0)
           AS NUMBER(30, 2)
       )                                                                 AS montantavecfraisaccessoire,
       ----------------------------------------------------------
       -- 8 PU unitaire HT + accessoires
       ----------------------------------------------------------
       CAST(
               (
                   (
                       ((f.QTE * f.PU * f.TAUXDECHANGE) - ((NVL(f.remises, 0) / 100) * (f.QTE * f.PU * f.TAUXDECHANGE)))
                       )
                       + NVL(MONTANTPERTEGAIN, 0)
                   ) / f.QTE
           AS NUMBER(30, 2)
       )                                                                 AS puavecfraisaccessoire,
       ----------------------------------------------------------
       -- Info produit
       ----------------------------------------------------------
       NVL(p.LIBELLEEXTACTE, p.LIBELLE)                                  AS libelleexacte,
       f.mois,
       f.annee
FROM FACTUREFOURNISSEURFILLE f
         LEFT JOIN FACTUREFOURNISSEUR f2
                   ON f2.ID = f.IDFACTUREFOURNISSEUR
         LEFT JOIN AS_INGREDIENTS p
                   ON p.ID = f.IDPRODUIT
;

CREATE OR REPLACE VIEW "FACTUREFOURNISSEURCPL" AS
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
         left join type_facture tf on tf.id = f.IDTYPEFACTURE
;