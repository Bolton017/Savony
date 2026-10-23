package paie.dashboard;

import bean.ClassMAPTable;

public class MaterniteDepartMensuelDashboard extends ClassMAPTable {

    private String mois;
    private int nombreDepart;
    public MaterniteDepartMensuelDashboard() throws Exception {
        this.setNomTable("V_DASH_MATERNITE_MOIS");
    }
    public String getMois() {
        return mois;
    }

    public void setMois(String mois) {
        this.mois = mois;
    }

    public int getNombreDepart() {
        return nombreDepart;
    }

    public void setNombreDepart(int nombreDepart) {
        this.nombreDepart = nombreDepart;
    }

    @Override
    public String getTuppleID() {
        return mois;
    }

    @Override
    public String getAttributIDName() {
        return "mois";
    }
}