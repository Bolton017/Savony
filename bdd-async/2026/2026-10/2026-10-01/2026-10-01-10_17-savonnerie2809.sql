--ireto View ireto : 
--
--COMPTA_ECRITURE_LIB
--
--COMPTA_ECRITURE_LIB_VENTE
--
--COMPTA_ECRITURE_LIB_ACHAT
--
--COMPTA_ECRITURE_LIB_AVOIRFC
--
--⇒ Colonne tierslib 
--
--apina concat : 
--
--client.codeclient
--
--fournisseur.code

CREATE OR REPLACE  VIEW FACTUREFOURNISSEURCPL (ID, IDFOURNISSEUR, IDFOURNISSEURLIB, IDMODEPAIEMENT, IDMODEPAIEMENTLIB, DATY, DESIGNATION, DATEECHEANCEPAIEMENT, ECHEANCEFACTURE, ETAT, ETATLIB, REFERENCE, IDBC, IDMAGASIN, DEVISE, TAUX, IDMAGASINLIB, IDDEVISE, MONTANTTVA, MONTANTHT, MONTANTTTC, MONTANTTTCAR, MONTANTPAYE, MONTANTPAYEAR, MONTANTRESTEAR, MONTANTRESTE, MONTANTAVOIR, TAUXDECHANGE, IDPREVISION, ESTPREVULIB, IDOBJET, IDREF, IDTYPEFACTURE, TYPEFACTURE, NUMERO, TYPEACHAT, IDFACTUREPRINCIPALE, IDSERVICELIB, SERVICE, TYPEFACTUREFOURNISSEUR, TYPEFACTUREFOURNISSEURLIB, IDECRITURE, TYPEACHATLIB, REMISE,CODE) AS 
  SELECT
    f.ID,
    f.IDFOURNISSEUR,
    f2.NOM  AS IDFOURNISSEURLIB,
    f.IDMODEPAIEMENT,
    m.VAL   AS IDMODEPAIEMENTLIB,
    f.DATY,
    f.DESIGNATION,
    f.DATEECHEANCEPAIEMENT,
    nvl(f.echeancefacture,0) AS echeancefacture,
    f.ETAT,
    CASE
        WHEN f.ETAT = 1
            THEN 'CR&Eacute;&Eacute;E'
        WHEN f.ETAT = 0
            THEN 'ANNUL&Eacute;E'
        WHEN f.ETAT = 11
            THEN 'VIS&Eacute;E'
        WHEN f.ETAT = 15
        	THEN 'CL&Ocirc;TUR&Eacute;E'
        END AS ETATLIB,
    nvl(f.REFERENCE, reff.reference) as reference,
    f.IDBC,
    f.IDMAGASIN,
    f.DEVISE,
    case
        when f.TAUX=0 then 1
        else f.TAUX
        end as taux,
    p.VAL   AS idMagasinLib,
    f.IDDEVISE,
    cast(f.MONTANTTVA as number(30,5)) as MONTANTTVA,
    CAST(f.MONTANTHT as number(30,5)) AS MONTANTHT,
    cast(f.MONTANTTTC as number(30,5)) as montantttc,
    cast(f.MONTANTTTCAR as number(30,5)) as MONTANTTTCAR,
    cast(nvl(mv.MONTANT,0) AS number(30,5)) AS montantpaye,
    cast(nvl(mv.MONTANTAR,0) AS number(30,5)) AS montantpayeAr,
    cast(f.MONTANTTTCAR-((nvl(mv.MONTANTAR,0)-nvl(av.montantTTC,0))) AS number(30,5)) AS montantresteAr,
    cast(f.MONTANTTTC-nvl(mv.MONTANT,0)-nvl(av.montantTTC,0) AS number(30,5)) AS montantreste,
    cast(av.montantTTC as number(30,2)) as montantAvoir,
    cast(f.TAUX AS  number(30,2)) AS tauxdechange,
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
    f.idfactureprincipale,
    s.libelle AS idServiceLib,
    f.SERVICE,
    f.TYPEFACTUREFOURNISSEUR,
    tff.DESCE AS TYPEFACTUREFOURNISSEURLIB,
    ce.id AS idecriture,
    ta.VAL AS typeachatlib,
    f.remise,
    f2.CODE 
