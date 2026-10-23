/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package paie.employe;

import bean.AdminGen;
import bean.CGenUtil;
import configuration.Configuration;
import java.sql.Connection;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;
import paie.CategorieQualification;
import paie.elementpaie.PaiePersonnelElementpaie;
import paie.elementpaie.PaiePersonnelElementpaieCalcul;
import paie.edition.Paie_edition;
import utilitaire.UtilDB;
import utilitaire.Utilitaire;
import static utilitaire.Utilitaire.getLastJourInMonth;
import static utilitaire.Utilitaire.stringDate;

/**
 *
 * @author rakotondralambokoto
 */
public class EmployeCompletCalcul{
    private EmployeComplet employe;
    private double salBase;
    private double cnaps;
    private double irsa;
    private double ostie;
    private double gainImposable;
    private double totalGain;
    private double totalRetenue;
    private double salaireNet;
    private double montantAbattement;
    private Configuration tauxCnaps;
    private Configuration tauxAbbatement;
    private Configuration tauxOstie;
    private Configuration confIrsa;
    private Configuration[] tabIrsa;
    private Configuration[] toutLesConf;
    private int mois;
    private int annee;
    private List<Paie_edition> editions;
    private List<PaiePersonnelElementpaieCalcul> elementRetenue;
    private List<PaiePersonnelElementpaieCalcul> elementGain;
    private List<PaiePersonnelElementpaieCalcul> elementGainImposable;
    private List<PaiePersonnelElementpaieCalcul> tousleselements;
    private List<PaiePersonnelElementpaieCalcul> elementAvantageEnNatureImposable;
    private double netImposable;
    private double appoint;
    private Date datyDebut;
    private Date datyFin;

    public List<PaiePersonnelElementpaieCalcul> getElementAvantageEnNatureImposable() {
        return elementAvantageEnNatureImposable;
    }

    public void setElementAvantageEnNatureImposable(List<PaiePersonnelElementpaieCalcul> elementAvantageEnNatureImposable) {
        this.elementAvantageEnNatureImposable = elementAvantageEnNatureImposable;
    }

    
    
    public EmployeCompletCalcul() {
    }

    public EmployeCompletCalcul(int mois, int annee,String idpersonnel,EmployeComplet e,Connection c)throws Exception {
        this.setMois(mois);
        this.setAnnee(annee);
        Date datyDeb = Utilitaire.stringDate("01/"+Utilitaire.completerInt(2, getMois())+"/"+getAnnee());
        Date datyFin = Utilitaire.stringDate(getLastJourInMonth(datyDeb)+"/"+Utilitaire.completerInt(2, getMois())+"/"+getAnnee());
        this.setDatyDebut(datyDeb);
        this.setDatyFin(datyFin);
        if(e==null){
            EmployeComplet[] tab = (EmployeComplet[])CGenUtil.rechercher(new EmployeComplet(), null, null, c, " and id = '"+idpersonnel+"'");
            if(tab.length==0)throw new Exception("Erreur personnel introuvable : "+idpersonnel);
            setEmploye(tab[0]);
        }else{
            setEmploye(e);
        }
    }
    
    public double[] calculAvantageNatureImposable()throws Exception{
        double retour[] = null;
        //[0] misy ilay montant exacte anaty retenue
        //[1] misy ilay montant angalana hetra mitsofoka ao amle entre parenth�se
        try{
            if(getElementAvantageEnNatureImposable()!=null && getElementAvantageEnNatureImposable().size()>0){
                retour = new double[2];
                for(int i = 0;i<getElementAvantageEnNatureImposable().size();i++){
                    retour[0] += getElementAvantageEnNatureImposable().get(i).getRetenue();
                    retour[1] += getElementAvantageEnNatureImposable().get(i).getGain();
                }
            }
        }catch(Exception e){
            e.printStackTrace();
            throw e;
        }
        return retour;
    }

