/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package paie.elementpaie;

/**
 *
 * @author rakotondralambokoto
 */
public class PaiePersonnelElementpaieCalcul extends PaiePersonnelElementpaie{
    private String typerubrique;
    private String imposable;
    private int afficher;
    private String nature;
    private String avantage;
    private String remarque;

    public String getRemarque() {
        return remarque;
    }

    public void setRemarque(String remarque) {
        this.remarque = remarque;
    }
    
    

    public String getAvantage() {
        return avantage;
    }

    public void setAvantage(String avantage) {
        this.avantage = avantage;
    }
    
    

    public String getNature() {
        return nature;
    }

    public void setNature(String nature) {
        this.nature = nature;
    }

    public int getAfficher() {
        return afficher;
    }

    public void setAfficher(int afficher) {
        this.afficher = afficher;
    }
 
    public PaiePersonnelElementpaieCalcul() {
        super.setNomTable("paie_personnel_elementpaie_imposable");
    }
    

    public String getTyperubrique() {
        return typerubrique;
    }

    public void setTyperubrique(String typerubrique) {
        this.typerubrique = typerubrique;
    }

    public String getImposable() {
        return imposable;
    }

    public void setImposable(String imposable) {
        this.imposable = imposable;
    }
    
    
    
}
