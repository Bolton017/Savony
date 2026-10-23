package remise;

public class RemiseFilleLib extends  RemiseFille{
    private String idcategorieclientlib;
    private String idproduitlib;
    private String categorieproduitlib;
    private String idpointlib;

    public String getIdcategorieclientlib() {
        return idcategorieclientlib;
    }

    public void setIdcategorieclientlib(String idcategorieclientlib) {
        this.idcategorieclientlib = idcategorieclientlib;
    }

    public String getIdproduitlib() {
        return idproduitlib;
    }

    public void setIdproduitlib(String idproduitlib) {
        this.idproduitlib = idproduitlib;
    }

    public String getCategorieproduitlib() {
        return categorieproduitlib;
    }

    public void setCategorieproduitlib(String categorieproduitlib) {
        this.categorieproduitlib = categorieproduitlib;
    }

    public String getIdpointlib() {
        return idpointlib;
    }

    public void setIdpointlib(String idpointlib) {
        this.idpointlib = idpointlib;
    }

    public  RemiseFilleLib() throws Exception{
        this.setNomTable("REMISEFILLELIB");
    }

}
