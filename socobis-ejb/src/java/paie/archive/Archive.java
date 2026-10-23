/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package paie.archive;
import bean.CGenUtil;
import bean.ClassMAPTable;
import utilitaire.*;
import java.sql.Connection;
/**
 *
 * @author Tsiky
 */
public class Archive extends ClassMAPTable {
    String idpersonnel;
    double imposable;
    
    public Archive(){
        this.setNomTable("archive_final");
    }
    
    public Archive(String idpersonnel, double imposable) {
        this.idpersonnel = idpersonnel;
        this.imposable = imposable;
    }

    public String getIdpersonnel() {
        return idpersonnel;
    }

    public void setIdpersonnel(String idpersonnel) {
        this.idpersonnel = idpersonnel;
    }

    public double getImposable() {
        return imposable;
    }

    public void setImposable(double imposable) {
        this.imposable = imposable;
    }
    
    public double getImposable_12()throws Exception {
        double val = 0.0;
        this.setNomTable("archive_final");
        Archive[] arc = (Archive[]) CGenUtil.rechercher(this, null, null, " AND IDPERSONNEL = '" +  this.getIdpersonnel()+ "' ");
        if(arc.length>0) val = arc[0].getImposable();
        return val;
    }
    
    @Override
    public String getTuppleID() {
        return idpersonnel;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }


    
}
