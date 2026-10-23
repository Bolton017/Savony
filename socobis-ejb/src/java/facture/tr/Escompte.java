/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package facture.tr;

import bean.AdminGen;
import utilitaire.UtilDB;

import java.sql.Connection;
import java.sql.Date;

/**
 *
 * @author Rado
 */
public class Escompte extends Traite {
    String id, idTraite;
    double frais;
    Date daty;

    @Override
    public void controler(Connection c) throws Exception{
        boolean verif = false;
        try{
            if(c == null) {
                c = new UtilDB().GetConn();
                c.setAutoCommit(false);
                verif = true;
            }
            Escompte[] esc = this.getTraite(c).getEscompte(c);
            if (AdminGen.calculSommeDouble (esc, "frais" ) >= this.getFrais())  throw new Exception("Les frais d`escompte dépassent le montant de la traite");
        } catch(Exception ex){ 
            if(c != null && verif){
                c.rollback();
            }
            throw ex;
        }finally{
            if(c != null && verif){
                c.close();
            }
        }
    }

    public Traite getTraite(Connection c) throws Exception{
        boolean verif = false;
        try{
            if(c == null) {
                c = new UtilDB().GetConn();
                c.setAutoCommit(false);
                verif = true;
            }
            return (Traite) new Traite().getById(this.getIdTraite(), "traite", c);
        } catch(Exception ex){ 
            if(c != null && verif){
                c.rollback();
            }
            throw ex;
        }finally{
            if(c != null && verif){
                c.close();
            }
        }
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public String getIdTraite() {
        return idTraite;
    }

    public void setIdTraite(String idTraite) {
        this.idTraite = idTraite;
    }

    public double getFrais() {
        return frais;
    }

    public void setFrais(double frais) {
        this.frais = frais;
    }

    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    public Escompte() {
        this.setNomTable("escompte");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("ES", "getseqescompte");
        this.setId(makePK(c));
    }

}
