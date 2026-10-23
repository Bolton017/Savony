create view MOUVEMENTCAISSECPL_V_DISPATCH as
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
       m.DESIGNATION as designationpaiement,
       idmvtcaissemere
FROM LIAISONPAIEMENT lp LEFT JOIN
     MOUVEMENTCAISSECPL m on m.id = lp.ID1
WHERE m.etat > 7;