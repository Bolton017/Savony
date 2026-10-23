package stock;

import java.sql.Date;

public class MvtStockFilleEntreeFab extends MvtStockFille {
    private String idproduitlib;
    private String idfab;
    private Date daty;
    private String categorieIngredient;

    public String getIdproduitlib() {
        return idproduitlib;
    }

    public void setIdproduitlib(String idproduitlib) {
        this.idproduitlib = idproduitlib;
    }

    public String getIdfab() {
        return idfab;
    }

    public void setIdfab(String idfab) {
        this.idfab = idfab;
    }

    public MvtStockFilleEntreeFab() throws Exception {
        this.setNomTable("MVTSTOCKFILLEENTREEFAB");
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    @Override
    public String getCategorieIngredient() {
        return categorieIngredient;
    }

    @Override
    public void setCategorieIngredient(String categorieIngredient) {
        this.categorieIngredient = categorieIngredient;
    }
}

