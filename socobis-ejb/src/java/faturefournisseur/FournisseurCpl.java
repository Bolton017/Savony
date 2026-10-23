package faturefournisseur;

public class FournisseurCpl extends Fournisseur {
    private int nb;
    String compteauxiliaire;

    public FournisseurCpl() {
        this.setNomTable("FournisseurCpl");
    }

    public int getNb() {
        return nb;
    }

    public void setNb(int nb) {
        this.nb = nb;
    }

    public String getCompteauxiliaire() {
        return compteauxiliaire;
    }

    public void setCompteauxiliaire(String compteauxiliaire) {
        this.compteauxiliaire = compteauxiliaire;
    }
     @Override
    public String[] getMotCles() {
        String[] motCles={"id","nom","compte","compteauxiliaire"};
        return motCles;
    }

    @Override
    public String[] getValMotCles() {
        String[] valMotCles={"id","nom","compte","compteauxiliaire"};
        return valMotCles;
    }
    
}
