package maintenance.travaux;

import bean.ClassMAPTable;

public class RapprochementTravaux extends ClassMAPTable {
    String id,idTravaux,idPersonnel,idPersonnelLib,dureeEstimatif_hms,dureeReel_hms,ecart_hms;
    double dureeEstimatif_seconde,dureeReel_seconde,ecart_seconde;
    double montantEstimatif,montantReel,montantEcart;

    public RapprochementTravaux() {
        this.setNomTable("RapprochementTravaux");
    }

    public String getIdPersonnelLib() {
        return idPersonnelLib;
    }

    public void setIdPersonnelLib(String idPersonnelLib) {
        this.idPersonnelLib = idPersonnelLib;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdTravaux() {
        return idTravaux;
    }

    public void setIdTravaux(String idTravaux) {
        this.idTravaux = idTravaux;
    }

    public String getIdPersonnel() {
        return idPersonnel;
    }

    public void setIdPersonnel(String idPersonnel) {
        this.idPersonnel = idPersonnel;
    }

    public String getDureeEstimatif_hms() {
        return dureeEstimatif_hms;
    }

    public void setDureeEstimatif_hms(String dureeEstimatif_hms) {
        this.dureeEstimatif_hms = dureeEstimatif_hms;
    }

    public String getDureeReel_hms() {
        return dureeReel_hms;
    }

    public void setDureeReel_hms(String dureeReel_hms) {
        this.dureeReel_hms = dureeReel_hms;
    }

    public String getEcart_hms() {
        return ecart_hms;
    }

    public void setEcart_hms(String ecart_hms) {
        this.ecart_hms = ecart_hms;
    }

    public double getDureeEstimatif_seconde() {
        return dureeEstimatif_seconde;
    }

    public void setDureeEstimatif_seconde(double dureeEstimatif_seconde) {
        this.dureeEstimatif_seconde = dureeEstimatif_seconde;
    }

    public double getDureeReel_seconde() {
        return dureeReel_seconde;
    }

    public void setDureeReel_seconde(double dureeReel_seconde) {
        this.dureeReel_seconde = dureeReel_seconde;
    }

    public double getEcart_seconde() {
        return ecart_seconde;
    }

    public void setEcart_seconde(double ecart_seconde) {
        this.ecart_seconde = ecart_seconde;
    }

    public double getMontantEstimatif() {
        return montantEstimatif;
    }

    public void setMontantEstimatif(double montantEstimatif) {
        this.montantEstimatif = montantEstimatif;
    }

    public double getMontantReel() {
        return montantReel;
    }

    public void setMontantReel(double montantReel) {
        this.montantReel = montantReel;
    }

    public double getMontantEcart() {
        return montantEcart;
    }

    public void setMontantEcart(double montantEcart) {
        this.montantEcart = montantEcart;
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
