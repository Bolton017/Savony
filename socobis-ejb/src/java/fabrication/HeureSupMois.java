package fabrication;

import bean.CGenUtil;
import bean.ClassMAPTable;

import java.sql.Connection;

public class HeureSupMois extends ClassMAPTable {
    private String idPersonnel;
    private int annee;
    private int mois;
    private double hs30_mois;
    private double hs50_mois;
    private String idDepartement, idCategorie;

    @Override
    public ClassMAPTable createObject(String u, Connection c) throws Exception {
        this.calculerHsPersonnel();
        return super.createObject(u, c);
    }

    public HeureSupMois() {
        super.setNomTable("HS_MOIS");
    }

    @Override
    public String getTuppleID() {
        return idPersonnel;
    }

    @Override
    public String getAttributIDName() {
        return "idPersonnel";
    }



    public void calculerHsPersonnel() throws Exception {
        HeureSupMois tmp = new HeureSupMois();
        tmp.setMois(this.getMois());
        tmp.setAnnee(this.getAnnee());
        tmp.setIdCategorie(this.getIdCategorie());
        if(this.getIdDepartement() != null) {
            tmp.setIdDepartement(this.getIdDepartement());
        }
        HeureSupMois[] hs = (HeureSupMois[]) CGenUtil.rechercher(tmp, null, null, "");
        if (hs != null && hs.length > 0) {
            final double SEUIL_NI = 20;

            for (HeureSupMois h : hs) {

                double hs30 = h.getHs30_mois();
                double hs50 = h.getHs50_mois();

                double hs30NI = 0;
                double hs30I = 0;

                double hs50NI = 0;
                double hs50I = 0;

                if (hs30 <= SEUIL_NI) {
                    hs30NI = hs30;
                    hs30I = 0;
                } else {
                    hs30NI = SEUIL_NI;
                    hs30I = hs30 - SEUIL_NI;
                }

                double resteNI = SEUIL_NI - hs30NI;
                double resteHs50 = 0;
                if(hs50 >= resteNI) {
                    resteHs50 = hs50 - resteNI;
                    hs50NI = resteNI;
                    hs50I = resteHs50;
                } else {
                    hs50NI = hs50;
                }

                // Debug console
                System.out.println("Personnel = " + h.getIdPersonnel());
                System.out.println("HS30NI : " + hs30NI + " | HS30I : " + hs30I);
                System.out.println("HS50NI : " + hs50NI + " | HS50I : " + hs50I);
                System.out.println("----------------------------------------");

            }
        }
    }

    public String getIdPersonnel() {
        return idPersonnel;
    }

    public void setIdPersonnel(String idPersonnel) {
        this.idPersonnel = idPersonnel;
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

    public double getHs30_mois() {
        return hs30_mois;
    }

    public void setHs30_mois(double hs30_mois) {
        this.hs30_mois = hs30_mois;
    }

    public double getHs50_mois() {
        return hs50_mois;
    }

    public void setHs50_mois(double hs50_mois) {
        this.hs50_mois = hs50_mois;
    }

    public String getIdDepartement() {
        return idDepartement;
    }

    public void setIdDepartement(String idDepartement) {
        this.idDepartement = idDepartement;
    }

    public String getIdCategorie() {
        return idCategorie;
    }

    public void setIdCategorie(String idCategorie) {
        this.idCategorie = idCategorie;
    }
}
