package maintenance.planning;

public class DemandeTravauxCpl extends DemandeTravaux{
    String idEntiteLib;
    String idSituationLib;
    String idMachineLib;
    String estExistantLib;
    String etatLib;
    String idDepartementLib;
    String prioriteLib;
    String idDepartementMaintenanceLib;
    String idOtFille;
    int qte;
    public String getIdOtFille() {
        return idOtFille;
    }

    public void setIdOtFille(String idOtFille) {
        this.idOtFille = idOtFille;
    }

    public String getIdDepartementLib() {
        return idDepartementLib;
    }

    public void setIdDepartementLib(String idDepartementLib) {
        this.idDepartementLib = idDepartementLib;
    }

    public String getEtatLib() {
        return etatLib;
    }

    public void setEtatLib(String etatLib) {
        this.etatLib = etatLib;
    }

    public DemandeTravauxCpl() {
        this.setNomTable("DemandeTravaux_Cpl");
    }

    public String getIdEntiteLib() {
        return idEntiteLib;
    }

    public void setIdEntiteLib(String idEntiteLib) {
        this.idEntiteLib = idEntiteLib;
    }

    public String getIdSituationLib() {
        return idSituationLib;
    }

    public void setIdSituationLib(String idSituationLib) {
        this.idSituationLib = idSituationLib;
    }

    public String getIdMachineLib() {
        return idMachineLib;
    }

    public void setIdMachineLib(String idMachineLib) {
        this.idMachineLib = idMachineLib;
    }

    public String getEstExistantLib() {
        return estExistantLib;
    }

    public void setEstExistantLib(String estExistantLib) {
        this.estExistantLib = estExistantLib;
    }

    public String getPrioriteLib() {
        return prioriteLib;
    }

    public void setPrioriteLib(String prioriteLib) {
        this.prioriteLib = prioriteLib;
    }

    public String getIdDepartementMaintenanceLib() {
        return idDepartementMaintenanceLib;
    }

    public void setIdDepartementMaintenanceLib(String idDepartementMaintenanceLib) {
        this.idDepartementMaintenanceLib = idDepartementMaintenanceLib;
    }

    public int getQte() {
        return qte;
    }

    public void setQte(int qte) {
        this.qte = qte;
    }
}
