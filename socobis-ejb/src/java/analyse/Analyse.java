package analyse;

import bean.ClassEtat;
import java.sql.Connection;
import java.sql.Date;

public class Analyse extends ClassEtat {
    private String id;
    private Date daty;
    private String idfabrication;
    private String idcritere;
    private double valeur;
    private String idresponsable;
    private int etat;

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

    public String getIdfabrication() {
        return idfabrication;
    }

    public void setIdfabrication(String idfabrication) {
        this.idfabrication = idfabrication;
    }

    public String getIdcritere() {
        return idcritere;
    }

    public void setIdcritere(String idcritere) {
        this.idcritere = idcritere;
    }

    public double getValeur() {
        return valeur;
    }

    public void setValeur(double valeur) {
        this.valeur = valeur;
    }

    public String getIdresponsable() {
        return idresponsable;
    }

    public void setIdresponsable(String idresponsable) {
        this.idresponsable = idresponsable;
    }

    public int getEtat() {
        return etat;
    }

    public void setEtat(int etat) {
        this.etat = etat;
    }



    public Analyse() throws Exception {
        this.setNomTable("ANALYSE");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("AN","GET_SEQ_ANALYSE");
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

