
package ordredepaiement;


public class OrdreDePaiementLib extends OrdreDePaiement{
    private String tiersLib , modepaiementLib;

    public OrdreDePaiementLib() throws Exception {
        this.setNomTable("ORDREDEPAIEMENTLIB");
    }

    public String getTiersLib() {
        return tiersLib;
    }

    public void setTiersLib(String tiersLib) {
        this.tiersLib = tiersLib;
    }

    public String getModepaiementLib() {
        return modepaiementLib;
    }

    public void setModepaiementLib(String modepaiementLib) {
        this.modepaiementLib = modepaiementLib;
    }

    
    
    
    
    
}
