package maintenance.travaux;

import bean.ClassMAPTable;

public class TravauxRecap extends ClassMAPTable {
    String id;
    double montantChargeExterne,montantPiece,montantMainDoeuvre,montantTotal;

    public TravauxRecap() {
        this.setNomTable("TRAVAUX_RECAP");
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

    public double getMontantChargeExterne() {
        return montantChargeExterne;
    }

    public void setMontantChargeExterne(double montantChargeExterne) {
        this.montantChargeExterne = montantChargeExterne;
    }

    public double getMontantPiece() {
        return montantPiece;
    }

    public void setMontantPiece(double montantPiece) {
        this.montantPiece = montantPiece;
    }

    public double getMontantMainDoeuvre() {
        return montantMainDoeuvre;
    }

    public void setMontantMainDoeuvre(double montantMainDoeuvre) {
        this.montantMainDoeuvre = montantMainDoeuvre;
    }

    public double getMontantTotal() {
        return montantTotal;
    }

    public void setMontantTotal(double montantTotal) {
        this.montantTotal = montantTotal;
    }
}
