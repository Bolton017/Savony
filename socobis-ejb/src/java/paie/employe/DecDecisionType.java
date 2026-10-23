/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package paie.employe;

import bean.ClassMAPTable;
import java.sql.Connection;

/**
 *
 * @author RAMARONERA
 */
public class DecDecisionType extends ClassMAPTable {
    
    private String id;
    private String val;
    private String desce;
    
    
    public DecDecisionType(){
        this.setNomTable("DEC_DECISION_TYPE");
        
    }

    public String getDesce() {
        return desce;
    }

    public void setDesce(String desce) {
        this.desce = desce;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getVal() {
        return val;
    }

    public void setVal(String val) {
        this.val = val;
    }
    
    @Override
    public void construirePK(Connection c) throws Exception {
	this.preparePk("DEC", "GETSEQDECDECISIONTYPE");
	this.setId(makePK(c));
    }
    @Override
    public String getTuppleID() {
      return  this.getId();
    }

    @Override
    public String getAttributIDName() {
     return "id";   
    }
    
}
