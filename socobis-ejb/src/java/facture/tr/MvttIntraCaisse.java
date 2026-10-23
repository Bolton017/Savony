/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package facture.tr;

import bean.CGenUtil;
import bean.ClassEtat;
import caisse.MvtCaisse;
import utilitaire.ConstanteEtat;
import utilitaire.UtilDB;
import utilitaire.Utilitaire;
import utils.ConstanteVente;

import java.sql.Connection;
import java.sql.Date;

/**
 *
 * @author Sanda
 */
public class MvttIntraCaisse extends ClassEtat {

    private String id,caissedepart,caissearrivee,modepaiement,remarque,designation,idTraite,caissedepartlib,caissearriveelib,modepaiementlib,etatlib;
    private Date daty, dateecheance;
    private Traite traite;
    private boolean visaArrive = true;
    
    public boolean isVisaArrive() {
        return visaArrive;
    }
    public void setVisaArrive(boolean visaArrive) {
        this.visaArrive = visaArrive;
    }
    public Traite getTraite() {
        return traite;
    }
    public void setTraite(Traite traite) {
        this.traite = traite;
    }

    private double montant;
    private  MvtCaisse[] listeJournal;
    int etatversement;
    String idfinaledestination ;
    String finaledestinationlib;
    String etatVersementLib;

    public void setEtatVersementLib(String etatVersementLib){
        this.etatVersementLib=etatVersementLib;
    }
    public String getEtatVersementLib(){
        return this.etatVersementLib;
    }

    public void setFinaledestinationlib(String finaledestinationlib){
        this.finaledestinationlib=finaledestinationlib;
    }
    public String getFinaledestinationlib(){
        return this.finaledestinationlib;
    }

    public String getCaissedepartlib() {
        return caissedepartlib;
    }

    public void setCaissedepartlib(String caissedepartlib) {
        this.caissedepartlib = caissedepartlib;
    }

    public String getCaissearriveelib() {
        return caissearriveelib;
    }

    public void setCaissearriveelib(String caissearriveelib) {
        this.caissearriveelib = caissearriveelib;
    }

    public String getModepaiementlib() {
        return modepaiementlib;
    }

    public void setModepaiementlib(String modepaiementlib) {
        this.modepaiementlib = modepaiementlib;
    }

    public Date getDateEcheance() {
        return dateecheance;
    }

    public void setDateEcheance(Date dateEcheance) {
        this.dateecheance = dateEcheance;
    }

    public int getEtatversement() {
        return etatversement;
    }

    public void setEtatversement(int etatversement) {
        this.etatversement = etatversement;
    }

    public String getIdfinaledestination() {
        return idfinaledestination;
    }

    public void setIdfinaledestination(String idfinaledestination) {
        this.idfinaledestination = idfinaledestination;
    }
    
    
    public MvttIntraCaisse(String modepaiementlib,String caissearriveelib,String caissedepartlib,Date dateEcheance,String caissedepart,String caissearrivee,String modepaiement,String remarque,String description,String idTraite,Date daty,double montant)throws Exception{
        this.setNomTable("MvtIntracaisse");
        this.setCaissearrivee(caissearrivee);
        this.setCaissedepart(caissedepart);
        this.setModepaiement(modepaiement);
        this.setRemarque(remarque);
        this.setDesignation(designation);
        this.setIdTraite(idTraite);
        this.setDaty(daty);
        this.setMontant(montant);
        this.setDateEcheance(dateEcheance);
        this.setCaissedepartlib(caissedepartlib);
        this.setCaissearriveelib(caissearriveelib);
        this.setModepaiementlib(modepaiementlib);
    }

    public MvttIntraCaisse(String caissedepart,String caissearrivee,String modepaiement,String remarque,String description,String idTraite,Date daty,double montant)throws Exception{
        this.setNomTable("MvtIntracaisse");
        this.setCaissearrivee(caissearrivee);
        this.setCaissedepart(caissedepart);
        this.setModepaiement(modepaiement);
        this.setRemarque(remarque);
        this.setDesignation(designation);
        this.setIdTraite(idTraite);
        this.setDaty(daty);
        this.setMontant(montant);
    }

