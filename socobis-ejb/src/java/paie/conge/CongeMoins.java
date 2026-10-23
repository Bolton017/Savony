/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package paie.conge;

import bean.ClassEtat;

import java.sql.Connection;

/**
 *
 * @author Fianritra
 */
public class CongeMoins extends ClassEtat {
    private String id;
    private String idpersonnel,idpersonnellib;
    private int mois,annee;
    private double conge;
    private String refdobject;
    private String iddemande;

    public String getIddemande() {
        return iddemande;
    }

    public void setIddemande(String iddemande) {
        this.iddemande = iddemande;
    }

    public String getIdpersonnellib() {
        return idpersonnellib;
    }

    public void setIdpersonnellib(String idpersonnellib) {
        this.idpersonnellib = idpersonnellib;
    }
    
    
    public CongeMoins() {
        super.setNomTable("conge_moins");
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

    public int getMois() {
        return mois;
    }

    public void setMois(int mois) {
        this.mois = mois;
    }

    public int getAnnee() {
        return annee;
    }

    public void setAnnee(int annee) {
        this.annee = annee;
    }

    public double getConge() {
        return conge;
    }

    public void setConge(double conge) {
        this.conge = conge;
    }

    public String getRefdobject() {
        return refdobject;
    }

    public void setRefdobject(String refdobject) {
        this.refdobject = refdobject;
    }
       
    @Override
    public void construirePK(Connection c) throws Exception {
	this.preparePk("CGM", "GET_SEQ_CONGEMOINS");
	this.setId(makePK(c));
    }

    @Override
    public String getTuppleID() {
        return getId();
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }
    
    
}