FROM FactFournisseurCalc f
    LEFT JOIN TYPEACHAT ta ON ta.DESCE = f.TYPEACHAT
    LEFT JOIN FOURNISSEUR f2 ON f2.ID = f.IDFOURNISSEUR
    LEFT JOIN MODEPAIEMENT m ON m.ID = f.IDMODEPAIEMENT
    LEFT JOIN MAGASIN p ON p.ID = f.IDMAGASIN
    LEFT JOIN LIAISONPAIEMENTTOTAL mv ON f.id=mv.ID2
    left join AvoirAChatCalcGroupeOrigine av on av.IDFACTURE=f.ID
    LEFT JOIN prevision prev ON prev.idfacture=f.id
    left join type_facture tf on tf.id = f.IDTYPEFACTURE
    LEFT JOIN SERVICE s ON f.SERVICE = s.COMPTE
    LEFT JOIN referencefacture reff ON f.id=reff.idfacture
    LEFT JOIN typefacturefournisseur tff ON tff.id = f.TYPEFACTUREFOURNISSEUR
    LEFT JOIN COMPTA_ECRITURE ce ON ce.idobjet=f.id
 
 ;

CREATE OR REPLACE  VIEW COMPTA_ECRITURE_LIB (ID, DATY, DATECOMPTABLE, EXERCICE, DESIGNATION, REMARQUE, ETAT, HORSEXERCICE, JOURNAL, OD, ORIGINE, CREDIT, DEBIT, IDUSER, PERIODE, TRIMESTRE, ANNEE, IDOBJET, MONTANT, JOURNALLIB, JOURNALCODE, ETATLIB, TIERSLIB, PIECE, REFERENCE) AS 
  SELECT ce.ID,
       ce.DATY,
       ce.DATECOMPTABLE,
       ce.EXERCICE,
       ce.DESIGNATION,
       ce.REMARQUE,
       ce.ETAT,
       ce.HORSEXERCICE,
       ce.JOURNAL,
       ce.OD,
       ce.ORIGINE,
       ce.CREDIT,
       ce.DEBIT,
       ce.IDUSER,
       ce.PERIODE,
       ce.TRIMESTRE,
       ce.ANNEE,
       COALESCE(ce.IDOBJET, '-')                                     AS IDOBJET,
       CAST(cm.montant AS NUMBER (38, 2))                            AS montant,
       cj.desce                                                      AS JOURNALLIB,
       cj.val                                                        AS JOURNALCODE,
       CASE
           WHEN ce.ETAT = 1 THEN 'Cree'
           WHEN ce.ETAT = 11 THEN 'Valide'
           ELSE 'Autre'
           END                                                       AS etatlib,
       COALESCE(fc.IDFOURNISSEURLIB, vc.idClientlib, mvc.tiers, '-')||' - '||vc.codeclient||' - '||fc.CODE AS tierslib,
       CASE
           WHEN ce.ORIGINE = 'AVR' THEN '-'
           WHEN ce.ORIGINE = 'MTC' THEN COALESCE(vc_mtc.NUMEROFACTURE, fc_mtc.NUMERO, '-')
           WHEN ce.ORIGINE = 'MVT' THEN '-'
           WHEN ce.ORIGINE = 'VNT' THEN vc.NUMEROFACTURE
           WHEN ce.ORIGINE = 'FCF' THEN fc.NUMERO
           ELSE '-'
           END                                                       AS piece,
           CASE
           WHEN ce.ORIGINE = 'AVR' THEN COALESCE(avo.NUMFACT, '-')
           WHEN ce.ORIGINE = 'MTC' THEN COALESCE( mvc.REFERENCE, '-')
           WHEN ce.ORIGINE = 'MVT' THEN '-'
           WHEN ce.ORIGINE = 'VNT' THEN COALESCE(vc.REFERENCEFACT , '-')
           WHEN ce.ORIGINE = 'FCF' THEN COALESCE(fc.REFERENCE , '-')
           ELSE '-'
           END                                                       AS reference
FROM COMPTA_ECRITURE ce
         JOIN COMPTA_MONTANT cm ON ce.id = cm.IDMERE
         LEFT JOIN COMPTA_JOURNAL cj ON cj.id = ce.JOURNAL
         LEFT JOIN FACTUREFOURNISSEURCPL fc ON fc.id = ce.idobjet
         LEFT JOIN (SELECT v.id, v.NUMEROFACTURE, c.NOM AS idClientlib,v.REFERENCEFACT,c.codeclient FROM VENTE v LEFT JOIN CLIENT c ON c.ID = v.IDCLIENT) vc ON vc.id = ce.idobjet
         LEFT JOIN MOUVEMENTCAISSECPL mvc ON mvc.id = ce.idobjet
         LEFT JOIN (SELECT v.id, v.NUMEROFACTURE, c.NOM AS idClientlib FROM VENTE v LEFT JOIN CLIENT c ON c.ID = v.IDCLIENT) vc_mtc ON vc_mtc.ID = mvc.IDORIGINE
         LEFT JOIN FACTUREFOURNISSEURCPL fc_mtc ON fc_mtc.ID = mvc.IDORIGINE
         LEFT JOIN AVOIRFCLIB_CPL avo ON avo.id = ce.idobjet
