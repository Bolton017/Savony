CREATE OR REPLACE VIEW "LIAISONPAIEMENTTOTAL" AS 
  select 
	id2,
	sum(nvl(montant,0)) as montant ,
	sum(nvl(l.montant*mc.taux,0)) AS montantAr
  from LIAISONPAIEMENT l
  LEFT JOIN mouvementcaisse mc ON mc.id = id1
where l.etat>=11 group by id2;

CREATE OR REPLACE VIEW "FACTUREFOURNISSEURCPL" AS 
  SELECT
    f.ID,
    f.IDFOURNISSEUR,
    f2.NOM  AS IDFOURNISSEURLIB,
    f.IDMODEPAIEMENT,
    m.VAL   AS IDMODEPAIEMENTLIB,
    f.DATY,
    f.DESIGNATION,
    f.DATEECHEANCEPAIEMENT,
    nvl(f.echeancefacture,0) AS echeancefacture,
    f.ETAT,
    CASE
        WHEN f.ETAT = 1
            THEN 'CR&Eacute;&Eacute;E'
        WHEN f.ETAT = 0
            THEN 'ANNUL&Eacute;E'
        WHEN f.ETAT = 11
            THEN 'VIS&Eacute;E'
        WHEN f.ETAT = 15
        	THEN 'CL&Ocirc;TUR&Eacute;E'
        END AS ETATLIB,
    nvl(f.REFERENCE, reff.reference) as reference,
    f.IDBC,
    f.IDMAGASIN,
    f.DEVISE,
    case
        when f.TAUX=0 then 1
        else f.TAUX
        end as taux,
    p.VAL   AS idMagasinLib,
    f.IDDEVISE,
    cast(f.MONTANTTVA as number(30,5)) as MONTANTTVA,
    CAST(f.MONTANTHT as number(30,5)) AS MONTANTHT,
    cast(f.MONTANTTTC as number(30,5)) as montantttc,
    cast(f.MONTANTTTCAR as number(30,5)) as MONTANTTTCAR,
    cast(nvl(mv.MONTANT,0) AS number(30,5)) AS montantpaye,
    cast(nvl(mv.MONTANTAR,0) AS number(30,5)) AS montantpayeAr,
    cast(f.MONTANTTTCAR-((nvl(mv.MONTANTAR,0)-nvl(av.montantTTC,0))) AS number(30,5)) AS montantresteAr,
    cast(f.MONTANTTTC-nvl(mv.MONTANT,0)-nvl(av.montantTTC,0) AS number(30,5)) AS montantreste,
    cast(av.montantTTC as number(30,2)) as montantAvoir,
    cast(f.TAUX AS  number(30,2)) AS tauxdechange,
    prev.id as idPrevision,
    CASE
        WHEN f.estprevu=0 THEN 'NON'
        ELSE 'OUI'
        END
        AS estprevulib,
    f.IDOBJET,
    f.IDREF,
    f.IDTYPEFACTURE,
    tf.VAL as typefacture,
    f.numero,
    f.typeachat,
    f.idfactureprincipale,
    s.libelle AS idServiceLib,
    f.SERVICE,
    f.TYPEFACTUREFOURNISSEUR,
    tff.DESCE AS TYPEFACTUREFOURNISSEURLIB,
    ce.id AS idecriture,
    ta.VAL AS typeachatlib,
    f.remise
FROM FactFournisseurCalc f
    LEFT JOIN TYPEACHAT ta ON ta.DESCE = f.TYPEACHAT
    LEFT JOIN FOURNISSEUR f2 ON f2.ID = f.IDFOURNISSEUR
    LEFT JOIN MODEPAIEMENT m ON m.ID = f.IDMODEPAIEMENT
    LEFT JOIN MAGASIN p ON p.ID = f.IDMAGASIN
    LEFT JOIN LIAISONPAIEMENTTOTAL mv ON f.id=mv.ID2
    left join AvoirAChatCalcGroupeOrigine av on av.IDFACTURE=f.ID
    LEFT JOIN prevision prev ON prev.idfacture=f.id
    left join type_facture tf on tf.id = f.IDTYPEFACTURE
    LEFT JOIN SERVICE s ON f.SERVICE = s.COMPTE
    LEFT JOIN referencefacture reff ON f.id=reff.idfacture
    LEFT JOIN typefacturefournisseur tff ON tff.id = f.TYPEFACTUREFOURNISSEUR
    LEFT JOIN COMPTA_ECRITURE ce ON ce.idobjet=f.id
 
 ;
