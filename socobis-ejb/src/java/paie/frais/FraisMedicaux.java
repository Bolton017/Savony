/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package paie.frais;

import bean.CGenUtil;
import bean.ClassMAPTable;
import java.sql.Connection;
import java.sql.Date;

/**
 *
 * @author Tsiky
 */
public class FraisMedicaux extends ClassMAPTable {

    private String id, matricule, nom, poste;
    private Date dateembauche;
    private String numero_cnaps;
     double total_brut,frais_medicaux ;
    private int mois;
    private String moislib,annee;

    public FraisMedicaux(String id, String matricule, String nom, String poste, Date dateembauche, String numero_cnaps, double total_brut, double frais_medicaux, int mois, String annee) {
        this.id = id;
        this.matricule = matricule;
        this.nom = nom;
        this.poste = poste;
        this.dateembauche = dateembauche;
        this.numero_cnaps = numero_cnaps;
        this.total_brut = total_brut;
        this.frais_medicaux = frais_medicaux;
        this.mois = mois;
        this.annee = annee;
    }
    
    
    public FraisMedicaux() {
        this.setNomTable("frais_medicaux_all");
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
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

    public String getPoste() {
        return poste;
    }

    public void setPoste(String poste) {
        this.poste = poste;
    }

    public Date getDateembauche() {
        return dateembauche;
    }

    public void setDateembauche(Date dateembauche) {
        this.dateembauche = dateembauche;
    }

    public String getNumero_cnaps() {
        return numero_cnaps;
    }

    public void setNumero_cnaps(String numero_cnaps) {
        this.numero_cnaps = numero_cnaps;
    }

    public double getTotal_brut() {
        return total_brut;
    }

    public void setTotal_brut(double total_brut) {
        this.total_brut = total_brut;
    }

    public double getFrais_medicaux() {
        return frais_medicaux;
    }

    public void setFrais_medicaux(double frais_medicaux) {
        this.frais_medicaux = frais_medicaux;
    }

    public int getMois() {
        return mois;
    }

    public void setMois(int mois) {
        this.mois = mois;
    }

    public String getAnnee() {
        return annee;
    }

    public void setAnnee(String annee) {
        this.annee = annee;
    }

    public String getMoislib() {
        return moislib;
    }

    public void setMoislib(String moislib) {
        this.moislib = moislib;
    }
    

    @Override
    public String getTuppleID() {
        return id; 
    }

    @Override
    public String getAttributIDName() {
        return "id";
    } 
    
    public static String convertirEnMois(int mois) {
        String[] moisNoms = {"Janvier", "F�vrier", "Mars", "Avril", "Mai", "Juin","Juillet", "Ao�t", "Septembre", "Octobre", "Novembre", "D�cembre", "13eme Mois","13eme Mois BIS"};
        return moisNoms[mois - 1];
    }
    
    public static String convertirEnNumeroMois(String mois) {
        String[] moisNoms = {"Janvier", "F�vrier", "Mars", "Avril", "Mai", "Juin","Juillet", "Ao�t", "Septembre", "Octobre", "Novembre", "D�cembre", "13eme Mois","13eme Mois BIS"};
 
        for (int i = 0; i < moisNoms.length; i++) {
            if (moisNoms[i].equalsIgnoreCase(mois)) return String.valueOf(i + 1);
        }
        return "Mois invalide"; // Message en cas d'entr�e incorrecte
    }

}
