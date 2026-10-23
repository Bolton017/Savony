package stock;

import bean.CGenUtil;
import bean.ResultatEtSomme;
import utilitaire.Utilitaire;

import java.sql.Connection;

public class EtatStockLot extends EtatStock {
    private String idLot;
    private String idLotLib;

    public EtatStockLot(){
        setNomTable("V_ETATSTOCK_INGLOT");
    }

    @Override
    public ResultatEtSomme rechercherPage(String[] colInt, String[] valInt, int numPage, String apresWhere, String[] nomColSomme, Connection c, int npp) throws Exception {
        String daty= Utilitaire.dateDuJour();
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
                "\tp.pu,\n" +
                "\tms.montant as montantReste,\n" +
                "\tms.IDLOT,\n" +
                "\tms.IDLOTLIB\n" +
                "FROM AS_INGREDIENTS p\n" +
                "LEFT JOIN (SELECT\n" +
                "    mf.IDPRODUIT,\n" +
                "    SUM(NVL(mf.ENTREE,0)) AS ENTREE,\n" +
                "    SUM(NVL(mf.SORTIE,0)) AS SORTIE,\n" +
                "    SUM(NVL(mf.ENTREE,0)) - SUM(NVL(mf.SORTIE,0)) AS quantite,\n" +
                "    cast(sum(mf.montantEntree) as number(30,2))  AS montantEntree,\n" +
                "    cast(sum(mf.montantSortie) as number(30,2))  AS montantSortie,\n" +
                "    CAST(NVL(ai.PU, 0) * (SUM(NVL(mf.ENTREE,0)) - SUM(NVL(mf.SORTIE,0))) AS NUMBER(30,2)) AS montant,\n" +
                "    m.IDMAGASIN,\n" +
                "    mf.IDLOT,\n" +
                "    mf.IDLOTLIB\n" +
                "FROM\n" +
                "    mvtstockfillemontantlot mf\n" +
                "JOIN MVTSTOCK m ON m.id = mf.IDMVTSTOCK\n" +
                "JOIN AS_INGREDIENTS ai ON ai.ID = mf.IDPRODUIT\n" +
                "WHERE\n" +
                "    m.ETAT >= 11\n" +
                "    AND mf.IDPRODUIT IS NOT NULL\n" +
                "    AND mf.IDLOT IS NOT NULL\n" +
                "    AND m.daty<=TO_DATE('"+daty+"', 'DD/MM/YYYY') \n" +
                "GROUP BY\n" +
                "    mf.IDPRODUIT,\n" +
                "    ai.PU,m.IDMAGASIN,\n" +
                "    mf.IDLOT,\n" +
                "    mf.IDLOTLIB) ms ON ms.IDPRODUIT = p.ID\n" +
                "LEFT JOIN CATEGORIEINGREDIENT tp ON p.CATEGORIEINGREDIENT = tp.ID\n" +
                "LEFT JOIN MAGASINPOINT mag ON ms.IDMAGASIN = mag.ID\n" +
                "LEFT JOIN AS_UNITE u ON p.UNITE = u.ID\n" +
                "where NVL(ms.ENTREE, 0)>0 or NVL(ms.SORTIE, 0)>0";
        ResultatEtSomme rs= CGenUtil.rechercherPage(this,req,numPage,nomColSomme,apresWhere,c,npp);
        return rs;
    }

    public String getIdLot() {
        return idLot;
    }

    public void setIdLot(String idLot) {
        this.idLot = idLot;
    }

    public String getIdLotLib() {
        return idLotLib;
    }

    public void setIdLotLib(String idLotLib) {
        this.idLotLib = idLotLib;
    }
}
