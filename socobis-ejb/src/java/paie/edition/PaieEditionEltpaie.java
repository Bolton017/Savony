package paie.edition;

import bean.ClassMAPTable;
import java.sql.Date;

/**
 *
 * @author nyaina
 */
public class PaieEditionEltpaie extends ClassMAPTable{
    private String id;
    private String idpersonnel;
    private String idelementpaie;
    private String idedition;
    private int mois;
    private int annee;
    private double droits;
    private double retenues;
    private String datedebut;
    private String datefin;
    private String element;
    private String code;
    private int rang;
    private String rubriquedesce;
    private String imposable;
    private String remarque;
    private int afficher;

    private String compteGen_DB; 
    private String compteAna_DB;
    private String comptegen_cr;
    private String compteAna_CR;

    private double heureNormal;
    private double heureSupNormal;
    private double heureSupNuit;
    private double heureSupFerie;
    private double heureSupWeekend;
    private double absence;
    private double salaireBase;

    public String getCompteAna_CR() {
        return compteAna_CR;
    }

    public void setCompteAna_CR(String compteAna_CR) {
        this.compteAna_CR = compteAna_CR;
    }

    public double getHeureNormal() {
        return heureNormal;
    }

    public void setHeureNormal(double heureNormal) {
        this.heureNormal = heureNormal;
    }

    public double getHeureSupNormal() {
        return heureSupNormal;
    }

    public void setHeureSupNormal(double heureSupNormal) {
        this.heureSupNormal = heureSupNormal;
    }

    public double getHeureSupNuit() {
        return heureSupNuit;
    }

    public void setHeureSupNuit(double heureSupNuit) {
        this.heureSupNuit = heureSupNuit;
    }

    public double getHeureSupFerie() {
        return heureSupFerie;
    }

    public void setHeureSupFerie(double heureSupFerie) {
        this.heureSupFerie = heureSupFerie;
    }

    public double getHeureSupWeekend() {
        return heureSupWeekend;
    }

    public void setHeureSupWeekend(double heureSupWeekend) {
        this.heureSupWeekend = heureSupWeekend;
    }

    public double getAbsence() {
        return absence;
    }

    public void setAbsence(double absence) {
        this.absence = absence;
    }

    public String getCompteGen_DB() {
        return compteGen_DB;
    }

    public void setCompteGen_DB(String compteGen_DB) {
        this.compteGen_DB = compteGen_DB;
    }

    public String getCompteAna_DB() {
        return compteAna_DB;
    }

    public void setCompteAna_DB(String compteAna_DB) {
        this.compteAna_DB = compteAna_DB;
    }

    public String getComptegen_cr() {
        return comptegen_cr;
    }

    public void setComptegen_cr(String comptegen_cr) {
        this.comptegen_cr = comptegen_cr;
    }

    public String getcompteAna_CR() {
        return compteAna_CR;
    }

    public void setcompteAna_CR(String compteAna_CR) {
        this.compteAna_CR = compteAna_CR;
    }


    public int getAfficher() {
        return afficher;
    }

    public void setAfficher(int afficher) {
        this.afficher = afficher;
    }
    
    
    public String getRemarque() {
        return remarque;
    }

    public void setRemarque(String remarque) {
        this.remarque = remarque;
    }
    
    
    
    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }
    
    public PaieEditionEltpaie(){
        super.setNomTable("PAIE_EDITION_ELTPAIE");
    }

    public String getIdedition() {
        return idedition;
    }

    public void setIdedition(String idedition) {
        this.idedition = idedition;
    }

    
    
    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getRubriquedesce() {
        return rubriquedesce;
    }

    public void setRubriquedesce(String rubriquedesce) {
        this.rubriquedesce = rubriquedesce;
    }

    public String getImposable() {
        return imposable;
    }

    public void setImposable(String imposable) {
        this.imposable = imposable;
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

    public double getDroits() {
        return droits;
    }

    public void setDroits(double droits) {
        this.droits = droits;
    }

    public double getRetenues() {
        return retenues;
    }

    public void setRetenues(double retenues) {
        this.retenues = retenues;
    }
    public String getDatedebut() {
        return datedebut;
    }

    public void setDatedebut(String datedebut) {
        this.datedebut = datedebut;
    }

    public String getDatefin() {
        return datefin;
    }

    public void setDatefin(String datefin) {
        this.datefin = datefin;
    }

    public String getElement() {
        return element;
    }

    public void setElement(String element) {
        this.element = element;
    }

    public int getRang() {
        return rang;
    }

    public void setRang(int rang) {
        this.rang = rang;
    }

    public double getSalaireBase() {
        return salaireBase;
    }

    public void setSalaireBase(double salaireBase) {
        this.salaireBase = salaireBase;
    }
}