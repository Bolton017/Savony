package declaration;

public class LiaisonCodeImpotSaisie extends LiaisonCodeImpot{
    String valeur;

    public String getValeur() {
        return valeur;
    }

    public void setValeur(String valeur) {
        this.valeur = valeur;
    }

    public LiaisonCodeImpotSaisie() throws Exception {
        this.setNomTable("LIAISONCODESAISIE");
    }
}
