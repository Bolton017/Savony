package produits;

public class RecetteMereLib extends RecetteMere{
    private String idProduitLib;

    public RecetteMereLib() throws Exception {
        setNomTable("RECETTE_MERE_LIB");
    }

    public String getIdProduitLib() {
        return idProduitLib;
    }

    public void setIdProduitLib(String idProduitLib) {
        this.idProduitLib = idProduitLib;
    }

}
