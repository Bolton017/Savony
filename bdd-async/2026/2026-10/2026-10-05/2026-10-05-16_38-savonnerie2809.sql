--MOUVEMENTCAISSECPL : atao order by id 

CREATE OR REPLACE  VIEW MOUVEMENTCAISSECPL (ID, DESIGNATION, IDCAISSE, IDCAISSELIB, IDVENTEDETAIL, IDVIREMENT, DEBIT, CREDIT, SOLDECREDIT, SOLDEDEBIT, DATY, ETAT, ETATLIB, IDVENTE, IDORIGINE, IDTIERS, TIERS, IDPREVISION, IDOP, TAUX, COMPTE, IDDEVISE, IDTRAITE, IDMODEPAIEMENTLIB, IDMVTCAISSEMERE, REFERENCE, DATYCOMPTABILISATION, UPDATED_AT, HEURE, IDREPORT, MOTSCLESS, IDECRITURE) AS 
  SELECT
	m.ID,
	m.DESIGNATION,
	m.IDCAISSE,
	c.VAL AS IDCAISSELIB,
	m.IDVENTEDETAIL,
	m.IDVIREMENT,
	m.DEBIT,
	m.CREDIT,
	CAST(
               CASE
                   WHEN m.credit > 0 THEN NVL(m.CREDIT, 0) - NVL(l.MONTANT, 0)
                   ELSE 0
                   END AS NUMBER(36, 5)
       ) AS soldecredit,
	CAST(
               CASE
                   WHEN m.debit > 0 THEN NVL(m.DEBIT, 0) - NVL(l.MONTANT, 0)
                   ELSE 0
                   END AS NUMBER(36, 5)
       ) AS soldedebit,
	m.DATY,
	m.ETAT,
	CASE
		WHEN m.ETAT = 0
               THEN 'ANNUL&Eacute;E'
		WHEN m.ETAT = 1
               THEN 'CR&Eacute;&Eacute;E'
		WHEN m.ETAT = 11
               THEN 'VALID&Eacute;E'
		WHEN m.ETAT = 8
               THEN '&Agrave; COMPTABILISER'
	END AS ETATLIB,
	vd.IDVENTE,
	m.IDORIGINE AS idorigine,
	m.idtiers,
	nvl(t.NOM,'-') AS tiers,
	m.idPrevision,
	m.idOP,
	m.taux,
	m.COMPTE,
	m.IDDEVISE,
	m.idtraite,
	mp.VAL AS idModePaiementLib,
	m.idmvtcaissemere,
	m.reference,
	m.datycomptabilisation,
	m.UPDATED_AT,
	nvl(m.heure,'-') AS heure,
	m.IDREPORT,
	m.ID || '' || m.DATY || '' || m.DESIGNATION || '' || t.NOM || '' || m.IDCAISSE || '' || c.VAL AS MOTSCLESS,
	cr.id AS idecriture
FROM
	MOUVEMENTCAISSE m
LEFT JOIN CAISSE c ON
	c.ID = m.IDCAISSE
LEFT JOIN VENTE_DETAILS vd ON
	vd.ID = m.IDVENTEDETAIL
LEFT JOIN tiers t ON
	t.ID = m.idtiers
LEFT JOIN liaisonpaiementmvtcaissegrp l ON
	l.idmvtcaisse = m.id
LEFT JOIN modepaiement mp ON
	m.idmodepaiement = mp.id
LEFT JOIN COMPTA_ECRITURE cr ON
	cr.IDOBJET = m.id
 
	ORDER BY m.ID DESC 


;