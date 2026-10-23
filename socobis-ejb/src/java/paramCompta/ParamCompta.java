package paramCompta;

import bean.ClassMAPTable;
import bean.TypeObjet;
import historique.MapUtilisateur;

import java.sql.Connection;

public class ParamCompta extends TypeObjet {
    public ParamCompta() {
        this.setNomTable("PARAMCOMPTA");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("PARAM", "getSeqParamCompta");
        this.setId(makePK(c));
    }

    @Override
    public ClassMAPTable createObject(MapUtilisateur u, Connection c) throws Exception {
        ClassMAPTable retour = super.createObject(u, c);
        ParamComptaStatique.reload(c);
        return retour;
    }

    @Override
    public int updateToTableWithHisto(String refUser, Connection c) throws Exception {
        int retour = super.updateToTableWithHisto(refUser, c);
        ParamComptaStatique.reload(c);
        return retour;
    }
}
