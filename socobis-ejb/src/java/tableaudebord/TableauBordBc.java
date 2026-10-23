package tableaudebord;

import java.sql.Date;

import vente.BonDeCommandeFIlleCpl;

public class TableauBordBc extends BonDeCommandeFIlleCpl {

    private Date daty;

    public TableauBordBc() 
        throws Exception 
    { 
        super();
        this.setNomTable("TABLEAUBORDBC");
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    @Override
    public String getTuppleID() {
        return getProduit();
    }
 
    @Override
    public String getAttributIDName() {
        return "produit";
    }

    public String generateQueryCore(Date dateMin, Date dateMax) {
        String query = "SELECT\n" +
                "   PRODUIT,\n" +
                "     LIBELLEPRODUIT,\n" +
                "     SUM(QUANTITE) AS quantite,\n" +
                "   SUM(QTEOF) AS qteof,\n" +
                "     SUM(QTEOFRESTANTE) AS qteofrestante,\n" +
                "    SUM(QTEFAB) AS qtefab,\n" +
                "     SUM(QTEFABRESTANTE) AS qtefabrestante,\n" +
                "    SUM(QTELIVRE) AS qtelivre,\n" +
                "    SUM(QTENONLIVRE) AS qtenonlivre\n" +
                "FROM\n" +
                "     BONDECOMMANDE_CLIENT_GLOBALE\n" +
                " WHERE\n" +
                "    DATY BETWEEN TO_DATE('"+dateMin.toString()+"', 'YYYY-MM-DD') AND TO_DATE('"+dateMax.toString()+"', 'YYYY-MM-DD')\n" +
                "GROUP BY\n" +
                "     PRODUIT, LIBELLEPRODUIT\n" +
                " ORDER BY\n" +
                "    LIBELLEPRODUIT";
        System.out.println("---- "+ query +"----");
        return query;
    }

    @Override
    public String toString() {
        return "TableauBordBc{}";
    }
}