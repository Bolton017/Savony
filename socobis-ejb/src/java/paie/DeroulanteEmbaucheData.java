/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package paie;

import bean.CGenUtil;
import bean.TypeObjet;
import utilitaire.UtilDB;

import java.sql.Connection;

/**
 *
 * @author MEVA
 */
public class DeroulanteEmbaucheData {
    private TypeObjet[] sexe;
    private TypeObjet[] situation_matrimoniale;
    private TypeObjet[] log_direction;
    private TypeObjet[] paie_modepaiement;
    private TypeObjet[] paie_statut;
    private TypeObjet[] droit_hs;
    private TypeObjet[] type_contrat;
    private TypeObjet[] mode_paiement;
    private TypeObjet[] formation;
    private TypeObjet[] personnel_etat;

    public DeroulanteEmbaucheData() throws Exception {
        int verif = 0;
        Connection c = null;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                c.setAutoCommit(false);
                verif = 1;
            }
            TypeObjet sex = new TypeObjet();
            sex.setNomTable("sexe");
            sexe=(TypeObjet[])CGenUtil.rechercher(sex, null, null, c, "");
            
            sex.setNomTable("situation_matrimoniale");
            situation_matrimoniale=(TypeObjet[])CGenUtil.rechercher(sex, null, null, c, "");
            
            sex.setNomTable("log_direction");
            log_direction=(TypeObjet[])CGenUtil.rechercher(sex, null, null, c, " order by val asc");
            
            sex.setNomTable("paie_modepaiement");
            paie_modepaiement=(TypeObjet[])CGenUtil.rechercher(sex, null, null, c, "");
            
            sex.setNomTable("paie_statut");
            paie_statut=(TypeObjet[])CGenUtil.rechercher(sex, null, null, c, "");
            
            droit_hs=new TypeObjet[2];
            droit_hs[0]=new TypeObjet("o", "Oui", "Oui");
            droit_hs[1]=new TypeObjet("n", "Non", "Non");
            
            sex.setNomTable("type_contrat");
            type_contrat=(TypeObjet[])CGenUtil.rechercher(sex, null, null, c, "");
            
            sex.setNomTable("modepaiement");
            mode_paiement=(TypeObjet[])CGenUtil.rechercher(sex, null, null, c, "");
            
            sex.setNomTable("formation_diplome");
            formation=(TypeObjet[])CGenUtil.rechercher(sex, null, null, c, "");
            
            personnel_etat=new TypeObjet[2];
            personnel_etat[0]=new TypeObjet("0", "Non", "Non");
            personnel_etat[1]=new TypeObjet("1", "Oui", "Oui");
            
        } catch (Exception ex) {
            throw ex;
        } finally {
            if (c != null && verif == 1) {
                c.close();
            }
        }
    }

    public TypeObjet[] getPersonnel_etat() {
        return personnel_etat;
    }

    public void setPersonnel_etat(TypeObjet[] personnel_etat) {
        this.personnel_etat = personnel_etat;
    }

    public TypeObjet[] getFormation() {
        return formation;
    }

    public TypeObjet[] getMode_paiement() {
        return mode_paiement;
    }

    public TypeObjet[] getSexe() {
        return sexe;
    }

    public TypeObjet[] getSituation_matrimoniale() {
        return situation_matrimoniale;
    }

    public TypeObjet[] getLog_direction() {
        return log_direction;
    }

    public TypeObjet[] getPaie_modepaiement() {
        return paie_modepaiement;
    }

    public TypeObjet[] getPaie_statut() {
        return paie_statut;
    }

    public TypeObjet[] getDroit_hs() {
        return droit_hs;
    }

    public TypeObjet[] getType_contrat() {
        return type_contrat;
    }
    
            
}
