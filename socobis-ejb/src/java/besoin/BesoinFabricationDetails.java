package besoin;

import bean.ClassFille;

import java.sql.Connection;

public class BesoinFabricationDetails extends ClassFille {
    private String id;
    private String idProduit;
    private double qte;
    private String unite;
    private String idBesoinFabrication;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdProduit() {
        return idProduit;
    }

    public void setIdProduit(String idProduit) {
        this.idProduit = idProduit;
    }

    public double getQte() {
        return qte;
    }

    public void setQte(double qte) {
        this.qte = qte;
    }

    public String getUnite() {
        return unite;
    }

    public void setUnite(String unite) {
        this.unite = unite;
    }

    @Override
    public String getNomClasseMere() {
        return "besoin.BesoinFabrication";
    }

    @Override
    public String getLiaisonMere() {
        return "idBesoinFabrication";
    }

    public BesoinFabricationDetails() throws Exception {
        this.setNomTable("BESOINFABRICATIONDETAILS");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("BFABD","get_SeqBesoinFabDetails");
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

    public String getIdBesoinFabrication() {
        return idBesoinFabrication;
    }

    public void setIdBesoinFabrication(String idBesoinFabrication) {
        this.idBesoinFabrication = idBesoinFabrication;
    }
}

