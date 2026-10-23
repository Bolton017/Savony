package machine;

import bean.ClassMAPTable;
import bean.TypeObjet;

import java.sql.Connection;

public class Machine extends TypeObjet {

    String idLigne;

    public String getIdLigne() {
        return idLigne;
    }

    public void setIdLigne(String idLigne) {
        this.idLigne = idLigne;
    }

    public Machine(){
        this.setNomTable("MACHINE");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("MACHN", "GETSEQMACHINE");
        this.setId(makePK(c));
    }
}
