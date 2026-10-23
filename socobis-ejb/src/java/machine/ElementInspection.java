package machine;

import bean.TypeObjet;
import java.sql.Connection;

public class ElementInspection extends TypeObjet {



    public ElementInspection() throws Exception {
        this.setNomTable("ELEMENTINSPECTION");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("ELI","getSeqelementInspection");
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

