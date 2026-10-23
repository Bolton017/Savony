package maintenance.resultat;

import bean.ClassMAPTable;
import java.sql.Connection;
import java.sql.Date;

public class ResultatMaintenance extends ClassMAPTable {
    private String id;
    private Date daty;
    private String idordretravaux;
    private int idpersonnel;
    private String etatmachine;
    private String designation;
    private String prochaineetape;
    private Date prochainedaty;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public String getIdordretravaux() {
        return idordretravaux;
    }

    public void setIdordretravaux(String idordretravaux) {
        this.idordretravaux = idordretravaux;
    }

    public int getIdpersonnel() {
        return idpersonnel;
    }

    public void setIdpersonnel(int idpersonnel) {
        this.idpersonnel = idpersonnel;
    }

    public String getEtatmachine() {
        return etatmachine;
    }

    public void setEtatmachine(String etatmachine) {
        this.etatmachine = etatmachine;
    }

    public String getDesignation() {
        return designation;
    }

    public void setDesignation(String designation) {
        this.designation = designation;
    }

    public String getProchaineetape() {
        return prochaineetape;
    }

    public void setProchaineetape(String prochaineetape) {
        this.prochaineetape = prochaineetape;
    }

    public Date getProchainedaty() {
        return prochainedaty;
    }

    public void setProchainedaty(Date prochainedaty) {
        this.prochainedaty = prochainedaty;
    }



    public ResultatMaintenance() throws Exception {
        this.setNomTable("RESULTATMAINTENANCE");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("RESM","get_seqresultatmaintenance");
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

