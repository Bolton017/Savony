package besoin;

import bean.ClassMere;

import java.sql.Connection;
import java.sql.Date;

public class BesoinFabrication extends ClassMere {
    private String id;
    private Date daty;
    private int mois;
    private int annee;
    private String remarque;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public int getMois() {
        return mois;
    }

    public void setMois(int mois) {
        this.mois = mois;
    }

    public int getAnnee() {
        return annee;
    }

    public void setAnnee(int annee) {
        this.annee = annee;
    }

    public String getRemarque() {
        return remarque;
    }

    public void setRemarque(String remarque) {
        this.remarque = remarque;
    }

    @Override
    public String getLiaisonFille() {
        return "idBesoinFabrication";
    }
    @Override
    public  String getNomClasseFille() {
        return "besoin.BesoinFabricationDetails";
    }

    public BesoinFabrication() throws Exception {
        this.setNomTable("BESOINFABRICATION");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("BFAB","get_seq_BesoinFabrication");
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

