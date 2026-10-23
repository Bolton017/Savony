/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package proforma;
import bean.ClassMAPTable;
import java.sql.Date;

/**
 *
 * @author Tsiky
 */
public class ProformaRelance extends ClassMAPTable{
    String id,idProforma;
    Date daty;
    
    public ProformaRelance() {
        this.setNomTable("proformarelance");
    }
    
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdProforma() {
        return idProforma;
    }

    public void setIdProforma(String idProforma) {
        this.idProforma = idProforma;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    @Override
    public String getTuppleID() {
        return this.id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

}
