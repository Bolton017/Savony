package vente;

import bean.ClassFille;

import java.sql.Connection;

public class CartonFille extends ClassFille {
    String id, idMere, idIngredient;
    double quantite;
    String remarque;
    String idBcFille;
    public CartonFille() throws Exception {
        super.setNomTable("CARTON");
        setLiaisonMere("idMere");
        setNomClasseMere("vente.Carton");
        this.setNomTable("CartonFille");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("CRTF", "getseqCartonFille");
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

    public String getIdMere() {
        return idMere;
    }

    public void setIdMere(String idMere) {
        this.idMere = idMere;
    }

    public String getIdIngredient() {
        return idIngredient;
    }

    public void setIdIngredient(String idIngredient) {
        this.idIngredient = idIngredient;
    }

    public double getQuantite() {
        return quantite;
    }

    public void setQuantite(double quantite) throws Exception {
        if(this.getMode().equals("modif") && quantite <= 0)
            throw new Exception("La Quantite devrait etre superieur a 0");
        this.quantite = quantite;
    }

    public String getRemarque() {
        return remarque;
    }

    public void setRemarque(String remarque) {
        this.remarque = remarque;
    }

    public String getIdBcFille() {
        return idBcFille;
    }

    public void setIdBcFille(String idBcFille) throws Exception {
        if(this.getMode().equals("modif") && (idBcFille == null || idBcFille.equals("")))
            throw new Exception("Bon de commande fille manquant");
        this.idBcFille = idBcFille;
    }
}
