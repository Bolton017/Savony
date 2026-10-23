
package fabrication.equipe;

import bean.TypeObjet;
import java.sql.Connection;

public class EquipeEmp extends TypeObjet{

    public EquipeEmp() {
        this.setNomTable("EQUIPEEMP");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("EQE", "getseq_equipeemp");
        this.setId(makePK(c));
    }
}