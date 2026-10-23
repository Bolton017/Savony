package caisse;

public class MouvementCaisseMereCpl extends MouvementCaisseMere{
    String idmodepaiementlib,idtierslib;

    public MouvementCaisseMereCpl() throws Exception {
        this.setNomTable("mouvementcaissemerelib");
    }

    public String getIdmodepaiementlib() {
        return idmodepaiementlib;
    }

    public void setIdmodepaiementlib(String idmodepaiementlib) {
        this.idmodepaiementlib = idmodepaiementlib;
    }

    public String getIdtierslib() {
        return idtierslib;
    }

    public void setIdtierslib(String idtierslib) {
        this.idtierslib = idtierslib;
    }
    
}
