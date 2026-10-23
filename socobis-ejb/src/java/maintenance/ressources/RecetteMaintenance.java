
package maintenance.ressources;

import produits.Recette;


public class RecetteMaintenance extends Recette{
    String idProduitsLib , IdIngredientsLib , idIngredientsMaintenance , uniteLib;

    public String getUniteLib() {
        return uniteLib;
    }

    public void setUniteLib(String uniteLib) {
        this.uniteLib = uniteLib;
    }

    public RecetteMaintenance() {
        setNomTable("AS_Recette_Maintenance_lib");
    }

    public String getIdProduitsLib() {
        return idProduitsLib;
    }

    public void setIdProduitsLib(String idProduitsLib) {
        this.idProduitsLib = idProduitsLib;
    }

    public String getIdIngredientsLib() {
        return IdIngredientsLib;
    }

    public void setIdIngredientsLib(String IdIngredientsLib) {
        this.IdIngredientsLib = IdIngredientsLib;
    }

    public String getIdIngredientsMaintenance() {
        return idIngredientsMaintenance;
    }

    public void setIdIngredientsMaintenance(String idIngredientsMaintenance) {
        this.idIngredientsMaintenance = idIngredientsMaintenance;
    }
    
            



    
}
