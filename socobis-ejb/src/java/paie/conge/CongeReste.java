/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package paie.conge;

import bean.ClassMAPTable;

/**
 *
 * @author Finaritra
 */

public class CongeReste extends ClassMAPTable {

    private String idpersonnel;
    private int annee;
    private double reste;

    public CongeReste() {
        setNomTable("conge_reste2");
    }

    public String getIdpersonnel() {
        return idpersonnel;
    }

    public void setIdpersonnel(String idpersonnel) {
        this.idpersonnel = idpersonnel;
    }

    public int getAnnee() {
        return annee;
    }

    public void setAnnee(int annee) {
        this.annee = annee;
    }

    public double getReste() {
        return reste;
    }

    public void setReste(double reste) {
        this.reste = reste;
    }

    @Override
    public String getTuppleID() {
        return idpersonnel;
    }

    @Override
    public String getAttributIDName() {
        return "idpersonnel";
    }
}

