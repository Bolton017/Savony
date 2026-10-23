package maintenance.travaux;

import bean.ClassMAPTable;

import java.sql.Connection;
import java.sql.Date;

public class ProcessMaintenance extends ClassMAPTable {
    String id,idTravaux,idPersonnel,heureDebut,heureFin;
    Date dateDebut;
    Date dateFin;

    public Date getDateFin() {
        return dateFin;
    }

    public void setDateFin(Date dateFin) {
        this.dateFin = dateFin;
    }

    public ProcessMaintenance() {
        this.setNomTable("ProcessMaintenance");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("PRC", "getSeqprocessmaintenance");
        this.setId(makePK(c));
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdTravaux() {
        return idTravaux;
    }

    public void setIdTravaux(String idTravaux) {
        this.idTravaux = idTravaux;
    }

    public String getIdPersonnel() {
        return idPersonnel;
    }

    public void setIdPersonnel(String idPersonnel) {
        this.idPersonnel = idPersonnel;
    }

    public String getHeureDebut() {
        return heureDebut;
    }

    public void setHeureDebut(String heureDebut) {
        this.heureDebut = heureDebut;
    }

    public String getHeureFin() {
        return heureFin;
    }

    public void setHeureFin(String heureFin) {
        this.heureFin = heureFin;
    }

    public Date getDateDebut() {
        return dateDebut;
    }

    public void setDateDebut(Date dateDebut) {
        this.dateDebut = dateDebut;
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
