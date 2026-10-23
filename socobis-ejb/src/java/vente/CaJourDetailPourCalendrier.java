package vente;

import bean.ClassMAPTable;

import java.sql.Date;

public class CaJourDetailPourCalendrier extends ClassMAPTable {
    Date daty;
    int jour,semainemois,mois,annee;
    String jourLib;
    double montant;
    String idjoursemaine;
    int numerojoursemaine;

    public CaJourDetailPourCalendrier() {
        this.setNomTable("CA_JOUR_DETAILS_CA");
    }

    @Override
    public String getTuppleID() {
        return "";
    }

    @Override
    public String getAttributIDName() {
        return "";
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public int getJour() {
        return jour;
    }

    public void setJour(int jour) {
        this.jour = jour;
    }

    public int getSemainemois() {
        return semainemois;
    }

    public void setSemainemois(int semainemois) {
        this.semainemois = semainemois;
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

    public String getJourLib() {
        return jourLib;
    }

    public void setJourLib(String jourLib) {
        this.jourLib = jourLib;
    }

    public double getMontant() {
        return montant;
    }

    public void setMontant(double montant) {
        this.montant = montant;
    }

    public String getIdjoursemaine() {
        return idjoursemaine;
    }

    public void setIdjoursemaine(String idjoursemaine) {
        this.idjoursemaine = idjoursemaine;
    }

    public int getNumerojoursemaine() {
        return numerojoursemaine;
    }

    public void setNumerojoursemaine(int numerojoursemaine) {
        this.numerojoursemaine = numerojoursemaine;
    }
}