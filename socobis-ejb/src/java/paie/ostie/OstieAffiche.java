/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package paie.ostie;
import bean.ClassMAPTable;
import java.sql.Date;
/**
 *
 * @author Tsiky
 */
public class OstieAffiche extends ClassMAPTable {

    private double mois1, mois2, mois3, salaires_non_plafonnes,
            salaires_plafonnes, employeur, travailleur, total;
    private String matricule, nom, prenoms, sexe,
            fonction, cnaps, cin, direction;
    private Date dateembauche, date_depart, date_naissance;
    private int numero, annee;

    @Override
    public String getTuppleID() {
        return matricule;
    }

    @Override
    public String getAttributIDName() {
        return "matricule";
    }

    public int getNumero() {
        return numero;
    }

    public void setNumero(int numero) {
        this.numero = numero;
    }

    public double getMois1() {
        return mois1;
    }

    public void setMois1(double mois1) {
        this.mois1 = mois1;
    }

    public double getMois2() {
        return mois2;
    }

    public void setMois2(double mois2) {
        this.mois2 = mois2;
    }

    public double getMois3() {
        return mois3;
    }

    public void setMois3(double mois3) {
        this.mois3 = mois3;
    }

    public double getSalaires_non_plafonnes() {
        return salaires_non_plafonnes;
    }

    public void setSalaires_non_plafonnes(double salaires_non_plafonnes) {
        this.salaires_non_plafonnes = salaires_non_plafonnes;
    }

    public double getSalaires_plafonnes() {
        return salaires_plafonnes;
    }

    public void setSalaires_plafonnes(double salaires_plafonnes) {
        this.salaires_plafonnes = salaires_plafonnes;
    }

    public double getEmployeur() {
        return employeur;
    }

    public void setEmployeur(double employeur) {
        this.employeur = employeur;
    }

    public double getTravailleur() {
        return travailleur;
    }

    public void setTravailleur(double travailleur) {
        this.travailleur = travailleur;
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

    public String getPrenoms() {
        return prenoms;
    }

    public void setPrenoms(String prenoms) {
        this.prenoms = prenoms;
    }

    public String getSexe() {
        return sexe;
    }

    public void setSexe(String sexe) {
        this.sexe = sexe;
    }

    public Date getDate_naissance() {
        return date_naissance;
    }

    public void setDate_naissance(Date date_naissance) {
        this.date_naissance = date_naissance;
    }

    public Date getDateembauche() {
        return dateembauche;
    }

    public void setDateembauche(Date dateembauche) {
        this.dateembauche = dateembauche;
    }

    public Date getDate_depart() {
        return date_depart;
    }

    public void setDate_depart(Date date_depart) {
        this.date_depart = date_depart;
    }

    public String getFonction() {
        return fonction;
    }

    public void setFonction(String fonction) {
        this.fonction = fonction;
    }

    public String getCnaps() {
        return cnaps;
    }

    public void setCnaps(String cnaps) {
        this.cnaps = cnaps;
    }

    public String getCin() {
        return cin;
    }

    public void setCin(String cin) {
        this.cin = cin;
    }

    public String getDirection() {
        return direction;
    }

    public void setDirection(String direction) {
        this.direction = direction;
    }

    public int getAnnee() {
        return annee;
    }

    public void setAnnee(int annee) {
        this.annee = annee;
    }

    public double getTotal() {
        return total;
    }

    public void setTotal(double total) {
        this.total = total;
    }

}
