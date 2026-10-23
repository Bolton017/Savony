package faturefournisseur;

import bean.ClassFille;

import java.sql.Connection;

public class DmdAchatFille extends ClassFille {
    private String id;
    private String idmere;
    private String idproduit;
    private String designation;
    private double quantite;
    private double pu;
    private double tva;
    private double qtestock;
    private String unite;
    private String remarque;

    public DmdAchatFille() throws Exception {
        this.setNomTable("DMDACHATFILLE");
        this.setNomClasseMere("faturefournisseur.DmdAchat");
        this.setLiaisonMere("idmere");
    }

    @Override
    public String getNomClasseMere()
    {
        return "faturefournisseur.DmdAchat";
    }

    @Override
    public String getLiaisonMere() {
        return "idmere";
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdmere() {
        return idmere;
    }

    public void setIdmere(String idmere) {
        this.idmere = idmere;
    }

    public String getIdproduit() {
        return idproduit;
    }

    public void setIdproduit(String idproduit) {
        this.idproduit = idproduit;
    }

    public String getDesignation() {
        return designation;
    }

    public void setDesignation(String designation) {
        this.designation = designation;
    }

    public double getQuantite() {
        return quantite;
    }

    public void setQuantite(double quantite) throws Exception {
        if(this.getMode().equals("modif")){
            if (quantite <= 0){
                throw new Exception("La quantit\u00E9 ne doit pas \u00EAtre inf\u00E9rieure ou \u00E9gale \u00E0 O");
            }
        }
        this.quantite = quantite;
    }

    public double getPu() {
        return pu;
    }

    public void setPu(double pu) throws Exception {
        if(this.getMode().equalsIgnoreCase("modif") && pu<=0){
            throw new Exception("pu non valide");
        }
        this.pu = pu;
    }

    public double getTva() {
        return tva;
    }

    public void setTva(double tva) {
        this.tva = tva;
    }

    public double getQtestock() {
        return qtestock;
    }

    public void setQtestock(double qtestock) {
        this.qtestock = qtestock;
    }

    public String getUnite() {
        return unite;
    }

    public void setUnite(String unite) {
        this.unite = unite;
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("DMDAF", "GETSEQDMDACHATFILLE");
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

    public String getRemarque() {
        return remarque;
    }

    public void setRemarque(String remarque) {
        this.remarque = remarque;
    }
    
}
