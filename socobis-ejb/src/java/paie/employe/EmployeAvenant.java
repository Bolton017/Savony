 /*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package paie.employe;

import bean.CGenUtil;
import bean.ClassEtat;
import java.sql.Connection;
import java.sql.Date;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import utilitaire.UtilDB;
import utilitaire.Utilitaire;
/**
 *
 * @author tsiky
 */
public class EmployeAvenant extends EmployeContratTravail {
    
    
    public EmployeAvenant() {
        super.setNomTable("paie_info_personnel_historic_avenants");
    }
    
    public ArrayList<EmployeContratTravail> getDataAvenant(String []idhisto) throws SQLException{
        EmployeContratTravail[] li = null;
        EmployeContratTravail emp = new EmployeContratTravail();
        emp.setNomTable("paie_info_personnel_historic_avenants");
        String where =this.getCondition(idhisto);
        try{
            li =(EmployeContratTravail[]) CGenUtil.rechercher(emp,null,null,where);
        }catch(Exception e){
            e.getMessage();
        }
            return new ArrayList<EmployeContratTravail>(Arrays.asList(li));       
    } 
    
    public ArrayList<PaieInfoPersonnelPdf> ToPipPdfAvenant(ArrayList<EmployeContratTravail> le){
        ArrayList<PaieInfoPersonnelPdf> data = new  ArrayList<PaieInfoPersonnelPdf>();

            for(EmployeContratTravail e:le ){
                PaieInfoPersonnelPdf de =new PaieInfoPersonnelPdf();
                de.setId(e.getId());
                de.setAvenant(e.check(e.getAvenant(), 10));
                de.setNomcomplet(e.check(e.getNom() + " " + e.getPrenom(), 20));
                de.setMatricule(e.getMatricule());
                de.setSexe(e.getSexePdf());
                de.setMontant(e.check((e.getMontant() == 0 ? "" : utilitaire.Utilitaire.formaterAr(e.getMontant())), 4));
                de.setMontantlettre(e.check((e.getMontant() == 0 ? "" : utilitaire.ChiffreLettre.convertRealToStringDevise(e.getMontant(), "Ariary")), 10));
                de.setTypecontrat(e.getTypeContrat());
                de.setDate_debut(Utilitaire.datedujourlettre( Utilitaire.datetostring(e.getDate_debut())) );
                de.setIdcontrat_avant(e.getIdcontrat_avant());
                
                
                System.out.println("Id===>"+de.getId());                
                System.out.println("Matricule===>"+de.getMatricule());
                System.out.println("Montant===>"+de.getMontant());
                System.out.println("MontantLettre===>"+de.getMontantlettre());
                System.out.println("Type contrat===>"+de.getTypecontrat());
                System.out.println("Date debut===>"+de.getDate_debut());
                System.out.println("idcontrat_avant===>"+de.getIdcontrat_avant());
                data.add(de);
            }
        return data; 
    }

/*
      
        param.put("montant", e.check((e.getMontant() == 0 ? "" : utilitaire.Utilitaire.formaterAr(e.getMontant())), 4));
        param.put("montantlettre", e.check((e.getMontant() == 0 ? "" : utilitaire.ChiffreLettre.convertRealToStringDevise(e.getMontant(), "Ariary")), 10));
  */      

}
