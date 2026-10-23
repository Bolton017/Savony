package maintenance.planning;

public class FrequencePanneMachine extends DemandeTravaux {

    private String idMachineLib;

    private int qte;

    public FrequencePanneMachine(){
        this.setNomTable("frequence_panne_machine");
    }

    public String getIdMachineLib() {
        return idMachineLib;
    }

    public void setIdMachineLib(String idMachineLib) {
        this.idMachineLib = idMachineLib;
    }

    public int getQte() {
        return qte;
    }

    public void setQte(int qte) {
        this.qte = qte;
    }
}
