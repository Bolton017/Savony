package paie.budget;

import bean.CGenUtil;
import bean.ClassEtat;
import bean.ClassMAPTable;
import bean.TypeObjet;
import java.sql.Connection;
import java.sql.SQLException;
//import mg.fer.contrat.FCC;
import utilitaire.UtilDB;
import utilitaire.Utilitaire;

public class BudgetDepense extends ClassEtat {

    private String id;
    private String programme;
    private String activite;
    private String objectif;
    private String projet;
    private String section_budget;
    private String compte;
    private double montant_credit;
    private double janvier;
    private double fevrier;
    private double mars;
    private double avril;
    private double mai;
    private double juin;
    private double juillet;
    private double aout;
    private double septembre;
    private double octobre;
    private double novembre;
    private double decembre;
    private double engage;
    private double liquide;
    private double paye;
    private int exercice;
    private String designation;
    private String idmere;
    int rang;

    @Override
    public String getValColLibelle() {
        return this.getDesignation(); //To change body of generated methods, choose Tools | Templates.
    }

    public BudgetDepense() {
        super.setNomTable("budget_depense");
    }

    public BudgetDepense(String nt) {
        super.setNomTable(nt);
    }

    public BudgetDepense(String id, String projet, String section_budget, String compte, double montant_credit, double janvier, double fevrier, double mars, double avril, double mai, double juin, double juillet, double aout, double septembre, double octobre, double novembre, double decembre, double engage, double liquide, double paye, double etat, int exercice) throws Exception {
        super.setNomTable("budget_depense");
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
        setEtat((int) etat);
        setExercice(exercice);
    }

    public BudgetDepense(String id, String projet, String section_budget, String compte, double montant_credit, double janvier, double fevrier, double mars, double avril, double mai, double juin, double juillet, double aout, double septembre, double octobre, double novembre, double decembre, double engage, double liquide, double paye, double etat, int exercice, String designation) throws Exception {
        super.setNomTable("GET_BUDGET_DEPENSE");
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
        setEtat((int) etat);
        setExercice(exercice);
        this.setDesignation(designation);
    }

    public BudgetDepense(String projet, String section_budget, String compte, double montant_credit, double janvier, double fevrier, double mars, double avril, double mai, double juin, double juillet, double aout, double septembre, double octobre, double novembre, double decembre, double engage, double liquide, double paye, double etat, int exercice, String designation) throws Exception {
        super.setNomTable("budget_depense");

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
        setEtat((int) etat);
        setExercice(exercice);
        this.setDesignation(designation);
    }

    public BudgetDepense(String programme, String objectif, String activite, String projet, String section_budget, String compte, double montant_credit, double janvier, double fevrier, double mars, double avril, double mai, double juin, double juillet, double aout, double septembre, double octobre, double novembre, double decembre, double engage, double liquide, double paye, double etat, int exercice, String designation) throws Exception {
        super.setNomTable("budget_depense");

        setProgramme(programme);
        setActivite(activite);
        setObjectif(objectif);
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
        setEtat((int) etat);
        setExercice(exercice);
        this.setDesignation(designation);
    }

    public BudgetDepense[] getByNiveau(String niveau, String where, String whereAnnee) throws Exception {
        UtilDB util = new UtilDB();
        Connection c = null;
 BudgetDepense[] bdg=null;
        try {
            c = util.GetConn();
            c.setAutoCommit(false);

            BudgetDepense budget = new BudgetDepense();
            where = where.replaceAll("where 1<2", " ");
            whereAnnee = whereAnnee.replaceAll("where 1<2", " ");
            where = where.replaceAll("annee", "exercice");
            whereAnnee = whereAnnee.replaceAll("annee", "exercice");
            where = where.replaceAll("designation", "c.libelle");
            where = where.replaceAll("compte", "bd.compte");
            String requete = "SELECT c.libelle                  as designation,\n"
                    + "        substr(bd.compte, 1, " + niveau + ")                               as compte,\n"
                    + "        string_agg(distinct exercice::varchar(100), ' - ')    as annee,\n"
                    + "        sum(bd.montant_credit)                             AS montant,\n"
                    + "        sum(bd.montant_credit) -\n"
                    + "                 0::double precision)                      AS restepaiement\n"
                    + "\n"
                    + " FROM  budget_depense bd\n";

            System.out.println(requete);
           bdg = (BudgetDepense[]) CGenUtil.rechercher(budget, requete);
            return bdg;

        } catch (Exception e) {

            e.printStackTrace();

            //System.out.println("ERREUR DELETE_TABLE ".concat(String.valueOf(String.valueOf(e.getMessage()))));
        } finally {
            if (c != null) {
                c.close();
            }
        }
    return bdg;
    }

    public String getTuppleID() {
        return id;
    }

    public String getAttributIDName() {
        return "id";
    }

    public void construirePK(Connection c) throws Exception {
        this.preparePk("DEP", "GET_BUDGET_DEPENSE");
        this.setId(makePK(c));
    }

    public String getActivite() {
        return activite;
    }

    public void setActivite(String activite) {
        this.activite = activite;
    }

    public String getObjectif() {
        return objectif;
    }

    public void setObjectif(String objectif) {
        this.objectif = objectif;
    }

    public String getProgramme() {
        return programme;
    }

    public void setProgramme(String programme) {
        this.programme = programme;
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

        this.projet = projet;
    }

    public String getSection_budget() {
        return Utilitaire.champNull(section_budget);
    }

    public void setSection_budget(String section_budget) throws Exception {

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
    @Override
    public ClassMAPTable createObject(String user, Connection c)throws Exception
    {
        String nomtable = "budget_depense";
        if(this.getNomTable().compareToIgnoreCase("budget_depense_mere") == 0)
        {
            nomtable="budget_depense_mere";
        }
        this.setNomTable(nomtable);
        BudgetDepense[] liste = (BudgetDepense[]) CGenUtil.rechercher(this, null, null, c,  " and  (idmere='"+this.getIdmere()+"' or id = '"+this.getIdmere()+"') AND rang = (SELECT MAX(rang) FROM "+nomtable+" WHERE (idmere='"+this.getIdmere()+"' or id = '"+this.getIdmere()+"'))");
        
        if(liste.length>0)
        {
            this.setRang(liste[0].getRang()+1);
        } 
        super.createObject(user, c);
        return this;
    }

}
