package declaration;

import bean.ClassMAPTable;
import java.sql.Connection;

public class SousEcritureDeclarer extends ClassMAPTable {
    private String id;
    private String idSousEcriture;
    private int moisDeclaration;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdSousEcriture() {
        return idSousEcriture;
    }

    public void setIdSousEcriture(String idSousEcriture) {
        this.idSousEcriture = idSousEcriture;
    }

    public int getMoisDeclaration() {
        return moisDeclaration;
    }

    public void setMoisDeclaration(int moisDeclaration) {
        this.moisDeclaration = moisDeclaration;
    }

    public SousEcritureDeclarer() throws Exception {
        this.setNomTable("SOUSECRITUREDECLARER");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("SED","getSeqSousEcritureDeclarer");
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

