package paie.accident;

import bean.ClassEtat;
import java.sql.Connection;
import java.sql.Date;

public class AccidentStats extends Accident {
    private Date datecomptage;
    private Date datedernieraccident;
    private int joursansaccident;
    private int recordjoursansaccident;

    public Date getDatecomptage()  {
        return datecomptage;
    }

    public void setDatecomptage(Date datecomptage) {
        this.datecomptage = datecomptage;
    }

    public Date getDatedernieraccident() {
        return datedernieraccident;
    }

    public void setDatedernieraccident(Date datedernieraccident) {
        this.datedernieraccident = datedernieraccident;
    }

    public int getJoursansaccident() {
        return joursansaccident;
    }

    public void setJoursansaccident(int joursansaccident) {
        this.joursansaccident = joursansaccident;
    }

    public int getRecordjoursansaccident() {
        return recordjoursansaccident;
    }

    public void setRecordjoursansaccident(int recordjoursansaccident) {
        this.recordjoursansaccident = recordjoursansaccident;
    }



    public AccidentStats() throws Exception {
        this.setNomTable("V_ACCIDENT_STATS");
    }


}

