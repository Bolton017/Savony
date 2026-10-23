package paie.conge;

import bean.ClassMAPTable;

import java.sql.Connection;

public class ReportSoldeConge extends ClassMAPTable {

    private String id;
    private String idPersonnel;
    private double conge;
    private int annee;
    private int mois;

    public ReportSoldeConge() {
        this.setNomTable("REPORTSOLDECONGE");
    }

    public void construirePK(Connection c) throws Exception {
        this.preparePk("RSC", "GET_SEQ_REPORTCONGE");
        this.setId(makePK(c));
    }

    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
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

    public double getConge() {
        return conge;
    }

    public void setConge(double conge) throws Exception {
        if (this.getMode().equals("modif") && conge == 0) {
            throw new Exception("Le nombre de cong&eacute; doit etre superieur a 0");
        }
        this.conge = conge;
    }

    public String getIdPersonnel() {
        return idPersonnel;
    }

    public void setIdPersonnel(String idPersonnel) {
        this.idPersonnel = idPersonnel;
    }
}
