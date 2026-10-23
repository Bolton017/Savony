alter table RISTOURNE add taux number(30, 2);
create or replace view AVOIRFCLIB as
SELECT a.ID,
       a.DESIGNATION,
       a.IDMAGASIN,
       m.VAL         AS IDMAGASINLIB,
       a.DATY,
       a.REMARQUE,
       a.ETAT,
       a.IDORIGINE,
       a.IDCLIENT,
       t.COMPTE,
       t.compteauxiliaire,
       a.IDVENTE,
       v.DESIGNATION AS IDVENTELIB,
       a.IDMOTIF,
       ma.VAL        AS IDMOTIFLIB,
       a.IDCATEGORIE,
       c.VAL         AS IDCATEGORIELIB,
       ag.IDDEVISE,
       ag.TAUXDECHANGE,
       ag.MONTANTHT,
       ag.MONTANTTVA,
       ag.MONTANTTTC,
       ag.MONTANTHTAR,
       ag.MONTANTTVAAR,
       ag.MONTANTTTCAR,
       v.IDRESERVATION,
       ta.val as Typeavoir,
       t.NOM as clientlib
FROM AVOIRFC a
         LEFT JOIN MAGASIN m ON m.id = a.IDMAGASIN
         LEFT JOIN VENTE v ON v.id = a.IDVENTE
         LEFT JOIN MOTIFAVOIRFC ma ON ma.id = a.IDMOTIF
         LEFT JOIN CATEGORIEAVOIRFC c ON c.id = a.IDCATEGORIE
         JOIN AVOIRFCFILLE_GRP ag ON ag.idavoirfc = a.id
         LEFT JOIN TIERS T ON T.ID = A.IDCLIENT
        left join TYPEAVOIR ta on ta.id = a.IDTYPEAVOIR
;
create or replace view AVOIRFCLIB_CPL as
SELECT AL.ID,
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
       M.DEBIT as MONTANTPAYE,
       nvl(M.DEBIT, 0)*nvl(AL.TAUXDECHANGE, 0) as MONTANTPAYEAR,
       AL.MONTANTTTC - nvl(M.DEBIT, 0) as RESTEAPAYER,
       AL.MONTANTTTCAR - (nvl(M.DEBIT,0)*nvl(AL.TAUXDECHANGE, 0)) as RESTEAPAYERAR,
       clientlib,
       Typeavoir
from AVOIRFCLIB AL
LEFT JOIN MOUVEMENTCAISSEGROUPEFACTURE M on AL.ID = M.IDORIGINE
;

select * from MOUVEMENTCAISSE;

create view CAISSETRAITE as
select ID,VAL,DESCE from caisse where id = 'CAIS00000T00016'
;

INSERT INTO MODEPAIEMENT (ID, VAL, DESCE) VALUES ('0003', 'virement', 'virement');

create or replace view TRAITE_LIB as
select
    tr.id,
    tr.daty,
    ti.nom as tiers,
    ba.val as banque,
    tr.dateEcheance,
    tr.etat,
    tr.montant,
    tr.REFERENCE,
    '' as CDCLT,
    ba.ID AS idbanque,
    IDTYPEPIECE ,
    tp.val AS typepiece,
    ti.id as idtiers
from traite tr
         left join client ti on tr.tiers = ti.id
         left join banque ba on tr.banque = ba.id
         LEFT JOIN type_piece tp ON tp.id=tr.IDTYPEPIECE
/


create or replace view TRAITE_LIBMTT as
select t.ID,t.DATY,t.TIERS,t.BANQUE,t.DATEECHEANCE,t.ETAT,t.MONTANT,
       sum(nvl(e.FRAIS,0)) AS escompte,
       montant - sum(nvl(e.FRAIS, 0)) AS total, t.reference,
       t.CDCLT,
       t.idbanque,
       t.idtypepiece,
       t.typepiece,
       t.idtiers
from traite_lib t
         LEFT JOIN ESCOMPTE_LIBV e ON e.IDTRAITE = t.id
GROUP BY t.id, t.DATY ,t.TIERS ,t.BANQUE ,t.DATEECHEANCE ,t.ETAT ,t.MONTANT,t.REFERENCE, t.CDCLT, t.idbanque,t.idtypepiece,
         t.typepiece, t.idtiers
/

create or replace view TRAITEMTTFC as
SELECT
    t.ID,
    cast(nvl(sum(f.montant),0) as number(30,2)) AS montantenlevetraite
FROM traite t
         LEFT JOIN LIAISONPAIEMENT f ON t.ID = f.ID1
