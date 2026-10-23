package caisse;

import bean.TypeObjet;

import java.sql.Connection;

public class Billet extends TypeObjet {

    public Billet() {
        super.setNomTable("BILLET");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("BILT", "GETSEQ_BILLET");
        this.setId(makePK(c));
    }


}
