package maintenance.configuration;

import bean.TypeObjet;

import java.sql.Connection;

public class Entite extends TypeObjet {
    public Entite() {
        this.setNomTable("Entite");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("ENT", "getSeqEntite");
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
