/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package prevision;

import bean.CGenUtil;
import bean.ClassMAPTable;
import bean.AdminGen;

import java.sql.Connection;

import caisse.MvtCaisse;
import com.google.gson.Gson;
import faturefournisseur.FactureFournisseur;
import java.sql.Date;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.Calendar;

import utilitaire.UtilDB;
import utilitaire.Utilitaire;
import vente.FactureCF;
import vente.Vente;
import vente.VenteLib;

import javax.json.Json;

/**
 *
 * @author dm
 */
public class Prevision extends MvtCaisse{

    private double soldeInitial;
    private double soldeFinale;
    private String idFacture;
    private Date dateInitial;
    private int dureeRetard;
    private int mois, annee;

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
    public String getDatyG(){
        return getDaty().toString();
    }
    public String getDatyGsemaine(){
        // Use Calendar to get the week information
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(getDaty());

        // Set the calendar to the start of the week (optional: change to Monday or Sunday based on locale)
        calendar.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY); // Set to the first day of the week (Monday)

        // Get the first day of the week
        java.util.Date weekStartDate = calendar.getTime();

        // Use SimpleDateFormat to format the week string
        SimpleDateFormat dateFormat = new SimpleDateFormat("d MMMM"); // Format as "6 April"
        String weekStartString = dateFormat.format(weekStartDate);


