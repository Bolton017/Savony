package machine;

import bean.ClassMAPTable;
import java.sql.Connection;

public class ElementInspectionMachine extends ClassMAPTable {
    private String id;
    private String idelementinspection;
    private String idmachine;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdelementinspection() {
        return idelementinspection;
    }

    public void setIdelementinspection(String idelementinspection) {
        this.idelementinspection = idelementinspection;
    }

    public String getIdmachine() {
        return idmachine;
    }

    public void setIdmachine(String idmachine) {
        this.idmachine = idmachine;
    }



    public ElementInspectionMachine() throws Exception {
        this.setNomTable("ELEMENTINSPECTIONMACHINE");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("ELM","getSeqelementInspectionMachine");
        this.setId(makePK(c));
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