    public void calculerSalaire(Configuration[] conf,PaieRubrique[] tabRub,Connection c)throws Exception{
        try{
            completerConfiguration(conf, c);
            getAutreElement(tabRub,c);
            calculGainImposable();
            calculCnaps();
            calculIrsa();
            if(getCnaps()>0)
            addElement(construireElement(ConstantePaie.id_cnaps, 0, getCnaps(), tabRub,""));
            addElement(construireElement(ConstantePaie.id_irsa, 0, getIrsa(), tabRub,""));
            
            //eto nny calcul Avantage en nanture Imposable
            double[] montant = calculAvantageNatureImposable();
            if(montant!=null){
                addElement(construireElement(ConstantePaie.id_irsa_nature, 0, montant[0], tabRub,Utilitaire.formaterAr(montant[1])));
            }
            if(getMontantAbattement()>0)addElement(construireElement(ConstantePaie.id_abattement, getMontantAbattement(), 0, tabRub,""));
            calculNetapayer();
//            addElement(construireElement(ConstantePaie.id_net_a_payer, getSalaireNet(), 0, tabRub));
            prepareEdition();
            printAllElement();
        }catch(Exception e){
            e.printStackTrace();
            throw e;
        }
    }
    
    
    public void calculNetapayer(){
        if(getElementGain()!=null && getElementGain().size()>0){
            double totalGain = 0;
            for(int i = 0;i<getElementGain().size();i++){
                totalGain+=getElementGain().get(i).getGain();
            }
            setTotalGain(totalGain);
        }
         if(getElementRetenue()!=null && getElementRetenue().size()>0){
            double totalret = 0;
            for(int i = 0;i<getElementRetenue().size();i++){
                totalret+=getElementRetenue().get(i).getRetenue();
            }
            setTotalRetenue(totalret);
        }
         setSalaireNet(Utilitaire.arrondir((getTotalGain()-getTotalRetenue()), 2) );
    }
    public void completerConfiguration(Configuration[] tab,Connection c)throws Exception{
        int indice = 0;
        try{
            if(tab!=null && tab.length>0){
                setToutLesConf(tab);
                distribuerConf();
                return;
            }
            if(c==null){
                indice = 1;
                c= new UtilDB().GetConn();
            }
            Configuration[] tabConf = (Configuration[])CGenUtil.rechercher(new Configuration(), null, null, c, " and id in ('"+ConstantePaie.cnaps+"','"+ConstantePaie.irsa_conf+"','"+ConstantePaie.ostie+"','"+ConstantePaie.abbatement_enfant+"') or desce  = '"+ConstantePaie.desce_irsa_bareme+"'");
            if(tabConf.length>0)setToutLesConf(tabConf);
            distribuerConf();
        }catch(Exception e){
            
        }finally{
            if(c!=null && indice==1){
                c.close();
            }
        }
        
    }

