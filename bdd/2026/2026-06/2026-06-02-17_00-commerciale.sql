alter table BONDECOMMANDE_CLIENT add commercial varchar(255);

CREATE OR REPLACE  VIEW BONDECOMMANDE_CLIENT_CPL ("ID", "DATY", "ETAT", "REMARQUE", "DESIGNATION", "MODEPAIEMENT", "MODEPAIEMENTLIB", "IDCLIENT", "IDCLIENTLIB", "REFERENCE", "IDMAGASINLIB", "ETATLIB", "IDPROFORMA", "NBFACTURE", "MODELIVRAISONLIB", "DATELIVRAISON", "LIEULIVRAISON", "MOTSCLESSS","COMMERCIALLIB") AS
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
        WHEN bc.ETAT = 0 THEN '<span style=color: green;>ANNUL&Eacute;</span>'
        WHEN bc.ETAT = 1 THEN '<span style=color: green;>CR&Eacute;&Eacute;</span>'
        WHEN bc.ETAT = 11 THEN '<span style=color: green;>VALID&Eacute;</span>'
        END AS ETATLIB,
    bc.IDPROFORMA,
    nvl(vo.nombre,0) as nbfacture,
    CASE
        WHEN bc.modelivraison = 1 THEN '<span style=color: green;>LIVRAISON</span>'
        WHEN bc.modelivraison = 2 THEN '<span style=color: green;>RECUPERATION</span>'
        END AS modelivraisonlib,
    bc.dateLivraison,
    bc.lieuLivraison,
    UPPER(
            NVL(bc.DESIGNATION, '') || ' ' ||
            NVL(bc.REFERENCE, '') || ' ' ||
            NVL(c.NOM, '') || ' ' ||
            NVL(m.VAL, '') || ' ' ||
            NVL(m2.VAL, '') || ' ' ||
            NVL(bc.lieuLivraison, '') || ' ' ||
            NVL(bc.IDPROFORMA, '') || ' ' ||
            TO_CHAR(bc.DATY, 'DD/MM/YYYY') || ' ' ||
            TO_CHAR(bc.dateLivraison, 'DD/MM/YYYY')
    ) AS MOTSCLESSS,
    com.nom||com.prenom AS commerciallib
FROM BONDECOMMANDE_CLIENT bc
         LEFT JOIN CLIENT c ON c.id = bc.IDCLIENT
         LEFT JOIN MODEPAIEMENT m ON m.id = bc.MODEPAIEMENT
         LEFT JOIN MAGASIN2 m2 ON m2.id = bc.IDMAGASIN
         left join vente_origine vo on vo.IDORIGINE=bc.id
         LEFT JOIN log_personnel com ON com.id=bc.commercial;