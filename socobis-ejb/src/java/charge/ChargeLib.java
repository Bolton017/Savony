package charge;

public class ChargeLib extends Charge{
    private String idOf;
    private String idOffille;

    public ChargeLib() {
        this.setNomTable("charge_lib");
    }
    public String getIdOffille() {
        return idOffille;
    }
    public void setIdOffille(String idOffille) {
        this.idOffille = idOffille;
    }
    public String getIdOf() {
        return idOf;
    }
    public void setIdOf(String idOf) {
        this.idOf = idOf;
    }
}
