create or replace view AVOIRFCLIB_CPL as
SELECT
    AL.ID,
    AL.DESIGNATION,
    AL.IDMAGASIN,
    AL.IDMAGASINLIB,
    AL.DATY,
    AL.REMARQUE,
    AL.ETAT,
    AL.IDORIGINE,
    AL.IDCLIENT,
    AL.COMPTE,
    AL.IDVENTE,
    AL.IDVENTELIB,
    AL.IDMOTIF,
    AL.IDMOTIFLIB,
    AL.IDCATEGORIE,
    AL.IDCATEGORIELIB,
    AL.IDDEVISE,
    AL.TAUXDECHANGE,
    AL.MONTANTHT,
    AL.MONTANTTVA,
    AL.MONTANTTTC,
    AL.MONTANTHTAR,
    AL.MONTANTTVAAR,
    AL.MONTANTTTCAR,
    nvl(M.montant, 0) AS MONTANTPAYE,
    NVL(M.montant, 0) * NVL(AL.TAUXDECHANGE, 0) AS MONTANTPAYEAR,

    NVL(vc.MONTANTRESTE, 0) AS MONTANT_RESTE_FACTURE,

    NVL(SUM_PRECEDENTS.montant_avoirs_precedents, 0) AS MONTANT_AVOIRS_ANTERIEURS,
    -- Cas 1 : facture deja soldee -> chaque avoir = credit direct (exedent)
    CASE
        WHEN NVL(vc.MONTANTRESTE, 0) = 0 THEN 0
        ELSE NVL(vc.MONTANTRESTE, 0) - NVL(SUM_PRECEDENTS.montant_avoirs_precedents, 0) - NVL(AL.MONTANTTTCAR, 0)
    END AS RESTE_CALCULE,
    -- Excedent a rembourser ou a reporter
    CASE
        WHEN NVL(vc.MONTANTRESTE, 0) = 0 THEN NVL(AL.MONTANTTTCAR, 0)
        WHEN NVL(vc.MONTANTRESTE, 0) - NVL(SUM_PRECEDENTS.montant_avoirs_precedents, 0) - NVL(AL.MONTANTTTCAR, 0) < 0
        THEN ABS(NVL(vc.MONTANTRESTE, 0) - NVL(SUM_PRECEDENTS.montant_avoirs_precedents, 0) - NVL(AL.MONTANTTTCAR, 0))
        ELSE 0
    END AS EXCEDENT_AR,
    (CASE
        WHEN NVL(vc.MONTANTRESTE, 0) = 0 THEN NVL(AL.MONTANTTTCAR, 0)
        WHEN NVL(vc.MONTANTRESTE, 0) - NVL(SUM_PRECEDENTS.montant_avoirs_precedents, 0) - NVL(AL.MONTANTTTCAR, 0) < 0
        THEN ABS(NVL(vc.MONTANTRESTE, 0) - NVL(SUM_PRECEDENTS.montant_avoirs_precedents, 0) - NVL(AL.MONTANTTTCAR, 0))
        ELSE 0
    END) - NVL(M.montant, 0) AS resteapayer,
    (CASE
        WHEN NVL(vc.MONTANTRESTE, 0) = 0 THEN NVL(AL.MONTANTTTCAR, 0)
        WHEN NVL(vc.MONTANTRESTE, 0) - NVL(SUM_PRECEDENTS.montant_avoirs_precedents, 0) - NVL(AL.MONTANTTTCAR, 0) < 0
        THEN ABS(NVL(vc.MONTANTRESTE, 0) - NVL(SUM_PRECEDENTS.montant_avoirs_precedents, 0) - NVL(AL.MONTANTTTCAR, 0))
        ELSE 0
    END) - (NVL(M.montant, 0) * NVL(AL.TAUXDECHANGE, 0)) AS resteapayerar,
    AL.clientlib,
    AL.Typeavoir
FROM AVOIRFCLIB AL
LEFT JOIN MOUVEMENTCAISSEGRPAVOIR_LP M
       ON AL.ID = M.IDORIGINE
