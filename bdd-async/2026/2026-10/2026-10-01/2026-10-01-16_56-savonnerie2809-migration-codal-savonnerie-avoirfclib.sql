ALTER TABLE AVOIRFC ADD IDREPRESENTANT VARCHAR2(250);

CREATE OR REPLACE VIEW AVOIRFCLIB AS 
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
       ta.val        as Typeavoir,
       t.NOM         as clientlib,
       UPPER(
               NVL(a.DESIGNATION, '') || ' ' ||
               NVL(a.REMARQUE, '') || ' ' ||
               NVL(t.NOM, '') || ' ' ||
               NVL(m.VAL, '') || ' ' ||
               NVL(v.DESIGNATION, '') || ' ' ||
               NVL(ma.VAL, '') || ' ' ||
               NVL(c.VAL, '') || ' ' ||
               NVL(ta.val, '') || ' ' ||
               NVL(t.COMPTE, '') || ' ' ||
               TO_CHAR(a.DATY, 'DD/MM/YYYY')
       ) AS MOTSCLESSS,
       CASE
           WHEN a.ETAT = 1 THEN 'CR&Eacute;&Eacute;E'
           WHEN a.ETAT = 11 THEN 'VIS&Eacute;E'
           WHEN a.ETAT = 0 THEN 'ANNUL&Eacute;E'
           END AS ETATLIB,
	   a.idrepresentant,
	   a.NUMAVOIR
FROM AVOIRFC a
         LEFT JOIN magasin2 m ON m.id = a.IDMAGASIN
         LEFT JOIN VENTE v ON v.id = a.IDVENTE
         LEFT JOIN MOTIFAVOIRFC ma ON ma.id = a.IDMOTIF
         LEFT JOIN CATEGORIEAVOIRFC c ON c.id = a.IDCATEGORIE
         JOIN AVOIRFCFILLE_GRP ag ON ag.idavoirfc = a.id
         LEFT JOIN TIERS T ON T.ID = A.IDCLIENT
         left join TYPEAVOIR ta on ta.id = a.IDTYPEAVOIR;

CREATE OR REPLACE VIEW AVOIRFCLIB_CPL AS 
  SELECT
	AL.ID,
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
	nvl(M.montant, 0) AS MONTANTPAYE,
	NVL(M.montant, 0) * NVL(AL.TAUXDECHANGE, 0) AS MONTANTPAYEAR,
	NVL(vc.MONTANTRESTE, 0) AS MONTANT_RESTE_FACTURE,
	NVL(SUM_PRECEDENTS.montant_avoirs_precedents, 0) AS MONTANT_AVOIRS_ANTERIEURS,
	-- Cas 1 : facture deja soldee -> chaque avoir = credit direct (exedent)
       CASE
		WHEN NVL(vc.MONTANTRESTE, 0) = 0 THEN 0
		ELSE NVL(vc.MONTANTRESTE, 0) - NVL(SUM_PRECEDENTS.montant_avoirs_precedents, 0) - NVL(AL.MONTANTTTCAR, 0)
	END AS RESTE_CALCULE,
	-- Excedent a rembourser ou a reporter
       CASE
		WHEN NVL(vc.MONTANTRESTE, 0) = 0 THEN NVL(AL.MONTANTTTCAR, 0)
		WHEN NVL(vc.MONTANTRESTE, 0) - NVL(SUM_PRECEDENTS.montant_avoirs_precedents, 0) - NVL(AL.MONTANTTTCAR, 0) < 0
               THEN ABS(NVL(vc.MONTANTRESTE, 0) - NVL(SUM_PRECEDENTS.montant_avoirs_precedents, 0) -
                        NVL(AL.MONTANTTTCAR, 0))
		ELSE 0
	END AS EXCEDENT_AR,
	(CASE
		WHEN NVL(vc.MONTANTRESTE, 0) = 0 THEN NVL(AL.MONTANTTTCAR, 0)
		WHEN NVL(vc.MONTANTRESTE, 0) - NVL(SUM_PRECEDENTS.montant_avoirs_precedents, 0) - NVL(AL.MONTANTTTCAR, 0) <
                 0
                THEN ABS(NVL(vc.MONTANTRESTE, 0) - NVL(SUM_PRECEDENTS.montant_avoirs_precedents, 0) -
                         NVL(AL.MONTANTTTCAR, 0))
		ELSE 0
	END) - NVL(M.montant, 0) AS resteapayer,
	(CASE
		WHEN NVL(vc.MONTANTRESTE, 0) = 0 THEN NVL(AL.MONTANTTTCAR, 0)
		WHEN NVL(vc.MONTANTRESTE, 0) - NVL(SUM_PRECEDENTS.montant_avoirs_precedents, 0) - NVL(AL.MONTANTTTCAR, 0) <
                 0
                THEN ABS(NVL(vc.MONTANTRESTE, 0) - NVL(SUM_PRECEDENTS.montant_avoirs_precedents, 0) -
                         NVL(AL.MONTANTTTCAR, 0))
		ELSE 0
	END) - (NVL(M.montant, 0) * NVL(AL.TAUXDECHANGE, 0)) AS resteapayerar,
	AL.clientlib,
	AL.Typeavoir,
	vc.NUMFACT,
	T.compteauxiliaire,
	v.IDRESERVATION,
	al.idrepresentant,
	rep.VAL as idrepresentantLib,
    al.etatlib,
    al.NUMAVOIR
FROM
	AVOIRFCLIB AL
LEFT JOIN MOUVEMENTCAISSEGRPAVOIR_LP M
                   ON
	AL.ID = M.IDORIGINE
LEFT JOIN VENTE_CPL_SANSAVOIR vc
                   ON
	vc.id = AL.idvente
LEFT JOIN TIERS T ON T.ID = AL.IDCLIENT
LEFT JOIN VENTE v ON v.ID = AL.idvente
left join REPRESENTANT rep on rep.id = al.idrepresentant
	-- Somme des avoirs precedents pour la meme facture
LEFT JOIN (
	SELECT
		a2.idvente,
		a2.id AS idcourant,
		SUM(a1.MONTANTTTCAR) AS montant_avoirs_precedents
	FROM
		AVOIRFCLIB a1
	JOIN AVOIRFCLIB a2 ON
		a1.idvente = a2.idvente
	WHERE
		a1.ETAT <> 0
		AND (a1.DATY < a2.DATY
			OR (a1.DATY = a2.DATY
				AND a1.ID < a2.ID))
	GROUP BY
		a2.idvente,
		a2.id) SUM_PRECEDENTS
                   ON
	SUM_PRECEDENTS.idvente = AL.idvente
	AND SUM_PRECEDENTS.idcourant = AL.id;
