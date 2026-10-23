package ristourne;

public class RistourneDetailsLib extends RistourneDetails{
    private String idProduitLib;

    public RistourneDetailsLib() throws Exception{
        this.setNomTable("RISTOURNEDETAILS_LIB");
    }

    public String getIdProduitLib() {
        return idProduitLib;
    }

    public void setIdProduitLib(String idProduitLib) {
        this.idProduitLib = idProduitLib;
    }
}
