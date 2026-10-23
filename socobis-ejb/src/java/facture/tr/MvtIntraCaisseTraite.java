/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package facture.tr;

import java.sql.Date;

/**
 *
 * @author je sais pas
 */
public class MvtIntraCaisseTraite extends MvttIntraCaisse{
    private Date datetraite; 
    private Date dateecheance;
    private double montanttraite;
    private String finaledestinationlib;
    private String reference;
    private String tiers;
    private String codeclient;
    private String facture;

    public String getFacture() {
        return facture;
    }

    public void setFacture(String facture) {
        this.facture = facture;
    }

    public String getCodeclient() {
        return codeclient;
    }

    public void setCodeclient(String codeclient) {
        this.codeclient = codeclient;
    }

    public String getTiers() {
        return tiers;
    }

    public void setTiers(String tiers) {
        this.tiers = tiers;
    }

    public String getReference() {
        return reference;
    }

    public void setReference(String reference) {
        this.reference = reference;
    }

    public void setDatetraite (Date datetraite){
        this.datetraite = datetraite;
    }

    public void setDateecheance (Date echeance){
        this.dateecheance = echeance;
    }

    public void setMontanttraite (double montanttraite){
        this.montanttraite = montanttraite;
    }

    public Date getDateecheance (){
        return this.dateecheance;
    }

    public Date getDatetraite (){
        return this.datetraite;
    }

    public double getMontanttraite (){
        return this.montanttraite;
    }

    public MvtIntraCaisseTraite(){
        super.setNomTable("mvtintracaissetraite");
    }

    public String getFinaledestinationlib() {
        return finaledestinationlib;
    }

    public void setFinaledestinationlib(String finaledestinationlib) {
        this.finaledestinationlib = finaledestinationlib;
    }

}
