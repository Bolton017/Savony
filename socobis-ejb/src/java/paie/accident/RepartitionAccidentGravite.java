package paie.accident;

import bean.ClassMAPTable;
import java.sql.Connection;

public class RepartitionAccidentGravite extends ClassMAPTable {
    private String id_gravite_lib;
    private int nombreaccidents;

    public String getId_gravite_lib() {
        return id_gravite_lib;
    }

    public void setId_gravite_lib(String id_gravite_lib) {
        this.id_gravite_lib = id_gravite_lib;
    }

    public int getNombreaccidents() {
        return nombreaccidents;
    }

    public void setNombreaccidents(int nombreaccidents) {
        this.nombreaccidents = nombreaccidents;
    }



    public RepartitionAccidentGravite() throws Exception {
        this.setNomTable("V_REPARTITION_ACCIDENT_GRAVITE");
    }



    @Override
    public String getTuppleID() {
        return id_gravite_lib;
    }

    @Override
    public String getAttributIDName() {
        return "id_gravite_lib";
    }
}

