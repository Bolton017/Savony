package paie.employe;
import bean.ClassMAPTable;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author Fy
 */
public class TrsBanqueAgenceDetails extends ClassMAPTable {
    private String id;
    private String codeagence;
    private String desceagence;
    private String idbanque;
    private String codebanque;
    private String descebanque;
    public TrsBanqueAgenceDetails(){
        this.setNomTable("TRS_BANQUES_AGENCES_DETAILS");
    }
    
    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getCodeagence() {
        return codeagence;
    }

    public void setCodeagence(String codeagence) {
        this.codeagence = codeagence;
    }

    public String getDesceagence() {
        return desceagence;
    }

    public void setDesceagence(String desceagence) {
        this.desceagence = desceagence;
    }

    public String getIdbanque() {
        return idbanque;
    }

    public void setIdbanque(String idbanque) {
        this.idbanque = idbanque;
    }

    public String getCodebanque() {
        return codebanque;
    }

    public void setCodebanque(String codebanque) {
        this.codebanque = codebanque;
    }

    public String getDescebanque() {
        return descebanque;
    }

    public void setDescebanque(String descebanque) {
        this.descebanque = descebanque;
    }
    
    
}
