package maintenance.travaux;

public class TravauxCpl extends Travaux{
    String lanceparLib, cibleLib,etatLib,idIngredientMaintenance,ingredientMaintenanceLib;
    public TravauxCpl() throws Exception {
        super.setNomTable("TRAVAUXCPL");
    }

    public String getLanceparLib(){
        return this.lanceparLib;
    }

    public void setLanceparLib(String lanceparLib){
        this.lanceparLib = lanceparLib;
    }

    public String getCibleLib(){
        return this.cibleLib;
    }

    public void setCibleLib(String cibleLib){
        this.cibleLib = cibleLib;
    }

    public String getEtatLib(){
        return this.etatLib;
    }

    public void setEtatLib(String etatLib){
        this.etatLib = etatLib;
    }

    public String getIdIngredientMaintenance() {
        return idIngredientMaintenance;
    }

    public String getIngredientMaintenanceLib() {
        return this.ingredientMaintenanceLib;
    }

    public void setIngredientMaintenanceLib(String ingredientMaintenanceLib) {
        this.ingredientMaintenanceLib = ingredientMaintenanceLib;
    }

    public void setIdIngredientMaintenance(String idIngredientMaintenance) {
        this.idIngredientMaintenance = idIngredientMaintenance;
    }

    public String[] getValMotCles() {
        String[] motCles={"id","libelle", "idoffille", "daty"};
        return motCles;
    }
}
