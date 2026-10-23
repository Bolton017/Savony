package maintenance.planning;

public class PlanningCpl extends Planning{
    String idMachineLib,idTypeMaintenanceLib,estPeriodiqueLib,etatLib,uniteLib;
    String priorite,prioriteLib,idDemandeTravaux,idOrdreTravaux,idOrdreTravauxFille;
    int etatDemandeTravaux,etatOrdreTravaux,etatTravaux,estTerminee;
    String etatDemandeTravauxLib,etatOrdreTravauxLib,etatTravauxLib,idTravaux,idEntite,idEntiteLib;

    public String getUniteLib() {
        return uniteLib;
    }

    public void setUniteLib(String uniteLib) {
        this.uniteLib = uniteLib;
    }

    public String getEtatLib() {
        return etatLib;
    }

    public void setEtatLib(String etatLib) {
        this.etatLib = etatLib;
    }

    public PlanningCpl() {
        this.setNomTable("PLANNING_CPL");
    }

    public String getIdMachineLib() {
        return idMachineLib;
    }

    public void setIdMachineLib(String idMachineLib) {
        this.idMachineLib = idMachineLib;
    }

    public String getIdTypeMaintenanceLib() {
        return idTypeMaintenanceLib;
    }

    public void setIdTypeMaintenanceLib(String idTypeMaintenanceLib) {
        this.idTypeMaintenanceLib = idTypeMaintenanceLib;
    }

    public String getEstPeriodiqueLib() {
        return estPeriodiqueLib;
    }

    public void setEstPeriodiqueLib(String estPeriodiqueLib) {
        this.estPeriodiqueLib = estPeriodiqueLib;
    }

    public String getPriorite() {
        return priorite;
    }

    public void setPriorite(String priorite) {
        this.priorite = priorite;
    }

    public String getPrioriteLib() {
        return prioriteLib;
    }

    public void setPrioriteLib(String prioriteLib) {
        this.prioriteLib = prioriteLib;
    }

    public String getIdDemandeTravaux() {
        return idDemandeTravaux;
    }

    public void setIdDemandeTravaux(String idDemandeTravaux) {
        this.idDemandeTravaux = idDemandeTravaux;
    }

    public String getIdOrdreTravaux() {
        return idOrdreTravaux;
    }

    public void setIdOrdreTravaux(String idOrdreTravaux) {
        this.idOrdreTravaux = idOrdreTravaux;
    }

    public String getIdOrdreTravauxFille() {
        return idOrdreTravauxFille;
    }

    public void setIdOrdreTravauxFille(String idOrdreTravauxFille) {
        this.idOrdreTravauxFille = idOrdreTravauxFille;
    }

    public int getEtatDemandeTravaux() {
        return etatDemandeTravaux;
    }

    public void setEtatDemandeTravaux(int etatDemandeTravaux) {
        this.etatDemandeTravaux = etatDemandeTravaux;
    }

    public int getEtatOrdreTravaux() {
        return etatOrdreTravaux;
    }

    public void setEtatOrdreTravaux(int etatOrdreTravaux) {
        this.etatOrdreTravaux = etatOrdreTravaux;
    }

    public int getEtatTravaux() {
        return etatTravaux;
    }

    public void setEtatTravaux(int etatTravaux) {
        this.etatTravaux = etatTravaux;
    }

    public int getEstTerminee() {
        return estTerminee;
    }

    public void setEstTerminee(int estTerminee) {
        this.estTerminee = estTerminee;
    }

    public String getEtatDemandeTravauxLib() {
        return etatDemandeTravauxLib;
    }

    public void setEtatDemandeTravauxLib(String etatDemandeTravauxLib) {
        this.etatDemandeTravauxLib = etatDemandeTravauxLib;
    }

    public String getEtatOrdreTravauxLib() {
        return etatOrdreTravauxLib;
    }

    public void setEtatOrdreTravauxLib(String etatOrdreTravauxLib) {
        this.etatOrdreTravauxLib = etatOrdreTravauxLib;
    }

    public String getEtatTravauxLib() {
        return etatTravauxLib;
    }

    public void setEtatTravauxLib(String etatTravauxLib) {
        this.etatTravauxLib = etatTravauxLib;
    }

    public String getIdTravaux() {
        return idTravaux;
    }

    public void setIdTravaux(String idTravaux) {
        this.idTravaux = idTravaux;
    }

    public String getIdEntite() {
        return idEntite;
    }

    public void setIdEntite(String idEntite) {
        this.idEntite = idEntite;
    }

    public String getIdEntiteLib() {
        return idEntiteLib;
    }

    public void setIdEntiteLib(String idEntiteLib) {
        this.idEntiteLib = idEntiteLib;
    }

    public int[] getDataRssume(PlanningCpl[] data) {
        int nombreDemande = data.length;

        int nombreRealise = 0;
        for (PlanningCpl planningCpl : data) {
            if (planningCpl.getEtatTravaux() == 41) {  // etat realisé
                nombreRealise++;
            }
        }

        return new int[]{nombreDemande, nombreRealise};
    }
}
