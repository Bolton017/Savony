/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package paie.employe;

/**
 *
 * @author Princie
 */
public class PersonneGainSortieReste extends PaieInfoPersonnel{
    private double gain;
    private double montant;
    private double reste;

    public PersonneGainSortieReste() {
        super.setNomTable("personne_gain_sortie_reste");
    }
    
    public double getGain() {
        return gain;
    }

    public void setGain(double gain) {
        this.gain = gain;
    }

    public double getMontant() {
        return montant;
    }

    public void setMontant(double montant) {
        this.montant = montant;
    }

    public double getReste() {
        return reste;
    }

    public void setReste(double reste) {
        this.reste = reste;
    }
}
