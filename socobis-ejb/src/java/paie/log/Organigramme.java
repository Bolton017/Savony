/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package paie.log;

import bean.CGenUtil;
import bean.ClassMAPTable;

import java.sql.Connection;

/**
 *
 * @author Axel
 */
public class Organigramme extends ClassMAPTable {
    
    private String val , desce ,id;
    private int rang;
    private String matricule;
    private String nompersonne;
    private String poste;

    public Organigramme() {
        setNomTable( "organigramme" );
    }
    
    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    public String getVal() {
        return val;
    }

    public void setVal(String val) {
        this.val = val;
    }

    public String getPoste() {
        return poste;
    }

    public void setPoste(String poste) {
        this.poste = poste;
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

    public int getRang() {
        return rang;
    }

    public void setRang(int rang) {
        this.rang = rang;
    }
    @Override
    public void construirePK(Connection c) throws Exception {
	this.preparePk("ORG", "get_seqorganigramme");
	this.setId(makePK(c));
    }

    public String getMatricule() {
        return matricule;
    }

    public void setMatricule(String matricule) {
        this.matricule = matricule;
    }

    public String getNompersonne() {
        return nompersonne;
    }

    public void setNompersonne(String nompersonne) {
        this.nompersonne = nompersonne;
    }
    
    public static Organigramme findByIdPersonne(Connection c, String idpersonne) throws Exception{
        Organigramme[] result = (Organigramme[])CGenUtil.rechercher(new Organigramme(), null, null, c, String.format(" and val = '%s' ", idpersonne));
        if(result.length > 0) return result[0];
        return null;
    }
    
    public static Organigramme findTop(Connection c) throws Exception{
        Organigramme[] result = (Organigramme[])CGenUtil.rechercher(new Organigramme(), null, null, c, " order by desce desc limit 1 offset 0 ");
        if(result.length > 0) return result[0];
        return null;
    }
    
}
