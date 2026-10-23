package paie.analyse;

import bean.ClassMAPTable;

public class SumHsMonth extends ClassMAPTable {
    private int annee;
    private int mois;
    private String monthLib;
    private double avg_hs_per_month;
    private String idDepartement;
    private String departementLib;

    public SumHsMonth() {
        setNomTable("SUM_HS_MONTH_LIB");
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

    public String getMonthLib() {
        return monthLib;
    }

    public void setMonthLib(String monthLib) {
        this.monthLib = monthLib;
    }

    public double getAvg_hs_per_month() {
        return avg_hs_per_month;
    }

    public void setAvg_hs_per_month(double avg_hs_per_month) {
        this.avg_hs_per_month = avg_hs_per_month;
    }

    public String getIdDepartement() {
        return idDepartement;
    }

    public void setIdDepartement(String idDepartement) {
        this.idDepartement = idDepartement;
    }

    public String getDepartementLib() {
        return departementLib;
    }

    public void setDepartementLib(String departementLib) {
        this.departementLib = departementLib;
    }

    @Override
    public String getTuppleID() {
        return idDepartement;
    }

    @Override
    public String getAttributIDName() {
        return "idDepartement";
    }
}
