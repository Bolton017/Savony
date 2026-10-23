package vente;

public class BoncommandeDetailsCarton extends BonDeCommandeFIlleCpl{
    private String idbc_mere;
    private double resteCartonFille;
    private double quantiteCartonFille , quantiteBcf;
    private String unite;
    private String idCartonMere;

    public BoncommandeDetailsCarton()throws Exception{
        super();
        this.setNomTable("produitcommandefillecarton");
    }

    public String getIdbc_mere() {
        return idbc_mere;
    }

    public void setIdbc_mere(String idbc_mere) {
        this.idbc_mere = idbc_mere;
    }

    public double getQuantiteBcf() {
        return quantiteBcf;
    }

    public void setQuantiteBcf(double quantiteBcf) {
        this.quantiteBcf = quantiteBcf;
    }

    public double getResteCartonFille() {
        return resteCartonFille;
    }

    public void setResteCartonFille(double resteCartonFille) {
        this.resteCartonFille = resteCartonFille;
    }

    public double getQuantiteCartonFille() {
        return quantiteCartonFille;
    }

    public void setQuantiteCartonFille(double quantiteCartonFille) {
        this.quantiteCartonFille = quantiteCartonFille;
    }


    public double getQteNonLivre() {
        return qteNonLivre;
    }

    public void setQteNonLivre(double qteNonLivre) {
        this.qteNonLivre = qteNonLivre;
    }

    public String getUnite() {
        return unite;
    }

    public void setUnite(String unite) {
        this.unite = unite;
    }

    public String getIdCartonMere() {
        return idCartonMere;
    }

    public void setIdCartonMere(String idCartonMere) {
        this.idCartonMere = idCartonMere;
    }

}
