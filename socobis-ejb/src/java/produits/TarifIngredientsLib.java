package produits;

public class TarifIngredientsLib extends TarifIngredients{

    private String idtypeclientlib;
    private String idingredientlib;
    private String unitelib;

    public String getUnitelib() {
        return unitelib;
    }
    public void setUnitelib(String unitelib) {
        this.unitelib = unitelib;
    }

    public TarifIngredientsLib(){
        this.setNomTable("tarif_ingredients_lib");
    }

    public String getIdtypeclientlib() {
        return idtypeclientlib;
    }

    public void setIdtypeclientlib(String idtypeclientlib) {
        this.idtypeclientlib = idtypeclientlib;
    }

    public String getIdingredientlib() {
        return idingredientlib;
    }

    public void setIdingredientlib(String idingredientlib) {
        this.idingredientlib = idingredientlib;
    }
}
