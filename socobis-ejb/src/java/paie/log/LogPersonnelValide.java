/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package paie.log;

import java.sql.Date;

/**
 *
 * @author ASUS
 */

public class LogPersonnelValide extends LogPersonnel{
    private String codee_dr,matricule;
    private Date datePropositionRetraite;
    private double resteconge;
    private String categorie;
    private String qualification;

    public String getCategorie() {
        return categorie;
    }

    public void setCategorie(String categorie) {
        this.categorie = categorie;
    }

    public String getQualification() {
        return qualification;
    }

    public void setQualification(String qualification) {
        this.qualification = qualification;
    }

    public String getCodee_dr() {
        return codee_dr;
    }

    public void setCodee_dr(String codee_dr) {
        this.codee_dr = codee_dr;
    }

    public String getMatricule() {
        return matricule;
    }

    public void setMatricule(String matricule) {
        this.matricule = matricule;
    }

    public LogPersonnelValide() {
        this.setNomTable("LOG_PERSONNEL_VALIDE");
    }

    public Date getDatePropositionRetraite() {
        return datePropositionRetraite;
    }

    public void setDatePropositionRetraite(Date datePropositionRetraite) {
        this.datePropositionRetraite = datePropositionRetraite;
    }

    public double getResteconge() {
        return resteconge;
    }

    public void setResteconge(double resteconge) {
        this.resteconge = resteconge;
    }

    @Override
    public String[] getMotCles() {
        String[] motCles={"id","nom", "prenom", "matricule"};
        return motCles;
    }

    @Override
    public String getValColLibelle() {
        return getMatricule()+"-"+getNom()+" "+getPrenom()+";"+getResteconge() + "-" + getService();
    }
}
