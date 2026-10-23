package paie.hs;

public class HsMoisCpl extends HsMois {

    private String idCategorieLib;
    private String idDepartementLib;
    private String etatLib;
    private String moisLib;

    public String getMoisLib() {
        return this.moisLib;
    }

    public void setMoisLib(String moisLib) {
        this.moisLib = moisLib;
    }

    public HsMoisCpl() {
        this.setNomTable("HSMOIS_CPL");
    }

    public String getIdCategorieLib() {
        return idCategorieLib;
    }

    public void setIdCategorieLib(String idCategorieLib) {
        this.idCategorieLib = idCategorieLib;
    }

    public String getIdDepartementLib() {
        return idDepartementLib;
    }

    public String getEtatLib() {
        return etatLib;
    }

    public void setEtatLib(String etatLib) {
        this.etatLib = etatLib;
    }

    public void setIdDepartementLib(String idDepartementLib) {
        this.idDepartementLib = idDepartementLib;
    }
}
