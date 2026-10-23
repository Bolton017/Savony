package maintenance.ressources;

public class IngredientMaintenanceLib extends IngredientMaintenance{
    private String idEntiteLib;
    private String qualiteObjetLib;
    private String etatObjetLib;
    private String estEnginLib;
    private String localisationObjetLib,idLigneLib;

    public String getLocalisationObjetLib() {
        return localisationObjetLib;
    }

    public void setLocalisationObjetLib(String localisationObjetLib) {
        this.localisationObjetLib = localisationObjetLib;
    }

    public IngredientMaintenanceLib() {
        setNomTable("AS_INGREDIENT_MAINTENANCE_LIB");
    }

    public String getIdEntiteLib() {
        return idEntiteLib;
    }

    public void setIdEntiteLib(String idEntiteLib) {
        this.idEntiteLib = idEntiteLib;
    }

    public String getQualiteObjetLib() {
        return qualiteObjetLib;
    }

    public void setQualiteObjetLib(String qualiteObjetLib) {
        this.qualiteObjetLib = qualiteObjetLib;
    }

    public String getEtatObjetLib() {
        return etatObjetLib;
    }

    public void setEtatObjetLib(String etatObjetLib) {
        this.etatObjetLib = etatObjetLib;
    }

    public String getEstEnginLib() {
        return estEnginLib;
    }

    public void setEstEnginLib(String estEnginLib) {
        this.estEnginLib = estEnginLib;
    }

    public String getIdLigneLib() {
        return idLigneLib;
    }

    public void setIdLigneLib(String idLigneLib) {
        this.idLigneLib = idLigneLib;
    }

    @Override
    public String[] getMotCles() {
        String[] motCles={"id","IdIngredient","libelle","numeroSerieObjet","idEntiteLib","etatObjetLib"};
        return motCles;
    }

    @Override
    public String[] getValMotCles() {
        String[] valMotCles={"id","IdIngredient","libelle","numeroSerieObjet","idEntiteLib","etatObjetLib"};
        return valMotCles;
    }
}