    public void getAutreElement(PaieRubrique[] tabRub,Connection c)throws Exception{
        int indice = 0;
        Paie_edition[] retour = null;
        try{
            if(c==null){
                c = new UtilDB().GetConn();
                indice = 1;
                
            }
            CategorieQualification[] tabCatQ = (CategorieQualification[])CGenUtil.rechercher(new CategorieQualification(), null, null, c, " and idcategorie = '"+getEmploye().getIdcategorie_paie()+"' and idqualification = '"+getEmploye().getIdqualification()+"'");
            if(tabCatQ.length>0)setSalBase(convertMontantProrata(tabCatQ[0].getMontant()));
            addElement(construireElement(ConstantePaie.id_sal_base, getSalBase(), 0, tabRub,""));
            String where = " and (idpersonnel = '"+Utilitaire.champNull(getEmploye().getId())+"' or ";
            if(tabCatQ.length>0)where += " (idcategorie_qualification = '"+tabCatQ[0].getId()+"'";
            where += " and idfonction = '"+getEmploye().getIdfonction()+"' ))";
            PaiePersonnelElementpaieCalcul[] tabPaie = (PaiePersonnelElementpaieCalcul[])CGenUtil.rechercher(new PaiePersonnelElementpaieCalcul(), null, null, c, where);
            if(tabPaie.length== 0) {
                where = " and idcategorie_qualification = '"+tabCatQ[0].getId()+"' " ;
               tabPaie =  (PaiePersonnelElementpaieCalcul[])CGenUtil.rechercher(new PaiePersonnelElementpaieCalcul(), null, null, c, where);
            }
            if(tabPaie.length>0){
                for(int i = 0;i<tabPaie.length;i++){
                    System.out.println(" element paie = "+tabPaie[i].getCode_rubrique());
                    if(tabPaie[i].getPourcentage()>0){
                       
                        if(tabPaie[i].getTyperubrique().equalsIgnoreCase("G")){
                             double montant = Math.round(tabPaie[i].getGain()*tabPaie[i].getPourcentage()/100);
                            tabPaie[i].setGain(montant);
                        }else if(tabPaie[i].getTyperubrique().equalsIgnoreCase("R")){
                             double montant = Math.round(tabPaie[i].getRetenue()*tabPaie[i].getPourcentage()/100);
                             tabPaie[i].setRetenue(montant);
                        }
                        
                    }
                    tabPaie[i].setGain(convertMontantProrata(tabPaie[i].getGain()));
                    if(tabPaie[i].getAfficher()== 1){
                        addElement(tabPaie[i]);
                    }else{
                        if(tabPaie[i].getImposable().equalsIgnoreCase("I") && tabPaie[i].getNature().equalsIgnoreCase("variable") && (tabPaie[i].getAvantage()!=null && tabPaie[i].getAvantage().equalsIgnoreCase("A"))){
                            double montant = tabPaie[i].getGain()*0.2;
                            tabPaie[i].setImposable(null); 
                            PaiePersonnelElementpaieCalcul elm = construireElement(tabPaie[i].getCode_rubrique(), tabPaie[i].getGain(), montant, tabRub,"Avantage");
                            if(getElementAvantageEnNatureImposable()==null){
                                List<PaiePersonnelElementpaieCalcul> temp = new ArrayList<PaiePersonnelElementpaieCalcul>();
                                setElementAvantageEnNatureImposable(temp);
                            } 
                            getElementAvantageEnNatureImposable().add(elm);
                        }
                    }
                }
            }
            
            
        }catch(Exception e){
            e.printStackTrace();
            throw e;
        }finally{
            if(c!=null && indice == 1)c.close();
        }
    }
    public List<PaiePersonnelElementpaieCalcul> getElementRetenue() {
        return elementRetenue;
    }

    public List<PaiePersonnelElementpaieCalcul> getTousleselements() {
        return tousleselements;
    }

    public void setTousleselements(List<PaiePersonnelElementpaieCalcul> tousleselements) {
        this.tousleselements = tousleselements;
    }

    public Date getDatyDebut() {
        return datyDebut;
    }

    public void setDatyDebut(Date datyDebut) {
        this.datyDebut = datyDebut;
    }

    public Date getDatyFin() {
        return datyFin;
    }

    public void setDatyFin(Date datyFin) {
        this.datyFin = datyFin;
    }

    public Configuration getTauxAbbatement() {
        return tauxAbbatement;
    }

    public void setTauxAbbatement(Configuration tauxAbbatement) {
        this.tauxAbbatement = tauxAbbatement;
    }

    public double getMontantAbattement() {
        return montantAbattement;
    }

