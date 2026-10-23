/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package paie.irsa;

import bean.CGenUtil;
import java.sql.Connection;
import paie.edition.PaieEditionDetails;
import utilitaire.UtilDB;

/**
 *
 * @author Tsiky
 */
public class EtatIrsa extends PaieEditionDetails{
    private String mois_lib;
    private double indemnite; 
    private double cnaps;    
    private double net_a_payer;    
    
    public EtatIrsa() {
         super.setNomTable("etat_irsa");
    }

    
    public String getMois_lib() {
        return mois_lib;
    }

    public void setMois_lib(String mois_lib) {
        this.mois_lib = mois_lib;
    }
    
    public double getNet_a_payer() {
        return net_a_payer;
    }

    public void setNet_a_payer(double net_a_payer) {
        this.net_a_payer = net_a_payer;
    }

    
    public double getCnaps() {
        return cnaps;
    }

    public void setCnaps(double cnaps) {
        this.cnaps = cnaps;
    }

    public double getIndemnite() {
        return indemnite;
    }

    public void setIndemnite(double indemnite) {
        this.indemnite = indemnite;
    }
    
    public static EtatIrsa[] getRecap(String mois_infrap,String annee_infrap)throws Exception {
        Connection c = null;
        EtatIrsa[] tab = null;
        try {
            c = new UtilDB().GetConn();      
            String reqf = " select * from etat_irsa where mois="+mois_infrap +" and annee="+annee_infrap +" order by matricule asc";
            tab = (EtatIrsa[]) CGenUtil.rechercher(new EtatIrsa(), reqf, c);
            System.out.println("tab = " + tab.length);
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }finally{
            if(c!=null)c.close();
        }
        return tab;
    }
}
