package produits;
import java.sql.Date;

import bean.ClassMAPTable;

public class Historique extends  ClassMAPTable{
    String idhistorique, heure, objet,action, idutilisateur,refobjet;
    Date datehistorique;
    public Historique() {
        this.setNomTable("HISTORIQUE");
    }

    @Override
    public String getTuppleID() {
        return idhistorique;
    }

    @Override
    public String getAttributIDName() {
        return "idhistorique";
    }

    public String getIdhistorique() {
        return idhistorique;
    }
    public void setIdhistorique(String idhistorique) {
        this.idhistorique = idhistorique;
    }
    public String getHeure() {
        return heure;
    }
    public void setHeure(String heure) {
        this.heure = heure;
    }
    public String getObjet() {
        return objet;
    }
    public void setObjet(String objet) {
        this.objet = objet;
    }
    public String getAction() {
        return action;
    }
    public void setAction(String action) {
        this.action = action;
    }
    public String getIdutilisateur() {
        return idutilisateur;
    }
    public void setIdutilisateur(String idutilisateur) {
        this.idutilisateur = idutilisateur;
    }
    public String getRefobjet() {
        return refobjet;
    }
    public void setRefobjet(String refobjet) {
        this.refobjet = refobjet;
    }
    public Date getDatehistorique() {
        return datehistorique;
    }
    public void setDatehistorique(Date datehistorique) {
        this.datehistorique = datehistorique;
    }
}
