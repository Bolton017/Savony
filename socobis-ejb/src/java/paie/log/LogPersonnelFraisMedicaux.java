/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package paie.log;

import bean.CGenUtil;
import paie.log.LogPersonnelValide;

/**
 *
 * @author Princie
 */
public class LogPersonnelFraisMedicaux extends LogPersonnelValide{
    private double reste_frais_medicaux;

    public LogPersonnelFraisMedicaux() {
        setNomTable("log_personnel_v_frais_medicaux");
    }

    
    public double getReste_frais_medicaux() {
        return reste_frais_medicaux;
    }

    public void setReste_frais_medicaux(double reste_frais_medicaux) {
        this.reste_frais_medicaux = reste_frais_medicaux;
    }
    
    @Override
    public String getValColLibelle() {
        return getNom()+" "+getPrenom()+";"+getReste_frais_medicaux();
    }
    
    public static LogPersonnelFraisMedicaux getInfoPersonnel(String matricule) throws Exception{
        LogPersonnelFraisMedicaux[] result = (LogPersonnelFraisMedicaux[])CGenUtil.rechercher(new LogPersonnelFraisMedicaux(), null, null, String.format(" and matricule = '%s' ", matricule));
        if(result.length == 0) return null;
        return result[0];
    }
}
