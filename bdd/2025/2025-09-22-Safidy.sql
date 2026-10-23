-- orthographe etat lib
CREATE OR REPLACE FORCE VIEW "VENTE_CPL" ("ID", "DESIGNATION", "IDMAGASIN", "IDMAGASINLIB", "DATY", "REMARQUE", "ETAT", "ETATLIB", "MONTANTTOTAL", "IDDEVISE", "IDCLIENT", "IDCLIENTLIB", "MONTANTTVA", "MONTANTTTC", "MONTANTTTCAR", "MONTANTPAYE", "MONTANTRESTE", "AVOIR", "TAUXDECHANGE", "MONTANTREVIENT", "MARGEBRUTE", "IDRESERVATION", "DATYPREVU", "REFERENCEFACTURE", "MONTANTREMISE", "MONTANT") AS
SELECT v.ID,
       v.DESIGNATION,
       v.IDMAGASIN,
       m.VAL AS IDMAGASINLIB,
       v.DATY,
       v.REMARQUE,
       v.ETAT,
       CASE
           WHEN v.ETAT = 1 THEN 'CRÉÉ'
           WHEN v.ETAT = 11 THEN 'VISÉ'
           WHEN v.ETAT = 0 THEN 'ANNULÉ'
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
       nvl(v2.MONTANTTOTAL,0)+nvl(v2.MONTANTREMISE,0) as montant
FROM VENTE v
         LEFT JOIN CLIENT c ON c.ID = v.IDCLIENT
         LEFT JOIN MAGASINPOINT m ON m.ID = v.IDMAGASIN
         JOIN VENTEMONTANT v2 ON v2.ID = v.ID
         LEFT JOIN LIAISONPAIEMENTTOTAL mv ON v.id=mv.id2
         LEFT JOIN AVOIRFCLIB_CPL_GRP ACG on ACG.IDVENTE = v.ID
         LEFT JOIN REFERENCEFACTURE rf ON rf.idfacture=v.Id;