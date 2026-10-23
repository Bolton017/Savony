package transport;

import bean.*;

import java.sql.Connection;
import java.sql.Date;

public class Course extends ClassMere{
    String id;
    String idvehicule;
    String idchauffeur;
    Date daty;
    String remarque;
    
    public Course() throws Exception{
        this.setNomTable("course");
        setLiaisonFille("idmere");
        setNomClasseFille("transport.CourseFille");
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdvehicule() {
        return idvehicule;
    }

    public void setIdvehicule(String idvehicule) {
        this.idvehicule = idvehicule;
    }

    public String getIdchauffeur() {
        return idchauffeur;
    }

    public void setIdchauffeur(String idchauffeur) {
        this.idchauffeur = idchauffeur;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public String getRemarque() {
        return remarque;
    }

    public void setRemarque(String remarque) {
        this.remarque = remarque;
    }
     public void construirePK(Connection c) throws Exception {
        this.preparePk("CRS", "GETSEQCOURSE");
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
    @Override
    public String getLiaisonFille() {
        return "idmere";
    }
    @Override
    public String getNomClasseFille() {
        return "transport.CourseFille";
    }


    

}