    public void setMontantAbattement(double montantAbattement) {
        this.montantAbattement = montantAbattement;
    }
    
    

    
    public PaiePersonnelElementpaieCalcul construireElement(String code_rubrique,double gain,double retenue,PaieRubrique[] tabRubr,String remarque)throws Exception{
        PaiePersonnelElementpaieCalcul retour = null;
        try{
            retour = new PaiePersonnelElementpaieCalcul();
            retour.setCode_rubrique(code_rubrique);
            retour.setIdpersonnel(getEmploye().getId());
            retour.setDate_debut(getDatyDebut());
            retour.setDate_fin(getDatyFin());
            retour.setGain(gain);
            retour.setRetenue(retenue);
            retour.setRemarque(remarque);
            String[] idRub = {"id"};
            String[] valrub = {code_rubrique};
            PaieRubrique[] tabRub = (PaieRubrique[])AdminGen.findInList(tabRubr, idRub, valrub);
            if(tabRub.length==0)throw new Exception("Erreur rubrique introuvable : "+code_rubrique);
            retour.setTyperubrique(tabRub[0].getTyperubrique());
            retour.setImposable(tabRub[0].getImposable());
        }catch(Exception e){
            e.printStackTrace();
            throw e;
        }
        return retour;
    }
    
    public void addElement(PaiePersonnelElementpaieCalcul elm)throws Exception{
        System.out.println("manatsofoka "+elm.getCode_rubrique()+ " hoan'i "+getEmploye().getId());
        elm.setIdpersonnel(getEmploye().getId());
        if(elm.getTyperubrique().equalsIgnoreCase("G")){
            if(getElementGain()==null){
                List<PaiePersonnelElementpaieCalcul> temp = new ArrayList<PaiePersonnelElementpaieCalcul>();
                setElementGain(temp);
            } 
//            elm.setGain(convertMontantProrata(elm.getGain()));
            getElementGain().add(elm);
        }else if(elm.getTyperubrique().equalsIgnoreCase("R")){
            if(getElementRetenue()==null){
                List<PaiePersonnelElementpaieCalcul> temp = new ArrayList<PaiePersonnelElementpaieCalcul>();
                setElementRetenue(temp);
            } 
            getElementRetenue().add(elm);
        }
        if(elm.getImposable()!=null && elm.getImposable().equalsIgnoreCase("I")){
            if(getElementGainImposable()==null){
                List<PaiePersonnelElementpaieCalcul> temp = new ArrayList<PaiePersonnelElementpaieCalcul>();
                setElementGainImposable(temp);
            } 
            getElementGainImposable().add(elm);
        }
        if(getTousleselements()==null){
            List<PaiePersonnelElementpaieCalcul> temp = new ArrayList<PaiePersonnelElementpaieCalcul>();
            setTousleselements(temp);
        } 
        getTousleselements().add(elm);
        
    }

    public EmployeComplet getEmploye() {
        return employe;
    }

    public void setEmploye(EmployeComplet employe) {
        this.employe = employe;
    }
    
    
    
    public void setElementRetenue(List<PaiePersonnelElementpaieCalcul> elementRetenue) {
        this.elementRetenue = elementRetenue;
    }

    public List<Paie_edition> getEditions() {
        return editions;
    }

    public void setEditions(List<Paie_edition> editions) {
        this.editions = editions;
    }

    public List<PaiePersonnelElementpaieCalcul> getElementGain() {
        return elementGain;
    }

    public void setElementGain(List<PaiePersonnelElementpaieCalcul> elementGain) {
        this.elementGain = elementGain;
    }

    public List<PaiePersonnelElementpaieCalcul> getElementGainImposable() {
        return elementGainImposable;
    }

    public void setElementGainImposable(List<PaiePersonnelElementpaieCalcul> elementGainImposable) {
        this.elementGainImposable = elementGainImposable;
    }
    
    
    
