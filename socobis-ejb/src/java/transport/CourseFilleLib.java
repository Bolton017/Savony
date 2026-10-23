package transport;

public class CourseFilleLib extends CourseFille{
    private String idpersonnellib;

    public CourseFilleLib() throws Exception{
        this.setNomTable("COURSEFILLELIB");
    }

    public String getIdpersonnellib() {
        return idpersonnellib;
    }

    public void setIdpersonnellib(String idpersonnellib) {
        this.idpersonnellib = idpersonnellib;
    }
    


}
