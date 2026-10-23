package stock;

import bean.CGenUtil;
import bean.ResultatEtSomme;
import java.sql.Connection;
import utilitaire.Utilitaire;

public class StockDashboardCpl extends EtatStockParEntree {

    private double valeurStock;
    private double nbArticles; // Changé de int à double pour éviter le type mismatch

    public StockDashboardCpl() {
        this.setNomTable("V_STOCK_DASHBOARD");
    }

    public double getValeurStock() {
        return valeurStock;
    }

    public void setValeurStock(double valeurStock) {
        this.valeurStock = valeurStock;
    }

    public double getNbArticles() {
        return nbArticles;
    }

    public void setNbArticles(double nbArticles) {
        this.nbArticles = nbArticles;
    }

    // Le reste de la classe (rechercherPage et getRequeteValeurStockETquantiteMag) reste identique
    public ResultatEtSomme rechercherPage(String[] colInt, String[]valInt, int numPage, String apresWhere, String[]nomColSomme, Connection c, int npp) throws Exception {
        String daty=Utilitaire.dateDuJour();
        if(valInt!=null&&valInt.length>1) {daty=valInt[1].toString();}
        String req=getRequeteValeurStockETquantiteMag(daty);
        System.out.println(req);
        ResultatEtSomme rs= CGenUtil.rechercherPage(this,req,numPage,nomColSomme,apresWhere,c,npp);
        return rs;
    }

