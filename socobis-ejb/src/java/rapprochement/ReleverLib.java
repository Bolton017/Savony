package rapprochement;

public class ReleverLib extends Relever{
    private String idcaisselib;
    private String etatlib;

    public String getEtatlib() {
        return etatlib;
    }
    public void setEtatlib(String etatlib) {
        this.etatlib = etatlib;
    }

    public String getIdcaisselib() {
        return idcaisselib;
    }
    public void setIdcaisselib(String idcaisselib) {
        this.idcaisselib = idcaisselib;
    }
    public ReleverLib() throws Exception {
        this.setNomTable("RELEVERLIB");
    }
}
