create or replace view MOUVEMENTCAISSECPL as
SELECT m.ID,
       m.DESIGNATION,
       m.IDCAISSE,
       c.VAL   AS IDCAISSELIB,
       m.IDVENTEDETAIL,
       m.IDVIREMENT,
       m.DEBIT,
       m.CREDIT,
       CAST(
               CASE
                   WHEN m.credit > 0 THEN NVL(m.CREDIT, 0) - NVL(l.MONTANT, 0)
                   ELSE 0
                   END AS NUMBER(36,5)
       ) AS soldecredit,
       CAST(
               CASE
                   WHEN m.debit > 0 THEN NVL(m.DEBIT, 0) - NVL(l.MONTANT, 0)
                   ELSE 0
                   END AS NUMBER(36,5)
       ) AS soldedebit,
       m.DATY,
       m.ETAT,
       CASE
           WHEN m.ETAT = 0
               THEN 'ANNUL&Eacute;E'
           WHEN m.ETAT = 1
               THEN 'CR&Eacute;&Eacute;E'
           WHEN m.ETAT = 11
               THEN 'VALID&Eacute;E'
           WHEN m.ETAT = 8
               THEN '&Agrave; COMPTABILISER'
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
       m.UPDATED_AT, m.heure,
       m.IDREPORT,
       m.ID || '' || m.DATY || '' || m.DESIGNATION || '' || t.NOM || '' || m.IDCAISSE || '' || c.VAL AS MOTSCLESS,
       cr.id as idecriture
FROM MOUVEMENTCAISSE m
         LEFT JOIN CAISSE c ON c.ID = m.IDCAISSE
         LEFT JOIN VENTE_DETAILS vd ON vd.ID = m.IDVENTEDETAIL
         LEFT JOIN tiers t ON t.ID = m.idtiers
         left join liaisonpaiementmvtcaissegrp l on l.idmvtcaisse=m.id
         left join modepaiement mp on m.idmodepaiement = mp.id
         LEFT JOIN COMPTA_ECRITURE cr on cr.IDOBJET=m.id;

create or replace view MOUVEMENTCAISSECPL_VALIDER2 as
SELECT
    ID,DESIGNATION,IDCAISSE,IDCAISSELIB,IDVENTEDETAIL,IDVIREMENT,DEBIT,CREDIT,DATY,ETAT,ETATLIB,IDVENTE,IDORIGINE,IDTIERS,TIERS
FROM
    MOUVEMENTCAISSECPL m
WHERE
    m.etat > 8;

create or replace  view MOUVEMENTCAISSECPL_cptbl AS
SELECT
    ID,DESIGNATION,IDCAISSE,IDCAISSELIB,IDVENTEDETAIL,IDVIREMENT,DEBIT,CREDIT,DATY,ETAT,ETATLIB,IDVENTE,IDORIGINE,IDTIERS,TIERS
FROM
    MOUVEMENTCAISSECPL m
WHERE
    m.etat = 8;

create or replace view REPORTCAISSELIB as
SELECT
    r.ID ,
    r.IDCAISSE ,
    c.VAL AS IDCAISSELIB,
    CAST(r.MONTANT AS NUMBER(30,5)) AS MONTANT ,
    CAST(r.MONTANTTHEORIQUE AS NUMBER(30,5)) AS MONTANTTHEORIQUE ,
    r.DATY ,
    r.ETAT ,r.heure,
    CASE
        WHEN r.ETAT = 0
            THEN 'Annul&eacute;'
        WHEN r.ETAT = 1
            THEN 'Cr&eacute;&eacute;'
        WHEN r.ETAT = 11
            THEN 'Valid&eacute;e'
        END AS ETATLIB
FROM REPORTCAISSE r
         LEFT JOIN CAISSE c ON c.ID  = r.IDCAISSE;

create or replace view DMDACHATLIB as
SELECT
    da.id,
    da.daty,
    da.fournisseur,
    f.nom AS fournisseurlib,
    da.remarque,
    da.dateLimite,
    m.val AS idMagasinLib,
    ci.val AS idCategorieLib,
    da.etat,
    CASE
        WHEN da.ETAT = 0
            THEN 'ANNUL&Eacute;E'
        WHEN da.ETAT = 1
            THEN 'CR&Eacute;&Eacute;E'
        WHEN da.ETAT = 6
            THEN 'VIS&Eacute;E par Direction Source'
        WHEN da.ETAT = 8
            THEN 'VIS&Eacute;E par Initiateur'
        WHEN da.ETAT = 10
            THEN 'VIS&Eacute;E par Chef de D&eacute;partement'
        WHEN da.ETAT = 11
            THEN 'VIS&Eacute;E par DMT'
        END AS etatlib,
    da.idObjet,
    da.service,
    s.libelle AS servicelib,
    p.val AS idPrioriteLib,
    da.idPriorite,
    da.DESTINATAIRE,
    sc.LIBELLE as destinataireLib
FROM DMDACHAT da
         LEFT JOIN FOURNISSEUR f ON f.ID = da.fournisseur
         LEFT JOIN MAGASIN2 m ON da.idMagasin = m.ID
         LEFT JOIN categorieIngredient ci ON da.idCategorie = ci.id
         LEFT JOIN service s ON s.compte = da.SERVICE
         LEFT JOIN service sc ON sc.compte = da.DESTINATAIRE
         LEFT JOIN PRIORITEDMDACHAT p ON p.id = da.idPriorite;
