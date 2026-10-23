package faturefournisseur;

import bean.TypeObjet;

import java.sql.Connection;

public class TypeFournisseur extends TypeObjet {
    public TypeFournisseur() {
        super.setNomTable("TYPEFOURNISSEUR");
    }

    public void construirePK(Connection c) throws Exception {
        this.preparePk("TYPFR", "GETTYPEFOURNISSEUR");
        this.setId(makePK(c));
    }
}
