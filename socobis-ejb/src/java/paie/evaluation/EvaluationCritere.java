package paie.evaluation;

import bean.CGenUtil;
import bean.TypeObjet;
import java.sql.Connection;

public class EvaluationCritere extends TypeObjet {



    public EvaluationCritere() throws Exception {
        this.setNomTable("EVALUATION_CRITERE");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("EVC","GET_SEQ_EVALUATION_CRITERE");
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

    public EvaluationCritere[] evaluationCriteres() throws Exception {
        EvaluationCritere[] evaluationCriteres = (EvaluationCritere[]) CGenUtil.rechercher(new EvaluationCritere(), null, null, "");
        return evaluationCriteres;
    }
}

