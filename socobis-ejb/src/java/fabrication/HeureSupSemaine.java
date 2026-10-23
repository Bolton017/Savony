package fabrication;

import bean.ClassMAPTable;

public class HeureSupSemaine extends ClassMAPTable {
    private String idPersonne;
    private int annee, mois;
    private String semaine;
    private double hs_total;
    private double hs30;
    private double hs50;

    public HeureSupSemaine() {
        super.setNomTable("HS_FABRICATION_SEMAINE");
    }
    @Override
    public String getTuppleID() {
        return idPersonne;
    }

    @Override
    public String getAttributIDName() {
        return "idPersonne";
    }

    public String getIdPersonne() {
        return idPersonne;
    }

    public void setIdPersonne(String idPersonne) {
        this.idPersonne = idPersonne;
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

    public String getSemaine() {
        return semaine;
    }

    public void setSemaine(String semaine) {
        this.semaine = semaine;
    }

    public double getHs_total() {
        return hs_total;
    }

    public void setHs_total(double hs_total) {
        this.hs_total = hs_total;
    }

    public double getHs30() {
        return hs30;
    }

    public void setHs30(double hs30) {
        this.hs30 = hs30;
    }

    public double getHs50() {
        return hs50;
    }

    public void setHs50(double hs50) {
        this.hs50 = hs50;
    }
}
