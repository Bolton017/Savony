package vente;

import bean.CGenUtil;
import bean.ClassMAPTable;

import java.sql.Date;
import java.util.LinkedHashMap;
import java.util.Map;

public class GrapheCaJournalier extends ClassMAPTable {

    private double montant;
    private int annee;
    private int mois;
    private String moislib;
    private Date daty;

    public GrapheCaJournalier() {
        this.setNomTable("CA_JOURNALIER");
    }

    public static Map<String, Double> getDataChart(int annee, int mois) throws Exception {
        String where = "";
        if (annee > 0) {
            where += " AND annee = " + annee;
        }
        if (mois > 0) {
            where += " AND mois = " + mois;
        }

        CaJournalier[] all = (CaJournalier[]) CGenUtil.rechercher(new CaJournalier(), null, null, where);

        Map<String, Double> data = new LinkedHashMap<>();
        if (all != null) {
            for (CaJournalier item : all) {
                // clé = date du jour, valeur = montant
                data.put(item.getDaty().toString(), item.getMontant());
            }
        }
        return data;
    }
    public static Map<String, Double> getDataChartCaMensuel(int annee) throws Exception {
        String where = "";
        if (annee > 0) {
            where += " AND annee = " + annee;
        }
        CaJournalier caJ = new CaJournalier();
        caJ.setNomTable("CA_MENSUEL");
        CaJournalier[] all = (CaJournalier[]) CGenUtil.rechercher(caJ, null, null, where);

        Map<String, Double> data = new LinkedHashMap<>();
        if (all != null) {
            for (CaJournalier item : all) {
                // clé = date du jour, valeur = montant
                data.put(item.getMoislib(), item.getMontant());
            }
        }
        return data;
    }

    // getters / setters
    public double getMontant() { return montant; }
    public void setMontant(double montant) { this.montant = montant; }
    public int getAnnee() { return annee; }
    public void setAnnee(int annee) { this.annee = annee; }
    public int getMois() { return mois; }
    public void setMois(int mois) { this.mois = mois; }
    public String getMoislib() { return moislib; }
    public void setMoislib(String moislib) { this.moislib = moislib; }
    public Date getDaty() { return daty; }
    public void setDaty(Date daty) { this.daty = daty; }

    @Override
    public String getTuppleID() {
        return daty != null ? daty.toString() : null;
    }

    @Override
    public String getAttributIDName() {
        return "daty";
    }
}