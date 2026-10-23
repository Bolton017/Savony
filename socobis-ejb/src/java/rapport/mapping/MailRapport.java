package rapport.mapping;

import java.sql.Connection;

import bean.TypeObjet;

public class MailRapport extends TypeObjet{

    public MailRapport(){
        this.setNomTable("MAILRAPPORT");
    }

    public void construirePK(Connection c) throws Exception {
        this.preparePk("MR", "getseqMailRapport");
        this.setId(makePK(c));
    }
}
