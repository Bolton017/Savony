/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package faturefournisseur;

import bean.CGenUtil;
import bean.ClassFille;

import java.sql.Connection;
import java.util.logging.Level;
import java.util.logging.Logger;

import produits.Ingredients;
import produits.RecetteLib;
import stock.MvtStockFille;
import utilitaire.Constante;
import utils.ConstanteSocobis;
import vente.As_BondeLivraisonClient;
import vente.VenteDetails;

/**
 *
 * @author Mirado
 */
public class As_BonDeLivraison_Fille extends ClassFille{
    
    String id,produit,numbl;
    double quantite,pu;
    String iddetailsfacturefournisseur;
    String unite, idbc_fille;
    String idFactureFournisseur;
    String designation;

    public String getDesignation() {
        return designation;
    }

    public void setDesignation(String designation) {
        this.designation = designation;
    }

    public As_BonDeLivraison_Fille() {
        try{
            this.setNomClasseMere("faturefournisseur.As_BonDeLivraison");
            this.setNomTable("AS_BONDELIVRAISON_FILLE");
            this.setLiaisonMere("numbl");
        }catch(Exception e){
            Logger.getLogger(VenteDetails.class.getName()).log(Level.SEVERE, null, e);
        }
    }
    
    public void construirePK(Connection c) throws Exception {
        this.preparePk("BLF", "getSeqBondeLivraisonFille");
        this.setId(makePK(c));
    }

//    public String getNomClasseMere(){
//      return "faturefournisseur.As_BonDeLivraison";
//    }
//
//    public String getLiaisonMere(){
//      return "numbl";
//    }

    
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

    public void setIdFactureFournisseur(String idFactureFournisseur) {
        this.idFactureFournisseur = idFactureFournisseur;
    }

    public String getIdFactureFournisseur() {
        return idFactureFournisseur;
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

    public double getQuantite() {
        return quantite;
    }

    public void setQuantite(double quantite) throws Exception {
        if(quantite <=0 && this.getMode().equals("modif")){
            throw new Exception("Quantite negatif ou 0");
        }
        this.quantite = quantite;
    }

    public String getIddetailsfacturefournisseur() {
        return iddetailsfacturefournisseur;
    }

    public void setIddetailsfacturefournisseur(String iddetailsfacturefournisseur) {
        this.iddetailsfacturefournisseur = iddetailsfacturefournisseur;
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
    public double getPu() {
        return pu;
    }

    public void setPu(double pu) throws Exception {
        if (this.getMode().equals("modif") && pu <= 0) {
            throw new Exception("Pu non valide !");
        }
        this.pu = pu;
    }
    @Override
    public String getNomClasseMere() {
        return "faturefournisseur.As_BonDeLivraison";
    }
    @Override
    public String getLiaisonMere() {
        return "numbl";
    }


    public MvtStockFille createMvtStockFille() throws Exception{
        MvtStockFille msf=new MvtStockFille();
        msf.setIdProduit(this.produit);
        msf.setEntree(this.quantite);
        return msf;
    }

    public MvtStockFille genererMvtStockFille(Connection c)throws Exception
    {
        //TODO : Anontaniana an'i Alicia ny logique an'ity
//        As_BonDeLivraison m=(As_BonDeLivraison) this.findMere(null,c);
//        System.out.println("BL = "+m.getNomTable());
//        System.out.println("BL_ID = "+m.getId());
        MvtStockFille mf=new MvtStockFille();
        mf.setIdProduit(this.getProduit());
        mf.setEntree(this.getQuantite());
        return mf;
    }

    public FactureFournisseurDetails toFactureFournisseurDetails() throws Exception{
        FactureFournisseurDetails v = new FactureFournisseurDetails();
        v.setIdProduit(this.getProduit());
        v.setQte(this.getQuantite());
        v.setIdDevise("AR");
        v.setPu(this.getPu());
        v.setIdbcDetail(this.getId());
        String idProduit = this.getProduit();
        if (idProduit != null && idProduit.contains("---")) {
            idProduit = idProduit.split("---")[0];
        }
        Ingredients ing= new Ingredients();
        ing = (Ingredients)ing.getById(idProduit,"AS_INGREDIENTS",null);
        if(ing != null){
             v.setCompte(ing.getCompte_achat());
        }
        return v;
    }

    public FactureFournisseurDetails[] toFactureFournisseurPrestataire(Connection c) throws Exception {
        FactureFournisseurDetails[] details = null;
        boolean connectionWasOpenedInside = false;

        try {
            if (c == null) {
                c = new utilitaire.UtilDB().GetConn();
                connectionWasOpenedInside = true;
            }

            Ingredients ingredients = new Ingredients();
            ingredients.setId(this.produit);

            RecetteLib[] recetteLibs = ingredients.getRecetteIngredient("AS_RECETTE_LIB_CAT", ConstanteSocobis.CATEGORIE_MAINDOEUVRE, c);

            details = new FactureFournisseurDetails[recetteLibs.length];
            for (int i = 0; i < recetteLibs.length; i++) {
                details[i] = new FactureFournisseurDetails();
                details[i].setIdProduit(recetteLibs[i].getIdingredients());
                details[i].setPu(recetteLibs[i].getPu());
                details[i].setQte(recetteLibs[i].getQuantite() * this.getQuantite());
                details[i].setCompte(recetteLibs[i].getCompte_achat());
            }

            return details;

        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        } finally {
            if (connectionWasOpenedInside && c != null) {
                try {
                    c.close();
                } catch (Exception ce) {
                    ce.printStackTrace();
                }
            }
        }
    }

    @Override
    public void controler(Connection c) throws Exception {
        Ingredients p = new Ingredients();
        p.setId(this.produit);
        Ingredients[] produit = (Ingredients[]) CGenUtil.rechercher(p,null, null, c, "");
        this.setUnite(produit[0].getUnite());
        super.controler(c);
    }
}
