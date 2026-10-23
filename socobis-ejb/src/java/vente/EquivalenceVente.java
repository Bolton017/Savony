package vente;

import bean.ClassMAPTable;
import java.sql.Connection;

public class EquivalenceVente extends ClassMAPTable {
    private String id;
    private String idproduit1;
    private String idproduit2;
    private int quantite;
    private double poids;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdproduit1() {
        return idproduit1;
    }

    public void setIdproduit1(String idproduit1) {
        this.idproduit1 = idproduit1;
    }

    public String getIdproduit2() {
        return idproduit2;
    }

    public void setIdproduit2(String idproduit2) {
        this.idproduit2 = idproduit2;
    }

    public int getQuantite() {
        return quantite;
    }

    public void setQuantite(int quantite) {
        this.quantite = quantite;
    }

    public double getPoids() {
        return poids;
    }

    public void setPoids(double poids) {
        this.poids = poids;
    }



    public EquivalenceVente() throws Exception {
        this.setNomTable("EQUIVALENCEVENTE");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("EQV","GET_SEQ_EquivalenceVente");
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

