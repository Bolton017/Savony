package vente;

import bean.ClassFille;
import produits.IngredientsLib;
import bean.CGenUtil;

import java.sql.Connection;
import stock.MvtStockFille;

public class As_BondeLivraisonClientFille extends ClassFille{
    String id , produit,numbl,idventedetail,unite,idbc_fille,compte_vente,compte_achat;
    double quantite,qteFacture, pu,tva;

    public double getTva() {
        return tva;
    }

    public void setTva(double tva) {
        this.tva = tva;
    }

    public double getPu() {
        return pu;
    }

    public void setPu(double pu) throws Exception {
        if (this.getMode().equals("modif") && pu < 0) {
            throw new Exception("Pu ne peut pas &ecirc;tre inf&eacute;rieur &agrave; 0");
        }
        this.pu = pu;
    }

    @Override
    public String getLiaisonMere() {
        return "numbl";
    }

    public String getCompte_vente() {
        return compte_vente;
    }

    public void setCompte_vente(String compte_vente) {
        this.compte_vente = compte_vente;
    }

    public String getCompte_achat() {
        return compte_achat;
    }

    public void setCompte_achat(String compte_achat) {
        this.compte_achat = compte_achat;
    }

    public As_BondeLivraisonClientFille() throws Exception{
        this.setNomTable("AS_BONDELIVRAISON_CLIENT_FILLE");
        this.setNomClasseMere("vente.As_BondeLivraisonClient");
        setLiaisonMere("numbl");
    }

    @Override
    public String getNomClasseMere() {
        return "vente.As_BondeLivraisonClient";
    }

    public void construirePK(Connection c) throws Exception {
        this.preparePk("BLCF", "getSEQBLCLIENTFILLE");
        this.setId(makePK(c));
    }

    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    public String getId() {
        return id;
    }
    public void setId(String id) {
        this.id = id;
    }

    public String getProduit() {
        return produit;
    }
    public void setProduit(String produit) {
        this.produit = produit;
    }
    public String getNumbl() {
        return numbl;
    }
    public void setNumbl(String numbl) {
        this.numbl = numbl;
    }
    public String getIdventedetail() {
        return idventedetail;
    }
    public void setIdventedetail(String idventedetail) {
        this.idventedetail = idventedetail;
    }
    public String getUnite() {
        return unite;
    }
    public void setUnite(String unite) {
        this.unite = unite;
    }
    public String getIdbc_fille() {
        return idbc_fille;
    }
    public void setIdbc_fille(String idbc_fille) {
        this.idbc_fille = idbc_fille;
    }
    public double getQuantite() {
        return quantite;
    }
    public double getQteFacture () {
        return qteFacture;
    }
    public void setQteFacture (double qteFacture ){
        this.qteFacture  = qteFacture ;
    }

    public void setQuantite(double quantite)throws Exception {
        if (this.getMode().equals("modif") && quantite <= 0 ) {
            throw new Exception("Quantite ne peut pas etre inferieur à 0");
        }
        this.quantite = quantite;
    }
    public MvtStockFille genererMvtStockFille(Connection c)throws Exception
    {
        As_BondeLivraisonClient m=(As_BondeLivraisonClient)this.findMere(null,c);
        MvtStockFille mf=new MvtStockFille();
        mf.setIdMvtStock(m.getId());
        mf.setIdProduit(this.getProduit());
        mf.setSortie(this.getQuantite());
        mf.setIdVenteDetail(this.getIdventedetail());
        return mf;
    }

    public VenteDetails toVenteDetails() throws Exception{
        VenteDetails v = new VenteDetails();
        v.setIdProduit(this.getProduit());
        v.setQte(this.getQuantite());
        v.setIdDevise("AR");
        return v;
    }




    public VenteDetails genererVenteDetails() throws Exception{
        VenteDetails ventedet = new VenteDetails();
        ventedet.setMode("modif");
        ventedet.setIdProduit(this.getProduit());
        IngredientsLib ingredients = (IngredientsLib) new IngredientsLib().getById(this.getProduit(), "AS_INGREDIENTS_LIB2", null);
        ventedet.setDesignation(ingredients.getLibelle());
        ventedet.setQte(this.getQuantite());
        ventedet.setPu(this.getPu());
        ventedet.setTva(this.getTva());
        ventedet.setCompte(this.getCompte_vente());
      /*  ventedet.setLibelle("");
        ventedet.setCompte("");
        ventedet.setIdOrigine("");
        ventedet.setIdDevise("");
        ventedet.setRemise(0);
        ventedet.setPuAchat(0);
        ventedet.setMontantTTC(0);
        ventedet.setMontantTva(0);
        ventedet.setMontantHT(0);
        ventedet.setPuVente(0);
        ventedet.setPuVente(0);
*/
        // ventedet.setIdbc_fille(this.getId());

        return ventedet;
    }
    public double getResteFacture(){
        return this.getQuantite()-this.getQteFacture() ;
    }

}