    public void distribuerConf()throws Exception{
        String[] id = {"id"};
        if(getToutLesConf()!=null && getToutLesConf().length>0){
            System.out.println("distribu� conf");
            String[] valCnaps = {ConstantePaie.cnaps};
            Configuration[] tauxCnaps = (Configuration[])AdminGen.findInList(getToutLesConf(), id, valCnaps);
            System.out.println("apres 1");
            setTauxCnaps(tauxCnaps[0]);
            String[] valOstie = {ConstantePaie.cnaps};
            tauxCnaps = (Configuration[])AdminGen.findInList(getToutLesConf(), id, valOstie);
            System.out.println("apres 2");
            setTauxOstie(tauxCnaps[0]);
            String[] idirsa = {ConstantePaie.irsa_conf};
            tauxCnaps = (Configuration[])AdminGen.findInList(getToutLesConf(), id, idirsa);
            System.out.println("aprtes 3");
            setConfIrsa(tauxCnaps[0]);
             String[] idabbatement = {ConstantePaie.abbatement_enfant};
            tauxCnaps = (Configuration[])AdminGen.findInList(getToutLesConf(), id, idabbatement);
            System.out.println("apres 4 "+tauxCnaps.length);
            setTauxAbbatement(tauxCnaps[0]);
            System.out.println("declarationn");
            String[] desce = {"desce"};
            String[] tabIrs  = {ConstantePaie.desce_irsa_bareme};
            System.out.println("avant oooo find inn lisrte");
            tauxCnaps = (Configuration[])AdminGen.findInList(getToutLesConf(), desce, tabIrs);
            System.out.println(" tab irasa = "+tauxCnaps.length);
            setTabIrsa(tauxCnaps);
        }
    }

    public double getAppoint() {
        return appoint;
    }

    public void setAppoint(double appoint) {
        this.appoint = appoint;
    }

    public double getNetImposable() {
        double retour = 0; 
        retour = getGainImposable() - getCnaps();
//        System.out.println(" netImposable --> "+retour+" = " + getGainImposable() + " - "+ getCnaps() );
        return retour;
    }

    public void setNetImposable(double netImposable) {
        this.netImposable = netImposable;
    }

    
    
    public int getMois() {
        return mois;
    }

    public void setMois(int mois)throws Exception {
        if(mois<0)throw new Exception("Erreur mois invalide");
        this.mois = mois;
    }

    public int getAnnee() {
        return annee;
    }

    public void setAnnee(int annee)throws Exception {
        if(annee<0)throw new Exception("Erreur annee invalide");
        this.annee = annee;
    }
    
    
    public Configuration[] getToutLesConf() {
        return toutLesConf;
    }

    public void setToutLesConf(Configuration[] toutLesConf) {
        this.toutLesConf = toutLesConf;
    }
    
    
    public Configuration getTauxCnaps() {
        return tauxCnaps;
    }

    public void setTauxCnaps(Configuration tauxCnaps) {
        this.tauxCnaps = tauxCnaps;
    }

    public Configuration getTauxOstie() {
        return tauxOstie;
    }

    public void setTauxOstie(Configuration tauxOstie) {
        this.tauxOstie = tauxOstie;
    }

    public Configuration getConfIrsa() {
        return confIrsa;
    }

    public void setConfIrsa(Configuration confIrsa) {
        this.confIrsa = confIrsa;
    }

    public Configuration[] getTabIrsa() {
        return tabIrsa;
    }

    public void setTabIrsa(Configuration[] tabIrsa) {
        this.tabIrsa = tabIrsa;
    }
    
    

    public double getSalBase() {
        return salBase;
    }

    public void setSalBase(double salBase) {
        this.salBase = salBase;
    }
    
    
    
    
    //set salaire de base prorata
    public void setSalBase(double montant,Date embauche) {
        if(Utilitaire.getMois(embauche)==getMois() && Utilitaire.getAnnee(embauche)==getAnnee()){
            montant = prorata(montant, embauche, getDatyFin());
        }
        this.salBase = montant;
    }

