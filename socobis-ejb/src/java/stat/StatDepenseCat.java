package stat;

import bean.ClassMAPTable;
import java.sql.Date;

public class StatDepenseCat extends ClassMAPTable {
    private Date daty;
    private String categorieingredient;
    private String categorieingredientlib;
    private int moisint;
    private String moisstring;
    private int annee;
    private double depense;

    public StatDepenseCat() {
        setNomTable("stat_depense_cat");
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public String getCategorieingredient() {
        return categorieingredient;
    }

    public void setCategorieingredient(String categorieingredient) {
        this.categorieingredient = categorieingredient;
    }

    public String getCategorieingredientlib() {
        return categorieingredientlib;
    }

    public void setCategorieingredientlib(String categorieingredientlib) {
        this.categorieingredientlib = categorieingredientlib;
    }

    public int getMoisint() {
        return moisint;
    }

    public void setMoisint(int moisint) {
        this.moisint = moisint;
    }

    public String getMoisstring() {
        return moisstring;
    }

    public void setMoisstring(String moisstring) {
        this.moisstring = moisstring;
    }

    public int getAnnee() {
        return annee;
    }

    public void setAnnee(int annee) {
        this.annee = annee;
    }

    public double getDepense() {
        return depense;
    }

    public void setDepense(double depense) {
        this.depense = depense;
    }

    @Override
    public String getTuppleID() {
        return categorieingredient + "_" + daty.toString();
    }

    @Override
    public String getAttributIDName() {
        return "categorieingredient";
    }
}