ORDER BY ce.DATY DESC
 


 ;
 
 
 CREATE OR REPLACE  VIEW COMPTA_ECRITURE_LIB_VENTE (ID, DATY, DATECOMPTABLE, EXERCICE, DESIGNATION, REMARQUE, ETAT, HORSEXERCICE, JOURNAL, OD, ORIGINE, CREDIT, DEBIT, IDUSER, PERIODE, TRIMESTRE, ANNEE, IDOBJET, MONTANT, JOURNALLIB, JOURNALCODE, ETATLIB, TIERSLIB, PIECE, REFERENCE) AS 
  SELECT ce.ID,
       ce.DATY,
       ce.DATECOMPTABLE,
       ce.EXERCICE,
       ce.DESIGNATION,
       ce.REMARQUE,
       ce.ETAT,
       ce.HORSEXERCICE,
       ce.JOURNAL,
       ce.OD,
       ce.ORIGINE,
       ce.CREDIT,
       ce.DEBIT,
       ce.IDUSER,
       ce.PERIODE,
       ce.TRIMESTRE,
       ce.ANNEE,
       COALESCE(ce.IDOBJET, '-')                                     AS IDOBJET,
       CAST(cm.montant AS NUMBER (38, 2))                            AS montant,
       cj.desce                                                      AS JOURNALLIB,
       cj.val                                                        AS JOURNALCODE,
       CASE
           WHEN ce.ETAT = 1 THEN 'Cree'
           WHEN ce.ETAT = 11 THEN 'Valide'
           ELSE 'Autre'
           END                                                       AS etatlib,
       COALESCE(fc.IDFOURNISSEURLIB, vc.idClientlib, mvc.tiers, '-')||' - '||vc.codeclient||' - '||fc.CODE AS tierslib,
       CASE
           WHEN ce.ORIGINE = 'AVR' THEN '-'
           WHEN ce.ORIGINE = 'MTC' THEN COALESCE(vc_mtc.NUMEROFACTURE, fc_mtc.NUMERO, '')
           WHEN ce.ORIGINE = 'MVT' THEN '-'
           WHEN ce.ORIGINE = 'VNT' THEN vc.NUMEROFACTURE
           WHEN ce.ORIGINE = 'FCF' THEN fc.NUMERO
           ELSE '-'
           END                                                       AS piece,
           CASE
           WHEN ce.ORIGINE = 'AVR' THEN COALESCE(avo.NUMFACT, '-')
           WHEN ce.ORIGINE = 'MTC' THEN COALESCE( mvc.REFERENCE, '-')
           WHEN ce.ORIGINE = 'MVT' THEN '-'
           WHEN ce.ORIGINE = 'VNT' THEN COALESCE(vc.REFERENCEFACT , '-')
           WHEN ce.ORIGINE = 'FCF' THEN COALESCE(fc.REFERENCE , '-')
           ELSE '-'
           END                                                       AS reference
FROM COMPTA_ECRITURE ce
         JOIN COMPTA_MONTANT cm ON ce.id = cm.IDMERE
         LEFT JOIN COMPTA_JOURNAL cj ON cj.id = ce.JOURNAL
         LEFT JOIN FACTUREFOURNISSEURCPL fc ON fc.id = ce.idobjet
         LEFT JOIN (SELECT v.id, v.NUMEROFACTURE, c.NOM AS idClientlib,v.REFERENCEFACT,c.codeclient FROM VENTE v LEFT JOIN CLIENT c ON c.ID = v.IDCLIENT) vc ON vc.id = ce.idobjet
         LEFT JOIN MOUVEMENTCAISSECPL mvc ON mvc.id = ce.idobjet
         LEFT JOIN (SELECT v.id, v.NUMEROFACTURE, c.NOM AS idClientlib FROM VENTE v LEFT JOIN CLIENT c ON c.ID = v.IDCLIENT) vc_mtc ON vc_mtc.ID = mvc.IDORIGINE
         LEFT JOIN FACTUREFOURNISSEURCPL fc_mtc ON fc_mtc.ID = mvc.IDORIGINE
         LEFT JOIN AVOIRFCLIB_CPL avo ON avo.id = ce.idobjet
