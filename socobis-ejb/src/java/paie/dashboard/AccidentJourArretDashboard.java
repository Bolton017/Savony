package paie.dashboard;

import bean.ClassMAPTable;

public class AccidentJourArretDashboard extends ClassMAPTable {
    private String id;
    private String moislib;
    private int cumuljoursarret;

    public AccidentJourArretDashboard() throws Exception {
        this.setNomTable("V_DASHBOARD_ACCIDENT_JOURS");
    }

    // Getters et Setters
    public String getId() {
        return id;
    }
    public void setId(String id) {
        this.id = id;
    }

    public String getMoislib() {
        return moislib;
    }
    public void setMoislib(String moislib) {
        this.moislib = moislib;
    }

    public int getCumuljoursarret() {
        return cumuljoursarret;
    }
    public void setCumuljoursarret(int cumuljoursarret) {
        this.cumuljoursarret = cumuljoursarret;
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