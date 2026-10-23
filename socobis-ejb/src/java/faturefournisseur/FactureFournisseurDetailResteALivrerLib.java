package faturefournisseur;

public class FactureFournisseurDetailResteALivrerLib extends FactureFournisseurDetailsCpl{
    protected String idUnite;
    protected String unitelib;
    private double pupertegain;
        
    public As_BonDeLivraison_Fille_Cpl createBLFille(String idMere)throws Exception{
        As_BonDeLivraison_Fille_Cpl resultat = new As_BonDeLivraison_Fille_Cpl();
        resultat.setIdbc_fille(this.getId());
        resultat.setIddetailsfacturefournisseur(this.getId());
        resultat.setNumbl(idMere);
        resultat.setProduit(this.getIdProduit());
        resultat.setQuantite(this.getQte());
        resultat.setUnite(this.getIdUnite());
        resultat.setProduitlib(this.getIdProduitLib());
        resultat.setUnitelib(this.getUnitelib());
        resultat.setPu(this.getPupertegain());
        return resultat;
    }

    public String getProduit(){
        return this.getIdProduit();
    }
    public String getProduitlib(){
        return this.getIdProduitLib();
    }
    public String getUnite(){
        return this.getIdUnite();
    }
    public double getQte_reste(){
        return this.getQte();
    }
    public String getIdUnite() {
        return idUnite;
    }

    public void setIdUnite(String idUnite) {
        this.idUnite = idUnite;
    }
    public String getUnitelib() {
        return unitelib;
    }

    public void setUnitelib(String unitelib) {
        this.unitelib = unitelib;
    }
     public double getPupertegain() {
        return pupertegain;
    }

    public void setPupertegain(double pupertegain) {
        this.pupertegain = pupertegain;
    }

    public FactureFournisseurDetailResteALivrerLib() throws Exception{
        super.setNomTable("FFFILLERESTEALIVRERLIB");
    }
}
