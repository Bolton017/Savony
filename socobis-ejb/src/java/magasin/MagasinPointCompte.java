package magasin;

import bean.ClassMAPTable;
import java.sql.Connection;

public class MagasinPointCompte extends ClassMAPTable {
    private int nbrMagasin;

    public int getNbrMagasin() {
        return nbrMagasin;
    }

    public void setNbrMagasin(int nbrMagasin) {
        this.nbrMagasin = nbrMagasin;
    }

    public MagasinPointCompte() throws Exception {
        this.setNomTable("MAGASINPOINTCOMPTE");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("","");
    }

    @Override
    public String getTuppleID() {
        return "";
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }
}

