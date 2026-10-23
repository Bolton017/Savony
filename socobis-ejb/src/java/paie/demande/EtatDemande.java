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
public class EtatDemande extends TypeObjet{
    String id,idTypeDemande,idEtatHierarchie;
    int rang;
    
    public EtatDemande() {
        setNomTable("etatdemande");
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdTypeDemande() {
        return idTypeDemande;
    }

    public void setIdTypeDemande(String idTypeDemande) {
        this.idTypeDemande = idTypeDemande;
    }

    public String getIdEtatHierarchie() {
        return idEtatHierarchie;
    }

    public void setIdEtatHierarchie(String idEtatHierarchie) {
        this.idEtatHierarchie = idEtatHierarchie;
    }
    public void construirePK(Connection c) throws Exception{
        super.setNomTable("etatdemande");
        this.preparePk("ED","get_seq_etatdemande");
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

    public int getRang() {
        return rang;
    }

    public void setRang(int rang) {
        this.rang = rang;
    }
}
