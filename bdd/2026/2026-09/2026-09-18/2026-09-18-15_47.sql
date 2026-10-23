create view RELEVER_CLIENT_OPT as
SELECT
    e.IDOBJET                    AS id,
    e.DATY                  AS daty,
    NVL(CJ.DESCE, ' ')      AS JOURNAL,
    NVL(CL.LETTRE, ' ')     AS LETTRE,
    se.COMPTE_AUX            AS idclient,
    se.LIBELLEPIECE          AS libelle,
    0                        AS solde_initial,
    se.DEBIT                 AS debit,
    se.CREDIT                AS credit,
    0                        AS solde_final
FROM COMPTA_SOUS_ECRITURE se
         JOIN COMPTA_ECRITURE e ON e.ID = se.IDMERE
         LEFT JOIN COMPTA_JOURNAL CJ ON CJ.ID = se.JOURNAL
         LEFT JOIN COMPTA_LETTRAGE CL ON CL.ID = se.LETTRAGE
WHERE se.COMPTE_AUX IS NOT NULL


    /

        INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1789730465460586', 'Analyse des ventes par produits', 'bar_chart', 'module.jsp?but=vente/vente-analyse.jsp&grouper=idProduitLib', 11, 3, 'MNDN000000010');
