package fabrication;

import bean.Process;

import java.sql.Date;

public class ProcessLib extends Process {
    double ecartMinutes;
    String designation;
    String of;
    String idMere;
    Date daty;


    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public String getDesignation() {
        return designation;
    }

    public void setDesignation(String designation) {
        this.designation = designation;
    }

    public String getOf() {
        return of;
    }

    public void setOf(String of) {
        this.of = of;
    }

    public String getIdMere() {
        return idMere;
    }

    public void setIdMere(String idMere) {
        this.idMere = idMere;
    }

    public double getEcartMinutes() {
        return ecartMinutes;
    }

    public void setEcartMinutes(double ecartMinutes) {
        this.ecartMinutes = ecartMinutes;
    }

    public ProcessLib() {
        this.setNomTable("ProcessLib");
    }
}
