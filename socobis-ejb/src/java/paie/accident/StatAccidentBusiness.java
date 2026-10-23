package paie.accident;

import bean.ClassMAPTable;
import java.sql.Connection;

public class StatAccidentBusiness extends ClassMAPTable {
    private String idbu;
    private String idbulib;
    private int nombreaccidents;

    public String getIdbu() {
        return idbu;
    }

    public void setIdbu(String idbu) {
        this.idbu = idbu;
    }

    public String getIdbulib() {
        return idbulib;
    }

    public void setIdbulib(String idbulib) {
        this.idbulib = idbulib;
    }

    public int getNombreaccidents() {
        return nombreaccidents;
    }

    public void setNombreaccidents(int nombreaccidents) {
        this.nombreaccidents = nombreaccidents;
    }



    public StatAccidentBusiness() throws Exception {
        this.setNomTable("V_ACCIDENT_PAR_BUSS_UNITE");
    }

   
    @Override
    public String getTuppleID() {
        return idbu;
    }

    @Override
    public String getAttributIDName() {
        return "idbu";
    }
}

