package maintenance.etats;

import bean.ClassMAPTable;

import java.sql.Date;

public class CoutMaintenance extends ClassMAPTable {

    private String idMachine;
    private String nomMachine;
    private String idLigne;
    private String idLigneLib;
    private String idTravaux;
    private Date daty;
    private double coutTotal;

    private double tauxDisponibilite;

    public CoutMaintenance(){
        this.setNomTable("coutsMaintenance");
    }

    @Override
    public String getTuppleID() {
        return idMachine;
    }

    @Override
    public String getAttributIDName() {
        return "idMachine";
    }

    public String getIdMachine() {
        return idMachine;
    }

    public void setIdMachine(String idMachine) {
        this.idMachine = idMachine;
    }

    public String getNomMachine() {
        return nomMachine;
    }

    public void setNomMachine(String nomMachine) {
        this.nomMachine = nomMachine;
    }

    public String getIdLigne() {
        return idLigne;
    }

    public void setIdLigne(String idLigne) {
        this.idLigne = idLigne;
    }

    public String getIdLigneLib() {
        return idLigneLib;
    }

    public void setIdLigneLib(String idLigneLib) {
        this.idLigneLib = idLigneLib;
    }

    public String getIdTravaux() {
        return idTravaux;
    }

    public void setIdTravaux(String idTravaux) {
        this.idTravaux = idTravaux;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public double getCoutTotal() {
        return coutTotal;
    }

    public void setCoutTotal(double coutTotal) {
        this.coutTotal = coutTotal;
    }

    public double getTauxDisponibilite() {
        return tauxDisponibilite;
    }

    public void setTauxDisponibilite(double tauxDisponibilite) {
        this.tauxDisponibilite = tauxDisponibilite;
    }
}
