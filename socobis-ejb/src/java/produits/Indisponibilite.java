/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package produits;

import bean.ClassMAPTable;
import java.sql.Connection;

/**
 *
 * @author MSI
 */
public class Indisponibilite extends ClassMAPTable{

    String id, idproduit, idpoint;

    public Indisponibilite(String idproduit, String idPoint){
        this.setNomTable("INDISPONIBILITE");
        this.setIdproduit(idproduit);
        this.setIdpoint(idPoint);
    }
    
    public Indisponibilite(){
        this.setNomTable("INDISPONIBILITE");
    }
    
    public void construirePK(Connection c) throws Exception {
        this.preparePk("IND", "GETSEQINDISPONIBILITE");
        this.setId(makePK(c));
    }
    
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdproduit() {
        return idproduit;
    }

    public void setIdproduit(String idproduit) {
        this.idproduit = idproduit;
    }

    public String getIdpoint() {
        return idpoint;
    }

    public void setIdpoint(String idpoint) {
        this.idpoint = idpoint;
    }
    
    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }
    
}
