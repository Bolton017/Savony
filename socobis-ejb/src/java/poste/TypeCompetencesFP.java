package poste;

import bean.CGenUtil;
import bean.TypeObjet;
import java.sql.Connection;

public class TypeCompetencesFP extends TypeObjet {



    public TypeCompetencesFP() throws Exception {
        this.setNomTable("TYPE_COMPETENCES_FP");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("TPC","GETSEQ_TYPE_COMPETENCES_FP");
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
    public String[] getMotCles() {
        String[] motCles={"id","val"};
        return motCles;
    }
    @Override
    public String[] getValMotCles() {
        String[] valMotCles={"id","val"};
        return valMotCles;
    }

    public TypeCompetencesFP getTypeCompetencesFP(String id) throws Exception {
        TypeCompetencesFP typeCompetencesFP = new TypeCompetencesFP();
        typeCompetencesFP.setId(id);
        typeCompetencesFP = (TypeCompetencesFP) CGenUtil.rechercher(typeCompetencesFP, null, null, " ")[0];
        return typeCompetencesFP;
    }
}

