package vente;

import java.sql.Date;

public class BonDeCommandeGlobale extends BonDeCommandeFIlleCpl{
    private String idClient;
    private String idClientLib;
    private Date daty;
    private String etatLib;

    public BonDeCommandeGlobale() throws Exception {
        super();
        this.setNomTable("BONDECOMMANDE_CLIENT_GLOBALE");
    }

    public String getIdClient() {
        return idClient;
    }

    public void setIdClient(String idClient) {
        this.idClient = idClient;
    }

    public String getIdClientLib() {
        return idClientLib;
    }

    public void setIdClientLib(String idClientLib) {
        this.idClientLib = idClientLib;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public String getEtatLib() {
        return etatLib;
    }

    public void setEtatLib(String etatLib) {
        this.etatLib = etatLib;
    }
}