    public String getIdTraite() {
        return idTraite;
    }

    public void setIdTraite(String idTraite) {
        this.idTraite = idTraite;
    }

    public MvtCaisse[] getListeJournal() {
        return listeJournal;
    }

    public void setListeJournal(MvtCaisse[] listeJournal) {
        this.listeJournal = listeJournal;
    }
    
    public MvttIntraCaisse(){
        super.setNomTable("mvtintracaisse");
    }

    public String getDesignation() {
        return designation;
    }

    public void setDesignation(String designation) {
        this.designation = designation;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getCaissedepart() {
        return caissedepart;
    }

    public void setCaissedepart(String caissedepart) {
        this.caissedepart = caissedepart;
    }

    public String getCaissearrivee() {
        return caissearrivee;
    }

    public void setCaissearrivee(String caissearrivee) {
        this.caissearrivee = caissearrivee;
    }

    public String getModepaiement() {
        return modepaiement;
    }

    public void setModepaiement(String modepaiement) {
        this.modepaiement = modepaiement;
    }

    public String getRemarque() {
        return remarque;
    }

    public void setRemarque(String remarque) {
        this.remarque = remarque;
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

    public String getEtatlib() {
        return etatlib;
    }

    public void setEtatlib(String etatlib) {
        this.etatlib = etatlib;
    }
    
    
    
    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }
    
    @Override
    public void construirePK(Connection c) throws Exception {
        super.preparePk("MIC", "getseqmvtintracaisse");
        this.setId(makePK(c));
    }


    @Override
    public Object validerObject(String u, Connection c) throws Exception {
        MvtCaisse sortie = new MvtCaisse();
        sortie.setIdCaisse(this.getCaissedepart());
        sortie.setIdtraite(this.getIdTraite());
        sortie.setDaty(this.getDaty());
        sortie.setDesignation("Mouvement intra caisse - "+this.getIdTraite());
        //sortiee.setIdTiers(this.getTiers());
        sortie.setCredit(this.getMontant());
        sortie.setDebit(0);
        sortie.setIdDevise("AR");
        sortie.setIdOrigine(this.getId());
        sortie.setIdtraite(this.getId());

        //sortie.createObject(u, c);
        //sortie.validerObject(u, c);

        MvtCaisse entree = new MvtCaisse();
        entree.setIdCaisse(this.getCaissearrivee());
        entree.setIdtraite(this.getIdTraite());
        entree.setDaty(this.getDaty());
        entree.setDesignation("Mouvement intra caisse - "+this.getIdTraite());
        //sortiee.setIdTiers(this.getTiers());
        entree.setDebit(this.getMontant());
        entree.setCredit(0);
        entree.setIdDevise("AR");
        entree.setIdOrigine(this.getId());
        entree.setIdtraite(this.getId());

        sortie.createObject(u, c);
        sortie.validerObject(u, c);



        entree.createObject(u, c);
        entree.validerObject(u, c);
        
        this.setEtatversement(ConstanteEtat.getEtatValider());
        
        return super.validerObject(u, c); //To change body of generated methods, choose Tools | Templates.
    }

    public void validerObjectVersement(String u, Connection c) throws Exception {
        MvtCaisse sortie = new MvtCaisse();
        sortie.setIdCaisse(this.getCaissedepart());
        sortie.setIdtraite(this.getIdTraite());
        sortie.setDaty(this.getDaty());
        sortie.setDesignation("Transfert Caisse Traite vers Caisse Effet à recevoir");
        sortie.setEtatversement(this.getEtatversement());
        //sortiee.setIdTiers(this.getTiers());
        sortie.setDebit(this.getMontant());
        sortie.setCredit(0);
        sortie.setIdDevise("AR");
        sortie.setIdOrigine(this.getId());


        MvtCaisse entree = new MvtCaisse();
        entree.setIdCaisse(this.getCaissearrivee());
        entree.setIdtraite(this.getIdTraite());
        entree.setDaty(this.getDaty());
        entree.setDesignation("REF : '"+this.getTraite().getReference() +"' -- Reception Traite dans Effet à recevoir");
        //entree.setIdTiers(this.getTiers());
        entree.setCredit(this.getMontant());
        entree.setDebit(0);
        entree.setEtatversement(this.getEtatversement());
        entree.setIdDevise("AR");
        entree.setIdOrigine(this.getId());


        sortie.createObject(u, c);
        sortie.validerObject(u, c);

        entree.createObject(u, c);
        entree.validerObject(u, c);

        this.setEtatversement(ConstanteEtat.getEtatValider());

        super.validerObject(u, c);
    }

    public void validerObjectEncaissement(String u, Connection c) throws Exception {
        Traite traite = new Traite();
        traite.setId(this.getIdTraite());
        this.setTraite(traite);
        /*
        MvtCaisse temp = this.getTraite().getPieceTraite(c);
        MvtCaisse sortie = new MvtCaisse(null, this.getCaissedepart(), null, "Transfert Caisse Effet à recevoir vers Caisse Banque", null, Utilitaire.dateDuJourSql(), this.getDaty(), this.getMontant(), 0);
        sortie.setIddevise(Constante.deviseAr);
        sortie.setIdmode(this.getModepaiement());
        sortie.setIdtraite(this.getIdTraite());
        sortie.setEtatversement(this.getEtatversement());
        sortie.setEtatversement(ConstanteVente.etatEncaissee);
        sortie.setRemarque(this.getRemarque());
        sortie.setTiers(temp.getTiers());
        sortie.setIdmouvcaisse(this.getId());
        sortie.createObject(u, c);
        sortie.validerObject(u, c);
        */

        MvtCaisse sortie = new MvtCaisse();
        sortie.setIdCaisse(this.getCaissedepart());
        sortie.setIdtraite(this.getIdTraite());
        sortie.setDaty(this.getDaty());
        sortie.setDesignation("Transfert Caisse Effet à recevoir vers Caisse Banque -- Remarque: "+this.getRemarque());
        //sortie.setEtatversement(this.getEtatversement());
        sortie.setEtatversement(ConstanteVente.etatEncaissee);
        //sortiee.setIdTiers(this.getTiers());
        sortie.setDebit(this.getMontant());
        sortie.setCredit(0);
        sortie.setIdDevise("AR");
        sortie.setIdOrigine(this.getId());/*
        MvtCaisse entree = new MvtCaisse(null, this.getCaissearrivee(), null, "Encaissement de la traite numero: "+temp.getNumPiece(), null, Utilitaire.dateDuJourSql(), this.getDaty(), 0, this.getMontant());
        entree.setIddevise(Constante.deviseAr);
        entree.setIdmode(this.getModepaiement());
        entree.setIdtraite(this.getIdTraite());
        entree.setEtatversement(this.getEtatversement());
        entree.setEtatversement(ConstanteVente.etatEncaissee);
        entree.setRemarque(this.getRemarque());
        entree.setIdmouvcaisse(this.getId());
        entree.setTiers(temp.getTiers());
        String numpiece = entree.calculerNumeroRecuTraite(null);
        entree.setNumPiece(numpiece);
        */
        MvtCaisse entree = new MvtCaisse();
        entree.setIdCaisse(this.getCaissearrivee());
        entree.setIdtraite(this.getIdTraite());
        entree.setDaty(this.getDaty());
        entree.setDesignation("Encaissement de la traite numero: "+this.getTraite().getReference()+ " -- Remarque: "+this.getRemarque());
        //entree.setIdTiers(this.getTiers());
        entree.setCredit(this.getMontant());
        entree.setDebit(0);
        entree.setEtatversement(ConstanteVente.etatEncaissee);
        entree.setIdDevise("AR");
        entree.setIdOrigine(this.getId());

        sortie.createObject(u, c);
        sortie.validerObject(u, c);

        entree.createObject(u, c);
        entree.validerObject(u, c);
        
        this.setEtatversement(ConstanteEtat.getEtatValider());

        super.validerObject(u, c);
    }
    
    @Override
    public void controler(Connection c) throws Exception{
        if(this.getCaissedepart() != null && this.getCaissearrivee() != null){
            if(this.getCaissedepart().equalsIgnoreCase(this.getCaissearrivee())){
                throw new Exception("Caisse de départ et d' arrivée identiques");
            }
        }
    }

    public double calculerSomme(String idMvts) throws Exception{
        double somme=0;
        String[] tableau = Utilitaire.split(idMvts, ";");
        String idMvtsNew = Utilitaire.tabToString(tableau, "'", ",");
        MvtCaisse[]journalCaisses =(MvtCaisse[]) CGenUtil.rechercher(new MvtCaisse(), null, null, null, " and id in ("+idMvtsNew+")");
        if(this.listeJournal==null){
            this.listeJournal = journalCaisses;
        }
       
        int taille= journalCaisses.length;
        String caisse=null;
        for(int i=0;i<taille;i++){
            if(caisse==null){
                caisse=journalCaisses[i].getIdCaisse();
            }
            else{
                if(!caisse.equals(journalCaisses[i].getIdCaisse())){
                    throw new Exception("Caisses différentes");
                }
            }
            if(journalCaisses[i].getEtat()<ConstanteEtat.getEtatValider()){
                throw new Exception("Mouvement non valide");
            }
            somme+=journalCaisses[i].getCredit();
        }
        return somme;
    }

    public void verserTraite(String refUser)throws Exception{
        Connection c=null;
        try{
            c=new UtilDB().GetConn();
            c.setAutoCommit(false);
            
            this.setEtatversement(ConstanteEtat.getEtatValider());
            this.validerObjectVersement(refUser, c);
            c.commit();
        }catch(Exception e){
            if(c!=null)c.rollback();
            e.printStackTrace();
        }finally{
            if(c!=null)c.close();
        }
    }
    
    public void encaisserTraite(String u)throws Exception{
        Connection c=null;
        try{
            c=new UtilDB().GetConn();
            c.setAutoCommit(false);
            
            MvttIntraCaisse mvt = new MvttIntraCaisse();
            mvt.setNomTable("mvtintracaissetraiteVcaisse");
            MvttIntraCaisse[] mvts = (MvttIntraCaisse[])CGenUtil.rechercher(mvt, null, null, c, " and idtraite='"+this.getIdTraite()+"'");
            int t = mvts.length;
            if(t > 0){
                for(int i = 0; i < t; i++){
                    if(mvts[i].getEtatversement() == ConstanteVente.etatEncaissee)
                        throw new Exception("Traite déjà encaissée.");
                }
            }
            
            MvttIntraCaisse nouvMvt = new MvttIntraCaisse(ConstanteVente.EFFETSARECEVOIRREMISALENCAISSEMENT,this.getIdfinaledestination(),this.getModepaiement(),
                        this.getRemarque(),this.getDesignation(),this.getIdTraite(),this.getDaty(),this.getMontant());
            nouvMvt.setEtatversement(ConstanteVente.etatEncaissee);
            nouvMvt.createObject(u,c);
            nouvMvt.validerObjectEncaissement(u, c);
            
            this.setEtatversement(ConstanteVente.etatEncaissee);
            this.updateToTable(c);
            c.commit();
        }catch(Exception e){
            if(c!=null)c.rollback();
            e.printStackTrace();
            throw e;
        }finally{
            if(c!=null)c.close();
        }
    }

    public void encaisserTraite(String idcaisse,String date,String u)throws Exception{
        Connection c=null;
        try{
            c=new UtilDB().GetConn();
            c.setAutoCommit(false);
            
            MvttIntraCaisse mvt = new MvttIntraCaisse();
            mvt.setNomTable("mvtintracaissetraiteVcaisse");
            MvttIntraCaisse[] mvts = (MvttIntraCaisse[])CGenUtil.rechercher(mvt, null, null, c, " and idtraite='"+this.getIdTraite()+"'");
            int t = mvts.length;
            if(t > 0){
                for(int i = 0; i < t; i++){
                    if(mvts[i].getEtatversement() == ConstanteVente.etatEncaissee)
                        throw new Exception("Traite déjà encaissée.");
                }
            }
            
            Date daty = Utilitaire.stringDate(date);
            MvttIntraCaisse nouvMvt = new MvttIntraCaisse(ConstanteVente.EFFETSARECEVOIRREMISALENCAISSEMENT,idcaisse,this.getModepaiement(),
                        this.getRemarque(),this.getDesignation(),this.getIdTraite(),daty,this.getMontant());
            nouvMvt.createObject(u,c);
            nouvMvt.validerObjectEncaissement(u, c);
            
            this.setEtatversement(ConstanteVente.etatEncaissee);
            this.updateToTable(c);
            c.commit();
        }catch(Exception e){
            if(c!=null)c.rollback();
            e.printStackTrace();
            throw e;
        }finally{
            if(c!=null)c.close();
        }
    }
/*
    public String validerObjectEncaisserTraite(String u, Connection c, MvtCaisse credit)throws Exception{
        MvtCaisse debit = new MvtCaisse(credit.getFolio(),ConstanteVente.EFFETSARECEVOIRREMISALENCAISSEMENT,credit.getNumPiece(),credit.getLibelle(),credit.getRemarque(),
                                credit.getDateSaisie(),credit.getDateEffet(),credit.getCredit(),0.0);
        credit.setIdtraite(this.getIdTraite());
        credit.setEtatversement(ConstanteVente.etatEncaissee);
        credit.createObject(u, c);
//        credit.validerObject(u, c);

        debit.setEtatversement(ConstanteVente.etatEncaissee);
        debit.setIdtraite(this.getIdTraite());
        debit.createObject(u, c);
//        debit.validerObject(u, c);
        
        this.setEtatversement(ConstanteEtat.getEtatValider());
        
        super.validerObject(u, c);

        return credit.getTuppleID();
    }

    public String encaisserTraite(String u, MvtCaisse journal)throws Exception{
        Connection c=null;
        String retour = null;

        if(this.getMontant()!=journal.getCredit())throw new Exception("Le montant saisie doit être identique à celui du Traite à encaisser");

        try{
            c=new UtilDB().GetConn();
            c.setAutoCommit(false);
            
            MvttIntraCaisse mvt = new MvttIntraCaisse();
            mvt.setNomTable("mvtintracaissetraiteVcaisse");
            MvttIntraCaisse[] mvts = (MvttIntraCaisse[])CGenUtil.rechercher(mvt, null, null, c, " and idtraite='"+this.getIdTraite()+"'");
            int t = mvts.length;
            if(t > 0){
                for(int i = 0; i < t; i++){
                    if(mvts[i].getEtatversement() == ConstanteVente.etatEncaissee)
                        throw new Exception("Traite déjà encaissée.");
                }
            }
            
            MvttIntraCaisse nouvMvt = new MvttIntraCaisse(ConstanteVente.EFFETSARECEVOIRREMISALENCAISSEMENT,this.getIdfinaledestination(),this.getModepaiement(),
                        this.getRemarque(),this.getDesignation(),this.getIdTraite(),this.getDaty(),this.getMontant());
            nouvMvt.createObject(u,c);
            retour = nouvMvt.validerObjectEncaisserTraite(u, c, journal);
            
            this.setEtatversement(ConstanteVente.etatEncaissee);
            this.updateToTable(c);
            c.commit();
        }catch(Exception e){
            if(c!=null)c.rollback();
            e.printStackTrace();
            throw e;
        }finally{
            if(c!=null)c.close();
        }
        return retour;
    }
 */

}
