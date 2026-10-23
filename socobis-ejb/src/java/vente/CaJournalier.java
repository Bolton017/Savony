package vente;

import bean.ClassMAPTable;

import java.sql.Date;

public class CaJournalier extends ClassMAPTable {
    String annee,mois,moislib;
    Date daty;
    double montant;

    public String getMoislib() {
        return moislib;
    }

    public void setMoislib(String moislib) {
        this.moislib = moislib;
    }

    public CaJournalier() {
        this.setNomTable("CA_JOURNALIER");
    }

    @Override
    public String getAttributIDName() {
        return "annee";
    }

    @Override
    public String getTuppleID() {
        return annee;
    }

    public String getAnnee() {
        return annee;
    }

    public void setAnnee(String annee) {
        this.annee = annee;
    }

    public String getMois() {
        return mois;
    }

    public void setMois(String mois) {
        this.mois = mois;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public double getMontant() {
        return montant;
    }

    public void setMontant(double montant) {
        this.montant = montant;
    }
}
