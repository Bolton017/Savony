package faturefournisseur.historique;

import bean.ClassMAPTable;
import java.sql.Connection;
import java.sql.Date;

public class HistoriqueValidationDmdAchat extends ClassMAPTable {
    private String id;
    private String idDmdAchat;
    private String refuser;
    private String nomuser;
    private Date daty;
    private String heure;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdDmdAchat() {
        return idDmdAchat;
    }

    public void setIdDmdAchat(String idDmdAchat) {
        this.idDmdAchat = idDmdAchat;
    }

    public String getRefuser() {
        return refuser;
    }

    public void setRefuser(String refuser) {
        this.refuser = refuser;
    }

    public String getNomuser() {
        return nomuser;
    }

    public void setNomuser(String nomuser) {
        this.nomuser = nomuser;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public String getHeure() {
        return heure;
    }

    public void setHeure(String heure) {
        this.heure = heure;
    }



    public HistoriqueValidationDmdAchat() throws Exception {
        this.setNomTable("HISTORIQUEVALIDATIONDMDACHAT");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("HVD","getseqhistoriquevalidationdmd");
        this.setId(makePK(c));
    }

    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }
}

