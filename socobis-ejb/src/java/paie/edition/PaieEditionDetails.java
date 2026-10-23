/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package paie.edition;

import java.sql.Date;
import paie.employe.PaieInfoPersonnel;


public class PaieEditionDetails extends PaieInfoPersonnel {
    
    private String  nom , poste, matricule, numero_cnaps;
    private double salaire_de_base, taux, juillet,indemnitedepresentationbrut,indemnite_de_transport,
                    avantages_en_nature, montant_brut,cnaps,brutcnaps, imposable,irsa,
                    netaprescalcul,reductionpourpersonnesacharge,irsanet,net_a_payer;
    private int annee, mois;
    private Date dateembauche;
    private String idedition,moislib;

    public String getMoislib() {
        return moislib;
    }

    public void setMoislib(String moislib) {
        this.moislib = moislib;
    }

    public String getIdedition() {
        return idedition;
    }

    public void setIdedition(String idedition) {
        this.idedition = idedition;
    }

    public String getNumero_cnaps() {
        return numero_cnaps;
    }

    public void setNumero_cnaps(String numero_cnaps) {
        this.numero_cnaps = numero_cnaps;
    }

    public Date getDateembauche() {
        return dateembauche;
    }

    public void setDateembauche(Date dateembauche) {
        this.dateembauche = dateembauche;
    }
    
    

    public String getMatricule() {
        return matricule;
    }

    public void setMatricule(String matricule) {
        this.matricule = matricule;
    }

    
    
    public int getAnnee() {
        return annee;
    }

    public void setAnnee(int annee) {
        this.annee = annee;
    }

    public int getMois() {
        return mois;
    }

    public void setMois(int mois) {
        this.mois = mois;
    }
    
    

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public String getPoste() {
        return poste;
    }

    public void setPoste(String poste) {
        this.poste = poste;
    }

    public double getSalaire_de_base() {
        return salaire_de_base;
    }

    public void setSalaire_de_base(double salaire_de_base) {
        this.salaire_de_base = salaire_de_base;
    }

    public double getTaux() {
        return taux;
    }

    public void setTaux(double taux) {
        this.taux = taux;
    }

    public double getJuillet() {
        return juillet;
    }

    public void setJuillet(double juillet) {
        this.juillet = juillet;
    }

    public double getIndemnitedepresentationbrut() {
        return indemnitedepresentationbrut;
    }

    public void setIndemnitedepresentationbrut(double indemnitedepresentationbrut) {
        this.indemnitedepresentationbrut = indemnitedepresentationbrut;
    }

    public double getIndemnite_de_transport() {
        return indemnite_de_transport;
    }

    public void setIndemnite_de_transport(double indemnite_de_transport) {
        this.indemnite_de_transport = indemnite_de_transport;
    }

    public double getAvantages_en_nature() {
        return avantages_en_nature;
    }

    public void setAvantages_en_nature(double avantages_en_nature) {
        this.avantages_en_nature = avantages_en_nature;
    }

    public double getMontant_brut() {
        return montant_brut;
    }

    public void setMontant_brut(double montant_brut) {
        this.montant_brut = montant_brut;
    }

    public double getCnaps() {
        return cnaps;
    }

    public void setCnaps(double cnaps) {
        this.cnaps = cnaps;
    }

    public double getBrutcnaps() {
        return brutcnaps;
    }

    public void setBrutcnaps(double brutcnaps) {
        this.brutcnaps = brutcnaps;
    }

    public double getImposable() {
        return imposable;
    }

    public void setImposable(double imposable) {
        this.imposable = imposable;
    }

    public double getIrsa() {
        return irsa;
    }

    public void setIrsa(double irsa) {
        this.irsa = irsa;
    }

    public double getNetaprescalcul() {
        return netaprescalcul;
    }

    public void setNetaprescalcul(double netaprescalcul) {
        this.netaprescalcul = netaprescalcul;
    }

    public double getReductionpourpersonnesacharge() {
        return reductionpourpersonnesacharge;
    }

    public void setReductionpourpersonnesacharge(double reductionpourpersonnesacharge) {
        this.reductionpourpersonnesacharge = reductionpourpersonnesacharge;
    }

    public double getIrsanet() {
        return irsanet;
    }

    public void setIrsanet(double irsanet) {
        this.irsanet = irsanet;
    }

    public double getNet_a_payer() {
        return net_a_payer;
    }

    public void setNet_a_payer(double net_a_payer) {
        this.net_a_payer = net_a_payer;
    }
    
    
                    
    
}
