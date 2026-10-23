package maintenance.configuration;

import bean.TypeObjet;

import java.sql.Connection;

public class Situation extends TypeObjet {
    public Situation() {
        this.setNomTable("Situation");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("SIT", "getSeqSituation");
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
