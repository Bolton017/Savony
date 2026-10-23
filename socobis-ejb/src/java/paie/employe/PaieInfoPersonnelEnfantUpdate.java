/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package paie.employe;

import bean.ClassMAPTable;

/**
 *
 * @author Thunderfly
 */
public class PaieInfoPersonnelEnfantUpdate extends ClassMAPTable {
    private String id, matricule, cturgence_nom_prenom;
    private int nbenfant;

    public PaieInfoPersonnelEnfantUpdate() {
        this.setNomTable("paie_info_personnel");
    }
    
    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getMatricule() {
        return matricule;
    }

    public void setMatricule(String matricule) {
        this.matricule = matricule;
    }

    public String getCturgence_nom_prenom() {
        return cturgence_nom_prenom;
    }

    public void setCturgence_nom_prenom(String cturgence_nom_prenom) {
        this.cturgence_nom_prenom = cturgence_nom_prenom;
    }

    public int getNbenfant() {
        return nbenfant;
    }

    public void setNbenfant(int nbenfant) {
        this.nbenfant = nbenfant;
    }
    
}
