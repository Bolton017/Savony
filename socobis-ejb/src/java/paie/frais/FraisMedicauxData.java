/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package paie.frais;

import bean.CGenUtil;
import java.sql.Connection;
import paie.frais.RetraitFraisMedicaux;
import paie.employe.PersonneGainSortieReste;
import utilitaire.UtilDB;

/**
 *
 * @author Thunderfly
 */
public class FraisMedicauxData {
    private PersonneGainSortieReste [] listePers;
    private RetraitFraisMedicaux [] listeRetrait;
    
    public FraisMedicauxData(String idPersonnel) throws Exception {
        int verif = 0;
        Connection c = null;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                c.setAutoCommit(false);
                verif = 1;
            }
            PersonneGainSortieReste pers = new PersonneGainSortieReste();
            PersonneGainSortieReste [] listePers = (PersonneGainSortieReste []) CGenUtil.rechercher(pers, null, null, c, String.format(" and id='%s'", idPersonnel));
            RetraitFraisMedicaux retraitFraisMedicaux = new RetraitFraisMedicaux();
            retraitFraisMedicaux.setNomTable("retrait_frais_medicaux_lib");
            RetraitFraisMedicaux [] listeRetrait = (RetraitFraisMedicaux []) CGenUtil.rechercher(retraitFraisMedicaux, null, null, c, String.format(" and idpersonnel='%s'", idPersonnel));
            this.setListePers(listePers);
            this.setListeRetrait(listeRetrait);
        } catch (Exception ex) {
            c.rollback();
            throw ex;
        } finally {
            if (c != null && verif == 1) {
                c.close();
            }
        }
    }

    public PersonneGainSortieReste[] getListePers() {
        return listePers;
    }

    public void setListePers(PersonneGainSortieReste[] listePers) {
        this.listePers = listePers;
    }

    public RetraitFraisMedicaux[] getListeRetrait() {
        return listeRetrait;
    }

    public void setListeRetrait(RetraitFraisMedicaux[] listeRetrait) {
        this.listeRetrait = listeRetrait;
    }
    
}
