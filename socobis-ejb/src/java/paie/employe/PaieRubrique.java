/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package paie.employe;

import bean.ClassEtat;

import java.sql.Connection;

/**
 *
 * @author nyamp
 */
public class PaieRubrique extends ClassEtat {
    private String id;
    private String val;
    private String desce;
    private int rang;
    private String remarque;
    private String comptepcg;
    private String code;
    private String typerubrique;
    private String bcs;
    private String bg;
    private String imposable;
    private String nature;
    private String avantage;
    private String formule;
    private int isinfini;
    private String cpt_gen_db;
    private String cpt_gen_cr;
    private String cpt_ana_db;
    private String cpt_ana_cr;
    private int afficher ;
    
    public int regroupement,arrondi,inserted,sommable,majoration;
    String beneficiaire, uniteFormule, qteFormule, remarqueFormule;
    double pu;
    String qte;
    
    public PaieRubrique(){
        super.setNomTable("paie_rubrique");
    }
    @Override
    public String getTuppleID() {
        return this.id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }
    public void construirePK(Connection c) throws Exception {
        this.preparePk("PR", "getseqPaie_rubrique");
        this.setId(makePK(c));
    }

    public int getAfficher() {
        return afficher;
    }

    public void setAfficher(int afficher) {
        this.afficher = afficher;
    }
    
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getVal() {
        return val;
    }

    public void setVal(String val) {
        this.val = val;
    }

    public String getDesce() {
        return desce;
    }

    public void setDesce(String desce) {
        this.desce = desce;
    }

    public int getRang() {
        return rang;
    }

    public void setRang(int rang) {
        this.rang = rang;
    }

    public String getRemarque() {
        return remarque;
    }

    public void setRemarque(String remarque) {
        this.remarque = remarque;
    }

    public String getComptepcg() {
        return comptepcg;
    }

    public void setComptepcg(String comptepcg) {
        this.comptepcg = comptepcg;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getTyperubrique() {
        return typerubrique;
    }

    public void setTyperubrique(String typerubrique) {
        this.typerubrique = typerubrique;
    }

    public String getBcs() {
        return bcs;
    }

    public void setBcs(String bcs) {
        this.bcs = bcs;
    }

    public String getBg() {
        return bg;
    }

    public void setBg(String bg) {
        this.bg = bg;
    }

    public String getImposable() {
        return imposable;
    }

    public void setImposable(String imposable) {
        this.imposable = imposable;
    }

    public String getNature() {
        return nature;
    }

    public void setNature(String nature) {
        this.nature = nature;
    }

    public String getAvantage() {
        return avantage;
    }

    public void setAvantage(String avantage) {
        this.avantage = avantage;
    }

    public String getFormule() {
        return formule;
    }

    public void setFormule(String formule) {
        this.formule = formule;
    }

    public int getIsinfini() {
        return isinfini;
    }

    public void setIsinfini(int isinfini) {
        this.isinfini = isinfini;
    }

    public String getCpt_gen_db() {
        return cpt_gen_db;
    }

    public void setCpt_gen_db(String cpt_gen_db) {
        this.cpt_gen_db = cpt_gen_db;
    }

    public String getCpt_gen_cr() {
        return cpt_gen_cr;
    }

    public void setCpt_gen_cr(String cpt_gen_cr) {
        this.cpt_gen_cr = cpt_gen_cr;
    }

    public String getCpt_ana_db() {
        return cpt_ana_db;
    }

    public void setCpt_ana_db(String cpt_ana_db) {
        this.cpt_ana_db = cpt_ana_db;
    }

    public String getCpt_ana_cr() {
        return cpt_ana_cr;
    }

    public void setCpt_ana_cr(String cpt_ana_cr) {
        this.cpt_ana_cr = cpt_ana_cr;
    }

    public int getRegroupement() {
        return regroupement;
    }

    public void setRegroupement(int regroupement) {
        this.regroupement = regroupement;
    }

    public int getArrondi() {
        return arrondi;
    }

    public void setArrondi(int arrondi) {
        this.arrondi = arrondi;
    }

    public int getInserted() {
        return inserted;
    }

    public void setInserted(int inserted) {
        this.inserted = inserted;
    }

    public int getSommable() {
        return sommable;
    }

    public void setSommable(int sommable) {
        this.sommable = sommable;
    }

    public int getMajoration() {
        return majoration;
    }

    public void setMajoration(int majoration) {
        this.majoration = majoration;
    }

    public String getBeneficiaire() {
        return beneficiaire;
    }

    public void setBeneficiaire(String beneficiaire) {
        this.beneficiaire = beneficiaire;
    }

    public String getUniteFormule() {
        return uniteFormule;
    }

    public void setUniteFormule(String uniteFormule) {
        this.uniteFormule = uniteFormule;
    }

    public String getQteFormule() {
        return qteFormule;
    }

    public void setQteFormule(String qteFormule) {
        this.qteFormule = qteFormule;
    }

    public String getRemarqueFormule() {
        return remarqueFormule;
    }

    public void setRemarqueFormule(String remarqueFormule) {
        this.remarqueFormule = remarqueFormule;
    }

    public double getPu() {
        return pu;
    }

    public void setPu(double pu) {
        this.pu = pu;
    }

    public String getQte() {
        return qte;
    }

    public void setQte(String qte) {
        this.qte = qte;
    }

    @Override
    public String[] getMotCles() {
        String[] motCles={ "id","val", "desce" };
        return motCles;
    }

    public String getValColLibelle() {
        return this.val;
    }
}
