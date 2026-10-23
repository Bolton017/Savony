package maintenance.travaux;

public class ProcessMaintenanceLib extends ProcessMaintenance{
    String idPersonnelLib,ecart_hms;
    int ecart_seconde;

    public ProcessMaintenanceLib() {
        this.setNomTable("ProcessMaintenanceLib");
    }

    public String getIdPersonnelLib() {
        return idPersonnelLib;
    }

    public void setIdPersonnelLib(String idPersonnelLib) {
        this.idPersonnelLib = idPersonnelLib;
    }

    public String getEcart_hms() {
        return ecart_hms;
    }

    public void setEcart_hms(String ecart_hms) {
        this.ecart_hms = ecart_hms;
    }

    public int getEcart_seconde() {
        return ecart_seconde;
    }

    public void setEcart_seconde(int ecart_seconde) {
        this.ecart_seconde = ecart_seconde;
    }
}
