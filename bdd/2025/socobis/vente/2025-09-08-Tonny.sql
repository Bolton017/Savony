alter table MOUVEMENTCAISSE add idModePaiement VARCHAR(100);


create view MOUVEMENTCAISSECPL as
SELECT m.ID,
       m.DESIGNATION,
       m.IDCAISSE,
       c.VAL   AS IDCAISSELIB,
       m.IDVENTEDETAIL,
       m.IDVIREMENT,
       m.DEBIT,
       m.CREDIT,
       m.DATY,
       m.ETAT,
       CASE
           WHEN m.ETAT = 0
               THEN 'ANNULEE'
           WHEN m.ETAT = 1
               THEN 'CREE'
           WHEN m.ETAT = 11
               THEN 'VALIDEE'
           END AS ETATLIB,
       vd.IDVENTE,
       case when l.id2 is null then m.IDORIGINE else l.ID2 end as idorigine,
       m.idtiers,
       t.NOM AS tiers,
       m.idPrevision,
       m.idOP,
       m.taux,
       m.COMPTE,
       m.IDDEVISE,
       m.idtraite,
       mp.VAL as idModePaiementLib
FROM MOUVEMENTCAISSE m
         LEFT JOIN CAISSE c ON c.ID = m.IDCAISSE
         LEFT JOIN VENTE_DETAILS vd ON vd.ID = m.IDVENTEDETAIL
         LEFT JOIN tiers t ON t.ID = m.idtiers
         left join LiaisonPaiement l on l.id1=m.id
         left join modepaiement mp on m.idmodepaiement = mp.id;
/

