package maintenance.configuration;

import bean.TypeObjet;

import java.sql.Connection;

public class TypeMaintenance extends TypeObjet {
    public TypeMaintenance() {
        this.setNomTable("TypeMaintenance");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("TM", "getSeqTypeMaintenance");
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
