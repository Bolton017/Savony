insert into COMPTA_COMPTE (ID, COMPTE, LIBELLE, TYPECOMPTE, CLASSY, ANALYTIQUE_OBLI, IDJOURNAL, CODEIMPOT)
values('COMPTE530001','530001','Banque BNI CLIENT','1','5',null,'COMP000075',null);
commit;

create or replace view FACTUREFOURNISSEUR_FILLECOMPTE as
select ff.COMPTE,
       ff.IDFACTUREFOURNISSEUR,
       f.etat,
       cast(sum(ff.MONTANTHT*(1-(nvl(f.REMISE,0))/100)) as number(30, 2))                            as montantht,
       cast(sum(ff.MONTANTTVA*(1-(nvl(f.REMISE,0))/100)) as number(30, 2))              as montanttva,
       cast(sum(ff.MONTANTTTC*(1-(nvl(f.REMISE,0))/100)) as number(30, 2)) as montantttc,
       cast(sum(ff.MONTANTTTCAR*(1-(nvl(f.REMISE,0))/100)) as number(30, 2)) as montantttcar,
       cast(sum(ff.MONTANTHTAR*(1-(nvl(f.REMISE,0))/100)) as number(30, 2)) as montanthtar,
       cast(sum(ff.MONTANTTVAAR*(1-(nvl(f.REMISE,0))/100)) as number(30, 2)) as MONTANTTVAAR,
       ff.iddevise,
       ff.tauxdechange
from FFFILLECALC ff join FACTUREFOURNISSEUR f on f.id=ff.IDFACTUREFOURNISSEUR
group by COMPTE, IDFACTUREFOURNISSEUR, f.etat,ff.iddevise,ff.tauxdechange
/
create or replace view FACTUREFOURNISSEUR_FILLE_VISE as
select COMPTE,IDFACTUREFOURNISSEUR,ETAT,MONTANTHT,MONTANTTVA,MONTANTTTC,iddevise,tauxdechange, montanthtar,MONTANTTVAAR,montantttcar
from FACTUREFOURNISSEUR_FILLECOMPTE
where etat >= 11
/

create or replace view AS_BONDELIVRAISON_LIVRE as
select IDBC_FILLE, sum(QUANTITE) as qte_livre
from AS_BONDELIVRAISON_MF where ETAT>=11
group by IDBC_FILLE
/


create or replace view FACTUREFOURNISSEURFILLECPL as
SELECT f.ID,
       f.IDFACTUREFOURNISSEUR,
       f.IDPRODUIT,
       p.LIBELLE                                                         AS IDPRODUITLIB,
       f.QTE,
       f.PU,
       f.REMISES,
       f.IDBCDETAIL,
       f.TVA,
       f.IDDEVISE,
       f2.DATY, cast(f.TAUXDECHANGE as number(30,2)) as TAUXDECHANGE,

       ----------------------------------------------------------
       -- 1 Montant HT brut
       ----------------------------------------------------------
       CAST(f.QTE * f.PU AS NUMBER(30, 2))                               AS montant,
       CAST(f.QTE * f.PU AS NUMBER(30, 2))                               AS montanttotal,

       ----------------------------------------------------------
       -- 2 Montant remise (appliquee sur HT)
       ----------------------------------------------------------
       CAST(f.montantRemiseSansTva AS NUMBER(30, 2)) AS montantRemise,

       ----------------------------------------------------------
       -- 3 Montant HT net apres remise
       ----------------------------------------------------------
       CAST(f.MONTANTHT
           AS NUMBER(30, 2))                                             AS montantht,

       ----------------------------------------------------------
       -- 4 TVA sur montant HT net
       ----------------------------------------------------------
       CAST(f.MONTANTTVA
           AS NUMBER(30, 2)
       )                                                                 AS montanttva,

       ----------------------------------------------------------
       -- 5 Montant TTC net (HT net + TVA)
       ----------------------------------------------------------
       CAST(
               f.MONTANTTTC
           AS NUMBER(30, 2)
       )                                                                 AS montantttc,

       ----------------------------------------------------------
       -- 6 Frais accessoires
       ----------------------------------------------------------
       NVL(r.montant, 0)                                          AS fraisaccesoire,

       ----------------------------------------------------------
       -- 7 Montant total avec frais (TTC + accessoires)
       ----------------------------------------------------------
       CAST(
               f.montantTTCAr    + NVL(r.montant, 0)
           AS NUMBER(30, 2)
       )                                                                 AS montantavecfraisaccessoire,

       ----------------------------------------------------------
       -- 8 PU unitaire HT + accessoires
       ----------------------------------------------------------
       CAST(

                   f.puRemise*nvl(f.TAUXDECHANGE,1)
                       + (NVL(r.montant, 0)
                    / f.QTE)
           AS NUMBER(30, 2)
       )                                                                 AS puavecfraisaccessoire,
       cast(f.montantTTCAr as number(30,2)) as montantTTCAr,

       ----------------------------------------------------------
       -- Info produit & localisation
       ----------------------------------------------------------
       NVL(p.LIBELLEEXTACTE, p.LIBELLE)                                  AS libelleexacte,
       f.IDPREVISION,
       p2.ID                                                             AS idpoint,
       p2.VAL                                                            AS idpointlib,
       m.ID                                                              AS idmagasin,
       m.VAL                                                             AS idmagasinlib,
       c.ID                                                              AS idcategorie,
       c.VAL                                                             AS idcategorielib,
       f.designation,
       f.remise

