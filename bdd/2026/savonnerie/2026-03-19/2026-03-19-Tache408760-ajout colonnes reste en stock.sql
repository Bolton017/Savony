CREATE OR REPLACE VIEW SITUATIONDEMANDETRANSFERT AS
SELECT
    t2.id,
    t.IDPRODUIT,
    p.libelle AS PRODUIT,
    t.QUANTITE AS QTEDEMANDE,
    NVL(SUM(
                CASE
                    WHEN ms.ETAT = 11 THEN msf.SORTIE
                    ELSE 0
                    END
        ),0) AS QTELIVRE,

    NVL(SUM(
                CASE
                    WHEN ms.ETAT = 11 THEN msf.ENTREE
                    ELSE 0
                    END
        ),0) AS QTERECU,
    COALESCE(vei.reste,0) AS qtestock
FROM DEMANDETRANSFERTFILLE t
         LEFT JOIN DEMANDETRANSFERT t2 ON t2.ID = t.IDDEMANDETRANSFERT
         LEFT JOIN AS_INGREDIENTS p ON p.ID = t.IDPRODUIT
         LEFT JOIN TRANSFERTSTOCK ts ON ts.IDDEMANDE = t2.ID
         LEFT JOIN TRANSFERTSTOCKDETAILS tsd ON tsd.IDTRANSFERTSTOCK = ts.ID AND tsd.IDPRODUIT = t.IDPRODUIT
         LEFT JOIN MVTSTOCK ms ON ms.IDTRANSFERT = ts.ID
         LEFT JOIN MVTSTOCKFILLE msf ON msf.IDMVTSTOCK = ms.ID AND msf.IDPRODUIT = t.IDPRODUIT
         LEFT JOIN V_ETATSTOCK_ING vei ON vei.id=t.IDPRODUIT AND vei.idmagasin=t2.idmagasindepart
GROUP BY t2.id,t.IDPRODUIT,p.libelle,t.QUANTITE,vei.reste;