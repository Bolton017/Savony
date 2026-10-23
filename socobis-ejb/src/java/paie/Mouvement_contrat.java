/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package paie;

import bean.CGenUtil;
import bean.ClassMAPTable;
import paie.log.LogPersonnelNonValide;
import paie.employe.PaieInfoPersonnel;

import java.sql.Connection;
import java.sql.Date;

/**
 *
 * @author rakotondralambo
 */
public class Mouvement_contrat extends ClassMAPTable{
    private String id;
    private String idpersonnel;
    private String idtype_mouvement_contrat;
    private Date daty_mouvement;
    private Date old_daty_debut;
    private Date new_daty_debut;
    private Date old_daty_fin;
    private Date new_daty_fin;
    private String old_contrat;
    private int old_nbcontrat;
    private String new_contrat;
    private int new_nbcontrat;

    public String getIdtype_mouvement_contrat() {
        return idtype_mouvement_contrat;
    }

    public void setIdtype_mouvement_contrat(String idtype_mouvement_contrat) {
        this.idtype_mouvement_contrat = idtype_mouvement_contrat;
    }



    public Date getOld_daty_debut() {
        return old_daty_debut;
    }

    public void setOld_daty_debut(Date old_daty_debut) {
        this.old_daty_debut = old_daty_debut;
    }

    public Date getNew_daty_debut() {
        return new_daty_debut;
    }

    public void setNew_daty_debut(Date new_daty_debut) {
        this.new_daty_debut = new_daty_debut;
    }

    public Date getOld_daty_fin() {
        return old_daty_fin;
    }

    public void setOld_daty_fin(Date old_daty_fin) {
        this.old_daty_fin = old_daty_fin;
    }

    public Date getNew_daty_fin() {
        return new_daty_fin;
    }

    public void setNew_daty_fin(Date new_daty_fin) {
        this.new_daty_fin = new_daty_fin;
    }


    public Mouvement_contrat() {
        super.setNomTable("");
    }

     public void construirePK(Connection c) throws Exception {
        super.setNomTable("");
	this.preparePk("MVC", "GET_SEQ_SEQ_ABSENCE");
	this.setId(makePK(c));
    }
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdpersonnel() {
        return idpersonnel;
    }

    public void setIdpersonnel(String idpersonnel) {
        this.idpersonnel = idpersonnel;
    }

    public Date getDaty_mouvement() {
        return daty_mouvement;
    }

    public void setDaty_mouvement(Date daty_mouvement) {
        this.daty_mouvement = daty_mouvement;
    }

    public String getOld_contrat() {
        return old_contrat;
    }

    public void setOld_contrat(String old_contrat) {
        this.old_contrat = old_contrat;
    }

    public int getOld_nbcontrat() {
        return old_nbcontrat;
    }

    public void setOld_nbcontrat(int old_nbcontrat) {
        this.old_nbcontrat = old_nbcontrat;
    }

    public String getNew_contrat() {
        return new_contrat;
    }

    public void setNew_contrat(String new_contrat) {
        this.new_contrat = new_contrat;
    }

    public int getNew_nbcontrat() {
        return new_nbcontrat;
    }

    public void setNew_nbcontrat(int new_nbcontrat) {
        this.new_nbcontrat = new_nbcontrat;
    }

    public void controlerMouvement(Connection c)throws Exception{
        try{
            PaieInfoPersonnel[] tabP = (PaieInfoPersonnel[])CGenUtil.rechercher(new PaieInfoPersonnel(), null, null, c, " and id = '"+getIdpersonnel()+"'");
            if(tabP.length==0)throw new Exception("Erreur Personnel introuvable : "+getIdpersonnel());
            tabP[0].setIndesirable(getNew_nbcontrat());
            tabP[0].setTemporaire(Integer.valueOf(getNew_contrat()).intValue());
            tabP[0].setDateembauche(getNew_daty_debut());
            tabP[0].updateToTable(c);
            if(getIdtype_mouvement_contrat().equalsIgnoreCase("MVTC3")){
                LogPersonnelNonValide debauche = new LogPersonnelNonValide(getIdpersonnel(), getDaty_mouvement(), "TYD003");
                debauche.setMotif("Fin de contrat");
                debauche.setDate_decision(getDaty_mouvement());
                debauche.setEtat(11);
                debauche.construirePK(c);
                debauche.insertToTable(c);

            }
        }catch(Exception e){
            e.printStackTrace();
            c.rollback();
            throw e;
        }
    }

    @Override
    public void controler(Connection c) throws Exception {
        controlerMouvement(c);
    }

    @Override
    public String getTuppleID() {
        return getId(); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public String getAttributIDName() {
        return "id"; //To change body of generated methods, choose Tools | Templates.
    }

}
