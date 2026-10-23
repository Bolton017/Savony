package machine;

import bean.TypeObjet;

import java.sql.Connection;

public class Ligne extends TypeObjet {

    public Ligne(){
        this.setNomTable("LIGNE");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("LGN", "GETSEQLIGNE");
        this.setId(makePK(c));
    }
}
