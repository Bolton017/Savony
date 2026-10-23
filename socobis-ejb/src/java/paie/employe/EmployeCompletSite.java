/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package paie.employe;

import bean.ClassEtat;

/**
 *
 * @author ASUS
 */
public class EmployeCompletSite extends ClassEtat {

    private String id, nom, prenom, matricule, idfonction;

    public EmployeCompletSite() {
        setNomTable("EMPLOYE_COMPLET_SITE");
    }

    public EmployeCompletSite(String nom, String prenom, String matricule, String direction, String service, String idfonction) {
        setNomTable("EMPLOYE_COMPLET_SITE");
        this.nom = nom;
        this.prenom = prenom;
        this.matricule = matricule;
        setDirection(direction);
        setService(service);
        this.idfonction = idfonction;
    }

    public EmployeCompletSite(String id, String nom, String prenom, String matricule, String direction, String service, String idfonction) {
        setNomTable("EMPLOYE_COMPLET_SITE");
        this.id = id;
        this.nom = nom;
        this.prenom = prenom;
        this.matricule = matricule;
        setDirection(direction);
        setService(service);
        this.idfonction = idfonction;
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

    public void setNom(String nom) throws Exception {
        if (getMode().compareTo("modif") != 0) {
            this.nom = nom;
            return;
        }
        if (String.valueOf(nom) == null || String.valueOf(nom).compareToIgnoreCase(" ") == 0) {
            throw new Exception("Nom Obligatoire");
        }
        this.nom = nom;
    }

    public String getPrenom() {
        return prenom;
    }

    public void setPrenom(String prenom) {
        this.prenom = prenom;
    }

    public String getMatricule() {
        return matricule;
    }

    public void setMatricule(String matricule) throws Exception {
        if (getMode().compareTo("modif") != 0) {
            this.matricule = matricule;
            return;
        }
        if (matricule == null || matricule.compareToIgnoreCase("") == 0) {
            throw new Exception("Matricule obligatoire");
        }
        this.matricule = matricule;
    }

    public String getIdfonction() {
        return idfonction;
    }

    public void setIdfonction(String idfonction) throws Exception {
        if (getMode().compareTo("modif") != 0) {
            this.idfonction = idfonction;
            return;
        }
        if (idfonction == null || idfonction.compareToIgnoreCase("") == 0) {
            throw new Exception("Fonction obligatoire");
        }
        this.idfonction = idfonction;
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
