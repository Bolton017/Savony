package fabrication;

public class FabricationCplAtelier extends FabricationCpl{
    private String atelier;
    private String idingredients;
    public FabricationCplAtelier() throws Exception {
        setNomTable("FABRICATIONCPLATELIER");
    }

    public String getAtelier() {
        return atelier;
    }

    public void setAtelier(String atelier) {
        this.atelier = atelier;
    }

    public String getIdingredients() {
        return idingredients;
    }

    public void setIdingredients(String idingredients) {
        this.idingredients = idingredients;
    }
}