LEFT JOIN VENTE_CPL_SANSAVOIR vc
       ON vc.id = AL.idvente
-- Somme des avoirs precedents pour la meme facture
LEFT JOIN (
    SELECT
        a2.idvente,
        a2.id AS idcourant,
        SUM(a1.MONTANTTTCAR) AS montant_avoirs_precedents
    FROM AVOIRFCLIB a1
    JOIN AVOIRFCLIB a2 ON a1.idvente = a2.idvente
    WHERE a1.ETAT <> 0
      AND (a1.DATY < a2.DATY OR (a1.DATY = a2.DATY AND a1.ID < a2.ID))
    GROUP BY a2.idvente, a2.id
) SUM_PRECEDENTS
    ON SUM_PRECEDENTS.idvente = AL.idvente
   AND SUM_PRECEDENTS.idcourant = AL.id;

create or replace view MOUVEMENTCAISSECPL_V_Dispatch as
SELECT m.ID,
       DESIGNATION,
       IDCAISSE,
       IDCAISSELIB,
       IDVENTEDETAIL,
       IDVIREMENT,
       DEBIT,
       CREDIT,
       lp.MONTANT as montantimpute,
       DATY,
       m.ETAT,
       ETATLIB,
       IDVENTE,
       id2 as IDORIGINE,
       IDTIERS,
       TIERS,
       id1 as idpaiement,
       m.REFERENCE as referencepaiement,
       m.DESIGNATION as designationpaiement
FROM LIAISONPAIEMENT lp LEFT JOIN
    MOUVEMENTCAISSECPL m on m.id = lp.ID1
WHERE m.etat > 7;

create or replace view MOUVEMENTCAISSECPL_V_D_avoir as
SELECT m.ID,
       DESIGNATION,
       IDCAISSE,
       IDCAISSELIB,
       IDVENTEDETAIL,
       IDVIREMENT,
       DEBIT,
       CREDIT,
       lp.MONTANT as montantimpute,
       DATY,
       m.ETAT,
       ETATLIB,
       IDVENTE,
       id2 as IDORIGINE,
       IDTIERS,
       TIERS,
       id1 as idpaiement,
       m.REFERENCE as referencepaiement,
       m.DESIGNATION as designationpaiement
FROM LIAISONPAIEMENT lp LEFT JOIN
    MOUVEMENTCAISSECPL m on m.id = lp.ID1
WHERE m.etat > 7
UNION ALL
SELECT m.ID,
       m.DESIGNATION,
       '' as IDCAISSE,
       '' as IDCAISSELIB,
       '' as IDVENTEDETAIL,
       '' as IDVIREMENT,
       0 as DEBIT,
       m.MONTANTTTCAR as CREDIT,
       lp.MONTANT as montantimpute,
       DATY,
       m.ETAT,
       '' as ETATLIB,
       IDVENTE,
       id2 as IDORIGINE,
       m.IDCLIENT as IDTIERS,
       m.CLIENTLIB as TIERS,
       id1 as idpaiement,
       m.id as referencepaiement,
       'NOTE DE CREDIT'as designationpaiement
FROM LIAISONPAIEMENT lp LEFT JOIN
    AVOIRFCLIB_CPL m on m.id = lp.ID1
WHERE m.etat > 7;

