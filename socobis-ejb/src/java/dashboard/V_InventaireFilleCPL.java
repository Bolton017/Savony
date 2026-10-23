package dashboard;

import bean.ClassMAPTable;

import java.sql.Connection;
import java.sql.Date;

public class V_InventaireFilleCPL extends ClassMAPTable {
    private String id;
    private String idInventaire;
    private String idProduit;
    private String idProduitLib;
    private String explication;
    private double quantiteTheorique;
    private double quantite;
    private String libelleExtacte;
    private double pu;

    private double ecart;
    private Date dateInv;
    private double montantTheorique;
    private double montantReelle;
    private double ecartMontant;

    private String categorieIngredient;

    public double getEcart() { return ecart; }
    public void setEcart(double ecart) { this.ecart = ecart; }

    public double getMontantTheorique() { return montantTheorique; }
    public void setMontantTheorique(double montantTheorique) { this.montantTheorique = montantTheorique; }

    public double getMontantReelle() { return montantReelle; }
    public void setMontantReelle(double montantReelle) { this.montantReelle = montantReelle; }

    public double getEcartMontant() { return ecartMontant; }
    public void setEcartMontant(double ecartMontant) { this.ecartMontant = ecartMontant; }

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public String getIdInventaire() { return idInventaire; }
    public void setIdInventaire(String idInventaire) { this.idInventaire = idInventaire; }
    public String getIdProduit() { return idProduit; }
    public void setIdProduit(String idProduit) { this.idProduit = idProduit; }
    public String getIdProduitLib() { return idProduitLib; }
    public void setIdProduitLib(String idProduitLib) { this.idProduitLib = idProduitLib; }
    public String getExplication() { return explication; }
    public void setExplication(String explication) { this.explication = explication; }
    public double getQuantiteTheorique() { return quantiteTheorique; }
    public void setQuantiteTheorique(double quantiteTheorique) { this.quantiteTheorique = quantiteTheorique; }
    public double getQuantite() { return quantite; }
    public void setQuantite(double quantite) { this.quantite = quantite; }
    public String getLibelleExtacte() { return libelleExtacte; }
    public void setLibelleExtacte(String libelleExtacte) { this.libelleExtacte = libelleExtacte; }
    public double getPu() { return pu; }
    public void setPu(double pu) { this.pu = pu; }
    public Date getDateInv() { return dateInv; }
    public void setDateInv(Date dateInv) { this.dateInv = dateInv; }
    public String getCategorieIngredient() { return categorieIngredient; }
    public void setCategorieIngredient(String categorieIngredient) { this.categorieIngredient = categorieIngredient; }

    public V_InventaireFilleCPL() throws Exception {
        this.setNomTable("V_INVENTAIREFILLECPL");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("","");
        this.setId(makePK(c));
    }

    @Override
    public String getTuppleID() { return id; }

    @Override
    public String getAttributIDName() { return "id"; }
}