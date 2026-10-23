package fabrication.equipe;

import bean.ClassMere;
import java.sql.Connection;

public class Equipe extends ClassMere {
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

    public Equipe() throws Exception {
        this.setNomTable("EQUIPE");
        this.setNomClasseFille("fabrication.equipe.CompositionEquipe");
        this.setLiaisonFille("idEquipe");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("EQP","getseq_equipe");
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

    @Override
    public String getLiaisonFille() {
        return  "idEquipe";
    }

    @Override
    public String getNomClasseFille() {
        return "fabrication.equipe.CompositionEquipe";
    }
}

