package annexe;

public class EquivalenceLib extends  EquivalenceCarton{
    String idPetrisLib, idCartonLib;

    public EquivalenceLib(){
        this.setNomTable("EQUIVALENCECARTONLIB");
    }

    public String getIdPetrisLib() {
        return idPetrisLib;
    }

    public void setIdPetrisLib(String idPetrisLib) {
        this.idPetrisLib = idPetrisLib;
    }

    public String getIdCartonLib() {
        return idCartonLib;
    }

    public void setIdCartonLib(String idCartonLib) {
        this.idCartonLib = idCartonLib;
    }
}
