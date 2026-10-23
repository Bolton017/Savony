/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package paie.employe;

/**
 *
 * @author nyamp
 */
public class PaieRubriqueLib extends PaieRubrique{
    String afficherlib;
    
    public PaieRubriqueLib(){
        this.setNomTable("PAIE_RUBRIQUE_LIBELLE");
    }

    public String getAfficherlib() {
        return afficherlib;
    }

    public void setAfficherlib(String afficherlib) {
        this.afficherlib = afficherlib;
    }
    
    
}
