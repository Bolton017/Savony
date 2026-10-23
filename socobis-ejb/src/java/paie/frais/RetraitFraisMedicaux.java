/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package paie.frais;

import bean.CGenUtil;
import bean.ClassEtat;
import utilitaire.Utilitaire;

import java.sql.Connection;
import java.sql.Date;

/**
 *
 * @author Andomahefa
 */
public class RetraitFraisMedicaux extends ClassEtat{
      
    private String id, idpersonnel,description,idpersonnel_lib,etatlib, matricule, idpersonnellib;
    private double montant;
    private double resteconge;
    private double reste;
    private String nom, prenom, fonction;
    private double gain, sortie,autre;
    private Date daty;

    public RetraitFraisMedicaux(String id, String idpersonnel, String description, double montant, Date daty) {
        this.id = id;
        this.idpersonnel = idpersonnel;
        this.description = description;
        this.montant = montant;
        this.daty = daty;
    }

    public double getAutre() {
        return autre;
    }

    public void setAutre(double autre) {
        this.autre = autre;
    }

    
    public double getGain() {
        return gain;
    }

    public void setGain(double gain) {
        this.gain = gain;
    }

    public double getSortie() {
        return sortie;
    }

    public void setSortie(double sortie) {
        this.sortie = sortie;
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

    public String getFonction() {
        return fonction;
    }

    public void setFonction(String fonction) {
        this.fonction = fonction;
    }

    public RetraitFraisMedicaux() {
        this.setNomTable("retrait_frais_medicaux");
    }

    public String getIdpersonnellib() {
        return idpersonnellib;
    }

    public void setIdpersonnellib(String idpersonnellib) {
        this.idpersonnellib = idpersonnellib;
    }

    public String getMatricule() {
        return matricule;
    }

    public void setMatricule(String matricule) {
        this.matricule = matricule;
    }

    public String getEtatlib() {
        return etatlib;
    }

    public void setEtatlib(String etatlib) {
        this.etatlib = etatlib;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdpersonnel() {
        return idpersonnel;
    }

    public void setIdpersonnel(String idpersonnel) {
        this.idpersonnel = idpersonnel;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public double getMontant() {
        return montant;
    }

    public void setMontant(double montant) {
        this.montant = montant;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    @Override
        public void construirePK(Connection c) throws Exception {
        this.preparePk("RFM", "get_seqretrait_frais_medicaux");
        this.setId(makePK(c));
    }

    @Override
    public String getTuppleID() {
        return id; //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public String getAttributIDName() {
        return "id"; //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public String getValColLibelle(){
        return getDescription();
    }

    public String getIdpersonnel_lib() {
        return idpersonnel_lib;
    }

    public void setIdpersonnel_lib(String idpersonnel_lib) {
        this.idpersonnel_lib = idpersonnel_lib;
    }

 //Updated upstream
    public double getResteconge() {
        return resteconge;
    }

    public void setResteconge(double resteconge) {
        this.resteconge = resteconge;
    }

    public double getReste() {
        return reste;
    }

    public void setReste(double reste) {
        this.reste = reste;
    }
    
    public void controleAction() throws Exception {
        try {
            if (this.getMontant()>this.getReste()) {
                throw new Exception("Montant demande depasse le solde");
            }

        } catch (Exception e) {
            throw e;
        }
    }
     
     @Override
    public Object validerObject(String u, Connection c) throws Exception
    {     
        RetraitFraisMedicaux[] avancement = (RetraitFraisMedicaux[]) CGenUtil.rechercher(new RetraitFraisMedicaux(), null, null, " AND ID = '" + this.getId() + "'");
        if(avancement.length==0)throw new Exception("Erreur frais medicaux intnrouvable : "+this.getId());
        if(avancement[0].getEtat()<10)throw new Exception("Erreur visa, vous devez valider avant de viser!");
        return super.validerObject(u,c);
    }
    
    
    
}
