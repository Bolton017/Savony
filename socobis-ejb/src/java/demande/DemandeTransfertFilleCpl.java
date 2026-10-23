package demande;
public class DemandeTransfertFilleCpl extends DemandeTransfertFille {
    private String idDemandeTransfertLib,idProduitLib,typeStock,idDemandeTransfert,unite;
    public DemandeTransfertFilleCpl() throws Exception{
        this.setNomTable("demandetransfertfillecpl");
    }

    public String getIdDemandeTransfertLib() {
        return idDemandeTransfertLib;
    }

    public void setIdDemandeTransfertLib(String idDemandeTransfertLib) {
        this.idDemandeTransfertLib = idDemandeTransfertLib;
    }

    public String getIdProduitLib() {
        return idProduitLib;
    }

    public void setIdProduitLib(String idProduitLib) {
        this.idProduitLib = idProduitLib;
    }

    public String getTypeStock() {
        return typeStock;
    }

    public void setTypeStock(String typeStock) {
        this.typeStock = typeStock;
    }

    public String getIdDemandeTransfert() {
        return idDemandeTransfert;
    }

    public void setIdDemandeTransfert(String idDemandeTransfert) {
        this.idDemandeTransfert = idDemandeTransfert;
    }

    public String getUnite() {
        return unite;
    }

    public void setUnite(String unite) {
        this.unite = unite;
    }
}