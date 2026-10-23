package maintenance.etats;

import bean.TypeObjet;
import java.sql.Connection;

public class EtatMachine extends TypeObjet {
    public EtatMachine() throws Exception {
        this.setNomTable("ETATMACHINE");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("ETM","get_SEQETATMACHINE");
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

