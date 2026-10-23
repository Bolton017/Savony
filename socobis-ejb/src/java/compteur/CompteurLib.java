package compteur;

public class CompteurLib extends Compteur {
    String idFabricationLib, idMachineLib, etatLib;

    public CompteurLib(){
        this.setNomTable("COMPTEURLIB");
    }

    public String getIdFabricationLib() {
        return idFabricationLib;
    }

    public void setIdFabricationLib(String idFabricationLib) {
        this.idFabricationLib = idFabricationLib;
    }

    public String getIdMachineLib() {
        return idMachineLib;
    }

    public void setIdMachineLib(String idMachineLib) {
        this.idMachineLib = idMachineLib;
    }

    public String getEtatLib() {
        return etatLib;
    }

    public void setEtatLib(String etatLib) {
        this.etatLib = etatLib;
    }
}
