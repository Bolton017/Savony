package besoin;

public class BesoinFabricationDetailsLib extends BesoinFabricationDetails{
    String produitLib;
    String idproduitlib;
    String unitelib;

    

    public String getUnitelib() {
        return unitelib;
    }

    public void setUnitelib(String unitelib) {
        this.unitelib = unitelib;
    }

    public String getProduitLib() {
        return produitLib;
    }

    public void setProduitLib(String produitLib) {
        this.produitLib = produitLib;
    }

    public BesoinFabricationDetailsLib() throws Exception {
        this.setNomTable("BESOINFABRICATIONDETAILSCPL");
    }

    public String getIdproduitlib() {
        return idproduitlib;
    }

    public void setIdproduitlib(String idproduitlib) {
        this.idproduitlib = idproduitlib;
    }
}
