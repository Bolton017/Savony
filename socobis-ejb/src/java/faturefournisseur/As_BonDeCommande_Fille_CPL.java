package faturefournisseur;

public class As_BonDeCommande_Fille_CPL extends As_BonDeCommande_Fille {
    protected String produitlib ;
    protected String unitelib;
    protected String modepaiementlib;
    protected String fournisseurlib;
    protected double qtelivrer;
     protected double qtefacturer;
     double montantTtcAr;
    
    public As_BonDeCommande_Fille_CPL() throws Exception {
        super.setNomTable("AS_BONDECOMMANDE_CPL");
    }
    public String getProduitlib() {
        return produitlib;
    }
    public void setProduitlib(String produitlib) {
        this.produitlib = produitlib;
    }
    public String getUnitelib() {
        return unitelib;
    }
    public void setUnitelib(String unitelib) {
        this.unitelib = unitelib;
    }
    public String getModepaiementlib() {
        return modepaiementlib;
    }
    public void setModepaiementlib(String modepaiementlib) {
        this.modepaiementlib = modepaiementlib;
    }
    public String getFournisseurlib() {
        return fournisseurlib;
    }
    public void setFournisseurlib(String fournisseurlib) {
        this.fournisseurlib = fournisseurlib;
    }
    public double getQtelivrer() {
        return qtelivrer;
    }
    public void setQtelivrer(double qtelivrer) {
        this.qtelivrer = qtelivrer;
    }
    public double getQtefacturer() {
        return qtefacturer;
    }
    public void setQtefacturer(double qtefacturer) {
        this.qtefacturer = qtefacturer;
    }


    public double getResteLivre() throws Exception {
        return getQuantite() - getQtelivrer();
    }

    public double getResteFacture() throws Exception {
        return getQuantite() - getQtefacturer();
    }


    public double getMontantTtcAr() {
        return montantTtcAr;
    }

    public void setMontantTtcAr(double montantTtcAr) {
        this.montantTtcAr = montantTtcAr;
    }
}
