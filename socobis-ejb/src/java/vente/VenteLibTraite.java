package vente;

public class VenteLibTraite extends VenteLib{
    String factureclientlib, tierslib, idTraite;
    double montantfacture, montanttraite;

    public VenteLibTraite() {
        setNomTable("TRAITE_FCsum");
    }

    public String getIdTraite() {
        return idTraite;
    }

    public void setIdTraite(String idTraite) {
        this.idTraite = idTraite;
    }

    public String getFactureclientlib() {
        return factureclientlib;
    }

    public void setFactureclientlib(String factureclientlib) {
        this.factureclientlib = factureclientlib;
    }

    public String getTierslib() {
        return tierslib;
    }

    public void setTierslib(String tierslib) {
        this.tierslib = tierslib;
    }

    public double getMontantfacture() {
        return montantfacture;
    }

    public void setMontantfacture(double montantfacture) {
        this.montantfacture = montantfacture;
    }

    public double getMontanttraite() {
        return montanttraite;
    }

    public void setMontanttraite(double montanttraite) {
        this.montanttraite = montanttraite;
    }
}
