package stock;


import bean.CGenUtil;
import bean.ClassMAPTable;

import java.sql.Connection;
import java.sql.Date;
import java.text.SimpleDateFormat;

import bean.ResultatEtSomme;
import utilitaire.Utilitaire;

public class EtatStockParEntree extends EtatStock {
    protected String idProduit;
    private String idFournisseur;
    private String idFournisseurLib , typeStock;
    private Date dateAchat;

    public String getTypeStock() {
        return typeStock;
    }

    public void setTypeStock(String typeStock) {
        this.typeStock = typeStock;
    }

    public String getIdProduit() {
        return idProduit;
    }

    public void setIdProduit(String idProduit) {
        this.idProduit = idProduit;
    }

    public String getIdFournisseur() {
        return idFournisseur;
    }

    public void setIdFournisseur(String idFournisseur) {
        this.idFournisseur = idFournisseur;
    }

    public String getIdFournisseurLib() {
        return idFournisseurLib;
    }

    public void setIdFournisseurLib(String idFournisseurLib) {
        this.idFournisseurLib = idFournisseurLib;
    }

    public Date getDateAchat() {
        return dateAchat;
    }

    public void setDateAchat(Date dateAchat) {
        this.dateAchat = dateAchat;
    }

    public EtatStockParEntree(){
        this.setNomTable("V_ETATSTOCK_ENTREE");
    }

