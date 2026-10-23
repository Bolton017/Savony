create view liaisonpaiementmvtcaissegrp as
select id1 as idmvtcaisse, sum(MONTANT) as montant from LIAISONPAIEMENT where etat = 11
group by id1;

create or replace view MOUVEMENTCAISSECPL as
SELECT m.ID,
       m.DESIGNATION,
       m.IDCAISSE,
       c.VAL   AS IDCAISSELIB,
       m.IDVENTEDETAIL,
       m.IDVIREMENT,
       m.DEBIT,
       m.CREDIT,
       case when m.credit > 0 then cast(nvl(m.CREDIT, 0) - nvl(l.MONTANT, 0) as number(30,2)) else 0 end as soldecredit,
       case when m.debit > 0 then cast(nvl(m.debit, 0) - nvl(l.MONTANT, 0) as number(30,2)) else 0 end as soldedebit,
       m.DATY,
       m.ETAT,
       CASE
           WHEN m.ETAT = 0
               THEN 'ANNULEE'
           WHEN m.ETAT = 1
               THEN 'CREE'
           WHEN m.ETAT = 11
               THEN 'VALIDEE'
           WHEN m.ETAT = 8
               THEN 'A COMPTABILISER'
           END AS ETATLIB,
       vd.IDVENTE,
       m.IDORIGINE as idorigine,
       m.idtiers,
       t.NOM AS tiers,
       m.idPrevision,
       m.idOP,
       m.taux,
       m.COMPTE,
       m.IDDEVISE,
       m.idtraite,
       mp.VAL as idModePaiementLib,
       m.idmvtcaissemere,
       m.reference
FROM MOUVEMENTCAISSE m
         LEFT JOIN CAISSE c ON c.ID = m.IDCAISSE
         LEFT JOIN VENTE_DETAILS vd ON vd.ID = m.IDVENTEDETAIL
         LEFT JOIN tiers t ON t.ID = m.idtiers
         left join liaisonpaiementmvtcaissegrp l on l.idmvtcaisse=m.id
        left join modepaiement mp on m.idmodepaiement = mp.id;

create or replace view REPORTCAISSE_DEVISE as
SELECT
r.ID ,
r.IDCAISSE ,
c.VAL AS IDCAISSELIB,
r.MONTANT ,
r.MONTANTTHEORIQUE ,
r.DATY ,
r.ETAT ,
c.iddevise,
CASE
	WHEN r.ETAT = 0
	THEN 'ANNULEE'
	WHEN r.ETAT = 1
	THEN 'CREE'
	WHEN r.ETAT = 11
	THEN 'VALIDEE'
END AS ETATLIB
FROM REPORTCAISSE r
LEFT JOIN (select * from CAISSE where id not in ('CAIS001')) c ON c.ID  = r.IDCAISSE;

drop materialized view V_ETATCAISSE_DEVISE_AR;
create materialized view V_ETATCAISSE_DEVISE_AR
    refresh complete on demand
as
SELECT
	r.ID,
	r.IDCAISSE ,
	c.val AS idcaisseLib,
	c.idtypecaisse,
	tc.desce AS idtypecaisselib,
	c.idpoint,
	p.desce AS idpointlib,
	r.DATY dateDernierReport,
	CAST(NVL(r.MONTANT*taux.taux,0) AS number(30,2)) montantDernierReport,
	CAST(NVL(mvt.debit,0) AS number(30,2)) debit,
	CAST(NVL(mvt.credit,0) AS number(30,2)) credit,
	CAST((NVL(mvt.credit,0)+NVL(r.MONTANT*taux.taux,0)-NVL(mvt.debit,0))  AS number(30,2)) reste,
	'AR' AS devise
FROM
	REPORTCAISSE_devise r,
	(
		SELECT
			r.IDCAISSE ,
			MAX(r.DATY) maxDateReport
		FROM
			REPORTCAISSE_devise r
		WHERE
			r.ETAT = 11
			AND r.DATY < sysdate
		GROUP BY r.IDCAISSE
	) rm,
	(
		SELECT
			m.IDCAISSE ,
			SUM(nvl((m.DEBIT*t.taux),0)) DEBIT ,
			SUM(nvl((m.CREDIT*t.taux) ,0)) CREDIT
		FROM
			MOUVEMENTCAISSE m ,
			(
				SELECT
					r.IDCAISSE ,
					MAX(r.DATY) maxDateReport
				FROM
					REPORTCAISSE r
				WHERE
					r.ETAT = 11
					AND r.DATY < sysdate
				GROUP BY r.IDCAISSE
			) rm,
			--ajout jointure table tauxdechange
			( SELECT
						ta.*
					FROM
						TAUXDECHANGE ta,
						(
						SELECT
										max(daty) AS daty,
										iddevise
						FROM
										TAUXDECHANGE t
							------mipetraka eto ilay date en params
						WHERE
							daty <= sysdate
						GROUP BY iddevise) tmax
					WHERE
						ta.daty = tmax.daty
						AND ta.iddevise = tmax.iddevise
			) t
		WHERE
			m.iddevise= t.iddevise(+)
			AND m.IDCAISSE = rm.idcaisse(+)
			AND m.DATY > rm.maxDateReport
			AND m.DATY <=  sysdate
		GROUP BY m.IDCAISSE
	) mvt,
	--ajout jointure table tauxdechange
	( SELECT
						ta.*
					FROM
						TAUXDECHANGE ta,
						(
						SELECT
										max(daty) AS daty,
										iddevise
						FROM
										TAUXDECHANGE t
							------mipetraka eto ilay date en params
						WHERE
							daty <= sysdate
						GROUP BY iddevise) tmax
					WHERE
						ta.daty = tmax.daty
						AND ta.iddevise = tmax.iddevise
			) taux,
	(select * from CAISSE where id not in ('CAIS001')) c,
	typecaisse tc,
	point p
