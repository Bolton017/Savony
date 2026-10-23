/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package paie.edition;

import bean.CGenUtil;
import bean.ClassEtat;
import bean.ClassMAPTable;
import java.sql.Connection;
import java.sql.Date;
import utilitaire.UtilDB;

/**
 *
 * @author BICI
 */
public class Paie_edition extends ClassEtat {

    private String id;
    private String idpersonnel;
    private String idelementpaie;
    private int mois;
    private int annee;
    private double gain;
    private double retenue;
    private Date datedebut;
    private Date datefin;
    private String idedition;
    private String remarque;
    private int etat;
    private String idperiodepaie;
    

    public String getIdperiodepaie() {
        return idperiodepaie;
    }

    public void setIdperiodepaie(String idperiodepaie) {
        this.idperiodepaie = idperiodepaie;
    }

    public String getRemarque() {
        return remarque;
    }

    public void setRemarque(String remarque) {
        this.remarque = remarque;
    }
    
    

    public String getIdedition() {
        return idedition;
    }

    public void setIdedition(String idedition) {
        this.idedition = idedition;
    }
    
    

    public Paie_edition(String idpersonnel, String idelementpaie, int mois, int annee, Date datedebut, Date datefin, double gain, double retenue) {
        this.idpersonnel = idpersonnel;
        this.idelementpaie = idelementpaie;
        this.mois = mois;
        this.annee = annee;
        this.datedebut = datedebut;
        this.datefin = datefin;
        this.gain = gain;
        this.retenue = retenue;
        super.setNomTable("paie_edition");
    }

    public Paie_edition() {
        super.setNomTable("paie_edition");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("EDI", "getseqpaieedition");
        this.setId(makePK(c));
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

    public String getIdpersonnel() {
        return idpersonnel;
    }

    public void setIdpersonnel(String idpersonnel) {
        this.idpersonnel = idpersonnel;
    }

    public String getIdelementpaie() {
        return idelementpaie;
    }

    public void setIdelementpaie(String idelementpaie) {
        this.idelementpaie = idelementpaie;
    }

    public int getMois() {
        return mois;
    }

    public void setMois(int mois) {
        this.mois = mois;
    }

    public int getAnnee() {
        return annee;
    }

    public void setAnnee(int annee) {
        this.annee = annee;
    }

    public double getGain() {
        return gain;
    }

    public void setGain(double gain) {
        this.gain = gain;
    }

    public double getRetenue() {
        return retenue;
    }

    public void setRetenue(double retenue) {
        this.retenue = retenue;
    }

    public Date getDatedebut() {
        return datedebut;
    }

    public void setDatedebut(Date datedebut) {
        this.datedebut = datedebut;
    }

    public Date getDatefin() {
        return datefin;
    }

    public void setDatefin(Date datefin) {
        this.datefin = datefin;
    }
    
    public Paie_edition find( String idedition ,Connection c ) throws Exception{
        Paie_edition obj = new Paie_edition();
        Paie_edition[] ls = null ;
        int indice = 0;        
        try {
            if(c==null){
                c = new UtilDB().GetConn();
                indice = 1;
            }
            ls =(Paie_edition[]) CGenUtil.rechercher(new Paie_edition()  , null, null, null, " and idedition='"+ idedition +"'" );
            if( ls.length > 0 ){
                obj = ls[0];
            }else{
                throw new Exception("Edition non trouver"); 
            }
        }catch(Exception e){
            e.printStackTrace();
            throw e;
        }finally{
            if(c!=null && indice == 1)c.close();
        }
        return obj ;
    }

    public int getEtat() {
        return etat;
    }

    public void setEtat(int etat) {
        this.etat = etat;
    }
}