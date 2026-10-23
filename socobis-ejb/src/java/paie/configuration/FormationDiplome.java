package paie.configuration;

import bean.TypeObjet;

import java.sql.Connection;

public class FormationDiplome extends TypeObjet {
    public FormationDiplome() {
        this.setNomTable("FORMATION_DIPLOME");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("FD", "GET_SEQFORMATION_DIPLOME");
        this.setId(makePK(c));
    }

    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }
}
