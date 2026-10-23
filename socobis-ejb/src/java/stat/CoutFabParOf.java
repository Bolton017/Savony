package stat;

import bean.ClassMAPTable;
import java.sql.Date;

public class CoutFabParOf extends ClassMAPTable {
    private String idmere;
    private Date datybesoin;
    private String ingredients;
    private double coutdeproduction;

    public CoutFabParOf() {
        setNomTable("cout_fab_par_of");
    }

    public String getIdmere() {
        return idmere;
    }

    public void setIdmere(String idmere) {
        this.idmere = idmere;
    }

    public Date getDatybesoin() {
        return datybesoin;
    }

    public void setDatybesoin(Date datybesoin) {
        this.datybesoin = datybesoin;
    }

    public String getIngredients() {
        return ingredients;
    }

    public void setIngredients(String ingredients) {
        this.ingredients = ingredients;
    }

    public double getCoutdeproduction() {
        return coutdeproduction;
    }

    public void setCoutdeproduction(double coutdeproduction) {
        this.coutdeproduction = coutdeproduction;
    }

    @Override
    public String getTuppleID() {
        return idmere;
    }

    @Override
    public String getAttributIDName() {
        return "idmere";
    }
}
