/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package paie.employe;

import java.sql.Date;

/**
 *
 * @author ASUS
 */
public class PaieInfoPersonnelEnfant extends PaieInfoPersonnel {

    int nbenfant;

    public int getNbenfant() {
        return nbenfant;
    }

    public void setNbenfant(int nbenfant) {
        this.nbenfant = nbenfant;
    }
    
    public PaieInfoPersonnelEnfant(String id, String matricule, String lieu_naissance_commune, String lieu_delivrance_cin, String situation_matrimonial, String initiale, Date datesaisie, String cturgence_nom_prenom, String cturgence_telephone1, String cturgence_telephone2, String cturgence_telephone3, String idconjoint, String code_agence_banque, String banque_numero_compte, String banque_compte_cle, Date dateembauche, String idfonction, String idcategorie, String mode_paiement, String classee, String indicegrade, String indicefonctionnel, String matricule_patron, String statut, String droit_hs) throws Exception {
        this.setId(id);
        this.setMatricule(matricule);
        this.setLieu_naissance_commune(lieu_naissance_commune);
        this.setLieu_delivrance_cin(lieu_delivrance_cin);
        this.setSituation_matrimonial(situation_matrimonial);
        this.setInitiale(initiale);
        this.setDatesaisie(datesaisie);
        this.setCturgence_nom_prenom(cturgence_nom_prenom);
        this.setCturgence_telephone1(cturgence_telephone1);
        this.setCturgence_telephone2(cturgence_telephone2);
        this.setCturgence_telephone3(cturgence_telephone3);
        this.setIdconjoint(idconjoint);
        this.setCode_agence_banque(code_agence_banque);
        this.setBanque_numero_compte(banque_numero_compte);
        this.setBanque_compte_cle(banque_compte_cle);
        this.setDateembauche(dateembauche);
        this.setIdfonction(idfonction);
        this.setIdcategorie(idcategorie);
        this.setMode_paiement(mode_paiement);
        this.setClassee(classee);
        this.setIndicegrade(indicegrade);
        this.setIndice_fonctionnel(indicefonctionnel);
        this.setMatricule_patron(matricule_patron);
        this.setStatut(statut);
        this.setDroit_hs(droit_hs);
        super.setNomTable("PAIE_INFO_PERSONNEL");
    }

    public PaieInfoPersonnelEnfant() {
        super.setNomTable("PAIE_INFO_PERSONNEL");
    }
}    
