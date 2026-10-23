CREATE OR REPLACE VIEW "TRAITEMENT_PAIE_LIB" AS
SELECT
    ec.id AS idpersonnel ,
    ec.nom || ' ' || ec.PRENOM AS nomPersonnel,
    ec.MATRICULE ,
    pe.GAIN AS netapayer,
    pe.IDEDITION ,
    ec.MODE_PAIEMENT AS modepaiement,
    ec.BANQUE_NUMERO_COMPTE AS numeroCompte
FROM PAIE_EDITION pe
         LEFT JOIN EMPLOYE_COMPLET ec ON ec.id = pe.IDPERSONNEL
WHERE pe.IDELEMENTPAIE ='PR000210A' AND pe.etat >= 11