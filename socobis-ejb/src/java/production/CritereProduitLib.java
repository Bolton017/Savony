package production;
public class CritereProduitLib extends CritereProduit {
    String idcriterelib;
    String idTypeProduitLib;


    public CritereProduitLib() throws Exception {
        super.setNomTable("CRITEREPRODUITLIB");
    }
    public String getIdcriterelib() {
        return idcriterelib;
    }
    public void setIdcriterelib(String idcriterelib) {
        this.idcriterelib = idcriterelib;
    }
    public String getIdTypeProduitLib() {
        return idTypeProduitLib;
    }
    public void setIdTypeProduitLib(String idTypeProduitLib) {
        this.idTypeProduitLib = idTypeProduitLib;
    }

    
    
}
