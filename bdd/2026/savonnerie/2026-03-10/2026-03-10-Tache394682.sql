
CREATE OR REPLACE VIEW PROFORMAFOURNISSEURDETAILSCPL2 AS 
  SELECT 
    src.ID,
    src.PRODUIT,
    src.IDMERE,
    src.QUANTITE,
    src.PU,
    src.TVA,
    src.TAUXDECHANGE,
    src.UNITE,
    src.REMISE,
    src.REMISEMONTANT,
    src.DATY,
    src.ETAT,
    src.REMARQUE,
    src.DESIGNATION,
    src.MODEPAIEMENT,
    src.FOURNISSEUR,
    src.REFERENCE,
    src.produitlib,
    src.unitelib,
    src.MODEPAIEMENTLIB,
    src.FOURNISSEURLIB,
    src.iddevise,
    src.idoriginemere,
    CAST(src.MONTANT_BRUT AS NUMBER(30,2)) AS MONTANT_BRUT,
    CAST(src.MONTANT_NET_HT AS NUMBER(30,2)) AS MONTANT,
    CAST(src.MONTANT_NET_HT AS NUMBER(30,2)) AS MONTANTHT,
    CAST(
        CASE 
            WHEN NVL(src.TVA, 0) = 0 THEN 0
            ELSE src.MONTANT_NET_HT * (NVL(src.TVA, 0) / 100)
        END 
    AS NUMBER(30,2)) AS MONTANTTVA,
    CAST(
        CASE 
            WHEN NVL(src.TVA, 0) = 0 THEN src.MONTANT_NET_HT
            ELSE src.MONTANT_NET_HT + (src.MONTANT_NET_HT * (NVL(src.TVA, 0) / 100))
        END 
    AS NUMBER(30,2)) AS MONTANTTTC

FROM (
    SELECT 
        bcf.ID,
        bcf.PRODUIT,
        bcf.IDMERE,
        bcf.QUANTITE,
        bcf.PU,
        bcf.TVA,
        bcf.TAUXDECHANGE,
        bcf.UNITE,
        bcf.REMISE,
        bcf.REMISEMONTANT,
        bcf.iddevise,
        ab.DATY,
        ab.ETAT,
        ab.REMARQUE,
        ab.DESIGNATION,
        ab.MODEPAIEMENT,
        ab.FOURNISSEUR,
        ab.REFERENCE,
        ab.IDORIGINE AS idoriginemere,
        p.LIBELLE AS produitlib,
        u.VAL AS unitelib,
        mp.VAL AS MODEPAIEMENTLIB,
        F.nom AS FOURNISSEURLIB,
        
        NVL(bcf.QUANTITE, 0) * NVL(bcf.PU, 0) AS MONTANT_BRUT,
        
        (NVL(bcf.QUANTITE, 0) * NVL(bcf.PU, 0)) 
        - 
        CASE 
            WHEN NVL(bcf.REMISE, 0) > 0 THEN 
                (NVL(bcf.QUANTITE, 0) * NVL(bcf.PU, 0)) * (NVL(bcf.REMISE, 0) / 100)
            WHEN NVL(bcf.REMISEMONTANT, 0) > 0 THEN 
                NVL(bcf.REMISEMONTANT, 0)
            ELSE 0 
        END AS MONTANT_NET_HT
        
    FROM PROFORMAFOURNISSEURDETAILS bcf
    LEFT OUTER JOIN PROFORMAFOURNISSEUR AB ON AB.ID = bcf.IDMERE
    LEFT JOIN AS_INGREDIENTS P ON bcf.PRODUIT = P.ID
    LEFT JOIN AS_UNITE u ON bcf.UNITE = u.id
    LEFT JOIN MODEPAIEMENT mp ON AB.MODEPAIEMENT = mp.id
    LEFT JOIN FOURNISSEUR F ON AB.fournisseur = F.id
) src;

CREATE OR REPLACE VIEW PROFORMAFOURNISSEURDETAILSGRP2 AS 
  select IDMERE,
       sum(montant)                   as montant,
       sum(MONTANTHT)                 as montantht,
       sum(MONTANTTVA)                as montanttva,
       sum(MONTANTTTC)                as montantttc,
       sum(MONTANTTTC * TAUXDECHANGE) as montantttcar
from PROFORMAFOURNISSEURDETAILSCPL2
group by IDMERE
 ;


