/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package paie.demande;

/**
 *
 * @author Jacques
 */
public class DemandeJustificationVise extends DemandeJustifications{
    String idEtatHierarchie,valEtatHierarchieSuivant;
    int etatVisa,etatAnnule;
 
    public DemandeJustificationVise(){
        this.setNomTable("situationdemandeconge");
    }

    public String getIdEtatHierarchie() {
        return idEtatHierarchie;
    }

    public void setIdEtatHierarchie(String idEtatHierarchie) {
        this.idEtatHierarchie = idEtatHierarchie;
    }

    public int getEtatVisa() {
        return etatVisa;
    }

    public void setEtatVisa(int etatVisa) {
        this.etatVisa = etatVisa;
    }

    public int getEtatAnnule() {
        return etatAnnule;
    }

    public String getValEtatHierarchieSuivant() {
        return valEtatHierarchieSuivant;
    }

    public void setValEtatHierarchieSuivant(String valEtatHierarchieSuivant) {
        this.valEtatHierarchieSuivant = valEtatHierarchieSuivant;
    }

    public void setEtatAnnule(int etatAnnule) {
        this.etatAnnule = etatAnnule;
    }
    
}
