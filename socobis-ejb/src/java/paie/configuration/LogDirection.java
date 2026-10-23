package paie.configuration;


import bean.ClassEtat;
import bean.ClassMAPTable;
import bean.TypeObjet;
import constante.ConstanteEtat;
import java.sql.Connection;
import java.sql.Date;

public class LogDirection extends TypeObjet {

    public LogDirection() {
        this.setNomTable("LOG_DIRECTION");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("DIR", "getSEQ_LOG_DIRECTION");
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

