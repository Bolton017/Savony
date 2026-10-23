/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package facture.tr;

import bean.AdminGen;
import bean.CGenUtil;
import bean.ClassEtat;
//import facture.FactureClient;
//import mg.spat.JournalCaisse;
//import mg.spat.MvttIntraCaisse;
import caisse.MvtCaisse;
import utilitaire.Constante;
import utilitaire.ConstanteEtat;
import utilitaire.UtilDB;
import utilitaire.Utilitaire;
import utils.ConstanteVente;
import vente.Vente;

import java.sql.Connection;
import java.sql.Date;

/**
 *
 * @author Rado
 */
public class Traite extends ClassEtat {

    String id, tiers, banque, reference,cdclt, idtiers;
    Date daty, dateEcheance;
    double montant,escompte,total,montantreste;
    String idtypepiece;
    String idfinaledestination;
    String idbanque, typepiece, etatlib;
    int etatversement;
    String etatversementlib,numcheque,numpiece,tierslib;

    public String getIdtiers() {
        return idtiers;
    }

    public void setIdtiers(String idtiers) {
        this.idtiers = idtiers;
    }

    public String getNumcheque() {
        return numcheque;
    }

    public void setNumcheque(String numcheque) {
        this.numcheque = numcheque;
    }

    public String getNumpiece() {
        return numpiece;
    }

    public void setNumpiece(String numpiece) {
        this.numpiece = numpiece;
    }


    public String getIdbanque() {
        return idbanque;
    }

    public void setIdbanque(String idbanque) {
        this.idbanque = idbanque;
    }

    public String getIdfinaledestination() {
        return idfinaledestination;
    }

    public void setIdfinaledestination(String idfinaledestination) {
        this.idfinaledestination = idfinaledestination;
    }

    public String getIdtypepiece() {
        return idtypepiece;
    }

    public void setIdtypepiece(String idtypepiece) {
        this.idtypepiece = idtypepiece;
    }


    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
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

    public void setBanque(String banque)throws Exception {
        if(this.getMode().equals("modif") && Utilitaire.champNull(banque).isEmpty()){
            throw new Exception("Banque obligatoire");
        }
        this.banque = banque;
    }

    public String getReference() {
        return reference;
    }

