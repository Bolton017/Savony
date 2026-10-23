
package production;


public class ObjectifProductionLib extends ObjectifProduction{
    String idProduitLib , uniteLib;

    public ObjectifProductionLib() {
        this.setNomTable("objectifproductionlib");
    }

    public String getIdProduitLib() {
        return idProduitLib;
    }

    public void setIdProduitLib(String idProduitLib) {
        this.idProduitLib = idProduitLib;
    }

    public String getUniteLib() {
        return uniteLib;
    }

    public void setUniteLib(String uniteLib) {
        this.uniteLib = uniteLib;
    }
    
    
}
