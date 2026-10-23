
package paie.budget;

import bean.CGenUtil;
import bean.ClassEtat;
import bean.ClassMAPTable;

import java.sql.Connection;
import utilitaire.UtilDB;
import utilitaire.Utilitaire;

public class BudgetRecette  extends ClassEtat {   

    private String id,projet,section_budget,compte,designation,idmere;
   
    private double montant_credit,janvier,fevrier,mars,avril,mai,juin,juillet,aout,septembre,octobre,novembre,decembre,engage,liquide,paye;
    private int exercice,rang;
   
   

    public BudgetRecette() {
        super.setNomTable("budget_recette");
    }

    public BudgetRecette(String id, String projet, String section_budget, String compte, double montant_credit, double janvier, double fevrier, double mars, double avril, double mai, double juin, double juillet, double aout, double septembre, double octobre, double novembre, double decembre, double engage, double liquide, double paye, double etat, int exercice) throws Exception {
        super.setNomTable("budget_recette");
        setId(id);
        setProjet(projet);
        setSection_budget(section_budget);
        setCompte(compte);
        setMontant_credit(montant_credit);
        setJanvier(janvier);
        setFevrier(fevrier);
        setMars(mars);
        setAvril(avril);
        setMai(mai);
        setJuin(juin);
        setJuillet(juillet);
        setAout(aout);
        setSeptembre(septembre);
        setOctobre(octobre);
        setNovembre(novembre);
        setDecembre(decembre);
        setEngage(engage);
        setLiquide(liquide);
        setPaye(paye);
        setEtat((int)etat);
        setExercice(exercice);
    }

    public BudgetRecette(String id, String projet, String section_budget, String compte, double montant_credit, double janvier, double fevrier, double mars, double avril, double mai, double juin, double juillet, double aout, double septembre, double octobre, double novembre, double decembre, double engage, double liquide, double paye, double etat, int exercice, String designation) throws Exception {
        super.setNomTable("budget_recette");
        setId(id);
        setProjet(projet);
        setSection_budget(section_budget);
        setCompte(compte);
        setMontant_credit(montant_credit);
        setJanvier(janvier);
        setFevrier(fevrier);
        setMars(mars);
        setAvril(avril);
        setMai(mai);
        setJuin(juin);
        setJuillet(juillet);
        setAout(aout);
        setSeptembre(septembre);
        setOctobre(octobre);
        setNovembre(novembre);
        setDecembre(decembre);
        setEngage(engage);
        setLiquide(liquide);
        setPaye(paye);
        setEtat((int)etat);
        setExercice(exercice);
        this.setDesignation(designation);
    }

    public BudgetRecette(String projet, String section_budget, String compte, double montant_credit, double janvier, double fevrier, double mars, double avril, double mai, double juin, double juillet, double aout, double septembre, double octobre, double novembre, double decembre, double engage, double liquide, double paye, double etat, int exercice, String designation) throws Exception {
        super.setNomTable("budget_recette");

        setProjet(projet);
        setSection_budget(section_budget);
        setCompte(compte);
        setMontant_credit(montant_credit);
        setJanvier(janvier);
        setFevrier(fevrier);
        setMars(mars);
        setAvril(avril);
        setMai(mai);
        setJuin(juin);
        setJuillet(juillet);
        setAout(aout);
        setSeptembre(septembre);
        setOctobre(octobre);
        setNovembre(novembre);
        setDecembre(decembre);
        setEngage(engage);
        setLiquide(liquide);
        setPaye(paye);
        setEtat((int)etat);
        setExercice(exercice);
        this.setDesignation(designation);
    }
    
     public BudgetRecette(String programme,String activite,String projet, String section_budget, String compte, double montant_credit, double janvier, double fevrier, double mars, double avril, double mai, double juin, double juillet, double aout, double septembre, double octobre, double novembre, double decembre, double engage, double liquide, double paye, double etat, int exercice, String designation) throws Exception {
        super.setNomTable("budget_recette");
        


     
        //setObjectif(objectif);
        setProjet(projet);
        setSection_budget(section_budget);
        setCompte(compte);
        setMontant_credit(montant_credit);
        setJanvier(janvier);
        setFevrier(fevrier);
        setMars(mars);
        setAvril(avril);
        setMai(mai);
        setJuin(juin);
        setJuillet(juillet);
        setAout(aout);
        setSeptembre(septembre);
        setOctobre(octobre);
        setNovembre(novembre);
        setDecembre(decembre);
        setEngage(engage);
        setLiquide(liquide);
        setPaye(paye);
        setEtat((int)etat);
        setExercice(exercice);
        this.setDesignation(designation);
    }

    public String getTuppleID() {
        return id;
    }

    public String getAttributIDName() {
        return "id";
    }

    public void construirePK(Connection c) throws Exception {
        this.preparePk("REC", "GET_BUDGET_RECETTE");
        this.setId(makePK(c));
    }

   
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getProjet() {
        return Utilitaire.champNull(projet);
    }

    public void setProjet(String projet) throws Exception {
        if ("".equals(projet)) {
            //throw new Exception("Champ projet manquant");
            projet=null;
        }
        if (getMode().compareTo("modif") != 0) {
            this.projet = projet;
            return;
        }
        this.projet = projet;
    }

