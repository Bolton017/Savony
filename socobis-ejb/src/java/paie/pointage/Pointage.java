package paie.pointage;

import bean.ClassEtat;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import paie.employe.ConstantePaie;

public class Pointage extends ClassEtat {
    private String id,personnel, direction,idPersonnel, nomPersonnel, matricule,nom,prenom;
    private double heureNormal, heureSupNormal,heureSupNuit, heureSupFerie, heureSupWeekend,absence;
    private Date daty;
    private int mois,annee,etat;
    private String moisLib, directionLib;

    public Pointage() throws Exception{
        this.setNomTable("POINTAGE");
    }

    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("PTG", "GET_SEQ_POINTAGE");
        this.setId(makePK(c));
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public String getPrenom() {
        return prenom;
    }

    public void setPrenom(String prenom) {
        this.prenom = prenom;
    }
    
    public String getIdPersonnel() {
        return idPersonnel;
    }

    public void setIdPersonnel(String idPersonnel) {
        this.idPersonnel = idPersonnel;
    }

    public String getNomPersonnel() {
        return nomPersonnel;
    }

    public void setNomPersonnel(String nomPersonnel) {
        this.nomPersonnel = nomPersonnel;
    }


    public String getMatricule() {
        return matricule;
    }

    public void setMatricule(String matricule) {
        this.matricule = matricule;
    }

    public double getHeureNormal() {
        return heureNormal;
    }

    public void setHeureNormal(double heureNormal) throws Exception {
        if(this.getMode().compareToIgnoreCase("modif")==0) {
            if(heureNormal < 0) {
                throw new Exception("L'heure normale ne peut pas etre n&eacute;gative");
            }
        }
        this.heureNormal = heureNormal;
    }

    public double getHeureSupNuit() {
        return heureSupNuit;
    }

    public void setHeureSupNuit(double heureSupNuit) throws Exception {
        if(this.getMode().compareToIgnoreCase("modif")==0) {
            if(heureSupNuit < 0) {
                throw new Exception("L'heure suppl&eacute;mentaire ne peut pas etre n&eacute;gative");
            }
        }
        this.heureSupNuit = heureSupNuit;
    }

    public double getHeureSupFerie() {
        return heureSupFerie;
    }

    public void setHeureSupFerie(double heureSupFerie) throws Exception {
        if(this.getMode().compareToIgnoreCase("modif")==0) {
            if(heureSupFerie < 0) {
                throw new Exception("L'heure suppl&eacute;mentaire ne peut pas etre n&eacute;gative");
            }
        }
        this.heureSupFerie = heureSupFerie;
    }

    public double getHeureSupWeekend() {
        return heureSupWeekend;
    }

    public void setHeureSupWeekend(double heureSupWeekend) throws Exception {
        if(this.getMode().compareToIgnoreCase("modif")==0) {
            if(heureSupWeekend < 0) {
                throw new Exception("L'heure suppl&eacute;mentaire ne peut pas etre n&eacute;gative");
            }
        }
        this.heureSupWeekend = heureSupWeekend;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public int getMois() {
        return mois;
    }

    public void setMois(int mois) {
        this.mois = mois;
    }

    public int getAnnee() {
        return annee;
    }

    public void setAnnee(int annee) {
        this.annee = annee;
    }

    
    public double getHeureSupNormal() {
        return heureSupNormal;
    }

    public void setHeureSupNormal(double heureSupNormal) {
        this.heureSupNormal = heureSupNormal;
    }
    
    @Override
    public int getEtat() {
        return etat;
    }

    @Override
    public void setEtat(int etat) {
        this.etat = etat;
    }
    
    public double getAbsence() {
        return absence;
    }

    public void setAbsence(double absence) {
        this.absence = absence;
    }
    
    public String getDirection() {
        return direction;
    }

    public String getMoisLib() {
        return moisLib;
    }

    public void setMoisLib(String moisLib) {
        this.moisLib = moisLib;
    }

    public String getDirectionLib() {
        return directionLib;
    }

    public void setDirectionLib(String directionLib) {
        this.directionLib = directionLib;
    }

    public String getPersonnel() {
        return personnel;
    }

    public void setPersonnel(String personnel) {
        this.personnel = personnel;
    }

    @Override
    public void setDirection(String direction) {
        this.direction = direction;
    }
}
