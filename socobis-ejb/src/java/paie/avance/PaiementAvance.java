/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package paie.avance;

import bean.ClassEtat;
import java.sql.Connection;
import java.sql.Date;

/**
 *
 * @author Tsiky
 */
public class PaiementAvance extends ClassEtat{
    String id;
    String idavance;
    Date datepaiement;
    int mois;
    int annee;
    double montant;
    String nompersonnel;
    String matricule;
    String modepaiement;
    int debiterSalaire;
    double montantavance;


    public PaiementAvance() {
         super.setNomTable("PAIEMENTAVANCE");
    }

    @Override
    public String getTuppleID() {
        return getId(); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public String getAttributIDName() {
        return "id"; //To change body of generated methods, choose Tools | Templates.
    }


    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("AVA", "getseqpaiementavance");
        this.setId(makePK(c));
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdavance() {
        return idavance;
    }

    public void setIdavance(String idavance) {
        this.idavance = idavance;
    }

    public Date getDatepaiement() {
        return datepaiement;
    }

    public void setDatepaiement(Date datepaiement) {
        this.datepaiement = datepaiement;
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

    public double getMontant() {
        return montant;
    }

    public void setMontant(double montant) throws Exception {
        if(this.getMode().compareToIgnoreCase("modif")==0&&montant<=0) throw new Exception("PU non valide");
        this.montant = montant;
    }

    public String getNompersonnel() {
        return nompersonnel;
    }

    public void setNompersonnel(String nompersonnel) {
        this.nompersonnel = nompersonnel;
    }

    public String getMatricule() {
        return matricule;
    }

    public void setMatricule(String matricule) {
        this.matricule = matricule;
    }

    public String getModepaiement() {
        return modepaiement;
    }

    public void setModepaiement(String modepaiement) {
        this.modepaiement = modepaiement;
    }

    public int isDebiterSalaire() {
        return debiterSalaire;
    }

    public void setDebiterSalaire(int debiterSalaire) {
        this.debiterSalaire = debiterSalaire;
    }

    public double getMontantavance() {
        return montantavance;
    }

    public void setMontantavance(double montantavance) {
        this.montantavance = montantavance;
    }

    public int getDebiterSalaire() {
        return debiterSalaire;
    }
}
