CREATE OR REPLACE VIEW PROFORMA_CPL AS
SELECT v.ID,
   v.DESIGNATION,
   v.IDMAGASIN,
   m.VAL AS IDMAGASINLIB,
   v.DATY,
   v.REMARQUE,
   v.ETAT,
   CASE
       WHEN v.ETAT = 1 THEN 'CREE'
       WHEN v.ETAT = 11 THEN 'VISEE'
       WHEN v.ETAT = 0 THEN 'ANNULEE'
       END
         AS ETATLIB,
   v2.IDDEVISE,
   v.IDCLIENT,
   c.NOM AS IDCLIENTLIB,
   c.ADRESSE,
   c.TELEPHONE AS CONTACT,
   cast(V2.montant as number(30,2)) as montant,
   v2.MONTANTTOTAL,
   cast(V2.montantremise as number(30,2)) as MONTANTREMISE,
   cast(V2.MONTANTTVA as number(30,2)) as MONTANTTVA,
   cast(V2.MONTANTTTC as number(30,2)) as montantttc,
   cast(V2.MONTANTTTCAR as number(30,2)) as MONTANTTTCAR,
   cast(nvl(mv.credit,0)-nvl(ACG.MONTANTPAYE, 0) AS NUMBER(30,2)) AS montantpaye,
   cast(V2.MONTANTTTC-nvl(mv.credit,0)-nvl(ACG.resteapayer_avr, 0) AS NUMBER(30,2)) AS montantreste,
   nvl(ACG.MONTANTTTC_avr, 0)  as avoir,
   v2.tauxDeChange AS tauxDeChange,v2.MONTANTREVIENT,cast((V2.MONTANTTTCAR-v2.MONTANTREVIENT) as number(20,2))  as margeBrute,
   v.IDRESERVATION,
   v.IDORIGINE,
   v.remise
FROM PROFORMA v
    LEFT JOIN CLIENT c ON c.ID = v.IDCLIENT
    LEFT JOIN MAGASIN2 m ON m.ID = v.IDMAGASIN
    JOIN PROFORMAMONTANT2 v2 ON v2.ID = v.ID
    LEFT JOIN mouvementcaisseGroupeFacture mv ON v.id=mv.IDORIGINE
    LEFT JOIN AVOIRFCLIB_CPL_GRP ACG on ACG.IDVENTE = v.ID;


CREATE OR REPLACE VIEW BONDECOMMANDE_CLIENT_CPL AS
SELECT
    bc.ID,
    bc.DATY,
    bc.ETAT,
    bc.REMARQUE,
    bc.DESIGNATION,
    bc.MODEPAIEMENT,
    m.VAL AS MODEPAIEMENTLIB,
    bc.IDCLIENT,
    c.NOM AS IDCLIENTLIB,
    bc.REFERENCE,
    m2.VAL AS IDMAGASINLIB,
CASE
    WHEN bc.ETAT = 0 THEN '<span style=color: green;>ANNULEE</span>'
    WHEN bc.ETAT = 1 THEN '<span style=color: green;>CREE</span>'
    WHEN bc.ETAT = 11 THEN '<span style=color: green;>VALIDEE</span>'
END AS ETATLIB
FROM BONDECOMMANDE_CLIENT bc
LEFT JOIN CLIENT c ON c.id = bc.IDCLIENT
LEFT JOIN MODEPAIEMENT m ON m.id = bc.MODEPAIEMENT
LEFT JOIN MAGASIN2 m2 ON m2.id = bc.IDMAGASIN;