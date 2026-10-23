package paie.analyse;

import bean.ClassMAPTable;

import java.sql.Date;

public class SumHsDay extends ClassMAPTable {
    private Date jour;
    private double avg_hs_per_day;
    private String idDepartement;
    private String departementLib;

    public SumHsDay() {
        setNomTable("sum_hs_day");
    }

    public Date getJour() {
        return jour;
    }

    public void setJour(Date jour) {
        this.jour = jour;
    }

    public double getAvg_hs_per_day() {
        return avg_hs_per_day;
    }

    public void setAvg_hs_per_day(double avg_hs_per_day) {
        this.avg_hs_per_day = avg_hs_per_day;
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