    public void calculCnaps() {
        System.out.println(" -- "+getEmploye().getPersonnel_etat());
        if(getEmploye().getPersonnel_etat()==0){
            double tauxCnaps = Double.valueOf(getTauxCnaps().getValmin()).doubleValue()/100;
            double maxCnaps = Double.valueOf(getTauxCnaps().getValmax());
            double retour = getGainImposable()*tauxCnaps;
            setCnaps(Math.min(retour,maxCnaps));
        }
    }
    
     public double getCnaps() {
        return cnaps;
    }

    public void setCnaps(double cnaps) {
        this.cnaps = cnaps;
    }

    public void calculIrsa() {
//        System.out.println("------> Idpers" + getEmploye().getId() );
        double irsa = 0;
        double irsaMin = Double.valueOf(getConfIrsa().getValmin());//2.000
        double irsaMax = Double.valueOf(getConfIrsa().getValmax());//350.000
        double netImbos = getNetImposable();
        double reference = getNetImposable();
        double reste = 0;
        if(netImbos>0){
//            System.out.println("netImbos = " + netImbos);
            for (int i = 0; i < getTabIrsa().length; i++) {
                double min = Double.valueOf(getTabIrsa()[i].getValmin());
                double max = Double.valueOf(getTabIrsa()[i].getValmax());
                double taux = Double.valueOf(getTabIrsa()[i].getRemarque())/100;
//                Configuration element = (Configuration) getTabIrsa()[iteration];
                if(netImbos>min){
                    if (netImbos > min && netImbos <= max) {
                        irsa+= (netImbos - min)*taux;
                    }else{
                        irsa+=(max - min)*taux;
                    }
                }
//                System.out.println("------> Irsa " + irsa);
            }            

//            for(int i = 0;i<getTabIrsa().length;i++){
//                double min = Double.valueOf(getTabIrsa()[i].getValmin());
//                double max = Double.valueOf(getTabIrsa()[i].getValmax());
//                double taux = Double.valueOf(getTabIrsa()[i].getRemarque());
//                if(netImbos>min){
//                    double tranche = 0;
//                    if(netImbos<=max){
////                        System.out.println("reste = "+reste);
//                         tranche = reste*taux/100;
//                    }else{
//                        tranche = (max - min)*taux/100;
//                    }
////                    System.out.println("tranche = " + tranche);
//                    if(tranche>0){
//                        irsa+=tranche;
////                        System.out.println("reference - max = " + reference +"-"+ max);
//                        reste = reference - max;
//                    }
//                }
//                
//                System.out.println("------> Irsa " + irsa);
//            }
//             System.out.println("------> Irsa ivelany " + irsa);
        }        
        double montant_abbatement = Double.valueOf(getTauxAbbatement().getValmin()).doubleValue()*getEmploye().getNbenfant();
        System.out.println(Double.valueOf(getTauxAbbatement().getValmin()).doubleValue()+"  x   "+getEmploye().getNbenfant()+" = "+montant_abbatement);
        setMontantAbattement(montant_abbatement);
        if(irsa-getMontantAbattement() < irsaMin){
            setMontantAbattement(0);
        }
        irsa  = Math.max((irsa) , irsaMin);
        setIrsa(irsa);
    }
    public double getIrsa() {
        return irsa;
    }

    public void setIrsa(double irsa) {
        this.irsa = irsa;
    }

    
    public double getOstie() {
        double tauxOstie = Double.valueOf(getTauxOstie().getValmin()).doubleValue()/100;
        double retour = getGainImposable()*tauxOstie;
        return retour;
    }

    public void setOstie(double ostie) {
        this.ostie = ostie;
    }

    public void calculGainImposable() {
        double gainImposable = 0;
        if(getElementGainImposable()!=null && getElementGainImposable().size()>0){
            for(int i = 0;i<getElementGainImposable().size();i++){
                gainImposable+=getElementGainImposable().get(i).getGain();
            }
        }
        setGainImposable(gainImposable);
    }
    
    public double getGainImposable() {
        return gainImposable;
    }

