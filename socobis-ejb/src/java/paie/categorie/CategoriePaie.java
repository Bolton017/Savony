/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package paie.categorie;

import bean.TypeObjet;

import java.sql.Connection;

/**
 *
 * @author rasol
 */
public class CategoriePaie extends TypeObjet{
    private double montant;
    private String remarque;
    private String droit_heure_sup;
    private double essaie;
    
    @Override
    public String getValColLibelle(){
        return this.getVal();
    }
    public CategoriePaie() {
        this.setNomTable("categorie_paie");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("CP", "get_seq_categorie_paie");
        this.setId(makePK(c));
    }

    public String getDroit_heure_sup() {
        return droit_heure_sup;
    }

    public void setDroit_heure_sup(String droit_heure_sup) {
        this.droit_heure_sup = droit_heure_sup;
    }

    public double getEssaie() {
        return essaie;
    }

    public void setEssaie(double essaie) {
        this.essaie = essaie;
    }

    public double getMontant() {
        return montant;
    }

    public void setMontant(double montant) {
        this.montant = montant;
    }

    public String getRemarque() {
        return remarque;
    }

    public void setRemarque(String remarque) {
        this.remarque = remarque;
    }

}
