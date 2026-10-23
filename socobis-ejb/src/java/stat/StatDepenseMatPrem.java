package stat;

import bean.ClassMAPTable;

public class StatDepenseMatPrem extends ClassMAPTable {
    private String id;
    private String designation;
    private double depense;
    private int annee;
    private String mois;
    private int moisInt;

    public StatDepenseMatPrem() {
        setNomTable("stat_depense_mat_prem");
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getDesignation() {
        return designation;
    }

    public void setDesignation(String designation) {
        this.designation = designation;
    }

    public double getDepense() {
        return depense;
    }

    public void setDepense(double depense) {
        this.depense = depense;
    }

    public int getAnnee() {
        return annee;
    }

    public void setAnnee(int annee) {
        this.annee = annee;
    }

    public String getMois() {
        return mois;
    }

    public void setMois(String mois) {
        this.mois = mois;
    }

    public int getMoisInt() {
        return moisInt;
    }

    public void setMoisInt(int moisInt) {
        this.moisInt = moisInt;
    }

    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }
}
