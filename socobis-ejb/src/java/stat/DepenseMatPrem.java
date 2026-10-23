package stat;

import bean.ClassMAPTable;

import java.sql.Date;

public class DepenseMatPrem extends ClassMAPTable {
    private String id;
    private Date daty;
    private String designation;
    private int quantite;
    private double pu;
    private double depense;

    public DepenseMatPrem() {
        setNomTable("DEPENSE_MAT_PREM");
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public String getDesignation() {
        return designation;
    }

    public void setDesignation(String designation) {
        this.designation = designation;
    }

    public int getQuantite() {
        return quantite;
    }

    public void setQuantite(int quantite) {
        this.quantite = quantite;
    }

    public double getPu() {
        return pu;
    }

    public void setPu(double pu) {
        this.pu = pu;
    }

    public double getDepense() {
        return depense;
    }

    public void setDepense(double depense) {
        this.depense = depense;
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