CREATE OR REPLACE  VIEW PROFORMAFOURNISSEUR_MERECPL2 AS 
  SELECT
    ab.ID,
    ab.DATY,
    ab.ETAT,
    ab.REMARQUE,
    ab.DESIGNATION,
    ab.MODEPAIEMENT,
    ab.FOURNISSEUR,
    ab.REFERENCE,
    mp.VAL AS MODEPAIEMENTLIB,
    F.NOM AS FOURNISSEURLIB,
    CAST( NVL(abf.MONTANTTVA, 0)
    AS NUMBER(30,2)) AS MONTANTTVA,
    CAST(
        NVL(abf.MONTANTHT, 0) - 
        CASE 
            WHEN NVL(ab.REMISE, 0) > 0 THEN NVL(abf.MONTANTHT, 0) * (NVL(ab.REMISE, 0) / 100.0)
            WHEN NVL(ab.REMISEMONTANT, 0) > 0 THEN NVL(ab.REMISEMONTANT, 0)
            ELSE 0 
        END
    AS NUMBER(30,2)) AS MONTANTHT,
    CAST(
        CASE 
            WHEN NVL(abf.MONTANTTTC, 0) = 0 THEN 
                NVL(abf.MONTANTTTC, 0) - 
                CASE 
                    WHEN NVL(ab.REMISE, 0) > 0 THEN NVL(abf.MONTANTHT, 0) * (NVL(ab.REMISE, 0) / 100.0)
                    WHEN NVL(ab.REMISEMONTANT, 0) > 0 THEN NVL(ab.REMISEMONTANT, 0)
                    ELSE 0 
                END
            ELSE 
                NVL(abf.MONTANTTTC, 0) - 
                CASE 
                    WHEN NVL(ab.REMISE, 0) > 0 THEN NVL(abf.MONTANTTTC, 0) * (NVL(ab.REMISE, 0) / 100.0)
                    WHEN NVL(ab.REMISEMONTANT, 0) > 0 THEN NVL(ab.REMISEMONTANT, 0)
                    ELSE 0 
                END
        END
    AS  NUMBER(30,2)) MONTANTTTC,
    CAST(nvl(abf.MONTANTTTCAR,0) AS NUMBER(30,2)) AS montantTTCAriary,
    d.val AS idDeviselib,
    d.id AS IDDEVISE,
    CASE
        WHEN ab.ETAT = 0
            THEN 'ANNUL&Eacute;E'
        WHEN ab.ETAT = 1
            THEN 'CR&Eacute;&Eacute;E'
        WHEN ab.ETAT = 11
            THEN 'VIS&Eacute;(E) par Directeur'
        WHEN ab.ETAT = 3
            THEN 'VIS&Eacute;(E) par Responsable achat'
        WHEN ab.ETAT = 4
            THEN 'VIS&Eacute;(E) par Chef hierarchique'
        END AS etatlib,
    ab.IDORIGINE,
    AB.REMISE,
    AB.REMISEMONTANT
from  proformafournisseur AB
          left join MODEPAIEMENT mp on AB.MODEPAIEMENT = mp.id
          left join FOURNISSEUR F on AB.FOURNISSEUR = F.id
          LEFT JOIN proformafournisseurdetailsgrp2 abf ON abf.IDMERE = ab.ID
          LEFT JOIN DEVISE d ON d.id = ab.IDDEVISE
 ;



--Facture 

alter TABLE FACTUREFOURNISSEUR add  remisemontant number(30,2);
alter TABLE FACTUREFOURNISSEUR add remise number(5,2);

alter TABLE FactureFournisseurFille add  remisemontant number(30,2);
alter TABLE FactureFournisseurFille add remise number(5,2);






