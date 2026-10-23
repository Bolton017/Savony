package paie.dashboard;

import bean.ClassMAPTable;
import java.sql.Connection;

public class DashHSUPMoisCDI extends ClassMAPTable {
    private String mois_num, mois;
    private int montant_hsup_total, montant_hsup_homme, montant_hsup_femme;

    public String getMois_num() {
        return mois_num;
    }

    public void setMois_num(String mois_num) {
        this.mois_num = mois_num;
    }

    public int getMontant_hsup_total() {
        return montant_hsup_total;
    }

    public void setMontant_hsup_total(int montant_hsup_total) {
        this.montant_hsup_total = montant_hsup_total;
    }

    public int getMontant_hsup_homme() {
        return montant_hsup_homme;
    }

    public void setMontant_hsup_homme(int montant_hsup_homme) {
        this.montant_hsup_homme = montant_hsup_homme;
    }

    public int getMontant_hsup_femme() {
        return montant_hsup_femme;
    }

    public void setMontant_hsup_femme(int montant_hsup_femme) {
        this.montant_hsup_femme = montant_hsup_femme;
    }

    public String getMois() {
        return mois;
    }

    public void setMois(String mois) {
        this.mois = mois;
    }

    public DashHSUPMoisCDI() throws Exception {
        this.setNomTable("V_DASH_HSUP_MOIS_CDI");
    }

    @Override
    public String getTuppleID() {
        return mois_num;
    }

    @Override
    public String getAttributIDName() {
        return "mois_num";
    }
}

