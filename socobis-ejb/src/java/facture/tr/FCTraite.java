/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package facture.tr;

import bean.CGenUtil;
import bean.ClassEtat;
import vente.Vente;
import caisse.MvtCaisse;
import utilitaire.Constante;
import utilitaire.UtilDB;

import java.sql.Connection;
import java.sql.Date;

/**
 *
 * @author Rado
 */
public class FCTraite  extends ClassEtat{
 
    String id, idTraite, idFC, idJc;
    Date daty;
    double montant;
    String tiers;
    String banque;
    String VenteLib;
    

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdTraite() {
        return idTraite;
    }

    public void setIdTraite(String idTraite) {
        this.idTraite = idTraite;
    }

    public String getIdFC() {
        return idFC;
    }

    public void setIdFC(String idFC) {
        this.idFC = idFC;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public double getMontant() {
        return montant;
    }

    public void setMontant(double montant) {
        this.montant = montant;
    }

    public String getTiers() {
        return tiers;
    }

    public void setTiers(String tiers) {
        this.tiers = tiers;
    }

    public String getBanque() {
        return banque;
    }

    public void setBanque(String banque) {
        this.banque = banque;
    }

    public void setVenteLib(String VenteLib) {
        this.VenteLib = VenteLib;
    }

    public String getVenteLib(){
        return this.VenteLib;
    }

    public String getIdJc() {
        return idJc;
    }

    public void setIdJc(String idJc) {
        this.idJc = idJc;
    }
    
    @Override
    public String getTuppleID() {
        return id ;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }
    
    public FCTraite() {
        this.setNomTable("fctraite");
    }
    
    @Override
    public void construirePK(Connection c) throws Exception{
        this.preparePk("FC", "GETSEQFCTRAITE");
        this.setId(makePK(c));
    }

    /*
     Fonction pour verifier la validité 
    */
   public double montantDispoFacture() throws Exception{
       Connection con = null;
        try{
            con = new UtilDB().GetConn();
            return montantDispoFacture(con);
        }
        catch(Exception exception){
            if(con!=null){
                con.rollback();
            }
            throw exception;
        }
        finally{
            if(con!=null){
                con.close();
            }
        }
   }
   public double montantDispoFacture(Connection conn) throws Exception{
       double toReturn = 0;
       if(this.getIdFC()!=null){
           Vente factureDefinitif = (Vente)new Vente().getById(this.getIdFC(), "VenteValide2", conn);
           if(factureDefinitif!=null){
               //toReturn = factureDefinitif.getMontantreste();
           }
       }
       return toReturn;
   }
   /*
     Fonction pour vérifier si le montant de facture de traite est valide
   */
   public void siMontantTraiteDispo(Traite traite,Connection conn) throws Exception{
      double montantDisponibleTraite = traite.getMontantDispo(conn);
       if(montantDisponibleTraite - this.getMontant() < 0){
           throw new Exception("Solde traite insuffisant");
       }
       double montantDisponibleFacture = this.montantDispoFacture(conn);
       if(montantDisponibleFacture - this.getMontant() <  0){
           throw new Exception("Veuillez vérifier le montant entré car il est supérieur au reste à payer de la facture.");
       }
       
   }

    public Traite getTraite(Connection c)throws Exception{
        Traite retour=null;
        int verif=0;
        try{
            if(this.getIdTraite()!=null){
                if(c==null){
                    c=new UtilDB().GetConn();
                    verif=1;
                }
                Traite t=new Traite();
                t.setId(this.getIdTraite());
                Traite[] liste=(Traite[])CGenUtil.rechercher(t, null,null,c,"");
                if(liste.length>0)retour=liste[0];
            }
        }catch(Exception e){
            e.printStackTrace();
            throw e;
        }finally{
            if(c!=null && verif==1)c.close();
        }
        return retour;
    }
/*
    public MvtCaisse getJC(Connection c)throws Exception{
        MvtCaisse retour=null;
        int verif=0;
        try{
            if(c==null){
                c=new UtilDB().GetConn();
                verif=1;
            }
            FCTraite fctraite=(FCTraite)new FCTraite().getById(this.getId(), "FCTRAITE_CPLT", c);
            if(fctraite!=null){
                this.setIdTraite(fctraite.getIdTraite());
                this.setMontant(fctraite.getMontant());
                this.setIdFC(fctraite.getIdFC());
                retour=new MvtCaisse(null, Constante.caisseCentraleBP, null, null, null, fctraite.getTiers(), Constante.typeCheque, fctraite.getDaty(), fctraite.getDaty(), 0.0, fctraite.getMontant());
                retour.setIdbanque(fctraite.getBanque());
            }
            return retour;

        }catch(Exception e){
            e.printStackTrace();
            throw e;
        }finally{
            if(c!=null && verif==1)c.close();
        }
    }
 */

    public void controler(Connection c) throws Exception {
        Traite traite = getTraite(c);
        siMontantTraiteDispo(traite,c);
        //MvtCaisse jc=this.getJC(c);
        //jc.setIdtraite(this.getIdTraite());
        //jc.updateToTable(c);
    }

    public Object validerObject(String u, Connection c) throws Exception{
        Object retour=this;
        int verif=0;
        try{
            if(c==null){
                c=new UtilDB().GetConn();
                c.setAutoCommit(false);
                verif=1;
            }
            /*MvtCaisse jc=this.getJC(c);
            if(jc!=null){
                jc.createObject(u, c);
                PaiementFacture pf=new PaiementFacture(jc.getTuppleID(), this.getIdFC(), this.getMontant());
                pf.createObject(u, c);
            }
            */
            retour=super.validerObject(u, c);
            
            if(c!=null && verif==1)c.commit();
        }catch(Exception e){
            if(c!=null && verif==1)c.rollback();
            e.printStackTrace();
            throw e;
        }finally{
            if(c!=null && verif==1)c.close();
        }
        return retour;
    }
}