CREATE OR REPLACE
VIEW FACTUREFOURNISSEURMONTANT2 AS 
SELECT
	v.ID,
	CAST(SUM (NVL(vd.QTE, 0) * NVL(vd.PU, 0))  AS NUMBER(30, 2)) AS MONTANT_BRUT, 
    CAST(SUM ((NVL(vd.QTE, 0) * NVL(vd.PU, 0)) 
        - 
        CASE 
            WHEN NVL(vd.REMISE,  0) > 0 THEN 
                (NVL(vd.QTE, 0) * NVL(vd.PU, 0)) * (NVL(vd.REMISE, NVL(vd.REMISES, 0)) / 100)
            WHEN NVL(vd.REMISEMONTANT, 0) > 0 THEN 
                NVL(vd.REMISEMONTANT, 0)
            ELSE 0 
        END 
        )
      AS NUMBER(30, 2)) AS MONTANT_HT,
        
    CAST(SUM(
    	(
			NVL(vd.QTE, 0) * NVL(vd.PU, 0)
		      -
		      CASE 
		        WHEN NVL(vd.REMISE, 0) > 0 THEN 
		          (NVL(vd.QTE, 0) * NVL(vd.PU, 0)) * (NVL(vd.REMISE, 0) / 100)
		        WHEN NVL(vd.REMISEMONTANT, 0) > 0 THEN 
		          NVL(vd.REMISEMONTANT, 0)
		        ELSE 0 
		      END
		    ) 
    + 
    (NVL(vd.QTE, 0) * NVL(vd.PU, 0)
		      -
		      CASE 
		        WHEN NVL(vd.REMISE, 0) > 0 THEN 
		          (NVL(vd.QTE, 0) * NVL(vd.PU, 0)) * (NVL(vd.REMISE, 0) / 100)
		        WHEN NVL(vd.REMISEMONTANT, 0) > 0 THEN 
		          NVL(vd.REMISEMONTANT, 0)
		        ELSE 0 
		      END
		    )  * (NVL (VD.TVA , 0)/100)
  ) 
  AS NUMBER(30, 2)) AS montantTTC,
  CAST(
    SUM(
        CASE
	        WHEN NVL(vd.TVA, 0) = 0 THEN 0
            ELSE 
                (
                    (NVL(vd.QTE, 0) * NVL(vd.PU, 0))
                    - 
                    CASE 
                        WHEN NVL(vd.REMISES, 0) > 0 THEN 
                            (NVL(vd.QTE, 0) * NVL(vd.PU, 0)) * (NVL(vd.REMISES, 0) / 100)
                        WHEN NVL(vd.REMISEMONTANT, 0) > 0 THEN 
                            NVL(vd.REMISEMONTANT, 0)
                        ELSE 0 
                    END
                ) * (NVL(vd.TVA, 0) / 100) 
        END
    ) AS NUMBER(30,2)
) AS montantTva,
NVL (vd.IDDEVISE, 'AR') AS IDDEVISE,
    nvl (vd.tauxdechange, 1) AS tauxdechange
            FROM FactureFournisseurFille vd LEFT JOIN facturefournisseur v ON v.ID = vd.idfacturefournisseur
   GROUP BY v.ID, vd.IDDEVISE, vd.tauxdechange
 ;


CREATE OR REPLACE  VIEW FACTUREFOURNISSEURCPL2  AS 
  SELECT f.ID,
       f.IDFOURNISSEUR,
       f2.NOM  AS IDFOURNISSEURLIB,
       f.IDMODEPAIEMENT,
       m.VAL   AS IDMODEPAIEMENTLIB,
       f.DATY,
       f.DESIGNATION,
       f.DATEECHEANCEPAIEMENT,
       f.ETAT,
       CASE
           WHEN f.ETAT = 1
               THEN 'CREEE'
           WHEN f.ETAT = 0
               THEN 'ANNULEE'
           WHEN f.ETAT = 11
               THEN 'VISEE'
           END AS ETATLIB,
       f.REFERENCE,
       f.IDBC,
       f.IDMAGASIN,
       f.DEVISE,
       case
           when f.TAUX=0 then 1
           else f.TAUX
           end as taux,
       p.VAL   AS idMagasinLib,
       f3.IDDEVISE,
       
       cast(f3.MONTANTTVA as number(30,2)) as MONTANTTVA,
       
	   CAST(
	        f3.MONTANT_HT - 
	        CASE 
	            WHEN NVL(f.REMISE, 0) > 0 THEN f3.MONTANT_HT * (NVL(f.REMISE, 0) / 100)
	            WHEN NVL(f.REMISEMONTANT, 0) > 0 THEN  NVL(f.REMISEMONTANT, 0)
	            ELSE 0 
	        END
    	AS NUMBER(30,2)) AS MONTANTHT,
    
       CAST(
	        f3.MONTANTTTC - 
	        CASE 
	            WHEN NVL(f.REMISE, 0) > 0 THEN f3.MONTANTTTC * (NVL(f.REMISE, 0) / 100)
	            WHEN NVL(f.REMISEMONTANT, 0) > 0 THEN  NVL(f.REMISEMONTANT, 0)
	            ELSE 0 
	        END
    	AS NUMBER(30,2)) AS MONTANTTTC,
       cast(
       f3.tauxdechange * (f3.MONTANTTTC - 
	        CASE 
	            WHEN NVL(f.REMISE, 0) > 0 THEN f3.MONTANTTTC * (NVL(f.REMISE, 0) / 100)
	            WHEN NVL(f.REMISEMONTANT, 0) > 0 THEN  NVL(f.REMISEMONTANT, 0)
	            ELSE 0 
	        END  
	        ) as number(30,2)) as MONTANTTTCAR,
       cast(nvl(mv.debit,0) AS NUMBER(30,2)) AS montantpaye,
       cast(f3.MONTANTTTC - 
	        CASE 
	            WHEN NVL(f.REMISE, 0) > 0 THEN f3.MONTANTTTC * (NVL(f.REMISE, 0) / 100)
	            WHEN NVL(f.REMISEMONTANT, 0) > 0 THEN  NVL(f.REMISEMONTANT, 0)
	            ELSE 0 
	        END 
	        -
	        nvl(mv.debit,0) AS NUMBER(30,2)) AS montantreste,
       cast(nvl(f3.tauxdechange,0) AS  NUMBER(30,2)) AS tauxdechange,
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
       f.remise,
       f.remisemontant
