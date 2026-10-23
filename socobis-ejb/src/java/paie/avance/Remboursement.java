/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package paie.avance;

import bean.CGenUtil;
import bean.ClassEtat;
import java.sql.Connection;
import java.sql.Date;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import utilitaire.UtilDB;
import utilitaire.Utilitaire;

/**
 *
 * @author Sambatra Rakotondrainibe
 */
public class Remboursement extends ClassEtat{

    private String id;
    private String idavance;
    private int mois;
    private int annee;
    private double montant;
    private String remarque;
    private Date daty;
    private String personnel, typeavancelib, etatlib,matricule;
    private String moisLib;
    private int avenant;


    public Remboursement() {
         super.setNomTable("Remboursement");
    }

    public Remboursement(String idavance, int mois, int annee, double montant)throws Exception {
         super.setNomTable("Remboursement");
        this.setIdavance(idavance);
        this.setMois(mois);
        this.setAnnee(annee);
        this.setMontant(montant);
        this.setDaty(Utilitaire.dateDuJourSql());
    }
    
    public Remboursement(String idavance, String mois, String annee, double montant)throws Exception {
         super.setNomTable("Remboursement");
        this.setIdavance(idavance);
        this.setMois(Utilitaire.stringToInt(mois));
        this.setAnnee(Utilitaire.stringToInt(annee));
        this.setMontant(montant);
        this.setDaty(Utilitaire.dateDuJourSql());
        this.setEtat(1);
    }

    
    public Remboursement(String idavance, String mois, String annee, String montant)throws Exception {
         super.setNomTable("Remboursement");
        this.setIdavance(idavance);
        this.setMois(Utilitaire.stringToInt(mois));
        this.setAnnee(Utilitaire.stringToInt(annee));
        this.setMontant(Utilitaire.stringToDouble(montant));
        this.setDaty(Utilitaire.dateDuJourSql());
        this.setEtat(1);
    }

     public String getMoisLib() {
        return moisLib;
    }

    public void setMoisLib(String moisLib) {
        this.moisLib = moisLib;
    }

    public String getEtatlib() {
        return etatlib;
    }

    public void setEtatlib(String etatlib) {
        this.etatlib = etatlib;
    }
    
    public String getPersonnel() {
        return personnel;
    }

    public void setPersonnel(String personnel) {
        this.personnel = personnel;
    }

    public String getTypeavancelib() {
        return typeavancelib;
    }

    public void setTypeavancelib(String typeavancelib) {
        this.typeavancelib = typeavancelib;
    }
    
    
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdavance() {
        return idavance;
    }

