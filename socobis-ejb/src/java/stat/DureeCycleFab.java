package stat;

import bean.ClassMAPTable;

public class DureeCycleFab extends ClassMAPTable {
    private String idmere;
    private double temps;

    public DureeCycleFab() {
        setNomTable("duree_cycle_fab");
    }

    public String getIdmere() {
        return idmere;
    }

    public void setIdmere(String idmere) {
        this.idmere = idmere;
    }

    public double getTemps() {
        return temps;
    }

    public void setTemps(double temps) {
        this.temps = temps;
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