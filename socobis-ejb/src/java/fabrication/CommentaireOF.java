package fabrication;

import bean.ClassMAPTable;
import java.sql.Connection;

public class CommentaireOF extends ClassMAPTable {
    private String id;
    private String idObjet;
    private String val;
    private String idPersonnel;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdObjet() {
        return idObjet;
    }

    public void setIdObjet(String idObjet) {
        this.idObjet = idObjet;
    }

    public String getVal() {
        return val;
    }

    public void setVal(String val) {
        this.val = val;
    }

    public String getIdPersonnel() {
        return idPersonnel;
    }

    public void setIdPersonnel(String idPersonnel) {
        this.idPersonnel = idPersonnel;
    }

    public CommentaireOF() throws Exception {
        this.setNomTable("COMMENTAIREOF");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("COF","getSeqCommOF");
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

