package faturefournisseur;

import bean.CGenUtil;
import utilitaire.UtilDB;

import java.sql.Connection;

public class DmdAchatLib extends DmdAchat {

    String fournisseurLib;
    String etatlib;
    private String idMagasinLib;
    private String idCategorieLib , serviceLib;
    private String idPrioriteLib;
    private String destinataireLib;

    public String getDestinataireLib() {
        return destinataireLib;
    }

    public void setDestinataireLib(String destinataireLib) {
        this.destinataireLib = destinataireLib;
    }

    public String getIdPrioriteLib() {
        return idPrioriteLib;
    }

    public void setIdPrioriteLib(String idPrioriteLib) {
        this.idPrioriteLib = idPrioriteLib;
    }

    public String getServiceLib() {
        return serviceLib;
    }

    public void setServiceLib(String serviceLib) {
        this.serviceLib = serviceLib;
    }

    public String getEtatlib() {
        return etatlib;
    }

    public void setEtatlib(String etatlib) {
        this.etatlib = etatlib;
    }

    public String getFournisseurLib() {
        return fournisseurLib;
    }

    public void setFournisseurLib(String fournisseurLib) {
        this.fournisseurLib = fournisseurLib;
    }

    public DmdAchatLib() throws Exception {
        this.setNomTable("DMDACHATLIB");
    }

    public String getIdMagasinLib() {
        return idMagasinLib;
    }

    public void setIdMagasinLib(String idMagasinLib) {
        this.idMagasinLib = idMagasinLib;
    }

    public String getIdCategorieLib() {
        return idCategorieLib;
    }

    public void setIdCategorieLib(String idCategorieLib) {
        this.idCategorieLib = idCategorieLib;
    }

    public boolean avecBC(Connection c) throws Exception {
        boolean estClosable = false;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                estClosable = true;
            }
            As_BonDeCommandeCpl b = new As_BonDeCommandeCpl();
            b.setNomTable("AS_BONDECOMMANDE_MERECPL");
            b.setIdOrigine(this.getId());
            As_BonDeCommandeCpl[] bc = (As_BonDeCommandeCpl[]) CGenUtil.rechercher(b, null, null, c, "");
            if (bc.length > 0) {
                return true;
            }
        } finally {
            if (estClosable) {
                c.close();
            }
        }
        return false;
    }

}
