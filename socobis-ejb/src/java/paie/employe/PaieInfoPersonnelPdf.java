/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package paie.employe;

import java.util.ArrayList;

/**
 *
 * @author tsiky
 */
public class PaieInfoPersonnelPdf {
    private String id;
    private String nom;
    private String prenom;
    private String sexe;
    private String genre;
    private String nomcomplet;
    private String matricule;
    private String date_naissance;
    private String lieu_naissance_commune;
    private String adresse;
    private String numero_cin;
    private String date_cin;
    private String dateembauche;
    private String idfonction;
    private String duree;
    private String idqualification;
    private String montant;
    private String montantlettre;
    private String idcategorie_paie;
    private String idcategorie;
    private String avenant;
    private String typecontrat;
    private String datecontrat;
    private String date_debut;
    private String idcontrat_avant;
    
    
    
    
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }
    
    public String getTypecontrat() {
        return typecontrat;
    }

    public void setTypecontrat(String typecontrat) {
        this.typecontrat = typecontrat;
    }

    public String getDatecontrat() {
        return datecontrat;
    }

    public void setDatecontrat(String datecontrat) {
        this.datecontrat = datecontrat;
    }

    /**
     * @return the nom
     */
    
    
    public String getAvenant() {
        return avenant;
    }

    public void setAvenant(String avenant) {
        this.avenant = avenant;
    }
    
    public String getNom() {
        return nom;
    }

    /**
     * @param nom the nom to set
     */
    public void setNom(String nom) {
        this.nom = nom;
    }

    /**
     * @return the prenom
     */
    public String getPrenom() {
        return prenom;
    }

    /**
     * @param prenom the prenom to set
     */
    public void setPrenom(String prenom) {
        this.prenom = prenom;
    }

    /**
     * @return the sexe
     */
    public String getSexe() {
        return sexe;
    }

    /**
     * @param sexe the sexe to set
     */
    public void setSexe(String sexe) {
        this.sexe = sexe;
    }

    /**
     * @return the genre
     */
    public String getGenre() {
        return genre;
    }

    /**
     * @param genre the genre to set
     */
    public void setGenre(String genre) {
        this.genre = genre;
    }

    /**
     * @return the nomcomplet
     */
    public String getNomcomplet() {
        return nomcomplet;
    }

    /**
     * @param nomcomplet the nomcomplet to set
     */
    public void setNomcomplet(String nomcomplet) {
        this.nomcomplet = nomcomplet;
    }

    /**
     * @return the matricule
     */
    public String getMatricule() {
        return matricule;
    }

    /**
     * @param matricule the matricule to set
     */
    public void setMatricule(String matricule) {
        this.matricule = matricule;
    }

    /**
     * @return the date_naissance
     */
    public String getDate_naissance() {
        return date_naissance;
    }

    /**
     * @param date_naissance the date_naissance to set
     */
    public void setDate_naissance(String date_naissance) {
        this.date_naissance = date_naissance;
    }

    /**
     * @return the lieu_naissance_commune
     */
    public String getLieu_naissance_commune() {
        return lieu_naissance_commune;
    }

    /**
     * @param lieu_naissance_commune the lieu_naissance_commune to set
     */
    public void setLieu_naissance_commune(String lieu_naissance_commune) {
        this.lieu_naissance_commune = lieu_naissance_commune;
    }

    /**
     * @return the adresse
     */
    public String getAdresse() {
        return adresse;
    }

    /**
     * @param adresse the adresse to set
     */
    public void setAdresse(String adresse) {
        this.adresse = adresse;
    }

    /**
     * @return the numero_cin
     */
    public String getNumero_cin() {
        return numero_cin;
    }

    /**
     * @param numero_cin the numero_cin to set
     */
    public void setNumero_cin(String numero_cin) {
        this.numero_cin = numero_cin;
    }

    /**
     * @return the date_cin
     */
    public String getDate_cin() {
        return date_cin;
    }

    /**
     * @param date_cin the date_cin to set
     */
    public void setDate_cin(String date_cin) {
        this.date_cin = date_cin;
    }

    /**
     * @return the dateembauche
     */
    public String getDateembauche() {
        return dateembauche;
    }

    /**
     * @param dateembauche the dateembauche to set
     */
    public void setDateembauche(String dateembauche) {
        this.dateembauche = dateembauche;
    }

    /**
     * @return the idfonction
     */
    public String getIdfonction() {
        return idfonction;
    }

    /**
     * @param idfonction the idfonction to set
     */
    public void setIdfonction(String idfonction) {
        this.idfonction = idfonction;
    }

    /**
     * @return the duree
     */
    public String getDuree() {
        return duree;
    }

    /**
     * @param duree the duree to set
     */
    public void setDuree(String duree) {
        this.duree = duree;
    }

    /**
     * @return the idqualification
     */
    public String getIdqualification() {
        return idqualification;
    }

    /**
     * @param idqualification the idqualification to set
     */
    public void setIdqualification(String idqualification) {
        this.idqualification = idqualification;
    }

    /**
     * @return the montant
     */
    public String getMontant() {
        return montant;
    }

    /**
     * @param montant the montant to set
     */
    public void setMontant(String montant) {
        this.montant = montant;
    }

    /**
     * @return the montantlettre
     */
    public String getMontantlettre() {
        return montantlettre;
    }

    /**
     * @param montantlettre the montantlettre to set
     */
    public void setMontantlettre(String montantlettre) {
        this.montantlettre = montantlettre;
    }

    /**
     * @return the idcategorie_paie
     */
    public String getIdcategorie_paie() {
        return idcategorie_paie;
    }

    /**
     * @param idcategorie_paie the idcategorie_paie to set
     */
    public void setIdcategorie_paie(String idcategorie_paie) {
        this.idcategorie_paie = idcategorie_paie;
    }

    /**
     * @return the idcategorie
     */
    public String getIdcategorie() {
        return idcategorie;
    }

    /**
     * @param idcategorie the idcategorie to set
     */
    public void setIdcategorie(String idcategorie) {
        this.idcategorie = idcategorie;
    }
  
    public String getDate_debut() {
        return date_debut;
    }

    public void setDate_debut(String date_debut) {
        this.date_debut = date_debut;
    }
    
    public String getIdcontrat_avant() {
        return idcontrat_avant;
    }

    public void setIdcontrat_avant(String idcontrat_avant) {
        this.idcontrat_avant = idcontrat_avant;
    }
    
}