    public static String getRequeteValeurStockETquantiteMag(String daty) {
        return "SELECT\n" +
                "     sub.id,\n" +
                "     sub.idproduit,\n" +
                "     sub.idproduitlib,\n" +
                "     sub.categorieingredient,\n" +
                "     sub.idtypeproduitlib,\n" +
                "     sub.idmagasin,\n" +
                "     sub.idmagasinlib,\n" +
                "     sub.typeStock,\n" +
                "     sub.quantite,\n" +
                "     sub.entree,\n" +
                "     sub.sortie,\n" +
                "     sub.reste,\n" +
                "     sub.unite,\n" +
                "     sub.idunitelib,\n" +
                "     sub.pu,\n" +
                "     sub.daty,\n" +
                "     sub.mvtsrc,\n" +
                "     sub.valeurStock,\n" +
                "     CAST(SUM(sub.quantite) OVER () AS NUMBER(30,2)) AS nbArticles\n" +
                " FROM (\n" +
                "     SELECT\n" +
                "         ve.id,\n" +
                "         ai.id AS idproduit,\n" +
                "         ai.LIBELLE AS idproduitlib,\n" +
                "         ai.CATEGORIEINGREDIENT,\n" +
                "         c.VAL AS idtypeproduitlib,\n" +
                "         ve.IDMAGASIN,\n" +
                "         ai.typeStock,\n" +
                "         m.VAL AS idmagasinlib,\n" +
                "         ve.QUANTITE,\n" +
                "         CAST(ve.ENTREE AS NUMBER(30,2)) AS ENTREE,\n" +
                "         CAST(ve.SORTIE AS NUMBER(30,2)) AS SORTIE,\n" +
                "         CAST(ve.RESTE AS NUMBER(30,2)) AS RESTE,\n" +
                "         ai.UNITE,\n" +
                "         u.VAL AS idunitelib,\n" +
                "         ve.PU,\n" +
                "         ve.DATY,\n" +
                "         ve.MVTSRC,\n" +
                "         (ve.RESTE * ve.PU) AS valeurStock\n" +
                "     FROM (\n" +
                "         SELECT\n" +
                "             \"ID\",\n" +
                "             \"IDMVTSTOCK\",\n" +
                "             \"IDPRODUIT\",\n" +
                "             \"ENTREE\",\n" +
                "             \"SORTIE\",\n" +
                "             \"IDVENTEDETAIL\",\n" +
                "             \"IDTRANSFERTDETAIL\",\n" +
                "             \"PU\",\n" +
                "             \"MVTSRC\",\n" +
                "             \"DATY\",\n" +
                "             \"RESTE\",\n" +
                "             \"QUANTITE\",\n" +
                "             \"IDMAGASIN\",\n" +
                "             \"COMPTELOCALISATION\",\n" +
                "             \"COMPTELOCALISATIONLIB\"\n" +
                "         FROM (\n" +
                "             SELECT\n" +
                "                 m.ID,\n" +
                "                 m.IDMVTSTOCK,\n" +
                "                 m.IDPRODUIT,\n" +
                "                 m.ENTREE,\n" +
                "                 s.SORTIE,\n" +
                "                 m.IDVENTEDETAIL,\n" +
                "                 m.IDTRANSFERTDETAIL,\n" +
                "                 m.PU,\n" +
                "                 m.MVTSRC,\n" +
                "                 mp.DATY,\n" +
                "                 NVL(m.ENTREE, 0) - NVL(s.SORTIE, 0) AS RESTE,\n" +
                "                 NVL(m.ENTREE, 0) - NVL(s.SORTIE, 0) AS QUANTITE,\n" +
                "                 mp.IDMAGASIN,\n" +
                "                 m.COMPTELOCALISATION,\n" +
                "                 loc.LIBELLE AS COMPTELOCALISATIONLIB\n" +
                "             FROM MVTSTOCKFILLE m\n" +
                "             LEFT JOIN MVTSTOCK mp ON mp.id = m.IDMVTSTOCK\n" +
                "             LEFT JOIN LOCALISATION loc ON loc.id = m.COMPTELOCALISATION\n" +
                "             LEFT JOIN (\n" +
                "                 SELECT m.MVTSRC, SUM(m.SORTIE) AS SORTIE\n" +
                "                 FROM MVTSTOCKFILLE m\n" +
                "                 LEFT JOIN MVTSTOCK mp ON mp.id = m.IDMVTSTOCK\n" +
                "                 WHERE mp.ETAT >= 11\n" +
                "                   AND m.MVTSRC IS NOT NULL\n" +
                "                   AND mp.DATY <= TO_DATE('" + daty + "', 'DD-MM-YYYY')\n" +
                "                 GROUP BY m.MVTSRC\n" +
                "             ) s ON s.MVTSRC = m.id\n" +
                "             WHERE m.ENTREE > 0\n" +
                "               AND mp.ETAT >= 11\n" +
                "               AND mp.DATY <= TO_DATE('" + daty + "', 'DD-MM-YYYY')\n" +
                "         )\n" +
                "     ) ve\n" +
                "     LEFT JOIN AS_INGREDIENTS ai ON ai.id = ve.IDPRODUIT\n" +
                "     LEFT JOIN CATEGORIEINGREDIENT c ON ai.CATEGORIEINGREDIENT = c.id\n" +
                "     LEFT JOIN MAGASINPOINT m ON ve.IDMAGASIN = m.id\n" +
                "     LEFT JOIN AS_UNITE u ON ai.UNITE = u.id\n" +
                "     WHERE ve.PU > 0\n" +
                " ) sub";
    }

//    public static String getRequeteValeurStockETquantiteMag(String daty) {
//        return "SELECT\n" +
//                "     sub.id,\n" +
//                "     sub.idproduit,\n" +
//                "     sub.idproduitlib,\n" +
//                "     sub.categorieingredient,\n" +
//                "     sub.idtypeproduitlib,\n" +
//                "     sub.idmagasin,\n" +
//                "     sub.idmagasinlib,\n" +
//                "     sub.quantite,\n" +
//                "     sub.entree,\n" +
//                "     sub.sortie,\n" +
//                "     sub.reste,\n" +
//                "     sub.unite,\n" +
//                "     sub.idunitelib,\n" +
//                "     sub.pu,\n" +
//                "     sub.daty,\n" +
//                "     sub.idfournisseur,\n" +
//                "     sub.idfournisseurlib,\n" +
//                "     sub.dateAchat,\n" +
//                "     sub.valeurStock,\n" +
//                "     CAST(SUM(sub.quantite) OVER () AS NUMBER(30,2)) AS nbArticles\n" + // Modifié pour cohérence
//                " FROM (\n" +
//                "     SELECT DISTINCT\n" +
//                "         ve.id,\n" +
//                "         ai.id AS idproduit,\n" +
//                "         ai.libelle AS idproduitlib,\n" +
//                "         ai.categorieingredient,\n" +
//                "         c.val AS idtypeproduitlib,\n" +
//                "         ve.idmagasin,\n" +
//                "         m.val AS idmagasinlib,\n" +
//                "         ve.quantite,\n" +
//                "         CAST(ve.entree AS NUMBER(30,2)) AS entree,\n" +
//                "         CAST(ve.sortie AS NUMBER(30,2)) AS sortie,\n" +
//                "         CAST(ve.reste AS NUMBER(30,2)) AS reste,\n" +
//                "         ai.unite,\n" +
//                "         u.val AS idunitelib,\n" +
//                "         ve.pu,\n" +
//                "         ve.daty,\n" +
//                "         ve.idfournisseur,\n" +
//                "         f.NOM AS idfournisseurlib,\n" +
//                "         ve.dateAchat,\n" +
//                "         (ve.RESTE * ve.PU) AS valeurStock\n" +
//                "     FROM (\n" +
//                "         SELECT\n" +
//                "             x.*,\n" +
//                "             COALESCE(b.idfournisseur, invf.idfournisseur, bb.IDFOURNISSEUR, trs.idfournisseur) AS idfournisseur,\n" +
//                "             f.DATY AS dateAchat\n" +
//                "         FROM (\n" +
//                "             SELECT\n" +
//                "                 ID,\n" +
//                "                 IDMVTSTOCK,\n" +
//                "                 IDPRODUIT,\n" +
//                "                 ENTREE,\n" +
//                "                 SORTIE,\n" +
//                "                 IDVENTEDETAIL,\n" +
//                "                 IDTRANSFERTDETAIL,\n" +
//                "                 PU,\n" +
//                "                 MVTSRC,\n" +
//                "                 DATY,\n" +
//                "                 RESTE,\n" +
//                "                 QUANTITE,\n" +
//                "                 IDMAGASIN,\n" +
//                "                 IDINVENTAIREFILLE\n" +
//                "             FROM (\n" +
//                "                 SELECT\n" +
//                "                     mf.ID,\n" +
//                "                     mf.IDMVTSTOCK,\n" +
//                "                     mf.IDPRODUIT,\n" +
//                "                     NVL(mf.ENTREE, 0) + NVL(s.ENTREE, 0) AS entree,\n" +
//                "                     s.SORTIE,\n" +
//                "                     mf.IDVENTEDETAIL,\n" +
//                "                     mf.IDTRANSFERTDETAIL,\n" +
//                "                     mf.PU,\n" +
//                "                     mf.MVTSRC,\n" +
//                "                     ms.DATY,\n" +
//                "                     NVL(mf.ENTREE, 0) - NVL(s.SORTIE, 0) + NVL(s.ENTREE, 0) AS RESTE,\n" +
//                "                     NVL(mf.ENTREE, 0) - NVL(s.SORTIE, 0) + NVL(s.ENTREE, 0) AS QUANTITE,\n" +
//                "                     ms.IDMAGASIN,\n" +
//                "                     mf.idinventairefille\n" +
//                "                 FROM MVTSTOCKFILLE mf\n" +
//                "                 LEFT JOIN MVTSTOCK ms ON ms.id = mf.IDMVTSTOCK\n" +
//                "                 LEFT JOIN (\n" +
//                "                     SELECT mf2.MVTSRC, SUM(mf2.SORTIE) AS SORTIE, SUM(mf2.ENTREE) AS ENTREE\n" +
//                "                     FROM MVTSTOCKFILLE mf2\n" +
//                "                     LEFT JOIN MVTSTOCK ms2 ON ms2.id = mf2.IDMVTSTOCK\n" +
//                "                     WHERE ms2.ETAT >= 11\n" +
//                "                       AND mf2.MVTSRC IS NOT NULL\n" +
//                "                       AND ms2.DATY <= TO_DATE('" + daty + "', 'DD-MM-YYYY')\n" +
//                "                     GROUP BY mf2.MVTSRC\n" +
//                "                 ) s ON s.MVTSRC = mf.id\n" +
//                "                 WHERE mf.ENTREE > 0 AND (mf.MVTSRC IS NULL OR mf.MVTSRC = mf.id)\n" +
//                "                   AND ms.ETAT >= 11\n" +
//                "                   AND ms.DATY <= TO_DATE('" + daty + "', 'DD-MM-YYYY')\n" +
//                "             )\n" +
//                "         ) x\n" +
//                "         LEFT JOIN MVTSTOCK ms               ON ms.id = x.IDMVTSTOCK\n" +
//                "         LEFT JOIN AS_BONDELIVRAISON b        ON b.ID = ms.IDOBJET\n" +
//                "         LEFT JOIN AS_BONDELIVRAISON bb       ON b.ID = ms.IDTRANSFERT\n" +
//                "         LEFT JOIN FACTUREFOURNISSEUR f       ON f.id = b.IDFACTUREFOURNISSEUR\n" +
//                "         LEFT JOIN INVENTAIREFILLE invf       ON invf.id = x.IDINVENTAIREFILLE\n" +
//                "         LEFT JOIN TRANSFERTSTOCKDETAILS trs  ON trs.id = x.IDTRANSFERTDETAIL\n" +
//                "         WHERE b.IDFOURNISSEUR IS NOT NULL\n" +
//                "            OR invf.IDFOURNISSEUR IS NOT NULL\n" +
//                "            OR bb.IDFOURNISSEUR IS NOT NULL\n" +
//                "            OR trs.idfournisseur IS NOT NULL\n" +
//                "     ) ve\n" +
//                "     LEFT JOIN AS_INGREDIENTS ai     ON ai.id = ve.IDPRODUIT\n" +
//                "     LEFT JOIN CATEGORIEINGREDIENT c ON ai.CATEGORIEINGREDIENT = c.id\n" +
//                "     LEFT JOIN MAGASINPOINT m        ON ve.IDMAGASIN = m.id\n" +
//                "     LEFT JOIN AS_UNITE u            ON ai.UNITE = u.id\n" +
//                "     LEFT JOIN FOURNISSEUR f         ON f.ID = ve.idfournisseur\n" +
//                "     WHERE ve.PU > 0\n" +
//                " ) sub";
//    }
}