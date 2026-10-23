/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package paie.employe;

import bean.CGenUtil;
import utilitaire.UtilDB;

import java.sql.Connection;

/**
 *
 * @author hp
 */
public class EmployeComplet2 extends EmployeComplet {

//    VEHICULEE_STR
    private String vehiculee_str;
    private String temporaire_lib;
    private String motif_debauche;
    private String type_debauche;
    private double salairebase;
    private String idremplacentslibelle, categoriePaieLib;
       
    
    public EmployeComplet2 intialize(String idpersonnel,Connection c) throws Exception{
        boolean isnewConnection=false;
        try {  
            if(c==null){          
                c = new UtilDB().GetConn();
                isnewConnection=true;
            }
            String apresWhere="and id='"+idpersonnel+"'";
            EmployeComplet2 [] lretour = (EmployeComplet2[]) CGenUtil.rechercher(this, null, null, c, apresWhere);
            if(lretour.length>0){
                return lretour[0];
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            throw ex;
        }finally{
            if (c!=null && isnewConnection) {
                c.close();
            }
        }
        return null;
    }

    public EmployeComplet2 getPersonnelByMatricule(String matricule)
            throws Exception
    {
        boolean isOpen = false;
        Connection con = null;
        try {
            if (con == null) {
                con = new UtilDB().GetConn();
                isOpen = true;
            }

            String apresWhere = " AND matricule = '" + matricule + "'";
            EmployeComplet2[] employees = (EmployeComplet2[]) CGenUtil.rechercher(this, null, null, con, apresWhere);

            if (employees.length > 0) {
                return  employees[0];
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (isOpen && con != null) {
                con.close();
            }
        }
        return null;
    }

    public double getSalairebase() {
        return salairebase;
    }

    public void setSalairebase(double salairebase) {
        this.salairebase = salairebase;
    }

    public String getType_debauche() {
        return type_debauche;
    }

    public void setType_debauche(String type_debauche) {
        this.type_debauche = type_debauche;
    }
    
    

    public String getMotif_debauche() {
        return motif_debauche;
    }

    public void setMotif_debauche(String motif_debauche) {
        this.motif_debauche = motif_debauche;
    }
    
    public EmployeComplet2() {
        this.setNomTable("EMPLOYE_COMPLET_LIBELLE2");
    }

    /**
     * @return the vehiculee_str
     */
    public String getVehiculee_str() {
        return vehiculee_str;
    }

    /**
     * @param vehiculee_str the vehiculee_str to set
     */
    public void setVehiculee_str(String vehiculee_str) {
        this.vehiculee_str = vehiculee_str;
    }

    public String getTemporaire_lib() {
        return temporaire_lib;
    }

    public void setTemporaire_lib(String temporaire_lib) {
        this.temporaire_lib = temporaire_lib;
    }
    
    public String getIdremplacentslibelle() {
        return idremplacentslibelle;
    }

    public void setIdremplacentslibelle(String idremplacentslibelle) {
        this.idremplacentslibelle = idremplacentslibelle;
    }
    
    @Override
    public String getValColLibelle() {
        return idremplacentslibelle; //To change body of generated methods, choose Tools | Templates.
    }


    public String getCategoriePaieLib() {
        return categoriePaieLib;
    }

    public void setCategoriePaieLib(String categoriePaieLib) {
        this.categoriePaieLib = categoriePaieLib;
    }
}