WHERE
	r.DATY = rm.maxDateReport
	AND r.IDDEVISE =taux.iddevise (+)
	AND r.ETAT = 11
	AND r.IDCAISSE = rm.IDCAISSE
	AND r.IDCAISSE = c.ID(+)
	AND r.IDCAISSE = mvt.idcaisse(+)
	AND c.IDTYPECAISSE = tc.ID (+)
	AND c.IDPOINT = p.ID;

create or replace view VENTE_CPL as
SELECT v.ID,
       v.DESIGNATION,
       v.IDMAGASIN,
       m.VAL AS IDMAGASINLIB,
       v.DATY,
       v.REMARQUE,
       v.ETAT,
       CASE
           WHEN v.ETAT = 1 THEN 'CR&Eacute;&Eacute;E'
           WHEN v.ETAT = 11 THEN 'VIS&Eacute;E'
           WHEN v.ETAT = 0 THEN 'ANNUL&Eacute;E'
           END
             AS ETATLIB,
       v2.MONTANTTOTAL,
       v2.IDDEVISE,
       v.IDCLIENT,
       c.NOM AS IDCLIENTLIB,
       cast(V2.MONTANTTVA as number(30,2)) as MONTANTTVA,
       cast(V2.MONTANTTTC as number(30,2)) as montantttc,
       cast(V2.MONTANTTTCAR as number(30,2)) as MONTANTTTCAR,
       cast(nvl(mv.montant,0) AS NUMBER(30,2)) AS montantpaye,
       cast(nvl(V2.MONTANTTTC, 0)-nvl(mv.montant,0)-nvl(ACG.imputeefactar, 0) AS NUMBER(30,2)) AS montantreste,
       cast(nvl(ACG.MONTANTTTC_avr, 0) as number(30,2)) as avoir,
       v2.tauxDeChange AS tauxDeChange,v2.MONTANTREVIENT,cast((V2.MONTANTTTCAR-v2.MONTANTREVIENT) as number(20,2))  as margeBrute,
       v.IDRESERVATION,
       case when v.DATYPREVU is null then v.daty else V.DATYPREVU end as datyprevu,
       rf.REFERENCE as referencefacture,
       v2.MONTANTREMISE,
       nvl(v2.MONTANTTOTAL,0)+nvl(v2.MONTANTREMISE,0) as montant,
       extract(month from v.DATY) as mois,
       extract(year from v.DATY) as annee,
       CAST(vp.poids as number(30,2)) as poids,
       CAST(vp.colis as number(30,2)) as colis,
       v.modepaiement,
       mp.VAL as modepaiementlib,
       nvl(v.fraislivraison,0)*nvl(vp.poids,0) as fraislivraison,
       v.modelivraison,
       CASE
            WHEN v.modelivraison = 1 THEN '<span style=color: green;>LIVRAISON</span>'
            WHEN v.modelivraison = 2 THEN '<span style=color: green;>RECUPERATION</span>'
        END AS modelivraisonlib,
       vr.reste,
       pv.id as idprovince,
       pv.val as provincelib,
       bl.id as idbl,
       v.IDORIGINE,
       v.FRAISLIVRAISON as frais,
       v.REFERENCEFACT,
       v.NUMEROFACTURE,
       v.LIEULIVRAISON,
       v.DATELIVRAISON
FROM VENTE v
         LEFT JOIN CLIENT c ON c.ID = v.IDCLIENT
        left join PROVINCE pv on pv.id = c.IDPROVINCE
         LEFT JOIN MAGASINPOINT m ON m.ID = v.IDMAGASIN
         JOIN VENTEMONTANT v2 ON v2.ID = v.ID
         LEFT JOIN LIAISONPAIEMENTTOTAL mv ON v.id=mv.id2
         LEFT JOIN AVOIRFCLIB_CPL_GRP ACG on ACG.IDVENTE = v.ID
         LEFT JOIN REFERENCEFACTURE rf ON rf.idfacture=v.Id
         left join vente_poids vp on vp.idvente=v.id
         left join MODEPAIEMENT mp on mp.id=v.modepaiement
         left join vente_reste vr on vr.idvente=v.id
         left join AS_BONDELIVRAISON_CLIENT bl on bl.IDVENTE = v.id;
