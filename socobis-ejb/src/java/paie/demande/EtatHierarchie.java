/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package paie.demande;

import bean.TypeObjet;
import java.sql.Connection;

/**
 *
 * @author Jacques
 */
public class EtatHierarchie extends TypeObjet{
    String id,idRole;
    int etatVisa,etatAnnule;
    
    public EtatHierarchie() {
        setNomTable("etathierarchie");
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public void construirePK(Connection c) throws Exception{
        super.setNomTable("etathierarchie");
        this.preparePk("ED","get_seq_etathierarchie");
        this.setId(makePK(c));
    }
    
    @Override
    public String getTuppleID() {
        return id ;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    public String getIdRole() {
        return idRole;
    }

    public void setIdRole(String idRole) {
        this.idRole = idRole;
    }

    public int getEtatVisa() {
        return etatVisa;
    }

    public void setEtatVisa(int etatVisa) {
        this.etatVisa = etatVisa;
    }

    public int getEtatAnnule() {
        return etatAnnule;
    }

    public void setEtatAnnule(int etatAnnule) {
        this.etatAnnule = etatAnnule;
    }
    
}
