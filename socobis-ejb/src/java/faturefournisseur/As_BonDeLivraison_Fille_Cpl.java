/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package faturefournisseur;


import stock.MvtStockFille;

public class As_BonDeLivraison_Fille_Cpl extends As_BonDeLivraison_Fille{
    String produitlib,unitelib;
    private double qteEntree;
    private double resteAEntrer,montant;

    public As_BonDeLivraison_Fille_Cpl() {
        this.setNomTable("AS_BONDELIVRAISON_LIBCPL");
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

    public MvtStockFille createMvtStockFille() throws Exception{
        MvtStockFille msf=new MvtStockFille();
        msf.setIdProduit(this.produit);
        msf.setEntree(this.getQuantite());
        msf.setPu(this.getPu());
        msf.setDesignation(this.produitlib);
        return msf;
    }

    public double getQteEntree() {
        return qteEntree;
    }

    public void setQteEntree(double qteEntree) {
        this.qteEntree = qteEntree;
    }

    public double getResteAEntrer() {
        return resteAEntrer;
    }

    public void setResteAEntrer(double resteAEntrer) {
        this.resteAEntrer = resteAEntrer;
    }

    public double getMontant() {
        return montant;
    }

    public void setMontant(double montant) {
        this.montant = montant;
    }
    
}
