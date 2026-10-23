/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package paie.employe;

/**
 *
 * @author Finaritra
 */

import bean.ClassMAPTable;

import java.sql.Date;

public class PersonnelValideInfoLibelle extends ClassMAPTable {
    
    private String id;
    private int sexe;
    private String personnel;
    private Date date_naissance;
    private String nationalite;
    private String adresse;
    private String numero_cin;
    private Date date_cin;
    private String banque_agence;
    private String banque_numero_compte;
    private String matricule;
    private Date dateembauche;
    private String fonction;
    private String categorie;
    private int echelon;
    private String classee;
    private String statut;
    private int indicegrade;
    private int indice_fonctionnel;
    private int vehiculee;
    private String service;
    private String direction;
    private int temporaire;
    private int etat;
    
    public PersonnelValideInfoLibelle() {
        this.setNomTable("PERSONNEL_VALIDE_INFOLIBELLE");
    }
    
    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public int getSexe() {
        return sexe;
    }

    public void setSexe(int sexe) {
        this.sexe = sexe;
    }

    public String getPersonnel() {
        return personnel;
    }

    public void setPersonnel(String personnel) {
        this.personnel = personnel;
    }

    public Date getDate_naissance() {
        return date_naissance;
    }

    public void setDate_naissance(Date date_naissance) {
        this.date_naissance = date_naissance;
    }

    public String getNationalite() {
        return nationalite;
    }

    public void setNationalite(String nationalite) {
        this.nationalite = nationalite;
    }

    public String getAdresse() {
        return adresse;
    }

    public void setAdresse(String adresse) {
        this.adresse = adresse;
    }

    public String getNumero_cin() {
        return numero_cin;
    }

    public void setNumero_cin(String numero_cin) {
        this.numero_cin = numero_cin;
    }

    public Date getDate_cin() {
        return date_cin;
    }

    public void setDate_cin(Date date_cin) {
        this.date_cin = date_cin;
    }

    public String getBanque_agence() {
        return banque_agence;
    }

    public void setBanque_agence(String banque_agence) {
        this.banque_agence = banque_agence;
    }

    public String getBanque_numero_compte() {
        return banque_numero_compte;
    }

    public void setBanque_numero_compte(String banque_numero_compte) {
        this.banque_numero_compte = banque_numero_compte;
    }

    public String getMatricule() {
        return matricule;
    }

    public void setMatricule(String matricule) {
        this.matricule = matricule;
    }

    public Date getDateembauche() {
        return dateembauche;
    }

    public void setDateembauche(Date dateembauche) {
        this.dateembauche = dateembauche;
    }

    public String getFonction() {
        return fonction;
    }

    public void setFonction(String fonction) {
        this.fonction = fonction;
    }

    public String getCategorie() {
        return categorie;
    }

    public void setCategorie(String categorie) {
        this.categorie = categorie;
    }

    public int getEchelon() {
        return echelon;
    }

    public void setEchelon(int echelon) {
        this.echelon = echelon;
    }

    public String getClassee() {
        return classee;
    }

    public void setClassee(String classee) {
        this.classee = classee;
    }

    public String getStatut() {
        return statut;
    }

    public void setStatut(String statut) {
        this.statut = statut;
    }

    public int getIndicegrade() {
        return indicegrade;
    }

    public void setIndicegrade(int indicegrade) {
        this.indicegrade = indicegrade;
    }

    public int getIndice_fonctionnel() {
        return indice_fonctionnel;
    }

    public void setIndice_fonctionnel(int indice_fonctionnel) {
        this.indice_fonctionnel = indice_fonctionnel;
    }

    public int getVehiculee() {
        return vehiculee;
    }

    public void setVehiculee(int vehiculee) {
        this.vehiculee = vehiculee;
    }

    public String getService() {
        return service;
    }

    public void setService(String service) {
        this.service = service;
    }

    public String getDirection() {
        return direction;
    }

    public void setDirection(String direction) {
        this.direction = direction;
    }

    public int getTemporaire() {
        return temporaire;
    }

    public void setTemporaire(int temporaire) {
        this.temporaire = temporaire;
    }

    public int getEtat() {
        return etat;
    }

    public void setEtat(int etat) {
        this.etat = etat;
    }
    
    
}
