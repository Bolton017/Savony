package calculBesoin;

import bean.ClassFille;
import java.sql.Connection;

public class CalculBesoinFille extends ClassFille {
    private String id;
    private String idProduit;
    private String idMere;
    private double qte;

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


    @Override
    public String getNomClasseMere() {
        return "calculBesoin.CalculBesoin";
    }

    @Override
    public String getLiaisonMere() {
        return "idMere";
    }

    public CalculBesoinFille() throws Exception {
        this.setNomTable("CALCULBESOINFILLE");
        this.setNomClasseMere("calculBesoin.CalculBesoin");
        this.setLiaisonMere("idMere");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("CBF","getSeqCalculBesoinFille");
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

    public String getIdMere() {
        return idMere;
    }

    public void setIdMere(String idMere) {
        this.idMere = idMere;
    }
}

