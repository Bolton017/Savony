package stock;
import bean.ClassMere;

public class TransfertDashboardCpl extends ClassMere {
    private String id, designation, idMagasinDepartLib, idMagasinArriveLib, statutLib;
    private java.sql.Date daty;
    private double nb,valeurTransferee;

    public double getValeurTransferee() {
        return valeurTransferee;
    }

    public void setValeurTransferee(double valeurTransferee) {
        this.valeurTransferee = valeurTransferee;
    }

    public double getNb() {
        return nb;
    }

    public void setNb(double nb) {
        this.nb = nb;
    }

    public TransfertDashboardCpl() { this.setNomTable("V_TRANSFERT_DASHBOARD"); }

    @Override public String getTuppleID() { return id; }
    @Override public String getAttributIDName() { return "id"; }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getDesignation() {
        return designation;
    }

    public void setDesignation(String designation) {
        this.designation = designation;
    }

    // Getters et Setters
    public String getIdMagasinDepartLib() { return idMagasinDepartLib; }
    public void setIdMagasinDepartLib(String idMagasinDepartLib) { this.idMagasinDepartLib = idMagasinDepartLib; }
    public String getIdMagasinArriveLib() { return idMagasinArriveLib; }
    public void setIdMagasinArriveLib(String idMagasinArriveLib) { this.idMagasinArriveLib = idMagasinArriveLib; }
    public String getStatutLib() { return statutLib; }
    public void setStatutLib(String statutLib) { this.statutLib = statutLib; }
    public java.sql.Date getDaty() { return daty; }
    public void setDaty(java.sql.Date daty) { this.daty = daty; }
}