package maintenance.configuration;

import bean.TypeObjet;

import java.sql.Connection;

public class TypePanne extends TypeObjet {
    public TypePanne() {
        this.setNomTable("TypePanne");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("TP", "getSeqTypePanne");
        this.setId(makePK(c));
    }

    @Override
    public String[] getMotCles() {
        String[] motCles={"id","val"};
        return motCles;
    }

    @Override
    public String[] getValMotCles() {
        String[] valMotCles={"val"};
        return valMotCles;
    }
}
