package mg.cnaps.compta;

public class ComptaCompteCpl extends ComptaCompte {
    private String compteInt;
    private String cpt;

    public ComptaCompteCpl() {
        this.setNomTable("v_compta_compte");
    }

    public String getCpt() {
        return cpt;
    }

    public void setCpt(String cpt) {
        this.cpt = cpt;
    }

    public String getCompteInt() {
        return compteInt;
    }

    public void setCompteInt(String compteInt) {
        this.compteInt = compteInt;
    }
}