WHERE ce.IDOBJET LIKE '%VNT%'
ORDER BY ce.DATY DESC
 

 ;
 
 
 CREATE OR REPLACE  VIEW COMPTA_ECRITURE_LIB_ACHAT (ID, DATY, DATECOMPTABLE, EXERCICE, DESIGNATION, REMARQUE, ETAT, HORSEXERCICE, JOURNAL, OD, ORIGINE, CREDIT, DEBIT, IDUSER, PERIODE, TRIMESTRE, ANNEE, IDOBJET, MONTANT, JOURNALLIB, JOURNALCODE, ETATLIB, TIERSLIB, PIECE, REFERENCE) AS 
  SELECT ce.ID,
       ce.DATY,
       ce.DATECOMPTABLE,
       ce.EXERCICE,
       ce.DESIGNATION,
       ce.REMARQUE,
       ce.ETAT,
       ce.HORSEXERCICE,
       ce.JOURNAL,
       ce.OD,
       ce.ORIGINE,
       ce.CREDIT,
       ce.DEBIT,
       ce.IDUSER,
       ce.PERIODE,
       ce.TRIMESTRE,
       ce.ANNEE,
       COALESCE(ce.IDOBJET, '-')                                     AS IDOBJET,
       CAST(cm.montant AS NUMBER (38, 2))                            AS montant,
       cj.desce                                                      AS JOURNALLIB,
       cj.val                                                        AS JOURNALCODE,
       CASE
           WHEN ce.ETAT = 1 THEN 'Cree'
           WHEN ce.ETAT = 11 THEN 'Valide'
           ELSE 'Autre'
           END                                                       AS etatlib,
       COALESCE(fc.IDFOURNISSEURLIB, vc.idClientlib, mvc.tiers, '-')||' - '||vc.codeclient||' - '||fc.CODE AS tierslib,
       CASE
           WHEN ce.ORIGINE = 'AVR' THEN '-'
           WHEN ce.ORIGINE = 'MTC' THEN COALESCE(vc_mtc.NUMEROFACTURE, fc_mtc.NUMERO)
           WHEN ce.ORIGINE = 'MVT' THEN '-'
           WHEN ce.ORIGINE = 'VNT' THEN vc.NUMEROFACTURE
           WHEN ce.ORIGINE = 'FCF' THEN fc.NUMERO
           ELSE '-'
           END                                                       AS piece,
           CASE
           WHEN ce.ORIGINE = 'AVR' THEN COALESCE(avo.NUMFACT, '-')
           WHEN ce.ORIGINE = 'MTC' THEN COALESCE( mvc.REFERENCE, '-')
           WHEN ce.ORIGINE = 'MVT' THEN '-'
           WHEN ce.ORIGINE = 'VNT' THEN COALESCE(vc.REFERENCEFACT , '-')
           WHEN ce.ORIGINE = 'FCF' THEN COALESCE(fc.REFERENCE , '-')
           ELSE '-'
           END                                                       AS reference
FROM COMPTA_ECRITURE ce
         JOIN COMPTA_MONTANT cm ON ce.id = cm.IDMERE
         LEFT JOIN COMPTA_JOURNAL cj ON cj.id = ce.JOURNAL
         LEFT JOIN FACTUREFOURNISSEURCPL fc ON fc.id = ce.idobjet
         LEFT JOIN (SELECT v.id, v.NUMEROFACTURE, c.NOM AS idClientlib,v.REFERENCEFACT,c.codeclient FROM VENTE v LEFT JOIN CLIENT c ON c.ID = v.IDCLIENT) vc ON vc.id = ce.idobjet
         LEFT JOIN MOUVEMENTCAISSECPL mvc ON mvc.id = ce.idobjet
         LEFT JOIN (SELECT v.id, v.NUMEROFACTURE, c.NOM AS idClientlib FROM VENTE v LEFT JOIN CLIENT c ON c.ID = v.IDCLIENT) vc_mtc ON vc_mtc.ID = mvc.IDORIGINE
         LEFT JOIN FACTUREFOURNISSEURCPL fc_mtc ON fc_mtc.ID = mvc.IDORIGINE
         LEFT JOIN AVOIRFCLIB_CPL avo ON avo.id = ce.idobjet
