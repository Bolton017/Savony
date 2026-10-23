create or replace view BONDECOMMANDE_CLIENT_CPL as
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
    bc.IDMAGASIN,
    m2.VAL AS IDMAGASINLIB,
    CASE
        WHEN bc.ETAT = 0  THEN '<span style=color: green;>ANNUL&Eacute;</span>'
        WHEN bc.ETAT = 1  THEN '<span style=color: green;>CR&Eacute;&Eacute;</span>'
        WHEN bc.ETAT = 11 THEN '<span style=color: green;>VALID&Eacute;</span>'
        WHEN bc.ETAT = 13 THEN '<span style=color: green;>PR&Eacute;PAR&Eacute;</span>'
        END AS ETATLIB,
    bc.IDPROFORMA,
    NVL(vo.nombre, 0) AS NBFACTURE,
    CASE
        WHEN bc.MODELIVRAISON = 1 THEN '<span style=color: green;>LIVRAISON</span>'
        WHEN bc.MODELIVRAISON = 2 THEN '<span style=color: green;>RECUPERATION</span>'
        END AS MODELIVRAISONLIB,
    bc.DATELIVRAISON,
    bc.LIEULIVRAISON,
    bc.FRAISLIVRAISON,
    c.NOM || ' ' || bc.REMARQUE || ' ' || bc.DESIGNATION AS MOTSCLESSS,
    bc.NUMEROBC,
    bc.IDREPRESENTANT,
    bc.IDDEVISE,
    r.VAL AS IDREPRESENTANTLIB,
    cast(bcf.montantHT as number(30,2))  AS MONTANTHT,
    cast(bcf.MONTANTTTC as number(30,2))  AS MONTANTTTC,
    cast(bcf.montantttcAr as number(30,2))  AS MONTANTTTCAR,
    cast(bcf.montantremise as number(30,2)) AS MONTANTREMISE,
    cast(bcf.MONTANTTVA as number(30,2)) AS MONTANTTVA,
    bc.IDZONECLIENT,
    z.val AS IDZONECLIENTLIB,
    bc.COMMERCIAL,
    com.nom||com.prenom AS commerciallib,
    CASE
        WHEN vnt.ID IS NOT NULL THEN 'Facture Cr&eacute;&eacute;e'
        ELSE 'Facture non Cr&eacute;&eacute;'
        END                                                                                AS ETATFacturation
FROM BONDECOMMANDE_CLIENT bc
         LEFT JOIN CLIENT c        ON c.id = bc.IDCLIENT
         LEFT JOIN MODEPAIEMENT m  ON m.id = bc.MODEPAIEMENT
         LEFT JOIN MAGASIN2 m2     ON m2.id = bc.IDMAGASIN
         LEFT JOIN VENTE_ORIGINE vo ON vo.IDORIGINE = bc.id
         LEFT JOIN REPRESENTANT r  ON r.id = bc.IDREPRESENTANT
         left join BCClientFille_GrpMontant bcf on bcf.IDBC=bc.ID
         LEFT JOIN zoneclient z ON z.id = bc.IDZONECLIENT
         LEFT JOIN LOG_PERSONNEL_COM com ON com.id = bc.COMMERCIAL
         LEFT JOIN vente vnt on vnt.IDORIGINE = bc.ID;