FROM FACTUREFOURNISSEUR f
         LEFT JOIN FOURNISSEUR f2 ON f2.ID = f.IDFOURNISSEUR
         LEFT JOIN MODEPAIEMENT m ON m.ID = f.IDMODEPAIEMENT
         LEFT JOIN MAGASIN p ON p.ID = f.IDMAGASIN
         JOIN FACTUREFOURNISSEURMONTANT2 f3 ON f.ID = f3.id
         LEFT JOIN mouvementcaisseGroupeFacture mv ON f.id=mv.IDORIGINE
         LEFT JOIN prevision prev ON prev.idfacture=f.id
		 left join type_facture tf on tf.id = f.IDTYPEFACTURE
 ;



CREATE OR REPLACE
VIEW AS_BONDECOMMANDEFILLE_CPL2 AS 
  SELECT
	abf.IDBC ,
	CAST(nvl(sum( (abf.QUANTITE * abf.PU) -
				CASE 
				    WHEN NVL(abf.REMISE, 0) > 0 THEN (abf.QUANTITE * abf.PU) * (NVL(abf.REMISE, 0) / 100)
				    WHEN NVL(abf.REMISEMONTANT, 0) > 0 THEN NVL(abf.REMISEMONTANT, 0)
				    ELSE 0 
				END 
), 0)
AS NUMBER(30, 2)) AS montantHT,
	CAST(nvl(sum(((abf.QUANTITE * abf.PU) -
				CASE 
				    WHEN NVL(abf.REMISE, 0) > 0 THEN (abf.QUANTITE * abf.PU) * (NVL(abf.REMISE, 0) / 100)
				    WHEN NVL(abf.REMISEMONTANT, 0) > 0 THEN NVL(abf.REMISEMONTANT, 0)
				    ELSE 0 
				END) * (abf.TVA / 100)), 0) AS NUMBER(30, 2)) AS montanttva,
	abf.TAUXDECHANGE
FROM
	AS_BONDECOMMANDE_FILLE abf
GROUP BY
	abf.IDBC,
	abf.TAUXDECHANGE
 
 
 ;    
 
CREATE OR REPLACE  VIEW AS_BONDECOMMANDE_MERECPL2 AS       
SELECT
    ab.ID,
    ab.DATY,
    ab.ETAT,
    ab.REMARQUE,
    ab.DESIGNATION,
    ab.MODEPAIEMENT,
    ab.FOURNISSEUR,
    ab.REFERENCE,
    ab.dateLimite,
    mp.VAL AS MODEPAIEMENTLIB,
    F.NOM AS FOURNISSEURLIB,
    abf.montantTVA,
    abf.montantHT,
    CAST(nvl(((abf.montantHT + abf.montantTVA)-
    	- 
    	CASE 
		    WHEN NVL(ab.REMISE, 0) > 0 THEN (abf.montantHT + abf.montantTVA) * (NVL(ab.REMISE, 0) / 100)
		    WHEN NVL(ab.REMISEMONTANT, 0) > 0 THEN NVL(ab.REMISEMONTANT, 0)
		    ELSE 0 
		END)
    ,0) AS NUMBER(30,2)) AS montantTTC ,
    CAST(nvl(((abf.montantHT + abf.montantTVA)
    	- 
    	CASE 
		    WHEN NVL(ab.REMISE, 0) > 0 THEN (abf.montantHT + abf.montantTVA) * (NVL(ab.REMISE, 0) / 100)
		    WHEN NVL(ab.REMISEMONTANT, 0) > 0 THEN NVL(ab.REMISEMONTANT, 0)
		    ELSE 0 
		END)
    * abf.TAUXDECHANGE,0) AS NUMBER(30,2)) AS montantTTCAriary,
    d.val AS idDeviselib,
    d.id AS IDDEVISE,
    AB.idOrigine,
    AB.IDMAGASIN,
    m.VAL AS idMagasinlib,
    CASE
        WHEN ab.ETAT = 1 THEN 'CREEE'
        WHEN ab.ETAT = 11 THEN 'VISEE'
        WHEN ab.ETAT = 0 THEN 'ANNULEE'
        END
        AS ETATLIB
from  AS_BONDECOMMANDE AB
          left join MODEPAIEMENT mp on AB.MODEPAIEMENT = mp.id
          left join FOURNISSEUR F on AB.FOURNISSEUR = F.id
          LEFT JOIN AS_BONDECOMMANDEFILLE_CPL abf ON abf.IDBC = ab.ID
          LEFT JOIN DEVISE d ON d.id = ab.IDDEVISE
          LEFT JOIN MAGASINPOINT m ON m.id =  AB.IDMAGASIN  
 ;       
       