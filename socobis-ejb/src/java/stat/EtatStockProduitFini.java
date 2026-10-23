package stat;

import bean.CGenUtil;
import bean.ResultatEtSomme;
import stock.EtatStock;
import utilitaire.Utilitaire;
import utils.ConstanteSocobis;

import java.sql.Connection;

public class EtatStockProduitFini extends EtatStock {
    public EtatStockProduitFini() {
        setNomTable("V_ETATSTOCK_PROD_FINI");
    }


    @Override
    public ResultatEtSomme rechercherPage(String[] colInt, String[]valInt, int numPage, String apresWhere, String[]nomColSomme, Connection c, int npp) throws Exception {
        String datyMin = "01/01/1999";
        String datyMax = Utilitaire.dateDuJour();

        if (valInt != null && valInt.length > 0) {
            String valMin = valInt[0];
            String valMax = valInt[1];

            if (valMin != null && !valMin.trim().isEmpty()) {
                datyMin = valMin;
            }
            if (valMax != null && !valMax.trim().isEmpty()) {
                datyMax = valMax;
            }
        }

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
                "\tp.pu,\n" +
                "\tms.montant as montantReste\n" +
                "FROM AS_INGREDIENTS p\n" +
                "LEFT JOIN (SELECT\n" +
                "    mf.IDPRODUIT,\n" +
                "    SUM(NVL(mf.ENTREE,0)) AS ENTREE,\n" +
                "    SUM(NVL(mf.SORTIE,0)) AS SORTIE,\n" +
                "    SUM(NVL(mf.ENTREE,0)) - SUM(NVL(mf.SORTIE,0)) AS quantite,\n" +
                "    cast(sum(mf.montantEntree) as number(30,2))  AS montantEntree,\n" +
                "    cast(sum(mf.montantSortie) as number(30,2))  AS montantSortie,\n" +
                "    CAST(NVL(ai.PU, 0) * (SUM(NVL(mf.ENTREE,0)) - SUM(NVL(mf.SORTIE,0))) AS NUMBER(30,2)) AS montant,\n" +
                "    m.IDMAGASIN\n" +
                "FROM\n" +
                "    mvtStockFilleMontant mf\n" +
                "JOIN MVTSTOCK m ON m.id = mf.IDMVTSTOCK\n" +
                "JOIN AS_INGREDIENTS ai ON ai.ID = mf.IDPRODUIT\n" +
                "WHERE\n" +
                "    m.ETAT >= 11\n" +
                "    AND mf.IDPRODUIT IS NOT NULL\n" +
                "    AND m.daty<='"+datyMax+"' AND m.daty >= '" + datyMin + "' \n" +
                "GROUP BY\n" +
                "    mf.IDPRODUIT,\n" +
                "    ai.PU,m.IDMAGASIN) ms ON ms.IDPRODUIT = p.ID\n" +
                "LEFT JOIN CATEGORIEINGREDIENT tp ON p.CATEGORIEINGREDIENT = tp.ID\n" +
                "LEFT JOIN MAGASINPOINT mag ON ms.IDMAGASIN = mag.ID\n" +
                "LEFT JOIN AS_UNITE u ON p.UNITE = u.ID\n" +
                "where (NVL(ms.ENTREE, 0)>0 or NVL(ms.SORTIE, 0)>0) AND tp.ID = '"+ ConstanteSocobis.CATEGORIE_PRODUIT_FINI +"'";
        ResultatEtSomme rs= CGenUtil.rechercherPage(this,req,numPage,nomColSomme,apresWhere,c,npp);
        return rs;
    }

}
