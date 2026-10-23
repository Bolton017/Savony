/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package paie.demande;

import bean.ClassMAPTable;
import java.sql.Connection;
import java.sql.Date;

/**
 *
 * @author Jacques
 */
public class HistoriqueDemande extends ClassMAPTable{
    String id,idPersonnel,idDemande,heure;
    Date daty;
    int etatDemande,rangetatdemande;

    public HistoriqueDemande(){
        this.setNomTable("HISTORIQUEDEMANDE");
    }

    public HistoriqueDemande(String idPersonnel, String idDemande, String heure, Date daty) {
        this.setNomTable("HISTORIQUEDEMANDE");
        this.setIdPersonnel(idPersonnel);
        this.setIdDemande(idDemande);
        this.setHeure(heure);
        this.setDaty(daty);
    }
    
    @Override
    public String getTuppleID() {
        return id; //To change body of generated methods, choose Tools | Templates.
    }
    
    public void construirePK(Connection c) throws Exception{
        super.setNomTable("HISTORIQUEDEMANDE");
        this.preparePk("HISTO00","get_seq_historiquedemande");
        this.setId(makePK(c));
    }
    @Override
    public String getAttributIDName() {
        return "id";
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdPersonnel() {
        return idPersonnel;
    }

    public void setIdPersonnel(String idPersonnel) {
        this.idPersonnel = idPersonnel;
    }

    public String getIdDemande() {
        return idDemande;
    }

    public void setIdDemande(String idDemande) {
        this.idDemande = idDemande;
    }

    public String getHeure() {
        return heure;
    }

    public void setHeure(String heure) {
        this.heure = heure;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public int getEtatDemande() {
        return etatDemande;
    }

    public void setEtatDemande(int etatDemande) {
        this.etatDemande = etatDemande;
    }

    public int getRangetatdemande() {
        return rangetatdemande;
    }

    public void setRangetatdemande(int rangetatdemande) {
        this.rangetatdemande = rangetatdemande;
    }
       
    public HistoriqueDemande(String nomtable){
        this.setNomTable(nomtable);
    }

    @Override
    public String toString() {
        return "HistoriqueDemande{" + "id=" + id + ", idPersonnel=" + idPersonnel + ", idDemande=" + idDemande + ", heure=" + heure + ", daty=" + daty + ", etatDemande=" + etatDemande + ", rangetatdemande=" + rangetatdemande + '}';
    }
    
    
}
