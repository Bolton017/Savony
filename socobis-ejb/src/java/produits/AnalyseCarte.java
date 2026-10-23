package produits;

import stock.MvtStockFille;

public class AnalyseCarte extends MvtStockFille {
    private String vehicule;
    public AnalyseCarte() throws Exception {
        super.setNomTable("ANALYSE_CARTE");
    }
    public String getVehicule() {
        return vehicule;
    }
    public void setVehicule(String vehicule) {
        this.vehicule = vehicule;
    }
}
