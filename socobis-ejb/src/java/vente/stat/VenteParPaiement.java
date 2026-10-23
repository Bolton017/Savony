package vente.stat;

import java.sql.Date;
import bean.ClassMAPTable;

public class VenteParPaiement extends ClassMAPTable {
    Date jour;
    int annee,mois;
    double montant_brut, montant_remise_calc, montant_net_ht_calc, montant_tva_calc, montant_ttc_calc;

    @Override
    public String getTuppleID() {
        return ""+jour.toString();
    }

    @Override
    public String getAttributIDName() {
        return "jour";
    }

    public VenteParPaiement() throws Exception {
        this.setNomTable("V_STAT_VENTE_BRUTE_JOUR"); 
    }
    
    public Date getJour() {
        return jour;
    }

    public void setJour(Date jour) {
        this.jour = jour;
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

    public double getMontant_brut() {
        return montant_brut;
    }

    public void setMontant_brut(double montant_brut) {
        this.montant_brut = montant_brut;
    }

    public double getMontant_remise_calc() {
        return montant_remise_calc;
    }

    public void setMontant_remise_calc(double montant_remise_calc) {
        this.montant_remise_calc = montant_remise_calc;
    }

    public double getMontant_net_ht_calc() {
        return montant_net_ht_calc;
    }

    public void setMontant_net_ht_calc(double montant_net_ht_calc) {
        this.montant_net_ht_calc = montant_net_ht_calc;
    }

    public double getMontant_tva_calc() {
        return montant_tva_calc;
    }

    public void setMontant_tva_calc(double montant_tva_calc) {
        this.montant_tva_calc = montant_tva_calc;
    }

    public double getMontant_ttc_calc() {
        return montant_ttc_calc;
    }

    public void setMontant_ttc_calc(double montant_ttc_calc) {
        this.montant_ttc_calc = montant_ttc_calc;
    }

}