create or replace view VENTE_CPL as
SELECT v.ID,
       v.DESIGNATION,
       v.IDMAGASIN,
       m.VAL AS IDMAGASINLIB,
       v.DATY,
       v.REMARQUE,
       v.ETAT,
       CASE
           WHEN v.ETAT = 1 THEN 'CR&Eacute;&Eacute;E'
           WHEN v.ETAT = 11 THEN 'VIS&Eacute;E'
           WHEN v.ETAT = 0 THEN 'ANNUL&Eacute;E'
           END
             AS ETATLIB,
       v2.MONTANTTOTAL,
       v2.IDDEVISE,
       v.IDCLIENT,
       c.NOM AS IDCLIENTLIB,
       cast(V2.MONTANTTVA as number(30,2)) as MONTANTTVA,
       cast(V2.MONTANTTTC as number(30,2)) as montantttc,
       cast(V2.MONTANTTTCAR as number(30,2)) as MONTANTTTCAR,
       cast(nvl(mv.montant,0) AS NUMBER(30,2)) AS montantpaye,
       cast(nvl(V2.MONTANTTTC, 0)-nvl(mv.montant,0)-nvl(ACG.imputeefactar, 0) AS NUMBER(30,2)) AS montantreste,
       cast(nvl(ACG.MONTANTTTC_avr, 0) as number(30,2)) as avoir,
       v2.tauxDeChange AS tauxDeChange,v2.MONTANTREVIENT,cast((V2.MONTANTTTCAR-v2.MONTANTREVIENT) as number(20,2))  as margeBrute,
       v.IDRESERVATION,
       case when v.DATYPREVU is null then v.daty else V.DATYPREVU end as datyprevu,
       rf.REFERENCE as referencefacture,
       v2.MONTANTREMISE,
       nvl(v2.MONTANTTOTAL,0)+nvl(v2.MONTANTREMISE,0) as montant,
       extract(month from v.DATY) as mois,
       extract(year from v.DATY) as annee,
       CAST(vp.poids as number(30,2)) as poids,
       CAST(vp.colis as number(30,2)) as colis,
       v.modepaiement,
       mp.VAL as modepaiementlib,
       nvl(v.fraislivraison,0)*nvl(vp.poids,0) as fraislivraison,
       v.modelivraison,
       CASE
            WHEN v.modelivraison = 1 THEN '<span style=color: green;>LIVRAISON</span>'
            WHEN v.modelivraison = 2 THEN '<span style=color: green;>RECUPERATION</span>'
        END AS modelivraisonlib,
       vr.reste,
       pv.id as idprovince,
       pv.val as provincelib,
       bl.id as idbl,
       v.IDORIGINE,
       v.FRAISLIVRAISON as frais,
       v.REFERENCEFACT,
       v.NUMEROFACTURE,
       v.LIEULIVRAISON,
       v.DATELIVRAISON,
       v.UPDATED_AT
FROM VENTE v
         LEFT JOIN CLIENT c ON c.ID = v.IDCLIENT
        left join PROVINCE pv on pv.id = c.IDPROVINCE
         LEFT JOIN MAGASINPOINT m ON m.ID = v.IDMAGASIN
         JOIN VENTEMONTANT v2 ON v2.ID = v.ID
         LEFT JOIN LIAISONPAIEMENTTOTAL mv ON v.id=mv.id2
         LEFT JOIN AVOIRFCLIB_CPL_GRP ACG on ACG.IDVENTE = v.ID
         LEFT JOIN REFERENCEFACTURE rf ON rf.idfacture=v.Id
         left join vente_poids vp on vp.idvente=v.id
         left join MODEPAIEMENT mp on mp.id=v.modepaiement
         left join vente_reste vr on vr.idvente=v.id
         left join AS_BONDELIVRAISON_CLIENT bl on bl.IDVENTE = v.id;

create or replace view MOUVEMENTCAISSE_DETAIL as
select v.ID,
       v.DESIGNATION,
       v.IDMAGASIN,
       v.IDMAGASINLIB,
       v.DATY,
       v.REMARQUE,
       v.ETAT,
       v.ETATLIB,
       v.MONTANTTOTAL,
       v.IDDEVISE,
       v.IDCLIENT,
       v.IDCLIENTLIB,
       v.MONTANTTVA,
       v.MONTANTTTC,
       v.MONTANTTTCAR,
       v.MONTANTPAYE,
       v.MONTANTRESTE,
       v.AVOIR,
       v.TAUXDECHANGE,
       v.MONTANTREVIENT,
       v.MARGEBRUTE,
       v.IDRESERVATION,
       mv.id as idobjet,
       mv.montantimpute,
       referencepaiement,
       idpaiement,
       designationpaiement,
       v.NUMEROFACTURE,
       v.UPDATED_AT
