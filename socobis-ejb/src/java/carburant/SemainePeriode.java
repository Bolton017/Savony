package carburant;

import bean.ClassMAPTable;

import java.sql.Date;

public class SemainePeriode extends ClassMAPTable {
    private String id;
    private int numSemaine;
    private int annee;
    private Date dateDebut;
    private Date dateFin;

    public SemainePeriode() {
        setNomTable("v_semaine_periode");
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public int getNumSemaine() {
        return numSemaine;
    }

    public void setNumSemaine(int numSemaine) {
        this.numSemaine = numSemaine;
    }

    public int getAnnee() {
        return annee;
    }

    public void setAnnee(int annee) {
        this.annee = annee;
    }

    public Date getDateDebut() {
        return dateDebut;
    }

    public void setDateDebut(Date dateDebut) {
        this.dateDebut = dateDebut;
    }

    public Date getDateFin() {
        return dateFin;
    }

    public void setDateFin(Date dateFin) {
        this.dateFin = dateFin;
    }

    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }
}
