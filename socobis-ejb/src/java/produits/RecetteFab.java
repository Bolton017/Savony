package produits;

import java.sql.Connection;

public class RecetteFab extends Recette {
    public RecetteFab() {
        this.setNomTable("AS_RECETTE");
    }
    public void controler(Connection c) throws Exception {

    }
}