  public ResultatEtSomme rechercherPage(String[] colInt, String[]valInt, int numPage, String apresWhere, String[]nomColSomme, Connection c, int npp) throws Exception {
        String daty=Utilitaire.dateDuJour();
        //ajouter fournisseur, et date d'achat
        if(valInt!=null&&valInt.length>1) {daty=valInt[1].toString();}
        /*String req = "SELECT\n" +
                "   ve.id,\n" +
                "   ai.id AS IDPRODUIT,\n" +
                "   ai.LIBELLE AS idproduitlib,\n" +
                "   ai.CATEGORIEINGREDIENT,\n" +
                "   c.VAL AS idtypeproduitlib,\n" +
                "   ve.IDMAGASIN,\n" +
                "   m.VAL AS idmagasinlib,\n" +
                "   ve.QUANTITE,\n" +
                "   CAST(ve.ENTREE AS NUMBER(30,2)) AS ENTREE,\n" +
                "   CAST(ve.SORTIE AS NUMBER(30,2)) AS SORTIE,\n" +
                "   CAST(ve.RESTE AS NUMBER(30,2)) AS RESTE,\n" +
                "   ai.UNITE,\n" +
                "   u.VAL AS idunitelib,\n" +
                "   ve.PU,\n" +
                "   ve.DATY\n" +
                "FROM (\n" +
                "   SELECT\n" +
                "       \"ID\",\n" +
                "       \"IDMVTSTOCK\",\n" +
                "       \"IDPRODUIT\",\n" +
                "       \"ENTREE\",\n" +
                "       \"SORTIE\",\n" +
                "       \"IDVENTEDETAIL\",\n" +
                "       \"IDTRANSFERTDETAIL\",\n" +
                "       \"PU\",\n" +
                "       \"MVTSRC\",\n" +
                "       \"DATY\",\n" +
                "       \"RESTE\",\n" +
                "       \"QUANTITE\",\n" +
                "       \"IDMAGASIN\"\n" +
                "   FROM (\n" +
                "       SELECT\n" +
                "           m.ID,\n" +
                "           m.IDMVTSTOCK,\n" +
                "           m.IDPRODUIT,\n" +
                "           m.ENTREE,\n" +
                "           s.SORTIE,\n" +
                "           m.IDVENTEDETAIL,\n" +
                "           m.IDTRANSFERTDETAIL,\n" +
                "           m.PU,\n" +
                "           m.MVTSRC,\n" +
                "           mp.DATY,\n" +
                "           NVL(m.ENTREE, 0) - NVL(s.SORTIE, 0) AS RESTE,\n" +
                "           NVL(m.ENTREE, 0) - NVL(s.SORTIE, 0) AS QUANTITE,\n" +
                "           mp.IDMAGASIN\n" +
                "       FROM MVTSTOCKFILLE m\n" +
                "       LEFT JOIN MVTSTOCK mp ON mp.id = m.IDMVTSTOCK\n" +
                "       LEFT JOIN (\n" +
                "           SELECT m.MVTSRC, SUM(m.SORTIE) AS SORTIE\n" +
                "           FROM MVTSTOCKFILLE m\n" +
                "           LEFT JOIN MVTSTOCK mp ON mp.id = m.IDMVTSTOCK\n" +
                "           WHERE mp.ETAT >= 11\n" +
                "             AND m.MVTSRC IS NOT NULL\n" +
                "             AND mp.DATY <= TO_DATE('" + daty + "', 'DD-MM-YYYY')\n" +
                "           GROUP BY m.MVTSRC\n" +
                "       ) s ON s.MVTSRC = m.id\n" +
                "       WHERE m.ENTREE > 0\n" +
                "         AND mp.ETAT >= 11\n" +
                "         AND mp.DATY <= TO_DATE('" + daty + "', 'DD-MM-YYYY')\n" +
                "   )\n" +
                "   \n" +
                ") ve\n" +
                "LEFT JOIN AS_INGREDIENTS ai ON ai.id = ve.IDPRODUIT\n" +
                "LEFT JOIN CATEGORIEINGREDIENT c ON ai.CATEGORIEINGREDIENT = c.id\n" +
                "LEFT JOIN MAGASINPOINT m ON ve.IDMAGASIN = m.id\n" +
                "LEFT JOIN AS_UNITE u ON ai.UNITE = u.id\n" +
                "WHERE  ve.PU > 0\n";*/
      String req=getRequeteEtatStockEntree(daty);
      System.out.println(req);
        //VE.RESTE
        ResultatEtSomme rs= CGenUtil.rechercherPage(this,req,numPage,nomColSomme,apresWhere,c,npp);
        return rs;
    }
    public static String getRequeteEtatStockEntree(String daty){
        /*return "SELECT DISTINCT\n" +
                "     ve.id,\n" +
                "     ai.id AS idproduit,\n" +
                "     ai.libelle AS idproduitlib,\n" +
                "     ai.categorieingredient,\n" +
                "     c.val AS idtypeproduitlib,\n" +
                "     ve.idmagasin,\n" +
                "     m.val AS idmagasinlib,\n" +
                "     ve.quantite,\n" +
                "     CAST(ve.entree AS NUMBER(30,2)) AS entree,\n" +
                "     CAST(ve.sortie AS NUMBER(30,2)) AS sortie,\n" +
                "     CAST(ve.reste AS NUMBER(30,2)) AS reste,\n" +
                "     ai.unite,\n" +
                "     u.val AS idunitelib,\n" +
                "     ve.pu,\n" +
                "     ve.daty,\n" +
                "     ve.idfournisseur,\n" +
                "     f.NOM AS idfournisseurlib,\n" +
                "     ve.dateAchat,\n" +
                "     ve.MVTSRC\n" +
                "\n" +
                " FROM (\n" +
                "     SELECT\n" +
                "         x.*,\n" +
                "          COALESCE(b.idfournisseur, invf.idfournisseur, bb.IDFOURNISSEUR,trs.idfournisseur) AS idfournisseur,\n" +
                "         f.DATY as dateAchat\n" +
                "\n" +
                "     FROM (\n" +
                "         SELECT\n" +
                "             ID,\n" +
                "             IDMVTSTOCK,\n" +
                "             IDPRODUIT,\n" +
                "             ENTREE,\n" +
                "             SORTIE,\n" +
                "             IDVENTEDETAIL,\n" +
                "             IDTRANSFERTDETAIL,\n" +
                "             PU,\n" +
                "             MVTSRC,\n" +
                "             DATY,\n" +
                "             RESTE,\n" +
                "             QUANTITE,\n" +
                "             IDMAGASIN,\n" +
                "             IDINVENTAIREFILLE\n" +
                "         FROM (\n" +
                "             SELECT\n" +
                "                 mf.ID,\n" +
                "                 mf.IDMVTSTOCK,\n" +
                "                 mf.IDPRODUIT,\n" +
                "                  nvl(mf.ENTREE,0)+nvl(s.ENTREE,0) as entree,\n" +
                "                 s.SORTIE,\n" +
                "                 mf.IDVENTEDETAIL,\n" +
                "                 mf.IDTRANSFERTDETAIL,\n" +
                "                 mf.PU,\n" +
                "                 mf.MVTSRC,\n" +
                "                 ms.DATY,\n" +
                "                 NVL(mf.ENTREE, 0) - NVL(s.SORTIE, 0)  + NVL(s.ENTREE, 0) AS RESTE,\n" +
                "                 NVL(mf.ENTREE, 0) - NVL(s.SORTIE, 0) +  NVL(s.ENTREE, 0) AS QUANTITE,\n" +
                "                 ms.IDMAGASIN,\n" +
                "                 mf.idinventairefille\n" +
                "             FROM MVTSTOCKFILLE mf\n" +
                "             LEFT JOIN MVTSTOCK ms ON ms.id = mf.IDMVTSTOCK\n" +
                "             LEFT JOIN (\n" +
                "                 SELECT mf2.MVTSRC, SUM(mf2.SORTIE) AS SORTIE,SUM(mf2.ENTREE) AS ENTREE\n" +
                "                 FROM MVTSTOCKFILLE mf2\n" +
                "                 LEFT JOIN MVTSTOCK ms2 ON ms2.id = mf2.IDMVTSTOCK\n" +
                "                 WHERE ms2.ETAT >= 11\n" +
                "                   AND mf2.MVTSRC IS NOT NULL\n" +
                "                   AND ms2.DATY <= TO_DATE('"+daty+"', 'DD-MM-YYYY')\n" +
                "                 GROUP BY mf2.MVTSRC\n" +
                "             ) s ON s.MVTSRC = mf.id\n" +
                "             WHERE mf.ENTREE > 0 and (mf.MVTSRC is null or mf.MVTSRC=mf.id)\n" +
                "               AND ms.ETAT >= 11\n" +
                "               AND ms.DATY <= TO_DATE('"+daty+"', 'DD-MM-YYYY')\n" +
                "         )\n" +
                "     ) x\n" +
                "     LEFT JOIN MVTSTOCK ms  ON ms.id = x.IDMVTSTOCK\n" +
                "     LEFT JOIN AS_BONDELIVRAISON b ON b.ID = ms.IDOBJET\n" +
                "     LEFT JOIN AS_BONDELIVRAISON bb ON b.ID = ms.IDTRANSFERT\n"+
                "     LEFT JOIN FACTUREFOURNISSEUR f on f.id=b.IDFACTUREFOURNISSEUR\n" +
                "     LEFT JOIN INVENTAIREFILLE invf ON invf.id = x.IDINVENTAIREFILLE\n" +
                "     LEFT JOIN TRANSFERTSTOCKDETAILS trs ON trs.id = x.IDTRANSFERTDETAIL\n" +
                "WHERE b.IDFOURNISSEUR IS NOT NULL OR invf.IDFOURNISSEUR IS NOT NULL or bb.IDFOURNISSEUR IS NOT NULL OR trs.idfournisseur is not null\n" +
                "\n" +
                " ) ve\n" +
                "\n" +
                " LEFT JOIN AS_INGREDIENTS ai ON ai.id = ve.IDPRODUIT\n" +
                " LEFT JOIN CATEGORIEINGREDIENT c ON ai.CATEGORIEINGREDIENT = c.id\n" +
                " LEFT JOIN MAGASINPOINT m ON ve.IDMAGASIN = m.id\n" +
                " LEFT JOIN AS_UNITE u ON ai.UNITE = u.id\n" +
                "\n" +
                " LEFT JOIN FOURNISSEUR f ON f.ID = ve.idfournisseur\n" +
                "\n" +
                " WHERE ve.PU > 0";*/
        String req= "SELECT\n" +
                "   ve.id,\n" +
                "   ai.id AS IDPRODUIT,\n" +
                "   ai.LIBELLE AS idproduitlib,\n" +
                "   ai.CATEGORIEINGREDIENT,\n" +
                "   c.VAL AS idtypeproduitlib,\n" +
                "   ve.IDMAGASIN, ai.typeStock,\n" +
                "   m.VAL AS idmagasinlib,\n" +
                "   ve.QUANTITE,\n" +
                "   CAST(ve.ENTREE AS NUMBER(30,2)) AS ENTREE,\n" +
                "   CAST(ve.SORTIE AS NUMBER(30,2)) AS SORTIE,\n" +
                "   CAST(ve.RESTE AS NUMBER(30,2)) AS RESTE,\n" +
                "   ai.UNITE,\n" +
                "   u.VAL AS idunitelib,\n" +
                "   ve.PU,\n" +
                "   ve.DATY,\n" +
                "     ve.MVTSRC,\n" +
                "     ve.compteLocalisationLib\n" +
                "     IDDEPARTEMENT,\n" +
                "    departementlib " +
                "FROM (\n" +
                "   SELECT\n" +
                "       \"ID\",\n" +
                "       \"IDMVTSTOCK\",\n" +
                "       \"IDPRODUIT\",\n" +
                "       \"ENTREE\",\n" +
                "       \"SORTIE\",\n" +
                "       \"IDVENTEDETAIL\",\n" +
                "       \"IDTRANSFERTDETAIL\",\n" +
                "       \"PU\",\n" +
                "       \"MVTSRC\",\n" +
                "       \"DATY\",\n" +
                "       \"RESTE\",\n" +
                "       \"QUANTITE\",\n" +
                "       \"IDMAGASIN\",\n" +
                "       \"COMPTELOCALISATION\",\n" +
                "       \"COMPTELOCALISATIONLIB\"\n" +
                "   FROM (\n" +
                "       SELECT\n" +
                "           m.ID,\n" +
                "           m.IDMVTSTOCK,\n" +
                "           m.IDPRODUIT,\n" +
                "           m.ENTREE + NVL(s.ENTREE, 0) as entree,\n" +
                "           s.SORTIE,\n" +
                "           m.IDVENTEDETAIL,\n" +
                "           m.IDTRANSFERTDETAIL,\n" +
                "           m.PU,\n" +
                "           m.MVTSRC,\n" +
                "           mp.DATY,\n" +
                "           NVL(m.ENTREE, 0) - NVL(s.SORTIE, 0) + NVL(s.ENTREE, 0) AS RESTE,\n" +
                "           NVL(m.ENTREE, 0) - NVL(s.SORTIE, 0) + NVL(s.ENTREE, 0) AS QUANTITE,\n" +
                "           mp.IDMAGASIN,\n" +
                "           m.COMPTELOCALISATION,\n" +
                "          loc.LIBELLE as COMPTELOCALISATIONLIB\n" +
                " ai.IDDEPARTEMENT,\n" +
                "                                                  ai.departementlib "+
                "       FROM MVTSTOCKFILLE m\n" +
                "       LEFT JOIN MVTSTOCK mp ON mp.id = m.IDMVTSTOCK\n" +
                "       LEFT JOIN LOCALISATION loc ON loc.id=m.COMPTELOCALISATION\n"+
                "       LEFT JOIN (\n" +
                "           SELECT m.MVTSRC, SUM(m.SORTIE) AS SORTIE, sum(m.ENTREE) as ENTREE\n" +
                "           FROM MVTSTOCKFILLE m\n" +
                "           LEFT JOIN MVTSTOCK mp ON mp.id = m.IDMVTSTOCK\n" +
                "           WHERE mp.ETAT >= 11\n" +
                "             AND m.MVTSRC IS NOT NULL\n" +
                "             AND mp.DATY <= TO_DATE('" + daty + "', 'DD-MM-YYYY')\n" +
                "           GROUP BY m.MVTSRC\n" +
                "       ) s ON s.MVTSRC = m.id\n" +
                "       WHERE m.ENTREE > 0 and m.MVTSRC IS NULL\n" +
                "         AND mp.ETAT >= 11\n" +
                "         AND mp.DATY <= TO_DATE('" + daty + "', 'DD-MM-YYYY')\n" +
                "   )\n" +
                "   \n" +
                ") ve\n" +
                "LEFT JOIN AS_INGREDIENT_DEP ai ON ai.id = ve.IDPRODUIT\n" +
                "LEFT JOIN CATEGORIEINGREDIENT c ON ai.CATEGORIEINGREDIENT = c.id\n" +
                "LEFT JOIN MAGASINPOINT m ON ve.IDMAGASIN = m.id\n" +
                "LEFT JOIN AS_UNITE u ON ai.UNITE = u.id\n" +
                "WHERE  ve.PU > 0 and ve.reste > 0 and ve.reste !=0 ";
        String reqAvecInv="SELECT\n" +
            "    invdaty,\n" +
            "    cast(invquantite as number(30,2)) as invquantite,\n" +
            "   ve.id,\n" +
            "   ai.id AS IDPRODUIT,\n" +
            "   ai.LIBELLE AS idproduitlib,\n" +
            "   ai.CATEGORIEINGREDIENT,\n" +
            "   c.VAL AS idtypeproduitlib,\n" +
            "   ve.IDMAGASIN, ai.typeStock,\n" +
            "   m.VAL AS idmagasinlib,\n" +
            "   ve.QUANTITE,\n" +
            "   CAST(ve.ENTREE AS NUMBER(30,2)) AS ENTREE,\n" +
            "   CAST(ve.SORTIE AS NUMBER(30,2)) AS SORTIE,\n" +
            "   CAST(ve.RESTE AS NUMBER(30,2)) AS RESTE,\n" +
            "   cast(ve.reste*ve.pu as number(30,2)) as montantReste,\n" +
            "   ai.UNITE,\n" +
            "   u.VAL AS idunitelib,\n" +
            "   ve.PU,\n" +
            "   ve.DATY,\n" +
            "   ve.IDFOURNISSEUR,\n" +
            "   ve.IDFOURNISSEURLIB\n" +
            "FROM (\n" +
            "       SELECT\n" +
            "            s.invdaty,\n" +
            "            s.invquantite,\n" +
            "           m.ID,\n" +
            "           m.IDMVTSTOCK,\n" +
            "           m.IDPRODUIT,\n" +
            "           case when s.invFid like 'invvidef%'\n" +
            "           then m.ENTREE\n" +
            "           else s.entree end\n" +
            "               as entree,\n" +
            "           s.SORTIE,\n" +
            "           m.IDVENTEDETAIL,\n" +
            "           m.IDTRANSFERTDETAIL,\n" +
            "           m.PU,\n" +
            "           m.MVTSRC,\n" +
            "           mp.DATY,\n" +
            "           case when s.invFid like 'invvidef%'\n" +
            "           then NVL(m.ENTREE, 0) - NVL(s.SORTIE, 0) + NVL(s.invquantite, 0)\n" +
            "           else NVL(s.ENTREE, 0) - NVL(s.SORTIE, 0) + NVL(s.invquantite, 0)\n" +
            "           end    AS RESTE,\n" +
            "           case when s.invFid like 'invvidef%'\n" +
            "           then NVL(m.ENTREE, 0) - NVL(s.SORTIE, 0) + NVL(s.invquantite, 0)\n" +
            "           else NVL(s.ENTREE, 0) - NVL(s.SORTIE, 0) + NVL(s.invquantite, 0)\n" +
            "           end AS QUANTITE,\n" +
            "           mp.IDMAGASIN,\n" +
            "           b.IDFOURNISSEUR,\n" +
            "           b.IDFOURNISSEURLIB\n" +
            "       FROM mvtSTockFilleVraiSource m\n" +
            "       LEFT JOIN MVTSTOCK mp ON mp.id = m.IDMVTSTOCK\n" +
            "       LEFT JOIN AS_BONDELIVRAISON_LIB b ON b.ID = mp.IDOBJET " +
            "\n" +
            "       LEFT JOIN (\n" +
            "           SELECT\n" +
            "    inv.invidproduit AS IDPRODUIT,\n" +
            "    inv.invmvtsrc AS MVTSRC,\n" +
            "    inv.invIdMagasin AS IDMAGASIN,\n" +
            "    inv.invquantite,\n" +
            "    inv.invdaty,\n" +
            "    NVL(mvt.SORTIE, 0) AS SORTIE,\n" +
            "    NVL(mvt.ENTREE, 0) AS ENTREE,inv.invFid,\n" +
            "    (NVL(inv.invquantite, 0) + NVL(mvt.ENTREE, 0) - NVL(mvt.SORTIE, 0)) AS STOCK_FINAL\n" +
            "FROM (\n" +
            "    SELECT\n" +
            "        invf.QUANTITE AS invquantite,\n" +
            "        invf.IDPRODUIT AS invidproduit,\n" +
            "        invf.MVTSRC AS invmvtsrc,\n" +
            "        im.daty AS invdaty,\n" +
            "        im.IDMAGASIN AS invIdMagasin,\n" +
            "        invf.id as invFid\n" +
            "    FROM inventaireFilleAvecVide invF\n" +
            "    LEFT JOIN inventaireAvecVide im ON im.ID = invf.IDINVENTAIRE\n" +
            "    WHERE im.ETAT >= 11\n" +
            "      AND im.daty = (\n" +
            "          SELECT MAX(im2.daty)\n" +
            "          FROM inventaireFilleAvecVide invf2\n" +
            "          LEFT JOIN inventaireAvecVide im2 ON im2.id = invf2.IDINVENTAIRE\n" +
            "          WHERE im2.ETAT >= 11\n" +
            "            AND invf2.IDPRODUIT = invf.IDPRODUIT\n" +
            "            AND invf2.MVTSRC = invf.MVTSRC\n" +
            "            AND im2.IDMAGASIN = im.IDMAGASIN\n" +
            "            AND im2.daty <= TO_DATE('"+daty+ "', 'DD-MM-YYYY')\n" +
            "      )\n" +
            ") inv\n" +
            "\n" +
            "LEFT JOIN (\n" +
            "    SELECT\n" +
            "        m.MVTSRC,\n" +
            "        mp.IDMAGASIN,\n" +
            "        m.IDPRODUIT,\n" +
            "        SUM(m.SORTIE) AS SORTIE,\n" +
            "        SUM(m.ENTREE) AS ENTREE\n" +
            "    FROM mvtSTockFilleVraiSource m\n" +
            "    JOIN MVTSTOCK mp ON mp.id = m.IDMVTSTOCK\n" +
            "    LEFT JOIN (\n" +
            "        SELECT\n" +
            "            invf3.IDPRODUIT,\n" +
            "            invf3.MVTSRC,\n" +
            "            im3.IDMAGASIN,\n" +
            "            MAX(im3.DATY) AS max_invdaty\n" +
            "        FROM inventaireFilleAvecVide invf3\n" +
            "        LEFT JOIN inventaireAvecVide im3 ON im3.id = invf3.IDINVENTAIRE\n" +
            "        WHERE im3.ETAT >= 11\n" +
            "          AND im3.DATY <= TO_DATE('"+daty+ "', 'DD-MM-YYYY')\n" +
            "        GROUP BY invf3.IDPRODUIT, invf3.MVTSRC, im3.IDMAGASIN\n" +
            "    ) inv_ref ON inv_ref.IDPRODUIT = m.IDPRODUIT\n" +
            "             AND inv_ref.MVTSRC = m.MVTSRC\n" +
            "             AND inv_ref.IDMAGASIN = mp.IDMAGASIN\n" +
            "    WHERE mp.ETAT >= 11\n" +
            "      AND mp.DATY <= TO_DATE('"+daty+ "', 'DD-MM-YYYY')\n" +
            "      AND mp.DATY > inv_ref.max_invdaty\n" +
            "    GROUP BY m.MVTSRC, mp.IDMAGASIN, m.IDPRODUIT\n" +
            ") mvt\n" +
            "  ON mvt.IDPRODUIT = inv.invidproduit\n" +
            " AND mvt.MVTSRC = inv.invmvtsrc\n" +
            " AND mvt.IDMAGASIN = inv.invIdMagasin\n" +
            "       ) s ON s.MVTSRC = m.id and s.IDMAGASIN=mp.IDMAGASIN\n" +
            "       WHERE  m.ENTREE > 0 --and m.MVTSRC IS NULL\n" +
            "         AND mp.ETAT >= 11\n" +
            "         AND mp.DATY <= TO_DATE('"+daty+ "', 'DD-MM-YYYY')\n" +
            ") ve\n" +
            "LEFT JOIN AS_INGREDIENTS ai ON ai.id = ve.IDPRODUIT\n" +
            "LEFT JOIN CATEGORIEINGREDIENT c ON ai.CATEGORIEINGREDIENT = c.id\n" +
            "LEFT JOIN MAGASINPOINT m ON ve.IDMAGASIN = m.id\n" +
            "LEFT JOIN AS_UNITE u ON ai.UNITE = u.id\n" +
            "WHERE\n" +
            "    ve.PU > 0\n" +
            "  and ve.reste !=0 order by ve.invdaty desc,ve.daty desc";

        //System.out.println(reqAvecInv);
        String reqAvecInvOptWith="WITH max_inventaire AS (\n" +
            "    -- Étape 1 : On extrait la date maximale valide par produit une fois pour toutes\n" +
            "    SELECT\n" +
            "        invff.MVTSRC,\n" +
            "        MAX(imeref.DATY) AS max_daty\n" +
            "    FROM INVENTAIREFILLE invff\n" +
            "    LEFT JOIN inventaireDateHeure imeref ON imeref.ID = invff.IDINVENTAIRE\n" +
            "    WHERE imeref.ETAT >= 11\n" +
            "      AND imeref.DATY < TO_DATE('"+daty+"', 'DD-MM-YYYY') + 1\n" +
            "    GROUP BY invff.MVTSRC\n" +
            "),\n" +
            "inv_final_precalc AS (\n" +
            "    -- Étape 2 : On récupère les quantités associées à cette date maximale\n" +
            "    SELECT\n" +
            "        invfff.MVTSRC,\n" +
            "        invfff.QUANTITE,\n" +
            "        imm.DATY AS invdaty\n" +
            "    FROM INVENTAIREFILLE invfff\n" +
            "    LEFT JOIN inventaireDateHeure imm ON imm.ID = invfff.IDINVENTAIRE\n" +
            "    INNER JOIN max_inventaire mi ON mi.MVTSRC = invfff.MVTSRC AND imm.DATY = mi.max_daty\n" +
            "    WHERE imm.ETAT >= 11\n" +
            "),\n" +
            "somme_precalc AS (\n" +
            "    -- Étape 3 : Calcul des sommes globales (sorties/entrées) sans sous-requête corrélée cassée\n" +
            "    SELECT\n" +
            "        mff.MVTSRC,\n" +
            "        NVL(SUM(mff.ENTREE), 0) AS entree,\n" +
            "        NVL(SUM(mff.SORTIE), 0) AS sortie\n" +
            "    FROM MVTSTOCKFILLE mff\n" +
            "    LEFT JOIN mvtStockDateHeure meref ON meref.ID = mff.IDMVTSTOCK\n" +
            "    LEFT JOIN inv_final_precalc inv ON inv.MVTSRC = mff.MVTSRC\n" +
            "    WHERE meref.DATY > nvl(inv.invdaty,to_date('01/01/2025','DD-MM-YYYY')) and meref.ETAT>=11\n" +
            "      AND meref.DATY < TO_DATE('"+daty+"', 'DD-MM-YYYY') + 1\n" +
            "      AND meref.IDTYPEMVSTOCK != 'TPMVST000023'\n" +
            "    GROUP BY mff.MVTSRC\n" +
            "),\n" +
            "main_data AS (\n" +
            "    -- Étape 4 : Requête principale avec application exacte des règles de calcul d'origine\n" +
            "    SELECT\n" +
            "        mf.ID,\n" +
            "        mere.DATY,\n" +
            "        CAST(NVL(invfinal.QUANTITE, 0) AS NUMBER(30,2)) AS invquantite,\n" +
            "\n" +
            "        CASE WHEN mere.DATY > NVL(invfinal.invdaty, TO_DATE('01/01/2025','DD-MM-YYYY'))\n" +
            "             THEN CAST(NVL(mf.ENTREE, 0) AS NUMBER(30,2))\n" +
            "             ELSE 0\n" +
            "        END AS ENTREE,\n" +
            "\n" +
            "        CAST(NVL(somme.SORTIE, 0) AS NUMBER(30,2)) AS sortie,\n" +
            "\n" +
            "        CASE WHEN mere.DATY <= NVL(invfinal.invdaty, TO_DATE('01/01/2025','DD-MM-YYYY'))\n" +
            "             THEN CAST((NVL(invfinal.QUANTITE, 0) - NVL(somme.SORTIE, 0)) AS NUMBER(30,2))\n" +
            "             ELSE CAST((NVL(invfinal.QUANTITE, 0) + mf.ENTREE - NVL(somme.SORTIE, 0)) AS NUMBER(30,2))\n" +
            "        END AS reste,\n" +
            "\n" +
            "        ai.LIBELLE AS idproduitlib,\n" +
            "        ai.CATEGORIEINGREDIENT,\n" +
            "        ai.UNITE,\n" +
            "        ai.TYPESTOCK,\n" +
            "        u.VAL AS idunitelib,\n" +
            "        c.VAL AS idtypeproduitlib,\n" +
            "        mf.PU,\n" +
            "        b.IDFOURNISSEUR,\n" +
            "        b.IDFOURNISSEURLIB,\n" +
            "        mf.IDPRODUIT,\n" +
            "        mere.IDMAGASIN,\n" +
            "        m.IDMAGASINLIB AS idmagasinlib,\n" +
            "        invfinal.invdaty AS invdaty,\n" +
            "        mf.compteLocalisation,\n" +
            "        loc.LIBELLE as COMPTELOCALISATIONLIB,\n" +
            "        ai.PARFUMS as codeproduit,\n" +
            "        m.IDDIRECTION as IDDEPARTEMENT,\n" +
            "        m.IDDIRECTIONLIB AS departementlib"+
            "   FROM MVTSTOCKFILLE mf\n" +
            "      LEFT JOIN mvtStockDateHeure mere ON mere.id = mf.IDMVTSTOCK\n" +
            "      LEFT JOIN somme_precalc somme ON somme.MVTSRC = mf.id\n" +
            "      LEFT JOIN inv_final_precalc invfinal ON invfinal.MVTSRC = mf.ID\n" +
            "      LEFT JOIN AS_INGREDIENT_DEP ai ON ai.id = mf.IDPRODUIT\n" +
            "      LEFT JOIN CATEGORIEINGREDIENT c ON ai.CATEGORIEINGREDIENT = c.id\n" +
            "      LEFT JOIN DIRECTIONMAGASINLIB m ON mere.IDMAGASIN = m.IDMAGASIN\n" +
            "      LEFT JOIN AS_UNITE u ON ai.UNITE = u.id\n" +
            "      LEFT JOIN AS_BONDELIVRAISON_LIB b ON b.ID = mere.IDOBJET\n" +
            "      LEFT JOIN LOCALISATION loc ON loc.id=mf.COMPTELOCALISATION" +
            "    WHERE mf.ENTREE > 0\n" +
            "      AND mere.IDTYPEMVSTOCK != 'TPMVST000023'\n" +
            "      AND ai.TYPESTOCK != 'CUMP'\n" +
            "      AND mere.ETAT >= 11\n" +
            "      AND mere.DATY < TO_DATE('"+daty+"', 'DD-MM-YYYY') + 1\n" +
            ")\n" +
            "-- Sélection finale nettoyée appliquant les alias répétitifs et le filtre d'exclusion\n" +
            "SELECT\n" +
            "    ID, DATY, invquantite, ENTREE, sortie, reste,\n" +
            "    reste AS quantite,\n" +
            "    CAST(reste * PU AS NUMBER(30,2)) AS montantreste,\n" +
            "    idproduitlib, CATEGORIEINGREDIENT, UNITE, TYPESTOCK, idunitelib, idtypeproduitlib,\n" +
            "    PU, IDFOURNISSEUR, IDFOURNISSEURLIB, IDPRODUIT, IDMAGASIN, idmagasinlib, invdaty,COMPTELOCALISATIONLIB,compteLocalisation,codeproduit,IDDEPARTEMENT,departementlib\n" +
            "FROM main_data\n" +
            "WHERE reste != 0";
        //System.out.println(reqAvecInvOptWith);
        return reqAvecInvOptWith;
    }

