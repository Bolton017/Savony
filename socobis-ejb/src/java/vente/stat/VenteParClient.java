package vente.stat;

import bean.ClassMAPTable;

public class VenteParClient extends ClassMAPTable {
    String client;
    int annee,mois,qte_totale;
    double montant_ht, montant_tva, montant_ttc, montant_remise, poids_total, frais_total;

    @Override
    public String getTuppleID() {
        return client;
    }

    @Override
    public String getAttributIDName() {
        return "client";
    }

    public VenteParClient() throws Exception {
        this.setNomTable("V_STAT_VENTE_CLIENT");
    }

    public String getClient() {
        return client;
    }

    public void setClient(String client) {
        this.client = client;
    }

    public int getAnnee() {
        return annee;
    }

    public void setAnnee(int annee) {
        this.annee = annee;
    }

    public int getMois() {
        return mois;
    }

    public void setMois(int mois) {
        this.mois = mois;
    }

    public int getQte_totale() {
        return qte_totale;
    }

    public void setQte_totale(int qte_totale) {
        this.qte_totale = qte_totale;
    }

    public double getMontant_ht() {
        return montant_ht;
    }

    public void setMontant_ht(double montant_ht) {
        this.montant_ht = montant_ht;
    }

    public double getMontant_tva() {
        return montant_tva;
    }

    public void setMontant_tva(double montant_tva) {
        this.montant_tva = montant_tva;
    }

    public double getMontant_ttc() {
        return montant_ttc;
    }

    public void setMontant_ttc(double montant_ttc) {
        this.montant_ttc = montant_ttc;
    }

    public double getMontant_remise() {
        return montant_remise;
    }

    public void setMontant_remise(double montant_remise) {
        this.montant_remise = montant_remise;
    }

    public double getPoids_total() {
        return poids_total;
    }

    public void setPoids_total(double poids_total) {
        this.poids_total = poids_total;
    }

    public double getFrais_total() {
        return frais_total;
    }

    public void setFrais_total(double frais_total) {
        this.frais_total = frais_total;
    }
}
