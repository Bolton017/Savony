package paie.employe;

import bean.CGenUtil;
import bean.ClassMAPTable;

import java.util.LinkedHashMap;
import java.util.Map;

public class SalaireParFonction extends ClassMAPTable {

    private String idfonction;
    private String fonctionLib;
    private double moyenne_salaire_base;
    private int mois;
    private int annee;
    private String fonction_libelle;
    private double moyenne_salaire;

    public SalaireParFonction() {
        this.setNomTable("v_moyenne_salaire_parfonction");
    }

    // --- Data chart sans filtre ---
    public static Map<String, Double> getDataChart() throws Exception {
        SalaireParFonction[] all = (SalaireParFonction[]) CGenUtil.rechercher(new SalaireParFonction(), null, null, "");

        Map<String, Double> dataChart = new LinkedHashMap<>();
        for (SalaireParFonction salaire : all) {
            String key = salaire.getFonctionLib() + " (" + salaire.getMois() + "/" + salaire.getAnnee() + ")";
            dataChart.put(key, salaire.getMoyenne_salaire_base());
        }
        return dataChart;
    }

    // --- Filtre par mois + année ---
    public static Map<String, Double> getDataChart(int mois, int annee) throws Exception {
        SalaireParFonction filtre = new SalaireParFonction();
        String where = " AND mois=" + mois + " AND annee=" + annee;
        SalaireParFonction[] all = (SalaireParFonction[]) CGenUtil.rechercher(filtre, null, null, where);

        Map<String, Double> dataChart = new LinkedHashMap<>();
        for (SalaireParFonction salaire : all) {
            dataChart.put(salaire.getFonctionLib(), salaire.getMoyenne_salaire_base());
        }
        return dataChart;
    }

    // --- Filtre par mois ---
    public static Map<String, Double> getDataChartByMois(int mois) throws Exception {
        SalaireParFonction filtre = new SalaireParFonction();
        String where = " AND mois=" + mois;
        SalaireParFonction[] all = (SalaireParFonction[]) CGenUtil.rechercher(filtre, null, null, where);

        Map<String, Double> dataChart = new LinkedHashMap<>();
        for (SalaireParFonction salaire : all) {
            String key = salaire.getFonctionLib() + " (" + salaire.getAnnee() + ")";
            dataChart.put(key, salaire.getMoyenne_salaire_base());
        }
        return dataChart;
    }

    // --- Filtre par année ---
    public static Map<String, Double> getDataChartByAnnee(int annee) throws Exception {
        SalaireParFonction filtre = new SalaireParFonction();
        String where = " AND annee=" + annee;
        SalaireParFonction[] all = (SalaireParFonction[]) CGenUtil.rechercher(filtre, null, null, where);

        Map<String, Double> dataChart = new LinkedHashMap<>();
        for (SalaireParFonction salaire : all) {
            String key = salaire.getFonctionLib() + " (" + salaire.getMois() + ")";
            dataChart.put(key, salaire.getMoyenne_salaire_base());
        }
        return dataChart;
    }

    public String getIdfonction() { return idfonction; }
    public void setIdfonction(String idfonction) { this.idfonction = idfonction; }

    public String getFonction_libelle() { return fonction_libelle; }
    public void setFonction_libelle(String fonction_libelle) { this.fonction_libelle = fonction_libelle; }

    public double getMoyenne_salaire() { return moyenne_salaire; }
    public void setMoyenne_salaire(double moyenne_salaire) { this.moyenne_salaire = moyenne_salaire; }

    public String getFonctionLib() { return fonctionLib; }
    public void setFonctionLib(String fonctionLib) { this.fonctionLib = fonctionLib; }

    public double getMoyenne_salaire_base() { return moyenne_salaire_base; }
    public void setMoyenne_salaire_base(double moyenne_salaire_base) { this.moyenne_salaire_base = moyenne_salaire_base; }

    public int getMois() { return mois; }
    public void setMois(int mois) { this.mois = mois; }

    public int getAnnee() { return annee; }
    public void setAnnee(int annee) { this.annee = annee; }

    @Override
    public String getTuppleID() { return idfonction; }

    @Override
    public String getAttributIDName() { return "idfonction"; }
}
