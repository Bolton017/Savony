package paie.analyse;

import bean.ClassMAPTable;

public class ViewVideFiltre extends ClassMAPTable {
    private String id;
    private String idDepartement;
    private String idTypeSomme;

    public ViewVideFiltre() {
        setNomTable("VIEW_VIDE_SOMME");
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdDepartement() {
        return idDepartement;
    }

    public void setIdDepartement(String idDepartement) {
        this.idDepartement = idDepartement;
    }

    public String getIdTypeSomme() {
        return idTypeSomme;
    }

    public void setIdTypeSomme(String idTypeSomme) {
        this.idTypeSomme = idTypeSomme;
    }

    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }
}
