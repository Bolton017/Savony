package paie.accident;

import bean.ClassMAPTable;
import java.sql.Connection;

public class LieuAccidentTravail extends ClassMAPTable {
    private String id;
    private String val;
    private String desce;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getVal() {
        return val;
    }

    public void setVal(String val) {
        this.val = val;
    }

    public String getDesce() {
        return desce;
    }

    public void setDesce(String desce) {
        this.desce = desce;
    }



    public LieuAccidentTravail() throws Exception {
        this.setNomTable("LIEU_ACCIDENT_TRAVAIL");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("LAT","getSeqaccidenttravail");
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