    public void setIdavance(String idavance) {
        this.idavance = idavance;
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

    public double getMontant() {
        return montant;
    }

    public void setMontant(double montant)throws Exception {
        if(montant<0)throw new Exception("Erreur montant rembousement negatif : "+montant);
        this.montant = montant;
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
    
    public void controlerUpdate() throws Exception {
        if( getEtat() >= 11  ) throw new Exception("Erreur de modification, Objet deja vise");
    }    

    
    @Override
    public String getTuppleID() {
        return getId(); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public String getAttributIDName() {
        return "id"; //To change body of generated methods, choose Tools | Templates.
    }
    
    
    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("PLN", "GET_SEQ_REMBOURSEMENT");
        this.setId(makePK(c));
    }
    
    public static void checkRemboursement(Connection c,Remboursement[] tab)throws Exception{
        boolean ccon = false;
        try{
            if(c==null){
                c = new UtilDB().GetConn();
                ccon = true;
            }
            if(tab!=null){
                if(tab.length>0){
                    
                    String idavance = tab[0].getIdavance();
                    Avance[] tabAc = (Avance[])CGenUtil.rechercher(new Avance(), null, null, c, " and id = '"+idavance+"'");
                    if(tabAc.length==0)throw new Exception("Erreur  avance introuvable : "+idavance);
                    if(tabAc[0].getIdtypeavance().compareToIgnoreCase("PRU000426")==0 && tab.length>1)throw new Exception("Erreur. Le remboursement d une avance /s ne doit pas depassee 1 mois ");
                    double montant_avance = tabAc[0].getMontant()+(tabAc[0].getInteret()*tabAc[0].getMontant()/100);
                    double sommeRemboursement = 0;
                    List<Date> liste_date = new ArrayList<Date>();
                    for(int i = 0;i<tab.length;i++){
                        liste_date.add(Utilitaire.stringDate("01/"+tab[i].getMois()+"/"+tab[i].getAnnee()));
                        sommeRemboursement+=tab[i].getMontant();
                    }
                    if(montant_avance!=sommeRemboursement)throw new Exception("Erreur montant de l avance ("+Utilitaire.formaterAr(montant_avance)+") different de montant de remboursement ("+Utilitaire.formaterAr(sommeRemboursement)+")");
                    
                    if(tab.length>1){
                        Collections.sort(liste_date);
                        Date debut = liste_date.get(0);
                        Date fin = liste_date.get(liste_date.size()-1);
                        int diffMois = Utilitaire.diffMoisDaty(fin, debut)+1;
                        if(diffMois>12)throw new Exception("Erreur le remboursement ne peut pas depasse 12 mois");
                    }
                    
                    
                }else{
                    throw new Exception("Erreur remboursement vide");
                }
            }
        }catch(Exception e){
            e.printStackTrace();
            throw e;
        }finally{
            if(ccon && c!=null)c.close();
        }
    }
    public  Remboursement[] listPlanRemb( String where, Connection c)throws Exception{
        int connex = 0 ;
        Remboursement[] ls = null ;
        try{
            if(c==null){
                c = new UtilDB().GetConn();
                connex = 1;
            }
            ls = (Remboursement[])CGenUtil.rechercher(this , null, null, c, " and idavance='"+getIdavance()+"' "+where);
        }catch(Exception e){
            e.printStackTrace();
            throw e;
        }finally{
            if( c!=null && connex==1)c.close();
        }
        return ls;
    }    
    
    
    public static Remboursement[] savePlanRemboursement(HttpServletRequest req,Connection c)throws Exception{
        Remboursement[] tabRembours = null;
        try{
            String idMere = req.getParameter("idMere");
            Avance[] tabAc = (Avance[])CGenUtil.rechercher(new Avance(), null, null, c, " and id = '"+idMere+"'");
            if(tabAc.length==0)throw new Exception("Erreur  avance introuvable : "+idMere);
            if(tabAc[0].getEtat()>1)throw new Exception("Erreur Avance d&eacuteja vis&eacute. ");
            
            int nb_remboursement = tabAc[0].getNbremboursement();
            tabRembours = new Remboursement[nb_remboursement];
            for(int i = 0;i<tabAc[0].getNbremboursement();i++){
                System.out.println("mois=====> " + req.getParameter("mois_"+i));
                System.out.println("annee=====> " + req.getParameter("annee_"+i));

                double montant = Double.valueOf(req.getParameter("montant_"+i));
                int mois = Integer.valueOf(req.getParameter("mois_"+i));
                int annee = Integer.valueOf(req.getParameter("annee_"+i));

                Remboursement plan = new Remboursement(idMere, mois, annee, montant);
                tabRembours[i] = plan;
            }
            checkRemboursement(c, tabRembours);
            String action = req.getParameter("action");
            if(action!=null && action.compareToIgnoreCase("update")==0){
                Remboursement delete = new Remboursement();
                String where = " idavance = '"+idMere+"'";
                delete.deleteToTable(where, c);
            }
        }catch(Exception e){
            e.printStackTrace();
            throw e;
        }
        return tabRembours;
    }
    
    public static Remboursement updatePlanValider(String idobjet,Connection c)throws Exception{
        Remboursement retour = null;
        try{
            Remboursement[] tabretour = (Remboursement[])CGenUtil.rechercher(new Remboursement(), null, null, c, " and id = '"+idobjet+"'");
            if(tabretour.length>0){
                retour = tabretour[0];
                retour.setEtat(retour.getEtat()+10);
            }
        }catch(Exception e){
            e.printStackTrace();
            throw e;
        }
        return retour;
    }

    public String getMatricule() {
        return matricule;
    }

    public void setMatricule(String matricule) {
        this.matricule = matricule;
    }
    
    public int getAvenant() {
        return avenant;
    }

    public void setAvenant(int avenant) {
        this.avenant = avenant;
    }
    
}
