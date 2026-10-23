package stock;

public class HistoriquePrixLib extends HistoriquePrix {
    public String etatLib, produit;

    public HistoriquePrixLib(){
        this.setNomTable("HistoriquePrixLib");
    }

    public String getEtatLib() {
        return etatLib;
    }

    public void setEtatLib(String etatLib) {
        this.etatLib = etatLib;
    }

    public String getProduit() {
        return produit;
    }

    public void setProduit(String produit) {
        this.produit = produit;
    }
}
