/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package mg.cnaps.paie;

import bean.ClassMAPTable;

/**
 *
 * @author Rado
 */
public class EcritureDeLaPaieRegr extends ClassMAPTable  {

    String idelementpaie;
    int mois;
    int annee;
    double gain;
    double retenue;
    String idedition;
    String comptegen_debit;
    String comptegen_credit;
    String typerubrique;
    String iddirection;
    String comptelibelle ;
    String imposable;

    public String getIdelementpaie() {
        return idelementpaie;
    }

    public void setIdelementpaie(String idelementpaie) {
        this.idelementpaie = idelementpaie;
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

    public double getGain() {
        return gain;
    }

    public void setGain(double gain) {
        this.gain = gain;
    }

    public double getRetenue() {
        return retenue;
    }

    public void setRetenue(double retenue) {
        this.retenue = retenue;
    }

    public String getIdedition() {
        return idedition;
    }

    public void setIdedition(String idedition) {
        this.idedition = idedition;
    }

    public String getComptegen_debit() {
        return comptegen_debit;
    }

    public void setComptegen_debit(String comptegen_debit) {
        this.comptegen_debit = comptegen_debit;
    }

    public String getComptegen_credit() {
        return comptegen_credit;
    }

    public void setComptegen_credit(String comptegen_credit) {
        this.comptegen_credit = comptegen_credit;
    }

    public String getTyperubrique() {
        return typerubrique;
    }

    public void setTyperubrique(String typerubrique) {
        this.typerubrique = typerubrique;
    }

    public String getIddirection() {
        return iddirection;
    }

    public void setIddirection(String iddirection) {
        this.iddirection = iddirection;
    }

    public String getComptelibelle() {
        return comptelibelle;
    }

    public void setComptelibelle(String comptelibelle) {
        this.comptelibelle = comptelibelle;
    }

    public String getImposable() {
        return imposable;
    }

    public void setImposable(String imposable) {
        this.imposable = imposable;
    }
    
    public EcritureDeLaPaieRegr(){
        setNomTable("ecriture_dela_paie_regr");
    }

    @Override
    public String getTuppleID() {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public String getAttributIDName() {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    
}