        return "Semaine du " + weekStartString;

    }

    public String getDatyGmois(){
        // Use SimpleDateFormat to format the month string
        SimpleDateFormat monthFormat = new SimpleDateFormat("MMMM"); // "MMMM" gives full month name (e.g., "April")

        // Format the date to get the month
        return monthFormat.format(getDaty());
    }

    public Prevision() {
        this.setNomTable("PREVISION");
    }

    @Override
    public void setIdDevise(String idDevise) throws Exception {
        this.idDevise = idDevise;
    }

    public boolean isDepense()
    {
        if(this.getDebit()>0&&this.getCredit()<=0) return true;
        return false;
    }
    public boolean isRecette()
    {
        if(this.getCredit()==0)return false;
        return !isDepense();
    }

    public double getSoldeInitial() {
        return soldeInitial;
    }

    public void setSoldeInitial(double soldeInitial) {
        this.soldeInitial = soldeInitial;
    }

    public double getSoldeFinale() {
        return soldeFinale;
    }

    public void setSoldeFinale(double soldeFinale) {
        this.soldeFinale = soldeFinale;
    }

    public String getIdFacture() {
        return idFacture;
    }

    public void setIdFacture(String idFacture) {
        this.idFacture = idFacture;
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("PREV", "getseqprevision");
        super.construirePK(c);
    }



    public void attacherFacture(String[] ids, String u, Connection c)throws Exception{
        boolean canClose=false;
        try{
            if(c==null){
                c=new UtilDB().GetConn();
                canClose=true;
            }
            MvtCaisse[] mvtCaisses =  MvtCaisse.getAll(ids, c);
            MvtCaisse m = null;
            for (int i = 0; i < mvtCaisses.length; i++) {
                m = mvtCaisses[i].attacherPrevision(this.getId(), u, c);
            }
        }catch(Exception e){
            throw e;
        } finally {
            if(canClose){
                c.close();
            }
        }
    }

    public Prevision scinderPrevuBatch(String idFacture, double montant, String u, Statement st) throws Exception{
        Prevision prev = (Prevision) dupliquerSansBase();
        prev.setId(null);
        if(this.isDepense()){
            if (getDebit()-montant>0){
                prev.setDebit(this.getDebit()-montant);
                this.setDebit(montant);
                prev.createObjectBatch(u, st);
            }
        }
        else if(this.isRecette()){
            if (getCredit()-montant>0){
                prev.setCredit(this.getCredit()-montant);
                this.setCredit(montant);
                prev.createObjectBatch(u, st);
            }
        }
        this.setIdFacture(idFacture);
        this.updateToTableWithHistoBatch(u, st);
        return prev;
    }

    @Override
    public void controler(Connection c) throws Exception {
        if((this.getCredit()==0&&this.getDebit()==0)) throw new Exception("Montant invalide");
    }

    @Override
    public ClassMAPTable createObject(String u, Connection c) throws Exception{
        this.setDateInitial(getDaty());
        this.setDureeRetard(0);
        System.out.println(new Gson().toJson(this));
        return createObjectSF(u, c);
    }

    @Override
    public String getTuppleID() {
        return this.getId();
    }
    public Vente getVente(Connection c) throws Exception
    {
        return null;
    }
    public FactureFournisseur getFF(Connection c) throws Exception
    {
        return null;
    }

    public double calculerSoldeFinale(){
        double sfinal = this.getSoldeInitial() + this.getCredit() - this.getDebit();
        this.setSoldeFinale(sfinal);
        return this.getSoldeFinale();
    }

    @Override
    public void setCompte(String compte) {
        if (getMode().equals("modif") && (compte == null || compte.trim().isEmpty())) {
            throw new RuntimeException("Le compte est obligatoire");
        }
        else if (getMode().equals("modif") && (compte.length() != 3)) {
            throw new RuntimeException("Le compte doit avoir 3 chiffres");
        }
        super.setCompte(compte);
    }

    @Override
    public String[] getMotCles() {
        return new String[]{"id","compte","designation","debit","credit"};
    }
    public FactureCF getFactureClientouFournisseur(String ntable, Connection c)throws Exception
    {
        if(this.getIdFacture()==null)return null;
        if(this.isRecette())
        {
            if(ntable==null||ntable.compareToIgnoreCase("")==0) ntable="vente_cpl";
            VenteLib crt=new VenteLib();
            crt.setNomTable(ntable);
            crt.setId(this.getIdFacture());
            VenteLib[] liste= (VenteLib[])CGenUtil.rechercher(crt, null, null, c,"");
            if(liste.length>0)return liste[0];
        }
        if(this.isDepense())
        {
            if(ntable==null||ntable.compareToIgnoreCase("")==0) ntable="FACTUREFOURNISSEUR_MERECMPT";
            FactureFournisseur crt=new FactureFournisseur();
            crt.setNomTable(ntable);
            crt.setId(this.getIdFacture());
            FactureFournisseur[] ffs = (FactureFournisseur[]) CGenUtil.rechercher(crt, null, null, c, "");
            if(ffs.length>0)return ffs[0];
        }
        return null;
    }


    public Prevision decaler(double montantDebit, double montantCredit, String devise, Date datyVaovao, String u, Connection c) throws Exception{
        double debit = this.getDebit();
        double credit = this.getCredit();
        if(debit < montantDebit){
            throw new Exception("Le montant saisi ne doit pas etre superieur au débit");
        }
        if(credit < montantCredit){
            throw new Exception("Le montant saisi ne doit pas etre superieur au credit");
        }
        Prevision nouvelle = (Prevision) this.dupliquer(u, c);
        nouvelle.setDebit(montantDebit);
        nouvelle.setCredit(montantCredit);
        nouvelle.setIdDevise(devise);
        setDateInitial(getDaty());
        nouvelle.setDaty(datyVaovao);
        setDureeRetard(Utilitaire.diffJourDaty(getDaty(), getDateInitial()));
        //nouvelle.createObject(u, c);
        debit -= montantDebit;
        credit -= montantCredit;
        setDaty(datyVaovao);
        this.updateToTableWithHisto(u, c);
        return this;

    }
    public void scinderAndSave(int nombre,String u,Connection c) throws Exception
    {
        Prevision[] liste=scinder(nombre,u,c);
        CGenUtil.insertBatch(liste, c);
    }
    public Prevision[] scinder(int nombre, String u, Connection c) throws Exception{
        Prevision[] previsions = new Prevision[nombre-1];
        if(this.isDepense()){
            this.setDebit(this.getDebit() / nombre);
        }
        if(this.isRecette()){
            this.setCredit(this.getCredit() / nombre);
        }
        this.updateToTableWithHisto(u, c);
        Prevision duplication = null;
        for (int i = 0; i <= nombre-2 ; i++) {
            duplication = (Prevision) this.dupliquer(u, c);
            duplication.setDaty(utilitaire.Utilitaire.ajoutJourDate(this.getDaty(),utils.ConstanteStation.nombreJourScindeDefaut*(i+1)));
            //duplication.createObject(u, c);
        }
        return previsions;
    }
    public static Prevision genererPrevision(ClassMAPTable o) throws Exception
    {
        if(o.getNomChampTotalPrev()==null)throw new Exception ("Nom de champ de total de prevision non defini");
        Prevision vao=new Prevision();
        java.sql.Date d= Utilitaire.stringDate(CGenUtil.getValeurInsert(o, o.getNomChampDatyDuplique()));
        double montant=Utilitaire.stringToDouble(CGenUtil.getValeurInsert(o,o.getNomChampTotalPrev()));
        String designation="prevision genere par : "+o.getTuppleID();
        vao.setEtat(1);
        vao.setIdDevise(ConstantePrev.deviseDef);
        vao.setIdFacture(o.getTuppleID());
        vao.setValChamp(o.getSensPrev(), montant);
        vao.setDaty(d);
        vao.setDesignation(designation);
        return vao;
    }
    @Override
    public void controlerUpdate(Connection c) throws Exception{
        MvtCaissePrevision[] mvt= (MvtCaissePrevision[]) CGenUtil.rechercher(new MvtCaissePrevision(),null,null, c," and id2='"+this.getId()+"'");
        double debitDejaPaye = AdminGen.calculSommeDouble(mvt,"montantMere");
        double creditDejaPaye = AdminGen.calculSommeDouble(mvt, "montantCredit");
        if(debitDejaPaye > this.getDebit())
        {
            throw new Exception("Montant debit deja paye superieur a montant");
        }
        if(creditDejaPaye > this.getCredit())
        {
            throw new Exception("Montant credit deja paye superieur a montant");
        }

    }
    public void scinder(String u,Connection c) throws Exception
    {
        System.out.println(new Gson().toJson(this));
        Prevision vao=(Prevision) this.dupliquerSansBase();
        this.setDebit(this.getDebit()/2);
        this.setCredit(this.getCredit()/2);
        vao.setCredit(vao.getCredit()/2);
        vao.setDebit(vao.getDebit()/2);
        vao.setId(null);
        this.updateToTableWithHisto(u, c);
        vao.insertToTableWithHisto(u,c);
    }
    public void scinder(String []ids,String u,Connection c) throws Exception
    {
        boolean estOuvert=false;
        try {
            if(c==null) {
                c = new UtilDB().GetConn();
                estOuvert=true;
            }
            if (ids == null || ids.length == 0) throw new Exception("veuiller cocher");
            for(int i=0; i<ids.length; i++){
                ids[i]=Utilitaire.split(ids[i], "_")[0];
            }
            Prevision[] lp = (Prevision[]) CGenUtil.rechercher(new Prevision(), null, null, c, utilitaire.Utilitaire.getAWhereIn(ids, "id"));
            for (Prevision p : lp) {
                p.scinder(u, c);
            }
            if(estOuvert)c.commit();
        }
        catch (Exception e) {
            e.printStackTrace();
            c.rollback();
            throw e;
        }
        finally {
            if(estOuvert==true&&c!=null)c.close();
        }
    }

    public void modifierPP(String refuser,String[] id, String[] debits, String[] credits, String[] taux, String[] daty, Connection c) throws Exception {
        int indice = 0;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                c.setAutoCommit(false);
                indice = 1;
            }

            if (id == null) {
                throw new Exception("Aucune prevision selectionee");
            }
            String[] listeIndice = new String[id.length];
            for (int j = 0; j < id.length; j++) {
                String[] id_indice = Utilitaire.split(id[j], "_");
                id[j] = id_indice[0];
                listeIndice[j] = id_indice[1];
            }

            String tid = Utilitaire.tabToString(id, "'", ",");
            Prevision[] cmds = (Prevision[]) CGenUtil.rechercher(new Prevision(), null, null, c, " and ID in (" + tid + ") order by id asc");
            if (cmds.length == 0) {
                throw new Exception("Prevision introuvable");
            }

            for (int i = 0; i < id.length; i++) {
                int indRemarque = Integer.parseInt(listeIndice[i]);
                cmds[i].setDebit(Double.parseDouble(debits[indRemarque]));
                cmds[i].setCredit(Double.parseDouble(credits[indRemarque]));
                cmds[i].setTaux(Double.parseDouble(taux[indRemarque]));
                cmds[i].setDaty(Date.valueOf(daty[indRemarque]));
                cmds[i].updateToTableWithHisto(refuser,c);
            }
            if (indice == 1) {
                c.commit();
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            if (c != null) {
                c.rollback();
            }
            throw new Exception(ex.getMessage());
        } finally {
            if (indice == 1 && c != null) {
                c.close();
            }
        }
    }

    public void suppressionMultiple(String[] id, String user, Connection c) throws Exception {
        int indice = 0;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                c.setAutoCommit(false);
                indice = 1;
            }
            if (id == null) {
                throw new Exception("Aucune prevision � supprimer selectione");
            }
            for (int i = 0; i < id.length; i++) {
                Prevision tmp = new Prevision();
                tmp.setId(Utilitaire.split(id[i], "_")[0]);
                tmp.deleteToTableWithHisto(user, c);
            }

            if (indice == 1) {
                c.commit();
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            if (c != null) {
                c.rollback();
            }
            throw new Exception(ex.getMessage());
        } finally {
            if (indice == 1) {
                c.close();
            }
        }
    }

    public Prevision scinderPrevu(String idFacture, double montant, String u, Connection c) throws Exception{
        Prevision prev = (Prevision) dupliquerSansBase();
        prev.setId(null);
        if(this.isDepense()){
            if (getDebit()-montant>0){
                prev.setDebit(this.getDebit()-montant);
                this.setDebit(montant);
                prev.createObject(u, c);
            }
            this.setIdFacture(idFacture);
            this.updateToTableWithHisto(u, c);
        }
        else if(this.isRecette()){
            if (getCredit()-montant>0){
                prev.setCredit(this.getCredit()-montant);
                this.setCredit(montant);
                prev.createObject(u, c);
            }
            this.setIdFacture(idFacture);
            this.updateToTableWithHisto(u, c);
        }
        return prev;
    }

    public Date getDateInitial() {
        return dateInitial;
    }

    public void setDateInitial(Date dateInitial) {
        this.dateInitial = dateInitial;
    }

    public int getDureeRetard() {
        return dureeRetard;
    }

    public void setDureeRetard(int dureeRetard) {
        this.dureeRetard = dureeRetard;
    }
}


