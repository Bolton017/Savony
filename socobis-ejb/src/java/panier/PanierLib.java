package panier;

import utilitaire.Utilitaire;

public class PanierLib extends Panier {
    private String idUniteLib;
    private String idClientLib;
    private String idProduitLib;

    public String getIdUniteLib() {
        return idUniteLib;
    }

    public void setIdUniteLib(String idUniteLib) {
        this.idUniteLib = idUniteLib;
    }

    public String getIdClientLib() {
        return idClientLib;
    }

    public void setIdClientLib(String idClientLib) {
        this.idClientLib = idClientLib;
    }

    public String getIdProduitLib() {
        return idProduitLib;
    }

    public void setIdProduitLib(String idProduitLib) {
        this.idProduitLib = idProduitLib;
    }

    public PanierLib() {
        this.setNomTable("PANIERLIB");
    }

    public String getPuUniteLib() {
        return Utilitaire.formaterAr(this.getPu()) +" MGA / "+this.getIdUniteLib();
    }
}
