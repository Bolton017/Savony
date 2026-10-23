package client;

public class ClientLib extends Client{

    private String idTypeClientLib;
    private String provinceLib;
    private String idzoneclientLib;
    private String idModePaiementLib,idTarificationLib;
    double forfait;
    private int qtePanier;

    public int getQtePanier() {
        return qtePanier;
    }

    public void setQtePanier(int qtePanier) {
        this.qtePanier = qtePanier;
    }

    public double getForfait() {
        return forfait;
    }
    public void setForfait(double forfait) {
        this.forfait = forfait;
    }

    public String getIdTarificationLib() {
            return idTarificationLib;
        }

    public void setIdTarificationLib(String idTarificationLib) {
        this.idTarificationLib = idTarificationLib;
    }

    public String getIdModePaiementLib() {
        return idModePaiementLib;
    }

    public void setIdModePaiementLib(String idModePaiementLib) {
        this.idModePaiementLib = idModePaiementLib;
    }

    public ClientLib(){
         this.setNomTable("CLIENTLIB");
    }

    public String getProvinceLib() {
        return provinceLib;
    }

    public void setProvinceLib(String provinceLib) {
        this.provinceLib = provinceLib;
    }

    public String getIdTypeClientLib() {
        return idTypeClientLib;
    }
    public void setIdTypeClientLib(String idTypeClientLib) {
        this.idTypeClientLib = idTypeClientLib;
    }

    public String getIdzoneclientLib() {
        return idzoneclientLib;
    }

    public void setIdzoneclientLib(String idzoneclientLib) {
        this.idzoneclientLib = idzoneclientLib;
    }
}
