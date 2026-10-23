package produits;

import bean.TypeObjet;

import java.sql.Connection;

public class TypeProduit extends TypeObjet {

    public TypeProduit(){
        this.setNomTable("TYPEPRODUIT");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("TP", "GETSEQTYPEPRODUIT");
        this.setId(makePK(c));
    }
}
