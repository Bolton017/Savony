package avoir;

public class AvoirAchatFilleLib extends  AvoirAchatFille {

    String idProduitLib;
    String idDeviseLib;
    private double montantHT;
    private double montantTva;
    private double montantTTC;
    private double montant;
    private double montantRemise;

    public double getMontantHT() {
        return montantHT;
    }

    public void setMontantHT(double montantHT) {
        this.montantHT = montantHT;
    }

    public double getMontantTva() {
        return montantTva;
    }

    public void setMontantTva(double montantTva) {
        this.montantTva = montantTva;
    }

    public double getMontantTTC() {
        return montantTTC;
    }

    public void setMontantTTC(double montantTTC) {
        this.montantTTC = montantTTC;
    }

    public double getMontant() {
        return montant;
    }

    public void setMontant(double montant) {
        this.montant = montant;
    }

    public double getMontantRemise() {
        return montantRemise;
    }

    public void setMontantRemise(double montantRemise) {
        this.montantRemise = montantRemise;
    }

    public AvoirAchatFilleLib() throws Exception {
        setNomTable("AVOIRACHATFILLELIB");
    }

    public AvoirAchatFilleLib(String nomTable) {
        super(nomTable);
    }

    public String getIdProduitLib() {
        return idProduitLib;
    }

    public void setIdProduitLib(String idProduitLib) {
        this.idProduitLib = idProduitLib;
    }

    public String getIdDeviseLib() {
        return idDeviseLib;
    }

    public void setIdDeviseLib(String idDeviseLib) {
        this.idDeviseLib = idDeviseLib;
    }
}
