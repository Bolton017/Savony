package produits;

import bean.TypeObjet;

import java.sql.Connection;

public class Critere extends TypeObjet {

    public Critere(){
        this.setNomTable("CRITERE");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("CRT", "GETSEQCRITERE");
        this.setId(makePK(c));
    }
}
