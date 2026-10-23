package paie.accident;

import bean.ClassMAPTable;
import java.sql.Connection;

public class StatAccidentEvolution extends ClassMAPTable {
    private String mois;
    private int moisInt,nombreaccidents;

    public String getMois() {
        return mois;
    }

    public void setMois(String mois) {
        this.mois = mois;
    }

    public int getNombreaccidents() {
        return nombreaccidents;
    }

    public void setNombreaccidents(int nombreaccidents) {
        this.nombreaccidents = nombreaccidents;
    }
    


    public StatAccidentEvolution() throws Exception {
        this.setNomTable("V_ACCIDENT_EVOLUTION");
    }



    @Override
    public String getTuppleID() {
        return String.valueOf(moisInt);
    }

    @Override
    public String getAttributIDName() {
        return "moisInt";
    }

    public int getMoisInt() {
        return moisInt;
    }

    public void setMoisInt(int moisInt) {
        this.moisInt = moisInt;
    }
}

