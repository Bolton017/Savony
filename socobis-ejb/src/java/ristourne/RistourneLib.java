package ristourne;

public class RistourneLib extends Ristourne{
    String idClientLib, etatLib;

    public RistourneLib() throws Exception{
        this.setNomTable("RistourneLib");
    }

    public String getIdClientLib() {
        return idClientLib;
    }

    public void setIdClientLib(String idClientLib) {
        this.idClientLib = idClientLib;
    }

    public String getEtatLib() {
        return etatLib;
    }

    public void setEtatLib(String etaLib) {
        this.etatLib = etaLib;
    }
}
