/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package paie.employe;

import bean.ClassMAPTable;

/**
 *
 * @author Finaritra
 */
public class LogPersonnelChoixAv extends ClassMAPTable {

    private String id, nom, prenom, matricule, statut, classee;
    private String service, direction, idcategorie, idfonction, mode_paiement;
    private int echelon, indicegrade, indice_fonctionnel, vehiculee;

    public LogPersonnelChoixAv(){
        super.setNomTable("LOG_PERSONNEL_CHOIXAV");
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

    public String getMatricule() {
        return matricule;
    }

    public void setMatricule(String matricule) {
        this.matricule = matricule;
    }

    public String getStatut() {
        return statut;
    }

    public void setStatut(String statut) {
        this.statut = statut;
    }

    public String getClassee() {
        return classee;
    }

    public void setClassee(String classee) {
        this.classee = classee;
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

    public String getIdcategorie() {
        return idcategorie;
    }

    public void setIdcategorie(String idcategorie) {
        this.idcategorie = idcategorie;
    }

    public String getIdfonction() {
        return idfonction;
    }

    public void setIdfonction(String idfonction) {
        this.idfonction = idfonction;
    }

    public int getEchelon() {
        return echelon;
    }

    public void setEchelon(int echelon) {
        this.echelon = echelon;
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

    public String getMode_paiement() {
        return mode_paiement;
    }

    public void setMode_paiement(String mode_paiement) {
        this.mode_paiement = mode_paiement;
    }

    @Override
    public String getValColLibelle() {
        return this.nom + " " + this.prenom;
    }

}

