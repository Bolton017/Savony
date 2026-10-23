package paie.analyse;

import bean.ClassMAPTable;

public class AnalyseEffectifPersonnel extends ClassMAPTable {
    private String sexe;
    private int nombre;
    private String idDepartement;
    private String idCategorie;

    private String departementLib;
    private String idCategorieLib;

    public AnalyseEffectifPersonnel() {
        setNomTable("effectif_log_personnel");
    }

    @Override
    public String getTuppleID() {
        return sexe;
    }

    @Override
    public String getAttributIDName() {
        return "sexe";
    }

    public String getSexe() {
        return sexe;
    }

    public void setSexe(String sexe) {
        this.sexe = sexe;
    }

    public int getNombre() {
        return nombre;
    }

    public void setNombre(int nombre) {
        this.nombre = nombre;
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

    public String getDepartementLib() {
        return departementLib;
    }

    public void setDepartementLib(String departementLib) {
        this.departementLib = departementLib;
    }

    public String getIdCategorieLib() {
        return idCategorieLib;
    }

    public void setIdCategorieLib(String idCategorieLib) {
        this.idCategorieLib = idCategorieLib;
    }
}
