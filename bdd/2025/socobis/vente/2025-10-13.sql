CREATE OR REPLACE VIEW AS_BONDELIVRAISON_LIB AS
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
           f.nom AS idfournisseurlib
from AS_BONDELIVRAISON bl
    left join MAGASIN m on bl.MAGASIN = m.ID
    LEFT JOIN fournisseur f ON f.id=bl.idfournisseur
    
         ;


CREATE OR REPLACE VIEW VENTE_CPL ("ID", "DESIGNATION", "IDMAGASIN", "IDMAGASINLIB", "DATY", "REMARQUE", "ETAT", "ETATLIB", "MONTANTTOTAL", "IDDEVISE", "IDCLIENT", "IDCLIENTLIB", "MONTANTTVA", "MONTANTTTC", "MONTANTTTCAR", "MONTANTPAYE", "MONTANTRESTE", "AVOIR", "TAUXDECHANGE", "MONTANTREVIENT", "MARGEBRUTE", "IDRESERVATION", "DATYPREVU", "REFERENCEFACTURE", "MONTANTREMISE", "MONTANT", "MOIS", "ANNEE", "POIDS", "COLIS", "MODEPAIEMENT", "MODEPAIEMENTLIB", "FRAISLIVRAISON", "MODELIVRAISON", "MODELIVRAISONLIB", "RESTE", "IDPROVINCE", "PROVINCELIB", "IDBL", "IDORIGINE", "FRAIS", "REFERENCEFACT", "NUMEROFACTURE") AS 
  SELECT v.ID,
       v.DESIGNATION,
       v.IDMAGASIN,
       m.VAL AS IDMAGASINLIB,
       v.DATY,
       v.REMARQUE,
       v.ETAT,
       CASE
           WHEN v.ETAT = 1 THEN 'CR&Eacute;E'
           WHEN v.ETAT = 11 THEN 'VIS&Eacute;'
           WHEN v.ETAT = 0 THEN 'ANNUL&Eacute;'
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
       CAST(vp.poids as number(30,2)),
       CAST(vp.colis as number(30,2)),
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
       v.NUMEROFACTURE
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