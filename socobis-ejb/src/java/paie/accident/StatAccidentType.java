package paie.accident;

import bean.ClassMAPTable;
import java.sql.Connection;

public class StatAccidentType extends ClassMAPTable {
    private String id_type_accident;
    private String id_type_accident_lib;
    private int nombreaccidents;

    public String getId_type_accident() {
        return id_type_accident;
    }

    public void setId_type_accident(String id_type_accident) {
        this.id_type_accident = id_type_accident;
    }

    public String getId_type_accident_lib() {
        return id_type_accident_lib;
    }

    public void setId_type_accident_lib(String id_type_accident_lib) {
        this.id_type_accident_lib = id_type_accident_lib;
    }

    public int getNombreaccidents() {
        return nombreaccidents;
    }

    public void setNombreaccidents(int nombreaccidents) {
        this.nombreaccidents = nombreaccidents;
    }



    public StatAccidentType() throws Exception {
        this.setNomTable("VW_ACCIDENT_PAR_TYPE");
    }



    @Override
    public String getTuppleID() {
        return id_type_accident;
    }

    @Override
    public String getAttributIDName() {
        return "id_type_accident";
    }
}

