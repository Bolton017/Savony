package stock;

public class AnomalieTransfert extends  TransfertStockDetailsCpl{

    private String idTransfert;

    private String designation;

    private String magasinDepartLib;
    private String magasinDepart;

    private String magasinArriveLib;
    private String magasinArrive;

    private double montant;

    private double envoye;
    private double montantEnvoye;

    private double recu;
    private double montantRecu;

    private double ecart;
    private double montantEcart;

    private double reste;

    private String idDepartementLibDepart, idDepartementLibArrive, idDepartementDepart, idDepartementArrive;

    public String  getAttributIDName () {
        return "idTransfert";
    }

    public AnomalieTransfert(){
        this.setNomTable("anomalieTransfert");
    }

    public String getIdTransfert() {
        return idTransfert;
    }

    public void setIdTransfert(String idTransfert) {
        this.idTransfert = idTransfert;
    }

    public double getMontant() {
        return montant;
    }

    public void setMontant(double montant) {
        this.montant = montant;
    }

    public String getDesignation() {
        return designation;
    }

    public void setDesignation(String designation) {
        this.designation = designation;
    }

    public String getMagasinDepartLib() {
        return magasinDepartLib;
    }

    public void setMagasinDepartLib(String magasinDepartLib) {
        this.magasinDepartLib = magasinDepartLib;
    }

    public String getMagasinDepart() {
        return magasinDepart;
    }

    public void setMagasinDepart(String magasinDepart) {
        this.magasinDepart = magasinDepart;
    }

    public String getMagasinArriveLib() {
        return magasinArriveLib;
    }

    public void setMagasinArriveLib(String magasinArriveLib) {
        this.magasinArriveLib = magasinArriveLib;
    }

    public String getMagasinArrive() {
        return magasinArrive;
    }

    public void setMagasinArrive(String magasinArrive) {
        this.magasinArrive = magasinArrive;
    }

    public double getEnvoye() {
        return envoye;
    }

    public void setEnvoye(double envoye) {
        this.envoye = envoye;
    }

    public double getMontantEnvoye() {
        return montantEnvoye;
    }

    public void setMontantEnvoye(double montantEnvoye) {
        this.montantEnvoye = montantEnvoye;
    }

    public double getRecu() {
        return recu;
    }

    public void setRecu(double recu) {
        this.recu = recu;
    }

    public double getMontantRecu() {
        return montantRecu;
    }

    public void setMontantRecu(double montantRecu) {
        this.montantRecu = montantRecu;
    }

    public double getEcart() {
        return ecart;
    }

    public void setEcart(double ecart) {
        this.ecart = ecart;
    }

    public double getMontantEcart() {
        return montantEcart;
    }

    public void setMontantEcart(double montantEcart) {
        this.montantEcart = montantEcart;
    }

    public double getReste() {
        return reste;
    }

    public void setReste(double reste) {
        this.reste = reste;
    }

    public String getIdDepartementArrive() {
        return idDepartementArrive;
    }

    public void setIdDepartementArrive(String idDepartementArrive) {
        this.idDepartementArrive = idDepartementArrive;
    }

    public String getIdDepartementDepart() {
        return idDepartementDepart;
    }

    public void setIdDepartementDepart(String idDepartementDepart) {
        this.idDepartementDepart = idDepartementDepart;
    }

    public String getIdDepartementLibArrive() {
        return idDepartementLibArrive;
    }

    public void setIdDepartementLibArrive(String idDepartementLibArrive) {
        this.idDepartementLibArrive = idDepartementLibArrive;
    }

    public String getIdDepartementLibDepart() {
        return idDepartementLibDepart;
    }

    public void setIdDepartementLibDepart(String idDepartementLibDepart) {
        this.idDepartementLibDepart = idDepartementLibDepart;
    }
}
