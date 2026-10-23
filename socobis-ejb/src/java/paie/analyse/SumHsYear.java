package paie.analyse;

import bean.ClassMAPTable;

public class SumHsYear extends ClassMAPTable {
    private int annee;
    private String avg_hs_per_year;
    private String idDepartement;
    private String departementLib;

    public SumHsYear() {
        setNomTable("sum_hs_year");
    }

    @Override
    public String getTuppleID() {
        return idDepartement;
    }

    @Override
    public String getAttributIDName() {
        return "idDepartement";
    }

    public int getAnnee() {
        return annee;
    }

    public void setAnnee(int annee) {
        this.annee = annee;
    }

    public String getAvg_hs_per_year() {
        return avg_hs_per_year;
    }

    public void setAvg_hs_per_year(String avg_hs_per_year) {
        this.avg_hs_per_year = avg_hs_per_year;
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
}
