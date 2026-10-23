/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package annexe;

import bean.ClassMAPTable;
import java.sql.Connection;
import java.sql.Date;

/**
 *
 * @author Estcepoire
 */
public class GenererEtat extends ClassMAPTable {
    String id;
    int exercice;  
    int etat;
    String typeCompte;
    String typeEtat;
    int moisDebut;
    int moisFin;
    String duCompte;
    String auCompte;

    public String getId()  {
        return id;
    }
    public void setId(String id) {
        this.id = id;
    }
    
    public int getExercice() {
        return exercice;
    }
    public void setExercice(int exercice) {
        this.exercice = exercice;
    }
    public int getEtat() {
        return etat;
    }
    public void setEtat(int etat) {
        this.etat = etat;
    }
    public String getTypeCompte() {
        return typeCompte;
    }
    public void setTypeCompte(String typeCompte) {
        this.typeCompte = typeCompte;
    }
    public String getTypeEtat() {
        return typeEtat;
    }
    public void setTypeEtat(String typeEtat) {
        this.typeEtat = typeEtat;
    }
    public int getMoisDebut() {
        return moisDebut;
    }
    public void setMoisDebut(int moisDebut) {
        this.moisDebut = moisDebut;
    }
    public int getMoisFin() {
        return moisFin;
    }
    public void setMoisFin(int moisFin) {
        this.moisFin = moisFin;
    }
    public String getDuCompte() {
        return duCompte;
    }
    public void setDuCompte(String duCompte) {
        this.duCompte = duCompte;
    }
    public String getAuCompte() {
        return auCompte;
    }
    public void setAuCompte(String auCompte) {
        this.auCompte = auCompte;
    }
     
    
    public GenererEtat() {
        this.setNomTable("GENERERETAT");
    } 

    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }
    
}