    public static String getRequeteEtatStockEntreeParCategorie(String daty) {
        return "SELECT " +
                "    ve.IDTYPEPRODUITLIB, " +
                "    ve.IDMAGASIN, " +
                "    ve.IDMAGASINLIB, " +
                "    ve.TYPESTOCK, " +
                "    SUM(ve.QUANTITE) AS QUANTITE, " +
                "    SUM(ve.ENTREE) AS ENTREE, " +
                "    SUM(ve.SORTIE) AS SORTIE, " +
                "    SUM(ve.RESTE) AS RESTE " +
                "FROM ( " +
                getRequeteEtatStockEntree(daty) +
                " ) ve " +
                "GROUP BY " +
                "    ve.IDTYPEPRODUITLIB, " +
                "    ve.IDMAGASIN, " +
                "    ve.IDMAGASINLIB, " +
                "    ve.TYPESTOCK " +
                "ORDER BY " +
                "    ve.IDMAGASINLIB, " +
                "    ve.IDTYPEPRODUITLIB";
    }

    public static String getRequeteEtatStockEntreeParCategorie2(String daty) {
        return "SELECT " +
                "    NVL(ve.IDTYPEPRODUITLIB, 'Autre') AS IDTYPEPRODUITLIB, " +
                "    NVL(ve.IDMAGASIN, -1) AS IDMAGASIN, " +
                "    NVL(ve.IDMAGASINLIB, 'Autre Magasin') AS IDMAGASINLIB, " +
                "    ve.TYPESTOCK, " +
                "    SUM(ve.QUANTITE) AS QUANTITE, " +
                "    SUM(ve.ENTREE) AS ENTREE, " +
                "    SUM(ve.SORTIE) AS SORTIE, " +
                "    SUM(ve.RESTE) AS RESTE " +
                "FROM ( " +
                getRequeteEtatStockEntree(daty) +
                " ) ve " +
                "GROUP BY " +
                "    NVL(ve.IDTYPEPRODUITLIB, 'Autre'), " +
                "    NVL(ve.IDMAGASIN, -1), " +
                "    NVL(ve.IDMAGASINLIB, 'Autre Magasin'), " +
                "    ve.TYPESTOCK " +
                "ORDER BY " +
                "    NVL(ve.IDMAGASINLIB, 'Autre Magasin'), " +
                "    NVL(ve.IDTYPEPRODUITLIB, 'Autre')";
    }

