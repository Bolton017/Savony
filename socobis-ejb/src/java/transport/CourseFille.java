package transport;

import bean.*;
import bean.ClassFille;
import stock.TransfertStock;

import java.sql.Connection;
import java.sql.Date;

public class CourseFille extends ClassFille {
    String id;
    String idobjet;
    Date datedepart;
    String heuredepart;
    Date datearrivee;
    String heurearrivee;
    String idpersonnel;
    String remarque;
    String idmere;

    public CourseFille() throws Exception {
        this.setNomTable("coursefille");
        this.setLiaisonMere("idmere");
        this.setNomClasseMere("transport.Course");
    }
    public String getId() {
        return id;
    }
    public void setId(String id) {
        this.id = id;
    }
    public String getIdobjet() {
        return idobjet;
    }
    public void setIdobjet(String idobjet) {
        this.idobjet = idobjet;
    }
    public Date getDatedepart() {
        return datedepart;
    }
    public void setDatedepart(Date datedepart) {
        this.datedepart = datedepart;
    }
    public String getHeuredepart() {
        return heuredepart;
    }
    public void setHeuredepart(String heuredepart) {
        this.heuredepart = heuredepart;
    }
    public Date getDatearrivee() {
        return datearrivee;
    }
    public void setDatearrivee(Date datearrivee) {
        this.datearrivee = datearrivee;
    }
    public String getHeurearrivee() {
        return heurearrivee;
    }
    public void setHeurearrivee(String heurearrivee) {
        this.heurearrivee = heurearrivee;
    }
    public String getIdpersonnel() {
        return idpersonnel;
    }
    public void setIdpersonnel(String idpersonnel) {
        this.idpersonnel = idpersonnel;
    }
    public String getRemarque() {
        return remarque;
    }
    public void setRemarque(String remarque) {
        this.remarque = remarque;
    }
     public void construirePK(Connection c) throws Exception {
        this.preparePk("CRF", "GETSEQCOURSEFILLE");
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
    public String getIdmere() {
        return idmere;
    }
    public void setIdmere(String idmere) {
        this.idmere = idmere;
    }
     @Override
    public String getNomClasseMere() {
        return "transport.Course";
    }

    @Override
    public String getLiaisonMere() {
        return "idmere";
    }

    @Override
    public int updateToTableWithHisto(String refUser, Connection c) throws Exception {

        System.out.println("UPDATE COURSEFILLE");

        if (this.getEtat() == 1)
        {
            this.setEtat(7);

            Course courseMere = (Course) this.getMere();

            if (courseMere.getEtat() == 1)
            {
                courseMere.setEtat(7);
                courseMere.updateToTableWithHisto(refUser, c);
            }

        } else if (this.getEtat() == 7) {

            this.setEtat(11);

        }
        else {

            throw new Exception("Erreur: Course Fille mise a jour");

        }

        int ret =  super.updateToTableWithHisto(refUser, c);

        CourseFille courseFille = new CourseFille();
        courseFille.setIdmere(this.getIdmere());

        CourseFille[] courseFilles = (CourseFille[]) CGenUtil.rechercher(courseFille, null, null, c, "");

        if (courseFilles == null || courseFilles.length == 0)
        {
            throw new Exception("Course Fille est null");
        }

        boolean allDone = true;

        for (CourseFille cf : courseFilles) {
            if (cf.getEtat() != 11) {
                allDone = false;
                break;
            }
        }

        Course cou = (Course) this.getMere();
        System.out.println("Course ID:" + cou.getId());

        if (allDone) {
            Course course = (Course) this.getMere();
            System.out.println("Course ID:" + course.getId());
            course.setEtat(11);
            course.updateToTableWithHisto(refUser, c);
            System.out.println("Updated");
        }

        System.out.println("Check Complete");

        return ret;
    }
}
