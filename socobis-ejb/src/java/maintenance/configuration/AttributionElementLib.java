package maintenance.configuration;

public class AttributionElementLib extends AttributionElement {
    private String idIngredientMaintenanceLib;
    private String idPersonnelLib;
    private String qualiteObjetMaintenanceLib;
    private String typeAttributionLib,etatLib;

    public AttributionElementLib() {
        setNomTable("attributionelementlib");
    }

    public String getIdIngredientMaintenanceLib() {
        return idIngredientMaintenanceLib;
    }

    public void setIdIngredientMaintenanceLib(String idIngredientMaintenanceLib) {
        this.idIngredientMaintenanceLib = idIngredientMaintenanceLib;
    }

    public String getIdPersonnelLib() {
        return idPersonnelLib;
    }

    public void setIdPersonnelLib(String idPersonnelLib) {
        this.idPersonnelLib = idPersonnelLib;
    }

    public String getQualiteObjetMaintenanceLib() {
        return qualiteObjetMaintenanceLib;
    }

    public void setQualiteObjetMaintenanceLib(String qualiteObjetMaintenanceLib) {
        this.qualiteObjetMaintenanceLib = qualiteObjetMaintenanceLib;
    }

    public String getTypeAttributionLib() {
        return typeAttributionLib;
    }

    public void setTypeAttributionLib(String typeAttributionLib) {
        this.typeAttributionLib = typeAttributionLib;
    }

    public String getEtatLib() {
        return etatLib;
    }

    public void setEtatLib(String etatLib) {
        this.etatLib = etatLib;
    }
}
