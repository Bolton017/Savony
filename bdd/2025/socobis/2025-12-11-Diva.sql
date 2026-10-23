create or replace view OFABLIB as
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
               THEN 'CR&Eacute;E'
           WHEN ofl.ETAT=11
               THEN 'VALID&Eacute;E'
           WHEN ofl.ETAT=0
               THEN 'ANNUL&Eacute;E'
           WHEN ofl.ETAT=21
               THEN 'ENTAM&Eacute;'
           WHEN ofl.ETAT=31
               THEN 'BLOQU&Eacute;'
           WHEN ofl.ETAT=41
               THEN 'TERMIN&Eacute;E'
           END AS ETATLIB
FROM OFAB ofl
         LEFT JOIN MAGASINPOINT p1 ON p1.ID = ofl.LANCEPAR
         LEFT JOIN MAGASINPOINT p2 ON p2.ID = ofl.CIBLE;


ALTER TABLE FACTUREFOURNISSEUR ADD IDOBJET VARCHAR(255);
ALTER TABLE FACTUREFOURNISSEUR ADD IDREF VARCHAR(255);

create or replace view FACTUREFOURNISSEURCPL as
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
       f.IDREF
FROM FACTUREFOURNISSEUR f
         LEFT JOIN FOURNISSEUR f2 ON f2.ID = f.IDFOURNISSEUR
         LEFT JOIN MODEPAIEMENT m ON m.ID = f.IDMODEPAIEMENT
         LEFT JOIN MAGASIN p ON p.ID = f.IDMAGASIN
         JOIN FACTUREFOURNISSEURMONTANT f3 ON f.ID = f3.id
         LEFT JOIN mouvementcaisseGroupeFacture mv ON f.id=mv.IDORIGINE
         LEFT JOIN prevision prev ON prev.idfacture=f.id;

create or replace view FACTUREFOURNISSEURCPL_TOUS as
SELECT
    fcpl.id,
    fcpl.idfournisseur,
    fcpl.idfournisseurlib,
    fcpl.idmodepaiement,
    fcpl.idmodepaiementlib,
    fcpl.daty,
    fcpl.designation,
    fcpl.dateecheancepaiement,
    fcpl.etatlib,
    fcpl.reference,
    fcpl.idbc,
    fcpl.idmagasin,
    fcpl.idmagasinlib,
    fcpl.devise,
    fcpl.iddevise,
    fcpl.etat,
    fcpl.taux,
    fcpl.montanttva,
    fcpl.montantht,
    fcpl.tauxdechange,
    fcpl.montantttc AS  MONTANTTTC,
    nvl((fcpl.montantpaye * fcpl.TAUXDECHANGE),0) AS MONTANTPAYE,
    nvl((fcpl.montantreste * fcpl.TAUXDECHANGE),0) AS MONTANTRESTE,
    fcpl.IDOBJET,
    fcpl.IDREF
FROM FACTUREFOURNISSEURCPL fcpl;


create or replace view FACTUREFOURNISSEURAVECMACHINE as
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
       machine.LIBELLE AS idObjetLib,
       machine.IDENTITE
FROM FACTUREFOURNISSEUR f
         LEFT JOIN FOURNISSEUR f2 ON f2.ID = f.IDFOURNISSEUR
         LEFT JOIN MODEPAIEMENT m ON m.ID = f.IDMODEPAIEMENT
         LEFT JOIN MAGASIN p ON p.ID = f.IDMAGASIN
         JOIN FACTUREFOURNISSEURMONTANT f3 ON f.ID = f3.id
         LEFT JOIN mouvementcaisseGroupeFacture mv ON f.id=mv.IDORIGINE
         LEFT JOIN prevision prev ON prev.idfacture=f.id
         JOIN AS_INGREDIENT_MAINTENANCE machine ON machine.ID = f.IDOBJET;


create or replace view AS_INGREDIENT_MAINTENANCE_LIB as
SELECT
    am."ID",am."IDINGREDIENT",am."IDENTITE",am."REFERENCEOBJET",am."MARQUEOBJET",am."MODELEOBJET",am."NUMEROSERIEOBJET",am."DESCRIPTIONOBJET",am."QUALITEOBJET",am."ETATOBJET",am."LOCALISATIONOBJET",am."PUISSANCEOBJET",am."OBSERVATIONOBJET",am."TYPERATTACHEMENT",am."ESTENGIN",am."LIBELLE",am."DATEAQUISITION",
    ai.libelle AS INGREDIENTLIB,
    am.IDENTITE AS IDENTITELIB,
    qo.VAL AS QUALITEOBJETLIB,
    eo.VAL AS ETATOBJETLIB,
    ld.val AS localisationObjetLib,
    CASE
        WHEN am.ESTENGIN = 1 THEN 'Oui'
        ELSE 'Non'
        END AS ESTENGINLIB,
    l.id AS idligne,
    l.val AS idlignelib,
    am.PU
FROM AS_INGREDIENTS ai
         JOIN AS_INGREDIENT_MAINTENANCE am ON ai.ID = am.IDINGREDIENT
         LEFT JOIN QUALITESOBJETMAINTENANCE qo ON am.QUALITEOBJET = qo.ID
         LEFT JOIN ETATOBJETMAINTENANCE eo ON am.ETATOBJET = eo.ID
         left join LOG_DEPARTEMENT ld on am.localisationObjet=ld.id
         LEFT JOIN LIGNE l ON l.id=am.idligne;


create or replace view MVTSTOCKFILLELIB as
SELECT
    m.ID ,
    m.IDMVTSTOCK ,
    m.IDPRODUIT ,
    p.libelle  AS IDPRODUITLIB,
    m.ENTREE ,
    m.SORTIE ,
    m.IDVENTEDETAIL ,
    '' AS IDVENTEDETAILLIB,
    m.IDTRANSFERTDETAIL ,
    '' AS IDTRANSFERTDETAILLIB,
    m2.DATY ,
    m2.IDMAGASIN ,
    m3.VAL AS IDMAGASINLIB,
    m.pu,
    cast(m.pu*m.ENTREE+(m.pu*m.sortie) as number(20,5)) as montant,
    p.LIBELLE,
    m.MVTSRC,
    p.libelle AS libelleexacte,
    m2.DATY AS dateSql
FROM MVTSTOCKFILLE m
         LEFT JOIN AS_INGREDIENTS  p ON p.ID = m.IDPRODUIT
         LEFT JOIN MVTSTOCK m2 ON m2.ID = m.IDMVTSTOCK
         LEFT JOIN MAGASIN2 m3 ON m3.ID = m2.IDMAGASIN;