WHERE ce.IDOBJET LIKE '%FCF%'
ORDER BY ce.DATY DESC
 

 ;
 
 
 CREATE OR REPLACE  VIEW COMPTA_ECRITURE_LIB_AVOIRFC (ID, DATY, DATECOMPTABLE, EXERCICE, DESIGNATION, REMARQUE, ETAT, HORSEXERCICE, JOURNAL, OD, ORIGINE, CREDIT, DEBIT, IDUSER, PERIODE, TRIMESTRE, ANNEE, IDOBJET, MONTANT, JOURNALLIB, JOURNALCODE, ETATLIB, TIERSLIB, PIECE, REFERENCE) AS 
  SELECT ce.ID,
       ce.DATY,
       ce.DATECOMPTABLE,
       ce.EXERCICE,
       ce.DESIGNATION,
       ce.REMARQUE,
       ce.ETAT,
       ce.HORSEXERCICE,
       ce.JOURNAL,
       ce.OD,
       ce.ORIGINE,
       ce.CREDIT,
       ce.DEBIT,
       ce.IDUSER,
       ce.PERIODE,
       ce.TRIMESTRE,
       ce.ANNEE,
       COALESCE(ce.IDOBJET, '-')                                     AS IDOBJET,
       CAST(cm.montant AS NUMBER (38, 2))                            AS montant,
       cj.desce                                                      AS JOURNALLIB,
       cj.val                                                        AS JOURNALCODE,
       CASE
           WHEN ce.ETAT = 1 THEN 'Cree'
           WHEN ce.ETAT = 11 THEN 'Valide'
           ELSE 'Autre'
           END                                                       AS etatlib,
       COALESCE(fc.IDFOURNISSEURLIB, vc.idClientlib, mvc.tiers, '-')||' - '||vc.codeclient||' - '||fc.CODE  AS tierslib,
       CASE
           WHEN ce.ORIGINE = 'AVR' THEN '-'
           WHEN ce.ORIGINE = 'MTC' THEN COALESCE(vc_mtc.NUMEROFACTURE, fc_mtc.NUMERO, '-')
           WHEN ce.ORIGINE = 'MVT' THEN '-'
           WHEN ce.ORIGINE = 'VNT' THEN vc.NUMEROFACTURE
           WHEN ce.ORIGINE = 'FCF' THEN fc.NUMERO
           ELSE '-'
           END                                                       AS piece,
           CASE
           WHEN ce.ORIGINE = 'AVR' THEN COALESCE(avo.NUMFACT, '-')
           WHEN ce.ORIGINE = 'MTC' THEN COALESCE( mvc.REFERENCE, '-')
           WHEN ce.ORIGINE = 'MVT' THEN '-'
           WHEN ce.ORIGINE = 'VNT' THEN COALESCE(vc.REFERENCEFACT , '-')
           WHEN ce.ORIGINE = 'FCF' THEN COALESCE(fc.REFERENCE , '-')
           ELSE '-'
           END                                                       AS reference
FROM COMPTA_ECRITURE ce
         JOIN COMPTA_MONTANT cm ON ce.id = cm.IDMERE
         LEFT JOIN COMPTA_JOURNAL cj ON cj.id = ce.JOURNAL
         LEFT JOIN FACTUREFOURNISSEURCPL fc ON fc.id = ce.idobjet
         LEFT JOIN (SELECT v.id, v.NUMEROFACTURE, c.NOM AS idClientlib,v.REFERENCEFACT,c.codeclient FROM VENTE v LEFT JOIN CLIENT c ON c.ID = v.IDCLIENT) vc ON vc.id = ce.idobjet
         LEFT JOIN MOUVEMENTCAISSECPL mvc ON mvc.id = ce.idobjet
         LEFT JOIN (SELECT v.id, v.NUMEROFACTURE, c.NOM AS idClientlib FROM VENTE v LEFT JOIN CLIENT c ON c.ID = v.IDCLIENT) vc_mtc ON vc_mtc.ID = mvc.IDORIGINE
         LEFT JOIN FACTUREFOURNISSEURCPL fc_mtc ON fc_mtc.ID = mvc.IDORIGINE
         LEFT JOIN AVOIRFCLIB_CPL avo ON avo.id = ce.idobjet
WHERE ce.IDOBJET LIKE '%AVRFC%'
ORDER BY ce.DATY DESC
 

 ;
 
 
 
 
 
 