FROM FFFILLECALC f
         LEFT JOIN FACTUREFOURNISSEUR f2
                   ON f2.ID = f.IDFACTUREFOURNISSEUR
         LEFT JOIN MAGASIN m
                   ON m.ID = f2.IDMAGASIN
         LEFT JOIN POINT p2
                   ON p2.ID = m.IDPOINT
         LEFT JOIN AS_INGREDIENTS p
                   ON p.ID = f.IDPRODUIT
         LEFT JOIN CATEGORIEINGREDIENT c
                   ON c.ID = p.CATEGORIEINGREDIENT
         LEFT JOIN REPARTIRIONPGGROUPEE r
                   ON r.IDFACTUREFILLE = f.ID
/


create or replace view FACTUREFOURNISSEURCPL_TOUS as
SELECT
	fcpl.id,
	fcpl.idfournisseur,
	fcpl.idfournisseurlib,
	fcpl.idmodepaiement,
	fcpl.idmodepaiementlib,
	fcpl.daty,
	fcpl.designation,
	fcpl.dateecheancepaiement,
	fcpl.etatlib,
	fcpl.reference,
	fcpl.idbc,
	fcpl.idmagasin,
	fcpl.idmagasinlib,
	fcpl.devise,
	fcpl.iddevise,
	fcpl.etat,
	fcpl.taux,
	fcpl.montanttva,
	fcpl.montantht,
	fcpl.tauxdechange,
	fcpl.montantttc AS  MONTANTTTC,
	nvl((fcpl.montantpaye * fcpl.TAUXDECHANGE),0) AS MONTANTPAYE,
	nvl((fcpl.montantreste * fcpl.TAUXDECHANGE),0) AS MONTANTRESTE,
	fcpl.MONTANTTTCAR, fcpl.MONTANTPAYEAR,fcpl.MONTANTRESTEAR,
	UPPER(
        NVL(fcpl.designation, '') || ' ' ||
        NVL(fcpl.reference, '') || ' ' ||
        NVL(fcpl.idfournisseurlib, '') || ' ' ||
        NVL(fcpl.idmodepaiementlib, '') || ' ' ||
        NVL(fcpl.idmagasinlib, '') || ' ' ||
        NVL(fcpl.devise, '') || ' ' ||
        NVL(fcpl.idbc, '') || ' ' ||
        TO_CHAR(fcpl.daty, 'DD/MM/YYYY') || ' ' ||
        TO_CHAR(fcpl.dateecheancepaiement, 'DD/MM/YYYY') || ' ' ||
        NVL(fcpl.etatlib, '')
    ) AS MOTSCLESSS
FROM FACTUREFOURNISSEURCPL fcpl


/


create or replace view FACTUREFOURNISSEURCPL_MGA as
SELECT "ID",
       "IDFOURNISSEUR",
       "IDFOURNISSEURLIB",
       "IDMODEPAIEMENT",
       "IDMODEPAIEMENTLIB",
       "DATY",
       "DESIGNATION",
       "DATEECHEANCEPAIEMENT",
       "ETAT",
       "ETATLIB",
       "REFERENCE",
       "IDBC",
       "IDMAGASIN",
       "DEVISE",
       "TAUX",
       "IDMAGASINLIB",
       "IDDEVISE",
       "MONTANTTVA",
       "MONTANTHT",
       "MONTANTTTC",
       "MONTANTTTCAR",
       "MONTANTPAYE",
       "MONTANTRESTE",
       "TAUXDECHANGE",MONTANTPAYEAR,MONTANTRESTEAR
FROM FACTUREFOURNISSEURCPL_TOUS
WHERE idDEVISE = 'AR'
/

create or replace view FACTUREFOURNISSEURCPL_EUR as
SELECT "ID","IDFOURNISSEUR","IDFOURNISSEURLIB","IDMODEPAIEMENT","IDMODEPAIEMENTLIB","DATY","DESIGNATION","DATEECHEANCEPAIEMENT","ETAT","ETATLIB","REFERENCE","IDBC","IDMAGASIN","DEVISE","TAUX","IDMAGASINLIB","IDDEVISE","MONTANTTVA","MONTANTHT","MONTANTTTC","MONTANTTTCAR","MONTANTPAYE","MONTANTRESTE","TAUXDECHANGE",MONTANTRESTEAR,MONTANTPAYEAR FROM FACTUREFOURNISSEURCPL_TOUS
WHERE idDEVISE = 'EUR'
/

create or replace view FACTUREFOURNISSEURCPL_USD as
SELECT "ID","IDFOURNISSEUR","IDFOURNISSEURLIB","IDMODEPAIEMENT","IDMODEPAIEMENTLIB","DATY","DESIGNATION","DATEECHEANCEPAIEMENT","ETAT","ETATLIB","REFERENCE","IDBC","IDMAGASIN","DEVISE","TAUX","IDMAGASINLIB","IDDEVISE","MONTANTTVA","MONTANTHT","MONTANTTTC","MONTANTTTCAR","MONTANTPAYE","MONTANTRESTE","TAUXDECHANGE",MONTANTRESTEAR,MONTANTPAYEAR FROM FACTUREFOURNISSEURCPL_TOUS
WHERE idDEVISE = 'USD'
/
