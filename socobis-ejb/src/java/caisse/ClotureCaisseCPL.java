package caisse;

public class ClotureCaisseCPL extends ClotureCaisse {

    private String idPointLib;
    private String idCaisseLib;
    private String etatLib;

    public ClotureCaisseCPL() throws Exception {
        this.setNomTable("CLOTURECAISSE_CPL");
    }

    public String getIdPointLib() {
        return idPointLib;
    }

    public void setIdPointLib(String idPointLib) {
        this.idPointLib = idPointLib;
    }

    public String getIdCaisseLib() {
        return idCaisseLib;
    }

    public void setIdCaisseLib(String idCaisseLib) {
        this.idCaisseLib = idCaisseLib;
    }

    public String getEtatLib() {
        return etatLib;
    }

    public void setEtatLib(String etatLib) {
        this.etatLib = etatLib;
    }
}