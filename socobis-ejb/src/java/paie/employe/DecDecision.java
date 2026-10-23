/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package paie.employe;

import bean.ClassMAPTable;
import java.sql.Connection;

/**
 *
 * @author user
 */
public class DecDecision extends ClassMAPTable {
    private String id;
    private String id_dec_type;
    private String contenu;
    private String ampliation;
    
    public DecDecision()
    {
        this.setNomTable("dec_decision");;
    }
    public DecDecision(String id, String id_dec_type,String contenu,String ampliation) throws Exception
    {
        this.setId(id);
        this.setId_dec_type(id_dec_type);
        this.setContenu(contenu);
        this.setAmpliation(ampliation);
        this.setNomTable("dec_decision");;
    }
    public DecDecision(String id_dec_type,String contenu,String ampliation) throws Exception
    {
        this.setId_dec_type(id_dec_type);
        this.setContenu(contenu);
        this.setAmpliation(ampliation);
        this.setNomTable("dec_decision");;
    }
    
    /**
     * @return the id
     */
    public String getId() {
        return id;
    }

    /**
     * @param id the id to set
     */
    public void setId(String id) {
        this.id = id;
    }

    /**
     * @return the id_dec_type
     */
    public String getId_dec_type() {
        return id_dec_type;
    }

    /**
     * @param id_dec_type the id_dec_type to set
     */
    public void setId_dec_type(String id_dec_type) throws Exception {
        if (getMode().compareTo("modif") != 0) {
            this.id_dec_type = id_dec_type;
            return;
        }
        if(id_dec_type=="" || id_dec_type==null) throw new Exception("Le champ Type ne peut être vide");
        this.id_dec_type = id_dec_type;
    }

    /**
     * @return the contenu
     */
    public String getContenu() {
        return contenu;
    }

    /**
     * @param contenu the contenu to set
     */
    public void setContenu(String contenu) throws Exception
    {
	if (getMode().compareTo("modif") != 0) {
            this.contenu = contenu;
            return;
        }
        if(contenu=="" || contenu==null) throw new Exception("Le champ Contenu ne peut pas être vide");
        this.contenu = contenu;
    }

    /**
     * @return the ampliation
     */
    public String getAmpliation() {
        return ampliation;
    }

    /**
     * @param ampliation the ampliation to set
     */
    public void setAmpliation(String ampliation)  throws Exception
    {
        this.ampliation = ampliation;
    }

    @Override
    public String getTuppleID() {
      return  this.getId();
    }

    @Override
    public String getAttributIDName() {
     return "id";   
    }
    @Override
    public void construirePK(Connection c) throws Exception {
	this.preparePk("dec", "getSeqDecision");
	this.setId(makePK(c));
    }
}
