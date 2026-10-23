package fabrication;

public class RessourceParFabricationLib extends RessourceParFabrication {
    String idPosteLib;
    String etatLib;

    public String getEtatLib() {
        return etatLib;
    }

    public void setEtatLib(String etatLib) {
        this.etatLib = etatLib;
    }

    public String getIdPosteLib() {
        return idPosteLib;
    }

    public void setIdPosteLib(String idPosteLib) {
        this.idPosteLib = idPosteLib;
    }

    public RessourceParFabricationLib() {
        super.setNomTable("RESSOURCEPARFABRICATIONCOMPLET");
    }

}