    public EtatStockParEntree[] getEtatDeStock(Date daty) throws Exception {
        SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
        String dateString = sdf.format(daty);

        String req = getRequeteEtatStockEntreeParCategorie2(dateString);
        return (EtatStockParEntree[]) CGenUtil.rechercher(this, req);
    }

  /*public ResultatEtSomme rechercherPage(String[] colInt, String[]valInt, int numPage, String apresWhere, String[]nomColSomme, Connection c, int npp) throws Exception {
      String daty=Utilitaire.dateDuJour();
      if(valInt!=null&&valInt.length>1) {daty=valInt[1].toString();}

      String req= "SELECT\n" +
              "\tp.ID AS ID,\n" +
              "\tp.LIBELLE AS idproduitLib,\n" +
              "\tp.CATEGORIEINGREDIENT,\n" +
              "\ttp.DESCE AS idtypeproduitlib,\n" +
              "\tms.IDMAGASIN,\n" +
              "\tmag.DESCE AS idmagasinlib,\n" +
              "\tTO_DATE('01-01-2001', 'DD-MM-YYYY') AS dateDernierMouvement,\n" +
              "\tms.quantite AS QUANTITE,\n" +
              "\tms.entree AS ENTREE,\n" +
              "\tms.sortie AS SORTIE,\n" +
              "\tms.quantite AS reste,\n" +
              "\tp.UNITE,\n" +
              "\tu.DESCE AS idunitelib,\n" +
              "\tCAST(NVL(p.PV, 0) AS NUMBER(30, 2)) AS PUVENTE,\n" +
              "\tmag.IDPOINT,\n" +
              "\tmag.IDTYPEMAGASIN,\n" +
              "\tp.SEUILMIN,\n" +
              "\tp.SEUILMAX,\n" +
              "\tms.montantEntree,\n" +
              "\tms.montantSortie,\n" +
              "\tms.pu,\n" +
              "\tms.montant as montantReste\n" +
              "FROM AS_INGREDIENTS p\n" +
              "LEFT JOIN (SELECT\n" +
              "    mf.IDPRODUIT,\n" +
              "    SUM(NVL(mf.ENTREE,0)) AS ENTREE,\n" +
              "    SUM(NVL(mf.SORTIE,0)) AS SORTIE,\n" +
              "    SUM(NVL(mf.ENTREE,0)) - SUM(NVL(mf.SORTIE,0)) AS quantite,\n" +
              "    cast(sum(mf.montantEntree) as number(30,2))  AS montantEntree,\n" +
              "    cast(sum(mf.montantSortie) as number(30,2))  AS montantSortie,\n" +
              "    CAST(NVL(mf.PU, 0) * (SUM(NVL(mf.ENTREE,0)) - SUM(NVL(mf.SORTIE,0))) AS NUMBER(30,2)) AS montant,\n" +
              "    m.IDMAGASIN,mf.pu\n" +
              "FROM\n" +
              "    mvtStockFilleMontant mf\n" +
              "JOIN MVTSTOCK m ON m.id = mf.IDMVTSTOCK\n" +
              "JOIN AS_INGREDIENTS ai ON ai.ID = mf.IDPRODUIT\n" +
              "WHERE\n" +
              "    m.ETAT >= 11\n" +
              "    AND mf.IDPRODUIT IS NOT NULL\n" +
              "    AND m.daty<=TO_DATE('"+daty+"', 'DD/MM/YYYY') \n" +
              "GROUP BY\n" +
              "    mf.IDPRODUIT,\n" +
              "    mf.PU,m.IDMAGASIN) ms ON ms.IDPRODUIT = p.ID\n" +
              "LEFT JOIN CATEGORIEINGREDIENT tp ON p.CATEGORIEINGREDIENT = tp.ID\n" +
              "LEFT JOIN MAGASINPOINT mag ON ms.IDMAGASIN = mag.ID\n" +
              "LEFT JOIN AS_UNITE u ON p.UNITE = u.ID\n" +
              "where (NVL(ms.ENTREE, 0)>0 or NVL(ms.SORTIE, 0)>0)";
      ResultatEtSomme rs= CGenUtil.rechercherPage(this,req,numPage,nomColSomme,apresWhere,c,npp);
      return rs;
  }*/

    public EtatStockParEntree [] genererFicheInventaire(String idMagasin, String idProduit, Connection c) throws Exception {
        EtatStockParEntree search = new EtatStockParEntree();
        search.setNomTable("V_ETATSTOCK_ENTREE");
        if (idMagasin!=null && !idMagasin.isEmpty()){
            search.setIdMagasin(idMagasin);
        }
        if (idProduit!=null && !idProduit.isEmpty()){
            search.setIdMagasin(idProduit);
        }
        EtatStockParEntree [] data = (EtatStockParEntree[]) CGenUtil.rechercher(search,null,null,c,"");
        return data;
    }
}
