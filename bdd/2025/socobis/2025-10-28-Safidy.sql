CREATE OR REPLACE VIEW periodepaielib as(
	SELECT
		p.id AS id,
		p.mois AS mois,
		p.datedebut AS datedebut,
		p.datefin AS datefin,
		p.etat AS etat,
		CASE
           WHEN p.mois = 1 THEN 'Janvier'
           WHEN p.mois = 2 THEN 'Fevrier'
           WHEN p.mois = 3 THEN 'Mars'
           WHEN p.mois = 4 THEN 'Avril'
           WHEN p.mois = 5 THEN 'Mai'
           WHEN p.mois = 6 THEN 'Juin'
           WHEN p.mois = 7 THEN 'Juillet'
           WHEN p.mois = 8 THEN 'Aout'
           WHEN p.mois = 9 THEN 'Septembre'
           WHEN p.mois = 10 THEN 'Octobre'
           WHEN p.mois = 11 THEN 'Novembre'
           WHEN p.mois = 12 THEN 'Decembre'
           WHEN p.mois = 13 THEN '13eme MOIS'
           WHEN p.mois = 14 THEN '13eme MOIS BIS'
           ELSE NULL
           END AS moislib
		FROM PERIODEPAIE p
)