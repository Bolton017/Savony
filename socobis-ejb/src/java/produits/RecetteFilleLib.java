package produits;

public class RecetteFilleLib extends RecetteFille{

    private String idIngredientLib;

    public RecetteFilleLib() throws Exception {
        setNomTable("RECETTE_FILLE_LIB");
    }

    public String getIdIngredientLib() {
        return idIngredientLib;
    }

    public void setIdIngredientLib(String idIngredientLib) {
        this.idIngredientLib = idIngredientLib;
    }

}
