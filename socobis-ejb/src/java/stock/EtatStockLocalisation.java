package stock;

import bean.CGenUtil;
import bean.ResultatEtSomme;
import utilitaire.Utilitaire;

import java.sql.Connection;

public class EtatStockLocalisation extends EtatStock {

    public EtatStockLocalisation(){
        this.setNomTable("V_ETATSTOCK_LOCALISATION");
    }

    public ResultatEtSomme rechercherPage(String[] colInt, String[]valInt, int numPage, String apresWhere, String[]nomColSomme, Connection c, int npp) throws Exception {
        String daty = Utilitaire.dateDuJour();
        if(valInt != null && valInt.length>1) {
            daty = valInt[1];
        }
        String req = getRequeteEtatStockLocalisation(daty);
        return CGenUtil.rechercherPage(this,req,numPage,nomColSomme,apresWhere,c,npp);
    }

    public static String getRequeteEtatStockLocalisation(String daty) {
        String requete = "WITH max_inventaire AS (\n" +
            "    SELECT\n" +
            "        invff.IDPRODUIT,\n" +
            "        imeref.IDMAGASIN,\n" +
            "        invff.COMPTELOCALISATION,\n" +
            "        MAX(imeref.DATY) AS max_daty,\n" +
            "        MAX(invff.QUANTITE) KEEP (DENSE_RANK LAST ORDER BY imeref.DATY) AS qte_max_daty,\n" +
            "        MAX(invff.pu) KEEP (DENSE_RANK LAST ORDER BY imeref.DATY) AS pu_max_daty\n" +
            "    FROM INVENTAIREFILLE invff\n" +
            "             LEFT JOIN inventaireDateHeure imeref ON imeref.ID = invff.IDINVENTAIRE\n" +
            "    WHERE imeref.ETAT >= 11 and imeref.DATY< to_date('"+daty+"','DD-MM-YYYY') + 1\n" +
            "    GROUP BY invff.IDPRODUIT, imeref.IDMAGASIN, invff.COMPTELOCALISATION\n" +
            "),\n" +
            "     somme_precalc AS (\n" +
            "         SELECT\n" +
            "             mff.idproduit as idproduit,\n" +
            "             meref.idmagasin as idmagasin,\n" +
            "             mff.COMPTELOCALISATION as compteLocalisation,\n" +
            "             NVL(SUM(CASE WHEN meref.DATY > NVL(inv.max_daty, TO_DATE('01/01/2025','DD-MM-YYYY')) THEN mff.ENTREE ELSE 0 END), 0) AS entree,\n" +
            "             NVL(SUM(CASE WHEN meref.DATY > NVL(inv.max_daty, TO_DATE('01/01/2025','DD-MM-YYYY')) THEN mff.SORTIE ELSE 0 END), 0) AS sortie,\n" +
            "             ai.LIBELLE AS idproduitlib,\n" +
            "             ai.CATEGORIEINGREDIENT as CATEGORIEINGREDIENT,\n" +
            "             ai.UNITE as unite,\n" +
            "             ai.TYPESTOCK as typestock,\n" +
            "             u.VAL AS idunitelib,\n" +
            "             c.VAL AS idtypeproduitlib,\n" +
            "             avg(mff.PU) as pu,\n" +
            "             null as IDFOURNISSEUR,\n" +
            "             null as IDFOURNISSEURLIB,\n" +
            "             m.VAL AS idmagasinlib,\n" +
            "             loc.LIBELLE AS COMPTELOCALISATIONLIB,\n" +
            "             max(inv.max_daty) AS invdaty,\n" +
            "             nvl(max(inv.qte_max_daty),0) as invquantite,\n" +
            "             NVL(SUM(CASE WHEN meref.DATY > NVL(inv.max_daty, TO_DATE('01/01/2025','DD-MM-YYYY')) THEN mff.ENTREE*mff.pu ELSE 0 END), 0) AS montantEntree,\n" +
            "             NVL(SUM(CASE WHEN meref.DATY > NVL(inv.max_daty, TO_DATE('01/01/2025','DD-MM-YYYY')) THEN mff.SORTIE*mff.pu ELSE 0 END), 0) AS montantSortie,\n" +
            "             nvl(avg(inv.pu_max_daty*inv.qte_max_daty),0) as montantInv,\n" +
            "             nvl(max(ai.SEUIL),0) as seuil,\n" +
            "             nvl(max(ai.SEUILMAX),\n" +
            "             nvl(max(ai.SEUILMIN),0)+1000) as seuilmax,\n" +
            "             nvl(max(ai.SEUILMIN),0) as seuilMin,\n" +
            "             ai.PARFUMS as codeproduit,\n" +
            "             m.IDDEPARTEMENT,\n" +
            "             d.val as departementlib\n" +
            "         FROM MVTSTOCKFILLE mff\n" +
            "                  LEFT JOIN mvtStockDateHeure meref ON meref.ID = mff.IDMVTSTOCK\n" +
            "                  LEFT JOIN max_inventaire inv ON inv.idproduit = mff.idproduit\n" +
            "                           AND inv.idmagasin = meref.idmagasin\n" +
            "                           AND inv.COMPTELOCALISATION = mff.COMPTELOCALISATION\n" +
            "                  LEFT JOIN AS_INGREDIENTS ai ON ai.id = mff.IDPRODUIT\n" +
            "                  LEFT JOIN CATEGORIEINGREDIENT c ON ai.CATEGORIEINGREDIENT = c.id\n" +
            "                  LEFT JOIN MAGASINPOINT m ON meref.IDMAGASIN = m.id\n" +
            "                  LEFT JOIN AS_UNITE u ON ai.UNITE = u.id\n" +
            "                  LEFT JOIN LOCALISATION loc ON loc.id = mff.COMPTELOCALISATION\n" +
            "                  LEFT JOIN DEPARTEMENT d ON d.ID = m.IDDEPARTEMENT\n" +
            "         WHERE meref.ETAT >= 11 AND meref.IDTYPEMVSTOCK != 'TPMVST000023'\n" +
            "             and meref.DATY< to_date('"+daty+"','DD-MM-YYYY') + 1\n" +
            "         GROUP BY mff.idproduit, meref.idmagasin, mff.COMPTELOCALISATION,\n" +
            "                  ai.LIBELLE, ai.CATEGORIEINGREDIENT, ai.UNITE, ai.TYPESTOCK,\n" +
            "                  u.VAL, c.VAL, m.VAL, loc.LIBELLE,\n" +
            "                  ai.PARFUMS, m.IDDEPARTEMENT, d.val\n" +
            "     )\n" +
            "SELECT\n" +
            "    null as ID, null as DATY,\n" +
            "    cast(invquantite as number(30,3)) as invquantite,\n" +
            "    cast(entree as number(30,3)) as entree,\n" +
            "    cast(sortie as number(30,3)) as sortie,\n" +
            "    CAST((invquantite)+(ENTREE)-(sortie) AS NUMBER(30,3)) as reste,\n" +
            "    CAST(invquantite+ENTREE-sortie AS NUMBER(30,3)) AS quantite,\n" +
            "    CAST((montantInv+montantEntree-montantSortie) AS NUMBER(30,2)) AS montantreste,\n" +
            "    cast((montantInv+montantEntree-montantSortie)/(invquantite+ENTREE-sortie) as number(30,2)) as pu,\n" +
            "    idproduitlib, CATEGORIEINGREDIENT, UNITE, TYPESTOCK, idunitelib, idtypeproduitlib,\n" +
            "    IDFOURNISSEUR, IDFOURNISSEURLIB, IDPRODUIT, IDMAGASIN, idmagasinlib,\n" +
            "    compteLocalisation, COMPTELOCALISATIONLIB,\n" +
            "    invdaty, codeproduit, IDDEPARTEMENT, departementlib\n" +
            "FROM somme_precalc\n" +
            "WHERE invquantite+ENTREE-sortie != 0";
        String requeteFinale = "WITH max_inventaire AS (\n" +
            "    SELECT\n" +
            "        invff.IDPRODUIT,\n" +
            "        imeref.IDMAGASIN,\n" +
            "        invff.COMPTELOCALISATION,\n" +
            "        MAX(imeref.DATY) AS max_daty,\n" +
            "        MAX(invff.QUANTITE) KEEP (DENSE_RANK LAST ORDER BY imeref.DATY) AS qte_max_daty,\n" +
            "        MAX(invff.pu) KEEP (DENSE_RANK LAST ORDER BY imeref.DATY) AS pu_max_daty\n" +
            "    FROM INVENTAIREFILLE invff\n" +
            "    LEFT JOIN inventaireDateHeure imeref ON imeref.ID = invff.IDINVENTAIRE\n" +
            "    WHERE imeref.ETAT >= 11 and imeref.DATY< to_date('"+daty+"','DD-MM-YYYY') + 1\n" +
            "    GROUP BY invff.IDPRODUIT, imeref.IDMAGASIN, invff.COMPTELOCALISATION\n" +
            "),\n" +
            "    mouvements AS (\n" +
            "        SELECT\n" +
            "            mff.idproduit,\n" +
            "            meref.idmagasin,\n" +
            "            mff.COMPTELOCALISATION,\n" +
            "            NVL(SUM(CASE WHEN meref.DATY > NVL(inv.max_daty, TO_DATE('01/01/2025','DD-MM-YYYY')) THEN mff.ENTREE ELSE 0 END), 0) AS entree,\n" +
            "            NVL(SUM(CASE WHEN meref.DATY > NVL(inv.max_daty, TO_DATE('01/01/2025','DD-MM-YYYY')) THEN mff.SORTIE ELSE 0 END), 0) AS sortie,\n" +
            "            avg(mff.PU) as pu,\n" +
            "            NVL(SUM(CASE WHEN meref.DATY > NVL(inv.max_daty, TO_DATE('01/01/2025','DD-MM-YYYY')) THEN mff.ENTREE*mff.pu ELSE 0 END), 0) AS montantEntree,\n" +
            "            NVL(SUM(CASE WHEN meref.DATY > NVL(inv.max_daty, TO_DATE('01/01/2025','DD-MM-YYYY')) THEN mff.SORTIE*mff.pu ELSE 0 END), 0) AS montantSortie\n" +
            "        FROM MVTSTOCKFILLE mff\n" +
            "        LEFT JOIN mvtStockDateHeure meref ON meref.ID = mff.IDMVTSTOCK\n" +
            "        LEFT JOIN max_inventaire inv ON inv.idproduit = mff.idproduit\n" +
            "        AND inv.idmagasin = meref.idmagasin\n" +
            "        AND inv.COMPTELOCALISATION = mff.COMPTELOCALISATION\n" +
            "        WHERE meref.ETAT >= 11 AND meref.IDTYPEMVSTOCK != 'TPMVST000023'\n" +
            "            and meref.DATY< to_date('"+daty+"','DD-MM-YYYY') + 1\n" +
            "        GROUP BY mff.idproduit, meref.idmagasin, mff.COMPTELOCALISATION\n" +
            "     ),\n" +
            "    somme_precalc AS (\n" +
            "        SELECT\n" +
            "            NVL(mv.idproduit, inv.idproduit) as idproduit,\n" +
            "            NVL(mv.idmagasin, inv.idmagasin) as idmagasin,\n" +
            "            NVL(mv.COMPTELOCALISATION, inv.COMPTELOCALISATION) as compteLocalisation,\n" +
            "            NVL(mv.entree, 0) AS entree,\n" +
            "            NVL(mv.sortie, 0) AS sortie,\n" +
            "            ai.LIBELLE AS idproduitlib,\n" +
            "            ai.CATEGORIEINGREDIENT as CATEGORIEINGREDIENT,\n" +
            "            ai.UNITE as unite,\n" +
            "            ai.TYPESTOCK as typestock,\n" +
            "            u.VAL AS idunitelib,\n" +
            "            c.VAL AS idtypeproduitlib,\n" +
            "            mv.pu,\n" +
            "            null as IDFOURNISSEUR,\n" +
            "            null as IDFOURNISSEURLIB,\n" +
            "            m.VAL AS idmagasinlib,\n" +
            "            loc.LIBELLE AS COMPTELOCALISATIONLIB,\n" +
            "            inv.max_daty AS invdaty,\n" +
            "            nvl(inv.qte_max_daty,0) as invquantite,\n" +
            "            NVL(mv.montantEntree, 0) AS montantEntree,\n" +
            "            NVL(mv.montantSortie, 0) AS montantSortie,\n" +
            "            nvl(inv.pu_max_daty * inv.qte_max_daty,0) as montantInv,\n" +
            "            nvl(ai.SEUIL,0) as seuil,\n" +
            "            nvl(ai.SEUILMAX,\n" +
            "            nvl(ai.SEUILMIN,0)+1000) as seuilmax,\n" +
            "            nvl(ai.SEUILMIN,0) as seuilMin,\n" +
            "            ai.PARFUMS as codeproduit,\n" +
            "            m.IDDEPARTEMENT,\n" +
            "            d.val as departementlib\n" +
            "        FROM mouvements mv\n" +
            "        FULL OUTER JOIN max_inventaire inv ON inv.idproduit = mv.idproduit\n" +
            "            AND inv.idmagasin = mv.idmagasin\n" +
            "            AND inv.COMPTELOCALISATION = mv.COMPTELOCALISATION\n" +
            "        LEFT JOIN AS_INGREDIENTS ai ON ai.id = NVL(mv.IDPRODUIT, inv.IDPRODUIT)\n" +
            "        LEFT JOIN CATEGORIEINGREDIENT c ON ai.CATEGORIEINGREDIENT = c.id\n" +
            "        LEFT JOIN MAGASINPOINT m ON m.id = NVL(mv.IDMAGASIN, inv.IDMAGASIN)\n" +
            "        LEFT JOIN AS_UNITE u ON ai.UNITE = u.id\n" +
            "        LEFT JOIN LOCALISATION loc ON loc.id = NVL(mv.COMPTELOCALISATION, inv.COMPTELOCALISATION)\n" +
            "        LEFT JOIN DEPARTEMENT d ON d.ID = m.IDDEPARTEMENT\n" +
            "    )\n" +
            "SELECT\n" +
            "    null as ID, null as DATY,\n" +
            "    cast(invquantite as number(30,3)) as invquantite,\n" +
            "    cast(entree as number(30,3)) as entree,\n" +
            "    cast(sortie as number(30,3)) as sortie,\n" +
            "    CAST((invquantite)+(ENTREE)-(sortie) AS NUMBER(30,3)) as reste,\n" +
            "    CAST(invquantite+ENTREE-sortie AS NUMBER(30,3)) AS quantite,\n" +
            "    CAST((montantInv+montantEntree-montantSortie) AS NUMBER(30,2)) AS montantreste,\n" +
            "    cast((montantInv+montantEntree-montantSortie)/(invquantite+ENTREE-sortie) as number(30,2)) as pu,\n" +
            "    idproduitlib, CATEGORIEINGREDIENT, UNITE, TYPESTOCK, idunitelib, idtypeproduitlib,\n" +
            "    IDFOURNISSEUR, IDFOURNISSEURLIB, IDPRODUIT, IDMAGASIN, idmagasinlib,\n" +
            "    compteLocalisation, COMPTELOCALISATIONLIB,\n" +
            "    invdaty, codeproduit, IDDEPARTEMENT, departementlib\n" +
            "FROM somme_precalc\n" +
            "WHERE invquantite+ENTREE-sortie != 0";
//        return requeteFinale;
        String req = "WITH max_inventaire AS (\n" +
            "    SELECT\n" +
            "        invff.IDPRODUIT,\n" +
            "        imeref.IDMAGASIN,\n" +
            "        invff.COMPTELOCALISATION,\n" +
            "        CASE WHEN ai.TYPESTOCK = 'CUMP' THEN '#'\n" +
            "             ELSE NVL(invff.MVTSRC, '#') END AS MVTSRC,\n" +
            "        MAX(imeref.DATY) AS max_daty,\n" +
            "        MAX(invff.QUANTITE) KEEP (DENSE_RANK LAST ORDER BY imeref.DATY) AS qte_max_daty,\n" +
            "        MAX(invff.pu) KEEP (DENSE_RANK LAST ORDER BY imeref.DATY) AS pu_max_daty\n" +
            "    FROM INVENTAIREFILLE invff\n" +
            "    LEFT JOIN inventaireDateHeure imeref ON imeref.ID = invff.IDINVENTAIRE\n" +
            "    LEFT JOIN AS_INGREDIENTS ai ON ai.id = invff.IDPRODUIT\n" +
            "    WHERE imeref.ETAT >= 11 and imeref.DATY< to_date('"+daty+"','DD-MM-YYYY') + 1\n" +
            "    GROUP BY invff.IDPRODUIT, imeref.IDMAGASIN, invff.COMPTELOCALISATION,\n" +
            "             CASE WHEN ai.TYPESTOCK = 'CUMP' THEN '#'\n" +
            "                  ELSE NVL(invff.MVTSRC, '#') END\n" +
            "),\n" +
            "mouvements AS (\n" +
            "    SELECT\n" +
            "        mff.idproduit,\n" +
            "        meref.idmagasin,\n" +
            "        mff.COMPTELOCALISATION,\n" +
            "        CASE WHEN ai.TYPESTOCK = 'CUMP' THEN '#'\n" +
            "             ELSE NVL(mff.MVTSRC, mff.ID) END AS MVTSRC,\n" +
            "        NVL(SUM(CASE WHEN meref.DATY > NVL(inv.max_daty, TO_DATE('01/01/2025','DD/MM/YYYY')) THEN mff.ENTREE ELSE 0 END), 0) AS entree,\n" +
            "        NVL(SUM(CASE WHEN meref.DATY > NVL(inv.max_daty, TO_DATE('01/01/2025','DD/MM/YYYY')) THEN mff.SORTIE ELSE 0 END), 0) AS sortie,\n" +
            "        NVL(SUM(CASE WHEN meref.DATY > NVL(inv.max_daty, TO_DATE('01/01/2025','DD/MM/YYYY')) THEN mff.ENTREE*mff.pu ELSE 0 END), 0) AS montantEntree,\n" +
            "        NVL(SUM(CASE WHEN meref.DATY > NVL(inv.max_daty, TO_DATE('01/01/2025','DD/MM/YYYY')) THEN mff.SORTIE*mff.pu ELSE 0 END), 0) AS montantSortie\n" +
            "    FROM MVTSTOCKFILLE mff\n" +
            "    LEFT JOIN mvtStockDateHeure meref ON meref.ID = mff.IDMVTSTOCK\n" +
            "    LEFT JOIN AS_INGREDIENTS ai ON ai.id = mff.idproduit\n" +
            "    LEFT JOIN max_inventaire inv\n" +
            "           ON inv.idproduit = mff.idproduit\n" +
            "          AND inv.idmagasin = meref.idmagasin\n" +
            "          AND inv.COMPTELOCALISATION = mff.COMPTELOCALISATION\n" +
            "          AND inv.MVTSRC = CASE WHEN ai.TYPESTOCK = 'CUMP' THEN '#'\n" +
            "                                ELSE NVL(mff.MVTSRC, mff.ID) END\n" +
            "    WHERE meref.ETAT >= 11 AND meref.IDTYPEMVSTOCK != 'TPMVST000023'\n" +
            "       and meref.DATY< to_date('"+daty+"','DD-MM-YYYY') + 1\n" +
            "    GROUP BY mff.idproduit, meref.idmagasin, mff.COMPTELOCALISATION,\n" +
            "             CASE WHEN ai.TYPESTOCK = 'CUMP' THEN '#'\n" +
            "                  ELSE NVL(mff.MVTSRC, mff.ID) END\n" +
            "),\n" +
            "par_lot AS (\n" +
            "    SELECT\n" +
            "        NVL(mv.idproduit, inv.idproduit) AS idproduit,\n" +
            "        NVL(mv.idmagasin, inv.idmagasin) AS idmagasin,\n" +
            "        NVL(mv.COMPTELOCALISATION, inv.COMPTELOCALISATION) AS compteLocalisation,\n" +
            "        NVL(mv.entree, 0) AS entree,\n" +
            "        NVL(mv.sortie, 0) AS sortie,\n" +
            "        inv.max_daty AS invdaty,\n" +
            "        NVL(inv.qte_max_daty, 0) AS invquantite,\n" +
            "        NVL(mv.montantEntree, 0) AS montantEntree,\n" +
            "        NVL(mv.montantSortie, 0) AS montantSortie,\n" +
            "        NVL(inv.pu_max_daty * inv.qte_max_daty, 0) AS montantInv\n" +
            "    FROM mouvements mv\n" +
            "    FULL OUTER JOIN max_inventaire inv\n" +
            "           ON inv.idproduit = mv.idproduit\n" +
            "          AND inv.idmagasin = mv.idmagasin\n" +
            "          AND inv.COMPTELOCALISATION = mv.COMPTELOCALISATION\n" +
            "          AND inv.MVTSRC = mv.MVTSRC\n" +
            "),\n" +
            "somme_precalc AS (\n" +
            "    SELECT\n" +
            "        idproduit, idmagasin, compteLocalisation,\n" +
            "        SUM(entree) AS entree,\n" +
            "        SUM(sortie) AS sortie,\n" +
            "        MAX(invdaty) AS invdaty,\n" +
            "        SUM(invquantite) AS invquantite,\n" +
            "        SUM(montantEntree) AS montantEntree,\n" +
            "        SUM(montantSortie) AS montantSortie,\n" +
            "        SUM(montantInv) AS montantInv\n" +
            "    FROM par_lot\n" +
            "    GROUP BY idproduit, idmagasin, compteLocalisation\n" +
            "),\n" +
            "detail AS (\n" +
            "    SELECT\n" +
            "        s.idproduit, s.idmagasin, s.compteLocalisation,\n" +
            "        s.entree, s.sortie, s.invdaty, s.invquantite,\n" +
            "        s.montantEntree, s.montantSortie, s.montantInv,\n" +
            "        ai.LIBELLE AS idproduitlib,\n" +
            "        ai.CATEGORIEINGREDIENT AS CATEGORIEINGREDIENT,\n" +
            "        ai.UNITE AS unite,\n" +
            "        ai.TYPESTOCK AS typestock,\n" +
            "        u.VAL AS idunitelib,\n" +
            "        c.VAL AS idtypeproduitlib,\n" +
            "        null AS IDFOURNISSEUR,\n" +
            "        null AS IDFOURNISSEURLIB,\n" +
            "        m.VAL AS idmagasinlib,\n" +
            "        loc.LIBELLE AS COMPTELOCALISATIONLIB,\n" +
            "        ai.PARFUMS AS codeproduit,\n" +
            "        m.IDDEPARTEMENT,\n" +
            "        d.val AS departementlib\n" +
            "    FROM somme_precalc s\n" +
            "    LEFT JOIN AS_INGREDIENTS ai ON ai.id = s.idproduit\n" +
            "    LEFT JOIN CATEGORIEINGREDIENT c ON ai.CATEGORIEINGREDIENT = c.id\n" +
            "    LEFT JOIN MAGASINPOINT m ON m.id = s.idmagasin\n" +
            "    LEFT JOIN AS_UNITE u ON ai.UNITE = u.id\n" +
            "    LEFT JOIN LOCALISATION loc ON loc.id = s.compteLocalisation\n" +
            "    LEFT JOIN DEPARTEMENT d ON d.ID = m.IDDEPARTEMENT\n" +
            ")\n" +
            "SELECT\n" +
            "    null AS ID, null AS DATY,\n" +
            "    CAST(invquantite AS NUMBER(30,3)) AS invquantite,\n" +
            "    CAST(entree AS NUMBER(30,3)) AS entree,\n" +
            "    CAST(sortie AS NUMBER(30,3)) AS sortie,\n" +
            "    CAST(invquantite + entree - sortie AS NUMBER(30,3)) AS reste,\n" +
            "    CAST(invquantite + entree - sortie AS NUMBER(30,3)) AS quantite,\n" +
            "    CAST(montantInv + montantEntree - montantSortie AS NUMBER(30,2)) AS montantreste,\n" +
            "    CAST((montantInv + montantEntree - montantSortie) / (invquantite + entree - sortie) AS NUMBER(30,2)) AS pu,\n" +
            "    idproduitlib, CATEGORIEINGREDIENT, UNITE, TYPESTOCK, idunitelib, idtypeproduitlib,\n" +
            "    IDFOURNISSEUR, IDFOURNISSEURLIB, IDPRODUIT, IDMAGASIN, idmagasinlib,\n" +
            "    compteLocalisation, COMPTELOCALISATIONLIB,\n" +
            "    invdaty, codeproduit, IDDEPARTEMENT, departementlib\n" +
            "FROM detail\n" +
            "WHERE invquantite + entree - sortie != 0";
//        return req;
        String reqFinale = "WITH max_inventaire AS (\n" +
            "    SELECT\n" +
            "        invff.IDPRODUIT,\n" +
            "        imeref.IDMAGASIN,\n" +
            "        invff.COMPTELOCALISATION,\n" +
            "        CASE WHEN ai.TYPESTOCK = 'CUMP' THEN '#'\n" +
            "             ELSE NVL(invff.MVTSRC, '#') END AS MVTSRC,\n" +
            "        MAX(imeref.DATY) AS max_daty,\n" +
            "        MAX(invff.QUANTITE) KEEP (DENSE_RANK LAST ORDER BY imeref.DATY) AS qte_max_daty,\n" +
            "        MAX(invff.pu)       KEEP (DENSE_RANK LAST ORDER BY imeref.DATY) AS pu_max_daty\n" +
            "    FROM INVENTAIREFILLE invff\n" +
            "    JOIN inventaireDateHeure imeref ON imeref.ID = invff.IDINVENTAIRE\n" +
            "    LEFT JOIN AS_INGREDIENTS ai ON ai.id = invff.IDPRODUIT\n" +
            "    WHERE imeref.ETAT >= 11\n" +
            "       and imeref.DATY< to_date('"+daty+"','DD-MM-YYYY') + 1\n" +
            "    GROUP BY invff.IDPRODUIT, imeref.IDMAGASIN, invff.COMPTELOCALISATION,\n" +
            "             CASE WHEN ai.TYPESTOCK = 'CUMP' THEN '#'\n" +
            "                  ELSE NVL(invff.MVTSRC, '#') END\n" +
            "),\n" +
            "mouvements AS (\n" +
            "    SELECT\n" +
            "        mff.idproduit,\n" +
            "        meref.idmagasin,\n" +
            "        mff.COMPTELOCALISATION,\n" +
            "        SUM(CASE WHEN meref.DATY > NVL(inv.max_daty, DATE '2025-01-01') THEN mff.ENTREE ELSE 0 END)        AS entree,\n" +
            "        SUM(CASE WHEN meref.DATY > NVL(inv.max_daty, DATE '2025-01-01') THEN mff.SORTIE ELSE 0 END)        AS sortie,\n" +
            "        SUM(CASE WHEN meref.DATY > NVL(inv.max_daty, DATE '2025-01-01') THEN mff.ENTREE * mff.pu ELSE 0 END) AS montantEntree,\n" +
            "        SUM(CASE WHEN meref.DATY > NVL(inv.max_daty, DATE '2025-01-01') THEN mff.SORTIE * mff.pu ELSE 0 END) AS montantSortie\n" +
            "    FROM MVTSTOCKFILLE mff\n" +
            "    JOIN mvtStockDateHeure meref ON meref.ID = mff.IDMVTSTOCK\n" +
            "    LEFT JOIN AS_INGREDIENTS ai ON ai.id = mff.idproduit\n" +
            "    LEFT JOIN max_inventaire inv\n" +
            "           ON inv.idproduit = mff.idproduit\n" +
            "          AND inv.idmagasin = meref.idmagasin\n" +
            "          AND inv.COMPTELOCALISATION = mff.COMPTELOCALISATION\n" +
            "          AND inv.MVTSRC = CASE WHEN ai.TYPESTOCK = 'CUMP' THEN '#'\n" +
            "                                ELSE NVL(mff.MVTSRC, mff.ID) END\n" +
            "    WHERE meref.ETAT >= 11\n" +
            "       and meref.DATY< to_date('"+daty+"','DD-MM-YYYY') + 1\n" +
            "      AND meref.IDTYPEMVSTOCK != 'TPMVST000023'\n" +
            "    GROUP BY mff.idproduit, meref.idmagasin, mff.COMPTELOCALISATION\n" +
            "),\n" +
            "lignes AS (\n" +
            "    SELECT idproduit, idmagasin, COMPTELOCALISATION,\n" +
            "           entree, sortie, 0 AS invquantite,\n" +
            "           montantEntree, montantSortie, 0 AS montantInv,\n" +
            "           CAST(NULL AS DATE) AS invdaty\n" +
            "    FROM mouvements\n" +
            "    UNION ALL\n" +
            "    SELECT idproduit, idmagasin, COMPTELOCALISATION,\n" +
            "           0, 0, NVL(qte_max_daty, 0),\n" +
            "           0, 0, NVL(pu_max_daty * qte_max_daty, 0),\n" +
            "           max_daty\n" +
            "    FROM max_inventaire\n" +
            "),\n" +
            "somme_precalc AS (\n" +
            "    SELECT idproduit, idmagasin, COMPTELOCALISATION AS compteLocalisation,\n" +
            "        SUM(entree) AS entree, SUM(sortie) AS sortie,\n" +
            "        MAX(invdaty) AS invdaty, SUM(invquantite) AS invquantite,\n" +
            "        SUM(montantEntree) AS montantEntree,\n" +
            "        SUM(montantSortie) AS montantSortie,\n" +
            "        SUM(montantInv) AS montantInv\n" +
            "    FROM lignes\n" +
            "    GROUP BY idproduit, idmagasin, COMPTELOCALISATION\n" +
            "    HAVING SUM(invquantite) + SUM(entree) - SUM(sortie) != 0\n" +
            "),\n" +
            "detail AS (\n" +
            "    SELECT\n" +
            "        s.idproduit, s.idmagasin, s.compteLocalisation,\n" +
            "        s.entree, s.sortie, s.invdaty, s.invquantite,\n" +
            "        s.montantEntree, s.montantSortie, s.montantInv,\n" +
            "        ai.LIBELLE AS idproduitlib,\n" +
            "        ai.CATEGORIEINGREDIENT AS CATEGORIEINGREDIENT,\n" +
            "        ai.UNITE AS unite,\n" +
            "        ai.TYPESTOCK AS typestock,\n" +
            "        u.VAL AS idunitelib,\n" +
            "        c.VAL AS idtypeproduitlib,\n" +
            "        null AS IDFOURNISSEUR,\n" +
            "        null AS IDFOURNISSEURLIB,\n" +
            "        m.IDMAGASINLIB AS idmagasinlib,\n" +
            "        loc.LIBELLE AS COMPTELOCALISATIONLIB,\n" +
            "        ai.PARFUMS AS codeproduit,\n" +
            "        m.IDDIRECTION as IDDEPARTEMENT,\n" +
            "        m.IDDIRECTIONLIB AS departementlib\n" +
            "    FROM somme_precalc s\n" +
            "    LEFT JOIN AS_INGREDIENTS ai ON ai.id = s.idproduit\n" +
            "    LEFT JOIN CATEGORIEINGREDIENT c ON ai.CATEGORIEINGREDIENT = c.id\n" +
            "    LEFT JOIN DIRECTIONMAGASINLIB m ON m.IDMAGASIN = s.idmagasin\n" +
            "    LEFT JOIN AS_UNITE u ON ai.UNITE = u.id\n" +
            "    LEFT JOIN LOCALISATION loc ON loc.id = s.compteLocalisation" +
            ")\n" +
            "SELECT\n" +
            "    null AS ID, null AS DATY,\n" +
            "    CAST(invquantite AS NUMBER(30,3)) AS invquantite,\n" +
            "    CAST(entree AS NUMBER(30,3)) AS entree,\n" +
            "    CAST(sortie AS NUMBER(30,3)) AS sortie,\n" +
            "    CAST(invquantite + entree - sortie AS NUMBER(30,3)) AS reste,\n" +
            "    CAST(invquantite + entree - sortie AS NUMBER(30,3)) AS quantite,\n" +
            "    CAST(montantInv + montantEntree - montantSortie AS NUMBER(30,2)) AS montantreste,\n" +
            "    CAST((montantInv + montantEntree - montantSortie)\n" +
            "         / NULLIF(invquantite + entree - sortie, 0) AS NUMBER(30,2)) AS pu,\n" +
            "    idproduitlib, CATEGORIEINGREDIENT, UNITE, TYPESTOCK, idunitelib, idtypeproduitlib,\n" +
            "    IDFOURNISSEUR, IDFOURNISSEURLIB, IDPRODUIT, IDMAGASIN, idmagasinlib,\n" +
            "    compteLocalisation, COMPTELOCALISATIONLIB,\n" +
            "    invdaty, codeproduit, IDDEPARTEMENT, departementlib\n" +
            "FROM detail";
        return reqFinale;
    }
}
