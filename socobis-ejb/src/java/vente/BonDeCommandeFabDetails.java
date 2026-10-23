/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package vente;

import bean.ClassMAPTable;

/**
 *
 * @author maroussia
 */
public class BonDeCommandeFabDetails extends ClassMAPTable {
    String idIngredients,libelleextacte,idbc,idFabrication;
    double qte;

    public String getIdIngredients() {
        return idIngredients;
    }

    public void setIdIngredients(String idIngredients) {
        this.idIngredients = idIngredients;
    }

    public String getLibelleextacte() {
        return libelleextacte;
    }

    public void setLibelleextacte(String libelleextacte) {
        this.libelleextacte = libelleextacte;
    }

    public BonDeCommandeFabDetails() {
        setNomTable("BONCOMMANDEFABDETAILS");
    }



    public String getIdbc() {
        return idbc;
    }

    public void setIdbc(String idbc) {
        this.idbc = idbc;
    }

    public double getQte() {
        return qte;
    }

    public void setQte(double qte) throws Exception {
        if (this.getMode().equals("modif") && qte <= 0) {
            throw new Exception("Qte ne peut pas &ecirc;tre inf&eacute;rieur &agrave; 0");
        }
        this.qte = qte;
    }
    
    @Override
    public String getTuppleID() {
        return idIngredients;
    }

    @Override
    public String getAttributIDName() {
        return "idIngredients";
    }

    public String getIdFabrication() {
        return idFabrication;
    }

    public void setIdFabrication(String idFabrication) {
        this.idFabrication = idFabrication;
    }
}
