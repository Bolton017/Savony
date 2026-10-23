package rapprochement;

public class RapprochementDBMereLib extends RapprochementDBMere{
    private String idbanquelib;
    private String etatlib;

    public String getEtatlib() {
        return etatlib;
    }
    public void setEtatlib(String etatlib) {
        this.etatlib = etatlib;
    }

    public String getIdbanquelib() {
        return idbanquelib;
    }

    public void setIdbanquelib(String idbanquelib) {
        this.idbanquelib = idbanquelib;
    }

    public RapprochementDBMereLib() throws Exception {
        this.setNomTable("RAPPROCHEMENTBCMERELIB");
    }
}
