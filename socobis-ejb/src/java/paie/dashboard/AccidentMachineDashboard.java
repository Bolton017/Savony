package paie.dashboard;

import bean.ClassMAPTable;
import java.sql.Connection;

public class AccidentMachineDashboard extends ClassMAPTable {
    private String id_machine_lib;
    private int nombreaccidents;

    public String getId_machine_lib() {
        return id_machine_lib;
    }

    public void setId_machine_lib(String id_machine_lib) {
        this.id_machine_lib = id_machine_lib;
    }

    public int getNombreaccidents() {
        return nombreaccidents;
    }

    public void setNombreaccidents(int nombreaccidents) {
        this.nombreaccidents = nombreaccidents;
    }



    public AccidentMachineDashboard() throws Exception {
        this.setNomTable("V_DASHBOARD_ACCIDENT_MACHINE");
    }

    @Override
    public String getTuppleID() {
        return id_machine_lib;
    }

    @Override
    public String getAttributIDName() {
        return "id_machine_lib";
    }
}