GROUP BY t.ID;

create or replace  view TRAITEMTTRESTE as
SELECT t.ID,
       t.DATY,
       t.TIERS,
       t.BANQUE,
       t.DATEECHEANCE,
       t.ETAT,
       CAST(nvl(t.MONTANT,0) AS NUMBER(30, 2))                          AS montant,
       t.ESCOMPTE,
       CAST(nvl(t.TOTAL,0) AS NUMBER(30, 2))                            AS total,
       t.REFERENCE,
       CAST((nvl(t.total,0) - nvl(tf.montantenlevetraite, 0)) AS NUMBER(30, 2)) AS montantreste,
       t.cdclt,
       t.idbanque,
       t.idtypepiece,
       t.typepiece,
       nvl(te.etatversement, 1)                                  as etatversement,
       case
           when te.etatversement = -2 then 'Encaissee'
           when te.etatversement = 11 then 'Versee'
           else
               'Non Versee' end                                  as etatversementlib,
    t.idtiers
FROM TRAITE_LIBMTT t
         LEFT JOIN traitemttfc tf ON tf.id = t.id
         LEFT JOIN traiteetatversement te on te.IDTRAITE = t.ID
/


create or replace view TRAITE_FC as
select
    fc.ID,tl.id AS IDTRAITE,fc.id AS IDFC, FC.MONTANTTTC as MONTANTFACTURE, 0 as MONTANTJC, pf.MONTANT,fc.DATY,fc.ETAT,'' as CODE,
    tl.tiers,
    tl.banque,
    fc.designation as factureclientlib,
    fc.IDCLIENTLIB as TIERSLIB,
    CASE
        WHEN tl.etat = 1
            THEN 'Créé'
        WHEN tl.ETAT >= 11
            THEN 'visée'
        WHEN tl.ETAT =0
            THEN 'Annulée'
        END AS etatlib
from LIAISONPAIEMENT pf
         JOIN traite tl on tl.id = pf.id1
         left join VENTE_CPL fc on pf.id2  = fc.id;

create or replace view VENTE_CPL as
SELECT v.ID,
       v.DESIGNATION,
       v.IDMAGASIN,
       m.VAL AS IDMAGASINLIB,
       v.DATY,
       v.REMARQUE,
       v.ETAT,
       CASE
           WHEN v.ETAT = 1 THEN 'CREE'
           WHEN v.ETAT = 11 THEN 'VISE'
           WHEN v.ETAT = 0 THEN 'ANNULE'
           END
             AS ETATLIB,
       v2.MONTANTTOTAL,
       v2.IDDEVISE,
       v.IDCLIENT,
       c.NOM AS IDCLIENTLIB,
       cast(V2.MONTANTTVA as number(30,2)) as MONTANTTVA,
       cast(V2.MONTANTTTC as number(30,2)) as montantttc,
       cast(V2.MONTANTTTCAR as number(30,2)) as MONTANTTTCAR,
       cast(nvl(mv.montant,0)-nvl(ACG.MONTANTPAYE, 0) AS NUMBER(30,2)) AS montantpaye,
       cast(V2.MONTANTTTC-nvl(mv.montant,0)-nvl(ACG.resteapayer_avr, 0) AS NUMBER(30,2)) AS montantreste,
       cast(nvl(ACG.MONTANTTTC_avr, 0) as number(30,2))  as avoir,
       v2.tauxDeChange AS tauxDeChange,v2.MONTANTREVIENT,cast((V2.MONTANTTTCAR-v2.MONTANTREVIENT) as number(20,2))  as margeBrute,
       v.IDRESERVATION,
       case when v.DATYPREVU is null then daty else V.DATYPREVU end as datyprevu,
       rf.REFERENCE as referencefacture,
       v2.MONTANTREMISE,
       nvl(v2.MONTANTTOTAL,0)+nvl(v2.MONTANTREMISE,0) as montant,
       extract(month from DATY) as mois,
       extract(year from DATY) as annee
FROM VENTE v
         LEFT JOIN CLIENT c ON c.ID = v.IDCLIENT
         LEFT JOIN MAGASINPOINT m ON m.ID = v.IDMAGASIN
         JOIN VENTEMONTANT v2 ON v2.ID = v.ID
         LEFT JOIN LIAISONPAIEMENTTOTAL mv ON v.id=mv.id2
         LEFT JOIN AVOIRFCLIB_CPL_GRP ACG on ACG.IDVENTE = v.ID
         LEFT JOIN REFERENCEFACTURE rf ON rf.idfacture=v.Id;