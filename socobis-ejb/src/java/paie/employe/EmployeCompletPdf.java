/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package paie.employe;

import bean.CGenUtil;

/**
 *
 * @author Axel
 */
public class EmployeCompletPdf extends EmployeComplet {

    private double montant , conger ;
    private String code_dr ;

    private String modePaiementLib;
    private String departementLib;
    private String categoriePersonnel;
    private String situationMLib;


    public String getModePaiementLib() {
        return modePaiementLib;
    }

    public void setModePaiementLib(String modePaiementLib) {
        this.modePaiementLib = modePaiementLib;
    }

    public String getDepartementLib() {
        return departementLib;
    }

    public void setDepartementLib(String departementLib) {
        this.departementLib = departementLib;
    }

    public String getCategoriePersonnel() {
        return categoriePersonnel;
    }

    public void setCategoriePersonnel(String categoriePersonnel) {
        this.categoriePersonnel = categoriePersonnel;
    }

    public String getSituationMLib() {
        return situationMLib;
    }

    public void setSituationMLib(String situationMLib) {
        this.situationMLib = situationMLib;
    }

    public String getCode_dr() {
        return code_dr;
    }

    public void setCode_dr(String code_dr) {
        this.code_dr = code_dr;
    }
    
    
    
    
    
    public EmployeCompletPdf(){
        setNomTable("employe_complet_pdf");
    }
    
    public EmployeCompletPdf findPdf( EmployeComplet obj ) throws Exception{
        EmployeCompletPdf[] ls = null ;
        try {
            ls =(EmployeCompletPdf[]) CGenUtil.rechercher(obj, null, null, null, "  " );
            if( ls.length == 0 ){
                throw new Exception("Personnel non trouver"); 
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return ls[0] ;
    }

    
    public String check(String tmp, int l) {
        if (tmp == null || tmp.compareToIgnoreCase("") == 0) {
            String point = "";
            for (int i = 0; i < l; i++) {
                point += " . ";
            }
            return point;
        }
        return tmp;
    }

    public double getMontant() {
        return montant;
    }

    public void setMontant(double montant) {
        this.montant = montant;
    }

    
    public String getSexePdf() {
        return  getSexe().compareToIgnoreCase("0") == 0 ? "Madame" :  "Monsieur";
    }

    public String getPronompersonnelsujet() {
        return  getSexe().compareToIgnoreCase("0") == 0 ? "elle" :  "il";
    }

    public String getGenrePdf() {
        return  getSexe().compareToIgnoreCase("0") == 0 ? "Elle" :  "Il";
    }

    public double getConger() {
        return conger;
    }

    public void setConger(double conger) {
        this.conger = conger;
    }
    
    
    
}