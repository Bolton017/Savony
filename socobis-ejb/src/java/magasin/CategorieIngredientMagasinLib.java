/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package magasin;

/**
 *
 * @author Angela
 */
public class CategorieIngredientMagasinLib extends CategorieIngredientMagasin {

    String idMagasinLib;
    String idCategorieIngredientLib;

    public String getIdMagasinLib() {
        return idMagasinLib;
    }

    public void setIdMagasinLib(String idMagasinLib) {
        this.idMagasinLib = idMagasinLib;
    }

    public String getIdCategorieIngredientLib() {
        return idCategorieIngredientLib;
    }

    public void setIdCategorieIngredientLib(String idCategorieIngredientLib) {
        this.idCategorieIngredientLib = idCategorieIngredientLib;
    }

    public CategorieIngredientMagasinLib() throws Exception {
        this.setNomTable("v_categorieIngredientMaglib");
    }
}
