package maintenance.travaux;

public class MoTravauxLib extends MoTravaux{
    String idPersonnelLib,dureeEstimatifLib;
    double montant;

    public MoTravauxLib() {
        this.setNomTable("MoTravauxLib");
    }

    public String getIdPersonnelLib() {
        return idPersonnelLib;
    }

    public void setIdPersonnelLib(String idPersonnelLib) {
        this.idPersonnelLib = idPersonnelLib;
    }

    public String getDureeEstimatifLib() {
        return dureeEstimatifLib;
    }

    public void setDureeEstimatifLib(String dureeEstimatifLib) {
        this.dureeEstimatifLib = dureeEstimatifLib;
    }

    public double getMontant() {
        return montant;
    }

    public void setMontant(double montant) {
        this.montant = montant;
    }
}
