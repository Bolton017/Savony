/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package produits;

import bean.ClassMAPTable;

/**
 *
 * @author Joe
 */
public class RecetteAtelier extends Recette {
    private String atelier;

    public String getAtelier() {
        return atelier;
    }

    public void setAtelier(String atelier) {
        this.atelier = atelier;
    }

    public  RecetteAtelier() {
        this.setNomTable("AS_RECOFFVUESTFAB");
    }
}
