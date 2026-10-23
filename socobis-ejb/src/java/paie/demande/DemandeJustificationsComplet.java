/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package paie.demande;

import java.sql.Date;

/**
 *
 * @author Tsiky
 */
public class DemandeJustificationsComplet extends DemandeJustifications {
    private String personnel,matricules;
    private String typedemandelib;
    private Date daty,datedepart,datefin,dateretour;
    
    
    public DemandeJustificationsComplet() {
        setNomTable("demande_libcomplet");
    }
    
    
    public String getMatricules() {
        return matricules;
    }

    public void setMatricules(String matricule) {
        this.matricules = matricule;
    }

    public String getPersonnel() {
        return personnel;
    }

    public void setPersonnel(String personnel) {
        this.personnel = personnel;
    }

    public String getTypedemandelib() {
        return typedemandelib;
    }

    public void setTypedemandelib(String typedemandelib) {
        this.typedemandelib = typedemandelib;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public Date getDatedepart() {
        return datedepart;
    }

    public void setDatedepart(Date datedepart) {
        this.datedepart = datedepart;
    }

    public Date getDatefin() {
        return datefin;
    }

    public void setDatefin(Date datefin) {
        this.datefin = datefin;
    }

    public Date getDateretour() {
        return dateretour;
    }

    public void setDateretour(Date dateretour) {
        this.dateretour = dateretour;
    }
    
}