    public String getSection_budget() {
        return Utilitaire.champNull(section_budget);
    }

    public void setSection_budget(String section_budget) throws Exception {
        if ("".equals(section_budget)) {
            section_budget=null;
        }
        if (getMode().compareTo("modif") != 0) {
            this.section_budget = section_budget;
            return;
        }
        /*if (section_budget == "") {
            throw new Exception("Champ section budget manquant");
        }*/
        this.section_budget = section_budget;
    }

    public String getCompte() {
        return Utilitaire.champNull(compte);
    }

    public void setCompte(String compte) throws Exception {
        if (getMode().compareTo("modif") != 0) {
            this.compte = compte;
            return;
        }
        /*if (compte == "") {
            throw new Exception("Champ compte manquant");
        }*/
        this.compte = compte;
    }

    public double getMontant_credit() {
        return montant_credit;
    }

    public void setMontant_credit(double montant_credit) throws Exception {
        if (getMode().compareTo("modif") != 0) {
            this.montant_credit = montant_credit;
            return;
        }
        if (montant_credit <= 0) {
            throw new Exception("Champ montant cr\\u00e9dit invalide car <= 0");
        }
        setJanvier(montant_credit / 12);
        setFevrier(montant_credit / 12);
        setMars(montant_credit / 12);
        setAvril(montant_credit / 12);
        setMai(montant_credit / 12);
        setJuin(montant_credit / 12);
        setJuillet(montant_credit / 12);
        setAout(montant_credit / 12);
        setSeptembre(montant_credit / 12);
        setOctobre(montant_credit / 12);
        setNovembre(montant_credit / 12);
        setDecembre(montant_credit / 12);
        this.montant_credit = montant_credit;
    }

    public double getJanvier() {
        return janvier;
    }

    public void setJanvier(double janvier) {
        this.janvier = janvier;
    }

    public double getFevrier() {
        return fevrier;
    }

    public void setFevrier(double fevrier) {
        this.fevrier = fevrier;
    }

    public double getMars() {
        return mars;
    }

    public void setMars(double mars) {
        this.mars = mars;
    }

    public double getAvril() {
        return avril;
    }

    public void setAvril(double avril) {
        this.avril = avril;
    }

    public double getMai() {
        return mai;
    }

    public void setMai(double mai) {
        this.mai = mai;
    }

    public double getJuin() {
        return juin;
    }

    public void setJuin(double juin) {
        this.juin = juin;
    }

    public double getJuillet() {
        return juillet;
    }

    public void setJuillet(double juillet) {
        this.juillet = juillet;
    }

    public double getAout() {
        return aout;
    }

    public void setAout(double aout) {
        this.aout = aout;
    }

    public double getSeptembre() {
        return septembre;
    }

    public void setSeptembre(double septembre) {
        this.septembre = septembre;
    }

    public double getOctobre() {
        return octobre;
    }

    public void setOctobre(double octobre) {
        this.octobre = octobre;
    }

    public double getNovembre() {
        return novembre;
    }

    public void setNovembre(double novembre) {
        this.novembre = novembre;
    }

    public double getDecembre() {
        return decembre;
    }

    public void setDecembre(double decembre) {
        this.decembre = decembre;
    }

    public double getEngage() {
        return engage;
    }

    public void setEngage(double engage) {
        this.engage = engage;
    }

    public double getLiquide() {
        return liquide;
    }

    public void setLiquide(double liquide) {
        this.liquide = liquide;
    }

    public double getPaye() {
        return paye;
    }

    public void setPaye(double paye) {
        this.paye = paye;
    }

    public int getExercice() {
        return exercice;
    }

    public void setExercice(int exercice) {
        this.exercice = exercice;
    }

    public String getDesignation() {
        return designation;
    }

    public void setDesignation(String designation) {
        this.designation = designation;
    }

    public String getIdmere() {
        return idmere;
    }

    public void setIdmere(String idmere) {
        this.idmere = idmere;
    }

    public int getRang() {
        return rang;
    }

    public void setRang(int rang) {
        this.rang = rang;
    }
    
    public BudgetRecette findById(Connection c)throws Exception{
        int verif = 0;
        try{
            BudgetRecette retour = null;
            if(c == null){
                c = new UtilDB().GetConn();
                verif = 1;
            }
            
            BudgetRecette[] liste = (BudgetRecette[]) CGenUtil.rechercher(new BudgetRecette(), null, null, c, " and id='"+this.getId()+"'");
            if(liste.length != 0)
                retour = liste[0];
            return retour;
        }catch(Exception e){
            throw e;
        }finally{
            if(c != null && verif == 1) c.close();
        }
    }

    @Override
    public ClassMAPTable createObject(String user, Connection c)throws Exception
    { 
        BudgetRecette[] liste = (BudgetRecette[]) CGenUtil.rechercher(new BudgetRecette(), null, null, c, " and  (idmere='"+this.getIdmere()+"' or id = '"+this.getIdmere()+"') AND rang = (SELECT MAX(rang) FROM budget_recette WHERE (idmere='"+this.getIdmere()+"' or id = '"+this.getIdmere()+"'))");
        if(liste.length>0)
        {
            this.setRang(liste[0].getRang()+1);
        } 
        super.createObject(user, c);
        return this;
    }
}
