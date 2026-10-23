package faturefournisseur;

public class DmdAchatFilleLib extends DmdAchatFille {
    private double montantTotal;

    public double getMontantTotal() {
        return montantTotal;
    }

    public void setMontantTotal(double montantTotal) {
        this.montantTotal = montantTotal;
    }

    public DmdAchatFilleLib() throws Exception {
        this.setNomTable("DMDACHATFILLELIB");
    }
}
