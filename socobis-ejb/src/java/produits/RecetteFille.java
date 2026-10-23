package produits;

import bean.ClassFille;
import java.sql.Connection;

public class RecetteFille extends ClassFille {
    private String id;
    private String idmere;
    private String idIngredient;
    private String idUnite;
    private double qte;

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

    public String getIdIngredient() {
        return idIngredient;
    }

    public void setIdIngredient(String idIngredient) {
        this.idIngredient = idIngredient;
    }

    public String getIdUnite() {
        return idUnite;
    }

    public void setIdUnite(String idUnite) {
        this.idUnite = idUnite;
    }

    public double getQte() {
        return qte;
    }

    public void setQte(double qte) {
        this.qte = qte;
    }


    @Override
    public String getNomClasseMere() {
        return "produits.RecetteMere";
    }

    @Override
    public String getLiaisonMere() {
        return "idmere";
    }

    public RecetteFille() throws Exception {
        this.setNomTable("RECETTE_FILLE");
        this.setNomClasseMere("produits.RecetteMere");
        this.setLiaisonMere("idmere");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("RCF","GETSEQRECETTE_FILLE");
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
}

