package paie.dashboard;

import bean.ClassMAPTable;

public class MaterniteDureeGlobaleDashboard extends ClassMAPTable {

    private String id;
    private double dureeMoyenneJours;

    public MaterniteDureeGlobaleDashboard() throws Exception {
        this.setNomTable("V_DASH_MATERNITE_DUREE_GLB");
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public double getDureeMoyenneJours() {
        return dureeMoyenneJours;
    }

    public void setDureeMoyenneJours(double dureeMoyenneJours) {
        this.dureeMoyenneJours = dureeMoyenneJours;
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