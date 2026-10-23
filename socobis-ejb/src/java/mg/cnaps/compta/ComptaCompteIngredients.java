package mg.cnaps.compta;

public class ComptaCompteIngredients extends ComptaCompte {
    private String libelleIngredient;
    private String idIngredient;

    public ComptaCompteIngredients() {
        this.setNomTable("COMPTA_COMPTE_INGREDIENTS");
    }

    public String getLibelleIngredient() {
        return libelleIngredient;
    }

    public void setLibelleIngredient(String libelleIngredient) {
        this.libelleIngredient = libelleIngredient;
    }

    public String getIdIngredient() {
        return idIngredient;
    }

    public void setIdIngredient(String idIngredient) {
        this.idIngredient = idIngredient;
    }
    @Override
    public String[] getMotCles() {
        String[] motCles={"id","compte","libelle","libelleingredient"};
        return motCles;
    }

    @Override
    public String[] getValMotCles() {
        String[] valMotCles={"compte","libelle","libelleingredient"};
        return valMotCles;
    }
}
