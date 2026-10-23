package client;

public class ForfaitZoneClientLib extends ForfaitZoneClient{
    private String idZoneLib, idIngredientLib;
    public ForfaitZoneClientLib() throws Exception {
        this.setNomTable("FORFAITZONECLIENTLIB");
    }

    public String getIdZoneLib() {
        return idZoneLib;
    }

    public void setIdZoneLib(String idZoneLib) {
        this.idZoneLib = idZoneLib;
    }

    public String getIdIngredientLib() {
        return idIngredientLib;
    }

    public void setIdIngredientLib(String idIngredientLib) {
        this.idIngredientLib = idIngredientLib;
    }
}