from VENTE_CPL v
         left join MOUVEMENTCAISSECPL_V_D_avoir mv on v.id = mv.idorigine;

CREATE OR REPLACE VIEW MOUVEMENTCAISSE_DETAIL_UNIQUE AS
SELECT
    v.ID,
    v.DESIGNATION,
    v.IDMAGASIN,
    v.IDMAGASINLIB,
    v.DATY,
    v.REMARQUE,
    v.ETAT,
    v.ETATLIB,
    v.MONTANTTOTAL,
    v.IDDEVISE,
    v.IDCLIENT,
    v.IDCLIENTLIB,
    v.MONTANTTVA,
    v.MONTANTTTC,
    v.MONTANTTTCAR,
    v.MONTANTPAYE,
    v.MONTANTRESTE,
    v.AVOIR,
    v.TAUXDECHANGE,
    v.MONTANTREVIENT,
    v.MARGEBRUTE,
    v.IDRESERVATION,
    v.NUMEROFACTURE,
    v.UPDATED_AT,
    -- 🔹 Somme des montants imputés
    SUM(v.montantimpute) AS TOTALIMPUTE,
    -- 🔹 Concaténation des références paiement (séparées par //)
    LISTAGG(v.designationpaiement ||' '|| v.referencepaiement, ' // ') WITHIN GROUP (ORDER BY v.designationpaiement || v.referencepaiement) AS REFERENCES_PAIEMENT
FROM MOUVEMENTCAISSE_DETAIL v
GROUP BY
    v.ID,
    v.DESIGNATION,
    v.IDMAGASIN,
    v.IDMAGASINLIB,
    v.DATY,
    v.REMARQUE,
    v.ETAT,
    v.ETATLIB,
    v.MONTANTTOTAL,
    v.IDDEVISE,
    v.IDCLIENT,
    v.IDCLIENTLIB,
    v.MONTANTTVA,
    v.MONTANTTTC,
    v.MONTANTTTCAR,
    v.MONTANTPAYE,
    v.MONTANTRESTE,
    v.AVOIR,
    v.TAUXDECHANGE,
    v.MONTANTREVIENT,
    v.MARGEBRUTE,
    v.IDRESERVATION, v.NUMEROFACTURE, v.UPDATED_AT;

create or replace view MOUVEMENTCAISSECPL as
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
               THEN 'ANNULEE'
           WHEN m.ETAT = 1
               THEN 'CREE'
           WHEN m.ETAT = 11
               THEN 'VALIDEE'
           WHEN m.ETAT = 8
               THEN 'A COMPTABILISER'
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
        left join modepaiement mp on m.idmodepaiement = mp.id;


create or replace view RELEVECLIENT as
select relever.ID,
       relever.JOURNAL,
       relever.REFERENCE,
       relever.DATY,
       relever.LIBELLE,
       relever.LETTRE,
       relever.DEBIT,
       relever.CREDIT,
       relever.IDCLIENT,
       t.NOM as clientlib,
       t.COMPTE,
       relever.updated_at,relever.solde
from (select id,
             ' '                      as journal,
             id                       as reference,
             daty,
             'NOTE DE CREDIT :' || id as libelle,
             ' '                      as lettre,
             0                        as debit,
             MONTANTTTCAR             as credit,
             IDCLIENT,
             DATY as updated_at,
             MONTANTTTCAR*-1 as solde
      from AVOIRFCLIB_CPL_VISEE
  UNION ALL
      select id,
             ' '           as journal,
             NUMEROFACTURE as reference,
             daty,
             case when REFERENCES_PAIEMENT is null then ' ' else REFERENCES_PAIEMENT end,
             ' '           as lettre,
             MONTANTTTCAR  as debit,
             0             as credit,
             IDCLIENT,
             UPDATED_AT as updated_at,
             MONTANTTTCAR as solde
      from MOUVEMENTCAISSE_DETAIL_UNIQUE
      where ETAT >= 7
  UNION ALL
      select mc.id,
             ' '        as journal,
             mc.id      as reference,
             mc.datycomptabilisation,
             mc.DESIGNATION,
             ' '        as lettre,
             0          as debit,
             mc.CREDIT,
             mc.IDTIERS as idclient,
             mc.UPDATED_AT,
             mc.CREDIT*-1 as solde
      from MOUVEMENTCAISSECPL mc where ETAT > 8 ) relever
         left join tiers t on t.id = relever.IDCLIENT
order by IDCLIENT, DATY, updated_at;

ALTER TABLE Vente
ADD UPDATED_AT TIMESTAMP;

CREATE OR REPLACE TRIGGER VENTE_UPD_TRG
BEFORE UPDATE ON vente
FOR EACH ROW
BEGIN
    :NEW.UPDATED_AT := SYSTIMESTAMP; -- ou SYSDATE selon ton besoin
END;
/

ALTER TABLE MOUVEMENTCAISSE
ADD UPDATED_AT TIMESTAMP;

CREATE OR REPLACE TRIGGER MOUVEMENTCAISSE_UPD_TRG
BEFORE UPDATE ON MOUVEMENTCAISSE
FOR EACH ROW
BEGIN
    :NEW.UPDATED_AT := SYSTIMESTAMP; -- ou SYSDATE selon ton besoin
END;
/

create view modepaiementmaj as
select id, upper(val) as val, upper(desce) as desce from MODEPAIEMENT;

alter table MOUVEMENTCAISSE add datycomptabilisation Date;

UPDATE CAISSE SET VAL = 'caisse BMOI MG', DESCE = 'BMOI', IDTYPECAISSE = 'TCA001', IDPOINT = 'PNT000084', IDPOMPISTE = null, ETAT = 11, IDCATEGORIECAISSE = 'CTC001', COMPTE = '5300000000000', IDMAGASIN = null, IDDEVISE = null WHERE ID = 'CAI000233';
UPDATE CAISSE SET VAL = 'Caisse  MCB MG', DESCE = 'MCB', IDTYPECAISSE = 'TCA001', IDPOINT = 'PNT000084', IDPOMPISTE = null, ETAT = 11, IDCATEGORIECAISSE = 'CTC001', COMPTE = '5300000000000', IDMAGASIN = null, IDDEVISE = null WHERE ID = 'CAI000234';
UPDATE CAISSE SET VAL = 'Caisse BRED MG', DESCE = 'BRED', IDTYPECAISSE = 'TCA001', IDPOINT = 'PNT000084', IDPOMPISTE = null, ETAT = 11, IDCATEGORIECAISSE = 'CTC001', COMPTE = '5300000000000', IDMAGASIN = null, IDDEVISE = null WHERE ID = 'CAI000229';
UPDATE CAISSE SET VAL = 'Caisse SBM MG', DESCE = 'SBM', IDTYPECAISSE = 'TCA001', IDPOINT = 'PNT000084', IDPOMPISTE = null, ETAT = 11, IDCATEGORIECAISSE = 'CTC001', COMPTE = '530003', IDMAGASIN = null, IDDEVISE = null WHERE ID = 'CAI000236';
UPDATE CAISSE SET VAL = 'Caisse Analakely', DESCE = 'Analakely', IDTYPECAISSE = 'TCA003', IDPOINT = 'PNT000084', IDPOMPISTE = null, ETAT = 1, IDCATEGORIECAISSE = 'CTC003', COMPTE = null, IDMAGASIN = null, IDDEVISE = null WHERE ID = 'CAI000230';
UPDATE CAISSE SET VAL = 'Banque BAOBAB MGA', DESCE = 'BAOBAB', IDTYPECAISSE = 'TCA003', IDPOINT = 'PNT000084', IDPOMPISTE = null, ETAT = 1, IDCATEGORIECAISSE = 'CTC002', COMPTE = null, IDMAGASIN = null, IDDEVISE = null WHERE ID = 'CAI000231';
UPDATE CAISSE SET VAL = 'Mvola 034 05 678 45', DESCE = 'MVOLA', IDTYPECAISSE = 'TCA002', IDPOINT = 'PNT000084', IDPOMPISTE = null, ETAT = 11, IDCATEGORIECAISSE = 'CTC004', COMPTE = null, IDMAGASIN = null, IDDEVISE = null WHERE ID = 'CAI000232';
UPDATE CAISSE SET VAL = 'Banque BAOBAB MGA', DESCE = 'BAOBAB', IDTYPECAISSE = 'TCA001', IDPOINT = 'PNT000084', IDPOMPISTE = null, ETAT = 11, IDCATEGORIECAISSE = 'CTC001', COMPTE = '530002', IDMAGASIN = null, IDDEVISE = null WHERE ID = 'CAI000235';
UPDATE CAISSE SET VAL = 'Banque BNI MGA', DESCE = 'BNI', IDTYPECAISSE = 'TCA001', IDPOINT = 'PNT000084', IDPOMPISTE = null, ETAT = 11, IDCATEGORIECAISSE = 'CTC001', COMPTE = '530001', IDMAGASIN = null, IDDEVISE = null WHERE ID = 'CAI000237';
UPDATE CAISSE SET VAL = 'Caisse Ankorondrano', DESCE = 'ANKORONDRANO', IDTYPECAISSE = 'TCA003', IDPOINT = 'PNT000084', IDPOMPISTE = null, ETAT = 11, IDCATEGORIECAISSE = 'CTC003', COMPTE = '5300000000000', IDMAGASIN = null, IDDEVISE = 'AR' WHERE ID = 'CAI000238';
UPDATE CAISSE SET VAL = 'EFFETS A RECEVOIR REMIS A L ENCAISSEMENT', DESCE = 'EFFETS A RECEVOIR REMIS A L ENCAISSEMENT', IDTYPECAISSE = 'TCA004', IDPOINT = 'PNT000084', IDPOMPISTE = null, ETAT = 11, IDCATEGORIECAISSE = 'CTC009', COMPTE = '5300000000000', IDMAGASIN = null, IDDEVISE = 'AR' WHERE ID = 'CAIS000017';
UPDATE CAISSE SET VAL = 'TRAITE', DESCE = 'TRAITE', IDTYPECAISSE = 'TCA004', IDPOINT = 'PNT000084', IDPOMPISTE = null, ETAT = 11, IDCATEGORIECAISSE = 'CTC009', COMPTE = '5300000000000', IDMAGASIN = null, IDDEVISE = 'AR' WHERE ID = 'CAIS00000T00016';
UPDATE CAISSE SET VAL = '-', DESCE = '-', IDTYPECAISSE = 'TCA001', IDPOINT = 'PNT000084', IDPOMPISTE = null, ETAT = 11, IDCATEGORIECAISSE = 'CTC001', COMPTE = '5300000000000', IDMAGASIN = null, IDDEVISE = 'AR' WHERE ID = 'CAIS001';

create or replace view VENTENONPAYE as
select ID,
       DESIGNATION,
       IDMAGASIN,
       IDMAGASINLIB,
       DATY,
       REMARQUE,
       ETAT,
       ETATLIB,
       MONTANTTOTAL,
       IDDEVISE,
       IDCLIENT,
       IDCLIENTLIB,
       MONTANTTVA,
       MONTANTTTC,
       MONTANTTTCAR,
       MONTANTPAYE,
       MONTANTRESTE,
       AVOIR,
       TAUXDECHANGE,
       MONTANTREVIENT,
       MARGEBRUTE,
       IDRESERVATION,
       DATYPREVU,
       mois,
       annee
from VENTE_CPL
where  ETAT >= 11 and MONTANTREMISE = 0;

alter table RISTOURNE add taux number(5,2);
alter table RISTOURNE add mois number;
alter table RISTOURNE add annee number;
