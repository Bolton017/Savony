package stock;

import bean.CGenUtil;
import bean.ClassMAPTable;
import bean.ResultatEtSomme;
import utilitaire.Utilitaire;

import java.sql.Connection;
import java.sql.Date;

public class EtatStockAvecEngagement extends EtatStock {

    @Override
    public ResultatEtSomme rechercherPage(String[] colInt, String[]valInt, int numPage, String apresWhere, String[]nomColSomme, Connection c, int npp) throws Exception {
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
                "    mvtStockFilleMontant_eng mf\n" +
                "JOIN MVTSTOCK_eng m ON m.id = mf.IDMVTSTOCK\n" +
                "JOIN AS_INGREDIENTS ai ON ai.ID = mf.IDPRODUIT\n" +
                "WHERE\n" +
                "    m.ETAT >= 11\n" +
                "    AND mf.IDPRODUIT IS NOT NULL\n" +
                "    AND m.daty<=TO_DATE('"+daty+"', 'DD/MM/YYYY') \n" +
                "GROUP BY\n" +
                "    mf.IDPRODUIT,\n" +
                "    ai.PU,m.IDMAGASIN) ms ON ms.IDPRODUIT = p.ID\n" +
                "LEFT JOIN CATEGORIEINGREDIENT tp ON p.CATEGORIEINGREDIENT = tp.ID\n" +
                "LEFT JOIN MAGASINPOINT mag ON ms.IDMAGASIN = mag.ID\n" +
                "LEFT JOIN AS_UNITE u ON p.UNITE = u.ID\n" +
                "where NVL(ms.ENTREE, 0)>0 or NVL(ms.SORTIE, 0)>0";
        ResultatEtSomme rs= CGenUtil.rechercherPage(this,req,numPage,nomColSomme,apresWhere,c,npp);
        return rs;
    }

    public EtatStockAvecEngagement() {
        this.setNomTable("v_etatstock_ing_eng");
    }

    @Override
    public String generateQueryCore(Date dateMin, Date dateMax) {
        String query =  " SELECT  " +
                "	inv.IDPRODUIT AS ID, " +
                "	p.libelle AS idproduitLib, " +
                "	p.CATEGORIEINGREDIENT, " +
                "	tp.desce AS idtypeproduitlib, " +
                "	inv.idmagasin, " +
                "	mag.desce AS idmagasinlib, " +
                "	inv.DATY dateDernierinventaire, " +
                "	NVL(inv.QUANTITE,0) QUANTITE, " +
                "	NVL(mvt.ENTREE,0) ENTREE,  " +
                "	NVL(mvt.SORTIE,0) SORTIE,  " +
                "	NVL(mvt.ENTREE,0)+NVL(inv.QUANTITE,0)-NVL(mvt.SORTIE,0) reste, " +
                "	p.UNITE, " +
                "	u.desce AS idunitelib, " +
                "   CAST(NVL(p.PV ,0) AS NUMBER(30,2)) PUVENTE, " +
                "	mag.IDPOINT, " +
                "	mag.IDTYPEMAGASIN "+
                "FROM  " +
                "	INVENTAIRE_FILLE_CPL inv, " +
                "	( " +
                "       SELECT  " +
                "			inv.IDPRODUIT , " +
                "                   inv.IDMAGASIN, "+
                "			MAX(inv.DATY) maxDateInventaire " +
                "		FROM  " +
                "			INVENTAIRE_FILLE_CPL inv  " +
                "		WHERE  " +
                "			inv.ETAT = 11  " +
                "			AND inv.DATY <= '"+Utilitaire.datetostring(dateMin)+"' " +
                "		GROUP BY inv.IDPRODUIT,inv.IDMAGASIN " +
                "	) invm, " +
                "	( " +
                "		SELECT  " +
                "			m.IDPRODUIT , " +
                "                   dinv.IDMAGASIN, "+
                "			SUM(nvl(m.ENTREE,0)) ENTREE ,  " +
                "			SUM(nvl(m.SORTIE ,0)) SORTIE  " +
                "		FROM  " +
                "			MVTSTOCKFILLELIB_ENG m , " +
                "			( " +
                "			SELECT  " +
                "				inv.IDPRODUIT , " +
                "                           inv.IDMAGASIN,"+
                "				MAX(inv.DATY) maxDateInventaire " +
                "			FROM  " +
                "				INVENTAIRE_FILLE_CPL inv  " +
                "			WHERE  " +
                "				inv.ETAT = 11  " +
                "				AND inv.DATY <= '"+Utilitaire.datetostring(dateMin)+"' " +
                "			GROUP BY inv.IDPRODUIT,inv.IDMAGASIN " +
                "			) dinv " +
                "		WHERE  " +
                "			m.IDPRODUIT = dinv.IDPRODUIT(+) " +
                "                   AND m.IDMAGASIN = dinv.IDMAGASIN(+)"+
                "			AND m.DATY > dinv.maxDateInventaire " +
                "			AND m.DATY <= '"+Utilitaire.datetostring(dateMax)+"' " +
                "		GROUP BY m.IDPRODUIT,dinv.IDMAGASIN " +
                "	) mvt, " +
                "	as_ingredients p, " +
                "	CATEGORIEINGREDIENT tp, " +
                "	magasin mag, " +
                "	unite u " +
                "WHERE  " +
                "	inv.DATY = invm.maxDateInventaire " +
                "	AND inv.IDMAGASIN = invm.IDMAGASIN " +
                "	AND inv.IDPRODUIT = invm.IDPRODUIT " +
                "	AND inv.IDPRODUIT = mvt.IDPRODUIT(+) " +
                "	AND inv.IDMAGASIN = mvt.IDMAGASIN(+) " +
                "	AND inv.IDPRODUIT = p.ID(+) " +
                "	AND p.CATEGORIEINGREDIENT = tp.ID " +
                "	AND inv.idmagasin = mag.ID " +
                "	AND p.UNITE = u.ID(+) "+
                "	AND ( mvt.sortie > 0  OR mvt.ENTREE > 0 ) "+
                "   AND inv.ETAT >= 11 ";
        return query;
    }

}