    public void setGainImposable(double gainImposable) {
        this.gainImposable = gainImposable;
    }

    public double getTotalGain() {
        return totalGain;
    }

    public void setTotalGain(double totalGain) {
        this.totalGain = totalGain;
    }

    public double getTotalRetenue() {
        return totalRetenue;
    }

    public void setTotalRetenue(double totalRetenue) {
        this.totalRetenue = totalRetenue;
    }

    public double getSalaireNet() {
        return salaireNet;
    }

    public void setSalaireNet(double salaireNet) {
        this.salaireNet = salaireNet;
    }
    
    public Paie_edition transformeElement(PaiePersonnelElementpaieCalcul e)throws Exception{
        Paie_edition retour = null;
        try{
            retour = new Paie_edition(e.getIdpersonnel(), e.getCode_rubrique(), getMois(),getAnnee() , getDatyDebut(), getDatyFin(), Utilitaire.arrondir(e.getGain(), 2), Utilitaire.arrondir(e.getRetenue(),2));
            retour.setRemarque(e.getRemarque());
        }catch(Exception ex){
            ex.printStackTrace();
            throw ex;
        }
        return retour;
    }
    
    public void prepareEdition()throws Exception{
        if(getEditions()==null){
            List<Paie_edition> tabEd = new ArrayList<Paie_edition>();
            setEditions(tabEd);
        }
        if(getTousleselements()!=null && getTousleselements().size()>0){
            for(int i = 0;i<getTousleselements().size();i++){
                getEditions().add(transformeElement(getTousleselements().get(i)));
            }
        }
    }
    
    public static void main(String[] args)throws Exception {
        System.out.println("kaiza");
        double vola = 246870;
        Connection c = null;
        try{
            c = new UtilDB().GetConn();
            EmployeCompletCalcul calc = new EmployeCompletCalcul(1, 2021, "PRS000043",null, c);
            PaieRubrique[] tabRub = (PaieRubrique[])CGenUtil.rechercher(new PaieRubrique(), null, null, c, " ");
            Configuration[] tabConf = (Configuration[])CGenUtil.rechercher(new Configuration(), null, null, c, " and id in ('"+ConstantePaie.cnaps+"','"+ConstantePaie.irsa_conf+"','"+ConstantePaie.ostie+"','"+ConstantePaie.abbatement_enfant+"') or desce  = '"+ConstantePaie.desce_irsa_bareme+"'");
            
            
            calc.calculerSalaire(tabConf,tabRub,c);
            calc.setGainImposable(450000);
            calc.setCnaps(0);
            calc.getEmploye().setNbenfant(0);
            calc.calculIrsa();
            
            System.out.println(" - "+calc.getIrsa());
        }catch(Exception e){
            e.printStackTrace();
//            throw e;
        }finally{
            if(c!=null)c.close();
        }

    }
    
    public static double arrondirAvanceCanculIrsa(double e ){
        double retour = 0;
        retour = Math.floor(e/100);
        retour = retour*100;
        return retour;
    }
    
    
    public void printAllElement(){
        if(getTousleselements()!=null && getTousleselements().size()>0){
            for(int i = 0;i<getTousleselements().size();i++){
                System.out.println(getTousleselements().get(i).getCode_rubrique()+" - "+getTousleselements().get(i).getGain()+" - "+getTousleselements().get(i).getRetenue());
            }
        }
    }
    
    public static double prorata(double gain, Date debut, Date fin){
        double nbj = 30 - debut.getDate();
        if(nbj==1)nbj=0;
        return Utilitaire.arrondir((gain*nbj)/30,0);
    }
    
    public double convertMontantProrata(double montant){
        if(Utilitaire.getMois(getEmploye().getDateembauche())==getMois() && Utilitaire.getAnnee(getEmploye().getDateembauche())==getAnnee()){
            montant = prorata(montant, getEmploye().getDateembauche(), getDatyFin());
        }
        return montant;
    }
    
}
