package paie.employe;

import bean.ClassMAPTable;
import java.sql.Connection;

/**
 *
 * @author Finaritra
 */
public class PersonnelClasse extends ClassMAPTable{
    private String id;
    private String val;
    private String desce;
    private int rang;
    public PersonnelClasse() {
        super.setNomTable("personnel_classe");
    }

    public PersonnelClasse(String val, String desce, int rang) {
        this.val = val;
        this.desce = desce;
        this.rang = rang;
        super.setNomTable("personnel_classe");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("CLS", "getseqpersonnelclasse");
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

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getVal() {
        return val;
    }

    public void setVal(String val) {
        this.val = val;
    }

    public String getDesce() {
        return desce;
    }

    public void setDesce(String desce) {
        this.desce = desce;
    }

    public double getRang() {
        return rang;
    }

    public void setRang(int rang) {
        this.rang = rang;
    }
}