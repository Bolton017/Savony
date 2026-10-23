package maintenance.configuration;

public class AttributionElementCpl extends AttributionElement{
    String idIngredientMaintenanceLib,idPersonnelLib,etatElementLib,typeAttributionLib;

    public AttributionElementCpl() {
        this.setNomTable("ATTRIBUTION_ELEMENT_CPL");
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

    public String getEtatElementLib() {
        return etatElementLib;
    }

    public void setEtatElementLib(String etatElementLib) {
        this.etatElementLib = etatElementLib;
    }

    public String getTypeAttributionLib() {
        return typeAttributionLib;
    }

    public void setTypeAttributionLib(String typeAttributionLib) {
        this.typeAttributionLib = typeAttributionLib;
    }
}
