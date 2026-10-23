package opfacture;

import bean.ClassEtat;

import java.sql.Connection;
import java.sql.Date;

public class OpFacture extends ClassEtat {
    private String id;
    private String idop;
    private String idfacture;
    private double montant;
    private Date daty;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdop() {
        return idop;
    }

    public void setIdop(String idop) {
        this.idop = idop;
    }

    public String getIdfacture() {
        return idfacture;
    }

    public void setIdfacture(String idfacture) {
        this.idfacture = idfacture;
    }

    public double getMontant() {
        return montant;
    }

    public void setMontant(double montant) {
        this.montant = montant;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public OpFacture()  {
        this.setNomTable("OPFACTURE");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("OPF","getSeqOpFacture");
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

