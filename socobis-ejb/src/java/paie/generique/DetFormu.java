/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package paie.generique;

import bean.AdminGen;
import bean.CGenUtil;
import bean.ClassMAPTable;
import configuration.Configuration;
import paie.employe.PaieInfoPersEltPaieComplet;
import paie.employe.PaieInfoPersonnel;

import java.sql.Connection;
import java.sql.Date;
import java.util.ArrayList;

/**
 *
 * @author tahina
 */
public class DetFormu extends ClassMAPTable {

    String id;
    double min;
    double max;
    String formule;
    double unite;
    String remarque;
    String mere;
    String formuleCondition;
    int etat;
    Date creation;
    
    
    public String getTuppleID() {
        return getId();
    }
    
    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("PRUF", "getseq_detformu");
        this.setId(makePK(c));
    }

    
    public boolean estVerifie(PaieInfoPersEltPaieComplet aCalc,ArrayList<PaieInfoPersEltPaieComplet> listeEltAInserer)throws Exception
    {
        if(aCalc.getCode_rubrique().compareToIgnoreCase(mere)==0)return true;
        return false;
    }
    
    public double calculerValeur(PaieInfoPersEltPaieComplet aCalc,ArrayList<PaieInfoPersEltPaieComplet> listeEltAInserer) throws Exception
    {
        if(estVerifie(aCalc,listeEltAInserer)==false)return 0;
        String valeurFormuleString=UtilitaireFormule.remplacerRubriqueParChiffre(aCalc,getFormule(), listeEltAInserer);
        String valeurFormuleConditionString=UtilitaireFormule.remplacerRubriqueParChiffre(aCalc,this.getFormuleCondition(), listeEltAInserer);
        double valeurFormule=UtilitaireFormule.calculerFormule(valeurFormuleString);
        boolean valeurFormuleCondition=UtilitaireFormule.evaluerCondition(valeurFormuleConditionString);
        
        if(valeurFormuleCondition==true) return valeurFormule;       
        return 0;
    }
    public void remplacerConfParValeur(Configuration[] lc) throws Exception
    {
        String[] listeRub=UtilitaireFormule.getListeRubriqueTab(formule);
        String valeur="0";
        for(String rub:listeRub)
        {
            String[]sousRub=rub.split("::");
            
            if(sousRub.length>1) // Traitement Au cas ou info vient de pers
            {                
                if(sousRub[0].compareToIgnoreCase("Conf")==0||sousRub[0].compareToIgnoreCase("Configuration")==0)
                {
                    Configuration[] lConfig=PaieInfoPersonnel.getListeConfig();
                    String[] splitPointPoint=sousRub[1].split("\\.\\.");
                    String[] attrFiltre={"id"};
                    String[] attrValeur={splitPointPoint[0]};
                    Configuration conf=(Configuration)AdminGen.findUnique(lConfig, attrFiltre, attrValeur);
                    if(conf==null) throw new Exception("Configuration inexistante");
                    System.out.println("configuration val min==>"+conf.getValmin());
                    valeur=CGenUtil.getValeurInsert(conf,"valmin").toString();
                    if(splitPointPoint.length>1&&splitPointPoint[1].compareToIgnoreCase("valmax")==0) valeur=CGenUtil.getValeurFieldByMethod(conf,"valmax").toString();
                    formule=formule.replace("["+rub+"]", valeur);
                }
            }
            
        }        
    }
    

    public String getAttributIDName() {
       return "id";
    }
    public DetFormu()
    {
        super.setNomTable("DetFormu");
    }
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public double getMin() {
        return min;
    }

    public void setMin(double min) {
        this.min = min;
    }

    public double getMax() {
        return max;
    }

    public void setMax(double max) {
        this.max = max;
    }

    public String getFormule() {
        return formule;
    }

    public void setFormule(String formule) {
        this.formule = formule;
    }

    public double getUnite() {
        return unite;
    }

    public void setUnite(double unite) {
        this.unite = unite;
    }

    public String getRemarque() {
        return remarque;
    }

    public void setRemarque(String remarque) {
        this.remarque = remarque;
    }

    public String getMere() {
        return mere;
    }

    public void setMere(String mere) {
        this.mere = mere;
    }

    public String getFormuleCondition() {
        return formuleCondition;
    }

    public void setFormuleCondition(String formuleCondition) {
        this.formuleCondition = formuleCondition;
    }
    
    public int getEtat() {
        return etat;
    }

    public void setEtat(int etat) {
        this.etat = etat;
    }

    public Date getCreation() {
        return this.creation;
    }

    public void setCreation(Date creation) {
        this.creation = creation;
    }
}
