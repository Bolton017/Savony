/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package paie.cnaps;

import bean.ClassMAPTable;
//import com.sun.imageio.plugins.jpeg.JPEG;
import java.sql.Date;

/**
 *
 * @author tsikyrami
 */
public class CnapsAfficheBis extends ClassMAPTable {

    private String idpersonnel,matricule,personnel, numero_cnaps, direction;
    private double mois1,cnaps_travailleur1,cnaps_employeur1, mois2,cnaps_travailleur2,cnaps_employeur2, mois3,cnaps_travailleur3,cnaps_employeur3, cotisation_travailleur, cotisation_employeur;
    private int annee;
    
    public CnapsAfficheBis() {
        setNomTable("cnaps_t1");
    }
    
    
    public String getIdpersonnel() {
        return idpersonnel;
    }

    public void setIdpersonnel(String idpersonnel) {
        this.idpersonnel = idpersonnel;
    }

    public String getMatricule() {
        return matricule;
    }

    public void setMatricule(String matricule) {
        this.matricule = matricule;
    }

    public String getPersonnel() {
        return personnel;
    }

    public void setPersonnel(String personnel) {
        this.personnel = personnel;
    }

    public String getNumero_cnaps() {
        return numero_cnaps;
    }

    public void setNumero_cnaps(String numero_cnaps) {
        this.numero_cnaps = numero_cnaps;
    }

    public String getDirection() {
        return direction;
    }

    public void setDirection(String direction) {
        this.direction = direction;
    }

    public double getMois1() {
        return mois1;
    }

    public void setMois1(double mois1) {
        this.mois1 = mois1;
    }

    public double getCnaps_travailleur1() {
        return cnaps_travailleur1;
    }

    public void setCnaps_travailleur1(double cnaps_travailleur1) {
        this.cnaps_travailleur1 = cnaps_travailleur1;
    }

    public double getCnaps_employeur1() {
        return cnaps_employeur1;
    }

    public void setCnaps_employeur1(double cnaps_employeur1) {
        this.cnaps_employeur1 = cnaps_employeur1;
    }

    public double getMois2() {
        return mois2;
    }

    public void setMois2(double mois2) {
        this.mois2 = mois2;
    }

    public double getCnaps_travailleur2() {
        return cnaps_travailleur2;
    }

    public void setCnaps_travailleur2(double cnaps_travailleur2) {
        this.cnaps_travailleur2 = cnaps_travailleur2;
    }

    public double getCnaps_employeur2() {
        return cnaps_employeur2;
    }

    public void setCnaps_employeur2(double cnaps_employeur2) {
        this.cnaps_employeur2 = cnaps_employeur2;
    }

    public double getMois3() {
        return mois3;
    }

    public void setMois3(double mois3) {
        this.mois3 = mois3;
    }

    public double getCnaps_travailleur3() {
        return cnaps_travailleur3;
    }

    public void setCnaps_travailleur3(double cnaps_travailleur3) {
        this.cnaps_travailleur3 = cnaps_travailleur3;
    }

    public double getCnaps_employeur3() {
        return cnaps_employeur3;
    }

    public void setCnaps_employeur3(double cnaps_employeur3) {
        this.cnaps_employeur3 = cnaps_employeur3;
    }

    public double getCotisation_travailleur() {
        return cotisation_travailleur;
    }

    public void setCotisation_travailleur(double cotisation_travailleur) {
        this.cotisation_travailleur = cotisation_travailleur;
    }

    public double getCotisation_employeur() {
        return cotisation_employeur;
    }

    public void setCotisation_employeur(double cotisation_employeur) {
        this.cotisation_employeur = cotisation_employeur;
    }

    public int getAnnee() {
        return annee;
    }

    public void setAnnee(int annee) {
        this.annee = annee;
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
