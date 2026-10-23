package maintenance.ressources;

import bean.TypeObjet;

import java.sql.Connection;

public class DepartementMaintenance extends TypeObjet {
    public DepartementMaintenance() {
        setNomTable("departementmaintenance");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("DEP", "get_seq_depmain");
        this.setId(makePK(c));
    }
}
