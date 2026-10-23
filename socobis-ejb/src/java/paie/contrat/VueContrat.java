/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package paie.contrat;

import bean.ClassEtat;

import java.sql.Date;

/**
 *
 * @author Audace
 */
public class VueContrat extends ClassEtat{
    private String id, matricule,nom, prenom, sexe, type_contrat;
    private Date dateembauche, date_fin_contrat;
    private int periode;
    
    public VueContrat(){
        this.setNomTable("vue_contrat_lib");
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getMatricule() {
        return matricule;
    }

    public void setMatricule(String matricule) {
        this.matricule = matricule;
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

    public String getSexe() {
        return sexe;
    }

    public void setSexe(String sexe) {
        this.sexe = sexe;
    }

    public Date getDateembauche() {
        return dateembauche;
    }

    public void setDateembauche(Date dateembauche) {
        this.dateembauche = dateembauche;
    }

    public Date getDate_fin_contrat() {
        return date_fin_contrat;
    }

    public void setDate_fin_contrat(Date date_fin_contrat) {
        this.date_fin_contrat = date_fin_contrat;
    }

    public int getPeriode() {
        return periode;
    }

    public void setPeriode(int periode) {
        this.periode = periode;
    }

    public String getType_contrat() {
        return type_contrat;
    }

    public void setType_contrat(String type_contrat) {
        this.type_contrat = type_contrat;
    }
    
    @Override
    public String getTuppleID() {
        return this.id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }
    
    
}
