package maintenance.ressources;

import bean.TypeObjet;

import java.sql.Connection;

public class Machine extends TypeObjet {

    public Machine(){
        this.setNomTable("MACHINE");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("MACHN", "GETSEQMACHINE");
        this.setId(makePK(c));
    }
}
