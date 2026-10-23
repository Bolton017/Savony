package transport;

public class CourseLib extends Course{

    String idvehiculelib;
    String idchauffeurlib;
    String etatlib;

    
    public CourseLib() throws Exception{
        this.setNomTable("courselib");
    }
    public String getIdvehiculelib() {
        return idvehiculelib;
    }
    public void setIdvehiculelib(String idvehiculelib) {
        this.idvehiculelib = idvehiculelib;
    }
    public String getIdchauffeurlib() {
        return idchauffeurlib;
    }
    public void setIdchauffeurlib(String idchauffeurlib) {
        this.idchauffeurlib = idchauffeurlib;
    }
    public String getEtatlib() {
        return etatlib;
    }
    public void setEtatlib(String etatlib) {
        this.etatlib = etatlib;
    }

    
    
}
