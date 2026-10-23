create or replace view FACTUREFOURNISSEURFILLECPL as
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
       CAST(f.QTE * f.PU*f.TAUXDECHANGE AS NUMBER(30, 2))                               AS montant,

       ----------------------------------------------------------
       -- 2 Montant remise (appliquee sur HT)
       ----------------------------------------------------------
       CAST((NVL(f.remises, 0) / 100) * (f.QTE * f.PU) AS NUMBER(30, 2)) AS montantRemise,

       ----------------------------------------------------------
       -- 3 Montant HT net apres remise
       ----------------------------------------------------------
       CAST((f.QTE * f.PU)*f.TAUXDECHANGE * (1-(NVL(f.remise, 0) / 100))
           AS NUMBER(30, 2))                                             AS montantht,

       ----------------------------------------------------------
       -- 4 TVA sur montant HT net
       ----------------------------------------------------------
       CAST(
               ((f.QTE * f.PU)*f.TAUXDECHANGE*(1-(NVL(f.remise, 0) / 100)) )
                   * f.TVA / 100
           AS NUMBER(30, 2)
       )                                                                 AS montanttva,

       ----------------------------------------------------------
       -- 5 Montant TTC net (HT net + TVA)
       ----------------------------------------------------------
       CAST(
               ((f.QTE * f.PU)*f.TAUXDECHANGE*(1-(NVL(f.remise, 0) / 100)))
                   + (
                   ((f.QTE * f.PU)*f.TAUXDECHANGE*(1-(NVL(f.remise, 0) / 100)))
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

                   ((f.QTE * f.PU * f.TAUXDECHANGE*(1-(NVL(f.remise, 0) / 100))))
                   + NVL(MONTANTPERTEGAIN, 0)
           AS NUMBER(30, 2)
       )                                                                 AS montantavecfraisaccessoire,

       ----------------------------------------------------------
       -- 8 PU unitaire HT + accessoires
       ----------------------------------------------------------
       CAST(
               (

                       ((f.QTE * f.PU * f.TAUXDECHANGE*(1-(NVL(f.remise, 0) / 100)))
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
       f.annee,f.REMISE
FROM FACTUREFOURNISSEURFILLE f
         LEFT JOIN FACTUREFOURNISSEUR f2
                   ON f2.ID = f.IDFACTUREFOURNISSEUR
         LEFT JOIN AS_INGREDIENTS p
                   ON p.ID = f.IDPRODUIT;