    public void setReference(String reference) {
        this.reference = reference;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public Date getDateEcheance() {
        return dateEcheance;
    }

    public void setDateEcheance(Date dateEcheance) {
        this.dateEcheance = dateEcheance;
    }

    public double getMontant() {
        return montant;
    }

    public void setMontant(double montant) {
        this.montant = montant;
    }

    public double getEscompte() {
        return escompte;
    }

    public void setEscompte(double escompte) {
        this.escompte = escompte;
    }

    public double getTotal() {
        return total;
    }

    public void setTotal(double total) {
        this.total = total;
    }

    public double getMontantreste() {
        return montantreste;
    }

    public void setMontantreste(double montantreste) {
        this.montantreste = montantreste;
    }

    public String getCdclt() {
        return cdclt;
    }

    public void setCdclt(String cdclt) {
        this.cdclt = cdclt;
    }



    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    public Traite() {
        this.setNomTable("traite");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("TR", "getseqtraite");
        this.setId(makePK(c));
    }

    /*
      Fonction pour voir le montant de traite disponibles
    */
    public double getMontantDispo(Connection c) throws Exception{
        double toReturn = 0;
        if(this.getId()!=null){
            FCTraite fcTraiteCritere = new FCTraite();
            fcTraiteCritere.setIdTraite(this.getId());
            FCTraite[] fcTraites = (FCTraite[]) CGenUtil.rechercher(fcTraiteCritere,null,null,c,"");
            for(FCTraite fcTraite: fcTraites){
                toReturn += fcTraite.getMontant();
            }
        }
        return this.getMontant() - toReturn;
    }
    /*
        public JournalCaisse getPieceTraite(Connection c) throws Exception{
            int verif = 0;
            try {
                if (c == null) {
                    c = new UtilDB().GetConn();
                    verif = 1;
                }
                JournalCaisse jc = new JournalCaisse();
                JournalCaisse[] j = (JournalCaisse[]) CGenUtil.rechercher(jc,null,null,c," AND idtraite = '"+this.getId()+"' and etatversement = 0");
                if(j.length > 0) return j[0];
                return null;
            } catch (Exception e) {
                e.printStackTrace();
                throw e;
            } finally {
                if (c != null && verif == 1) {
                    c.close();
                }
            }
        }
        public JournalCaisse[] getPieceTraiteNew(Connection c) throws Exception{     // vaovao
            int verif = 0;
            try {
                if (c == null) {
                    c = new UtilDB().GetConn();
                    verif = 1;
                }
                JournalCaisse jc = new JournalCaisse();
                JournalCaisse[] j = (JournalCaisse[]) CGenUtil.rechercher(jc,null,null,c," AND idtraite = '"+this.getId()+"' and etatversement = 0");
            //    if(j.length > 0) return j[0];
                if(j.length > 0) return j;   // vaovao
                return null;
            } catch (Exception e) {
                e.printStackTrace();
                throw e;
            } finally {
                if (c != null && verif == 1) {
                    c.close();
                }
            }
        }

     */
    public Escompte[] getEscompte(Connection c) throws Exception {
        int verif = 0;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                verif = 1;
            }
            Escompte escompte = new Escompte();
            escompte.setIdTraite(this.getId());
            return (Escompte[]) CGenUtil.rechercher(escompte, null, null, c, " AND ETAT=" + ConstanteEtat.getEtatValider());
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        } finally {
            if (c != null && verif == 1) {
                c.close();
            }
        }
    }
    /*

    public JournalCaisse[] getRetour(Connection c) throws Exception {
        int verif = 0;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                verif = 1;
            }
            JournalCaisse jc = new JournalCaisse();
            jc.setIdordre(this.getId());
            return (JournalCaisse[]) CGenUtil.rechercher(jc, null, null, c, " AND DEBIT!=0");
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        } finally {
            if (c != null && verif == 1) {
                c.close();
            }
        }
    }
     */

    public Vente[] getFactureAttacher(Connection c) throws Exception {
        int verif = 0;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                verif = 1;
            }
            Vente fact = new Vente();
            fact.setNomTable("TRAITE_FCsum");
            //fact.setIdtraite(this.getId());
            return (Vente[]) CGenUtil.rechercher(fact, null, null, c, "");
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        } finally {
            if (c != null && verif == 1) {
                c.close();
            }
        }
    }

    public Vente[] getFactureLiees(Connection c) throws Exception {
        int verif = 0;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                verif = 1;
            }
            Vente fact = new Vente();
            fact.setNomTable("factureclient_traite");
            //fact.setIdtraite(this.getId());
            return (Vente[]) CGenUtil.rechercher(fact, null, null, c, "");
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        } finally {
            if (c != null && verif == 1) {
                c.close();
            }
        }
    }

    public double getSolde(Connection c) throws Exception {
        int verif = 0;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                verif = 1;
            }
            Vente[] facture = getFactureLiees(c);
            double montantF = AdminGen.calculSommeDouble(facture, "montant");
            return this.getMontant() - montantF;
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        } finally {
            if (c != null && verif == 1) {
                c.close();
            }
        }
    }
    /*
    public void lierJournalCaisse(String[] ids) throws Exception{
        Connection c = null;
        try{
            c=new UtilDB().GetConn();
            c.setAutoCommit(false);
            lierJournalCaisse(ids,c);
            c.commit();
        }
        catch(Exception ex){
            if(c!=null)c.rollback();
            ex.printStackTrace();
            throw ex;
        }
        finally{
            if(c!=null)c.close();
        }
    }
     */
    /*
    public void lierJournalCaisse(String[] ids, Connection c) throws Exception{
        JournalCaisse critere = new JournalCaisse();
        critere.setNomTable("journalcaisse");
        if(ids==null ) throw new Exception("Veuillez cocher le journal correspondant");
        JournalCaisse[] journaux =  (JournalCaisse[])CGenUtil.rechercher(critere,null,null,c," and id in ("+Utilitaire.tabToString(ids, "'", ",")+")");
        double sommeCredit = AdminGen.calculSommeDouble(journaux, "credit");
        if(sommeCredit > this.montantreste){
            throw new Exception("Montant traite insuffisant");
        }
        for(int i=0;i<journaux.length;i++){
            if(journaux[i].getIdtraite()!=null)
                throw new Exception("Traite deja existant");
            if(journaux[i].getIdmode().compareToIgnoreCase(Constante.getTraite()) != 0)
                throw new Exception("Mode de paiement doit etre de type traite");
            journaux[i].setIdtraite(this.id);
            journaux[i].updateToTable(c);
        }
    }
     */
    public String getValColLibelle(){
        return id+";"+montant;
    }

    @Override
    public Object validerObject(String u, Connection c) throws Exception {
        //Traite traite = new Traite();
        //traite = (Traite) traite.getById(this.getId(), "TRAITEMTTRESTE", c);
        //if(traite.getMontantreste()>0)
        //    throw new Exception("Le montant disponible ne doit pas etre superieur a zero.");
        String caisseDep = ConstanteVente.caisseTraite;
        //MvttIntraCaisse mvt = new MvttIntraCaisse(caisseDep, ConstanteVente.EFFETSARECEVOIRREMISALENCAISSEMENT,null,null,
        //        null,this.getTuppleID(),this.getDaty(),this.getMontant());
        MvtCaisse mvtCaisse = new MvtCaisse();
        mvtCaisse.setIdCaisse(caisseDep);
        mvtCaisse.setDaty(Utilitaire.dateDuJourSql());
        mvtCaisse.setDesignation("Reception Traite: "+this.getId());
        mvtCaisse.setIdTiers(this.getTiers());
        mvtCaisse.setCredit(this.getMontant());
        mvtCaisse.setDebit(0);
        mvtCaisse.setIdDevise("AR");
        mvtCaisse.setIdOrigine(this.getId());
        mvtCaisse.setIdtraite(this.getId());

        //mvt.setIdfinaledestination(this.getIdfinaledestination());
        mvtCaisse.createObject(u, c);
        mvtCaisse.setTraite(this);
        mvtCaisse.validerObject(u, c);
        return super.validerObject(u, c);
    }

      public void verser(String u, Connection c) throws Exception {

          Traite traite = new Traite();
          traite = (Traite) traite.getById(this.getId(), "TRAITEMTTRESTE", c);
          if(traite.getMontantreste()>0)
              throw new Exception("Le montant disponible ne doit pas etre superieur a zero.");
          String caisseDep = ConstanteVente.caisseTraite;
          //if(this.getIdtypepiece()!=null && this.getIdtypepiece().equals(Constante.getTypePieceCheque()))caisseDep = Constante.caisseDepense;
          MvttIntraCaisse mvt = new MvttIntraCaisse(caisseDep,ConstanteVente.EFFETSARECEVOIRREMISALENCAISSEMENT,ConstanteVente.idmdpmttraite,null,
                                      null,this.getTuppleID(),this.getDaty(),this.getMontant());
  //        mvt.setIdfinaledestination(this.getIdfinaledestination());
          mvt.createObject(u, c);
          mvt.setEtatversement(ConstanteEtat.getEtatValider());
          mvt.setTraite(this);
          mvt.validerObjectVersement(u, c);
          //c.commit();

      }


    public void verser(String u,String date, Connection c) throws Exception {

        Traite traite = new Traite();
        traite = (Traite) traite.getById(this.getId(), "TRAITEMTTRESTE", c);
        if(traite.getMontantreste()>0)
            throw new Exception("Le montant disponible ne doit pas etre superieur a zero.");
        String caisseDep = ConstanteVente.caisseTraite;
        //if(this.getIdtypepiece()!=null && this.getIdtypepiece().equals(Constante.getTypePieceCheque()))caisseDep = Constante.caisseDepense;
        Date datyChoix = Utilitaire.stringDate(date);
        MvttIntraCaisse mvt = new MvttIntraCaisse(caisseDep,ConstanteVente.EFFETSARECEVOIRREMISALENCAISSEMENT,ConstanteVente.idmdpmttraite,null,
                                    null,this.getTuppleID(),datyChoix,this.getMontant());
//        mvt.setIdfinaledestination(this.getIdfinaledestination());
        mvt.createObject(u, c);
        mvt.setEtatversement(ConstanteEtat.getEtatValider());
        mvt.setTraite(this);
        mvt.validerObjectVersement(u, c);
        c.commit();

    }

    @Override
    public void controler(Connection c) throws Exception{
        if(this.getMontant() <= 0){
            throw new Exception("Le montant ne doit pas etre 0 ou negatif");
        }
    }

        public void avantVerser(String[] tId, String u, String finaldestination, Connection c) throws Exception {
            try{
                if(c == null){
                    c=new UtilDB().GetConn();
                    c.setAutoCommit(false);
                }
                MvttIntraCaisse mvt = new MvttIntraCaisse();
                mvt.setNomTable("mvtintracaissetraiteVcaisse");
                MvttIntraCaisse[] mvts = (MvttIntraCaisse[])CGenUtil.rechercher(mvt, null, null, c, " and idtraite='"+this.getId()+"'");
                if(mvts.length > 0){
                    if(mvts[0].getEtatversement() == ConstanteEtat.getEtatValider())
                        throw new Exception("Traite déjà versée.");
                    if(mvts[0].getEtatversement() == ConstanteVente.etatEncaissee)
                        throw new Exception("Traite déjà encaissée.");
                }
                Traite traite=new Traite();
                String aWhere = " AND id in ("+Utilitaire.tabToString(tId, "'", ",")+")";
                Traite[] listeTraite = (Traite[])CGenUtil.rechercher(traite, null, null, c, aWhere);
                for(int i=0;i<listeTraite.length;i++){
                    if(listeTraite[i].getFactureAttacher(c).length == 0 ) throw new Exception("Impossible de verser, pas encore de facture attacher à ce traite ID("+listeTraite[i].getId()+")");
    //                listeTraite[i].setIdfinaledestination(finaldestination);
                    listeTraite[i].setDaty(this.getDaty());
                    listeTraite[i].verser(u, c);
                }
            }
            catch(Exception ex){
                if(c!=null)c.rollback();
                ex.printStackTrace();
                throw ex;
            }
            finally{
                if(c!=null)c.close();
            }
        }

        public void avantVerser(String[] tId, String u, String finaldestination,String date, Connection c) throws Exception {
            try{
                if(c == null){
                    c=new UtilDB().GetConn();
                    c.setAutoCommit(false);
                }
                MvttIntraCaisse mvt = new MvttIntraCaisse();
                mvt.setNomTable("mvtintracaissetraiteVcaisse");
                MvttIntraCaisse[] mvts = (MvttIntraCaisse[])CGenUtil.rechercher(mvt, null, null, c, " and idtraite='"+this.getId()+"'");
                if(mvts.length > 0){
                    if(mvts[0].getEtatversement() == ConstanteEtat.getEtatValider())
                        throw new Exception("Traite déjà versée.");
                    if(mvts[0].getEtatversement() == ConstanteVente.etatEncaissee)
                        throw new Exception("Traite déjà encaissée.");
                }
                Traite traite=new Traite();
                String aWhere = " AND id in ("+Utilitaire.tabToString(tId, "'", ",")+")";
                System.out.println(aWhere);
                Traite[] listeTraite = (Traite[])CGenUtil.rechercher(traite, null, null, c, aWhere);
                for(int i=0;i<listeTraite.length;i++){
    //                listeTraite[i].setIdfinaledestination(finaldestination);
                    if(listeTraite[i].getFactureAttacher(c).length == 0 ) throw new Exception("Impossible de verser, pas encore de facture attacher à ce traite ID("+listeTraite[i].getId()+")");
                    listeTraite[i].verser(u,date, c);
                }
            }
            catch(Exception ex){
                if(c!=null)c.rollback();
                ex.printStackTrace();
                throw ex;
            }
            finally{
                if(c!=null)c.close();
            }
        }
    public String getTypepiece() {
        return typepiece;
    }

    public void setTypepiece(String typepiece) {
        this.typepiece = typepiece;
    }

    public String getEtatlib() {
        return etatlib;
    }

    public void setEtatlib(String etatlib) {
        this.etatlib = etatlib;
    }

    public int getEtatversement() {
        return etatversement;
    }

    public void setEtatversement(int etatversement) {
        this.etatversement = etatversement;
    }

    public String getEtatversementlib() {
        return etatversementlib;
    }

    public void setEtatversementlib(String etatversementlib) {
        this.etatversementlib = etatversementlib;
    }

    public String getTierslib() {
        return tierslib;
    }

    public void setTierslib(String tierslib) {
        this.tierslib = tierslib;
    }
}
