package rapprochement;

import bean.ClassMAPTable;

import java.sql.Date;

public class SousEcritureNR extends ClassMAPTable {
    private String id;
    private String libellePiece;
    private double debit;
    private double credit;
    private Date daty;
    private String idCaisse;

    public SousEcritureNR() {
        setNomTable("SousEcritureNR");
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getLibellePiece() {
        return libellePiece;
    }

    public void setLibellePiece(String libellePiece) {
        this.libellePiece = libellePiece;
    }

    public double getDebit() {
        return debit;
    }

    public void setDebit(double debit) {
        this.debit = debit;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public String getIdCaisse() {
        return idCaisse;
    }

    public void setIdCaisse(String idCaisse) {
        this.idCaisse = idCaisse;
    }

    public double getCredit() {
        return credit;
    }

    public void setCredit(double credit) {
        this.credit = credit;
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
