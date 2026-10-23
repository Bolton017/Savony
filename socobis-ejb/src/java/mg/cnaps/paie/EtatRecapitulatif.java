package mg.cnaps.paie;

import bean.CGenUtil;
import bean.ClassEtat;
import bean.ResultatEtSomme;
import java.sql.Connection;
import utilitaire.UtilDB;

/**
 *
 * @author Tsiky
 */
public class EtatRecapitulatif extends ClassEtat{
    int mois,annee;
    double salaire,indemnite,avantage_en_nature,salaire_brut,irsa,cnaps_travailleur,montant_net_payer,cnaps_employeur,cnaps_a_payer,total_frm, heuresup;
    String other,id, moislib;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public EtatRecapitulatif() {
        super.setNomTable("recapitulatif_salaire2");
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

    public double getSalaire() {
        return salaire;
    }

    public void setSalaire(double salaire) {
        this.salaire = salaire;
    }

    public double getIndemnite() {
        return indemnite;
    }

    public void setIndemnite(double indemnite) {
        this.indemnite = indemnite;
    }

    public double getAvantage_en_nature() {
        return avantage_en_nature;
    }

    public void setAvantage_en_nature(double avantage_en_nature) {
        this.avantage_en_nature = avantage_en_nature;
    }

    public double getSalaire_brut() {
        return salaire_brut;
    }

    public void setSalaire_brut(double salaire_brut) {
        this.salaire_brut = salaire_brut;
    }

    public double getIrsa() {
        return irsa;
    }

    public void setIrsa(double irsa) {
        this.irsa = irsa;
    }

    public double getCnaps_travailleur() {
        return cnaps_travailleur;
    }

    public void setCnaps_travailleur(double cnaps_travailleur) {
        this.cnaps_travailleur = cnaps_travailleur;
    }

    public double getMontant_net_payer() {
        return montant_net_payer;
    }

    public void setMontant_net_payer(double montant_net_payer) {
        this.montant_net_payer = montant_net_payer;
    }

    public double getCnaps_employeur() {
        return cnaps_employeur;
    }

    public void setCnaps_employeur(double cnaps_employeur) {
        this.cnaps_employeur = cnaps_employeur;
    }

    public double getCnaps_a_payer() {
        return cnaps_a_payer;
    }

    public void setCnaps_a_payer(double cnaps_a_payer) {
        this.cnaps_a_payer = cnaps_a_payer;
    }

    public String getOther() {
        return other;
    }

    public void setOther(String other) {
        this.other = other;
    }

    public double getTotal_frm() {
        return total_frm;
    }

    public void setTotal_frm(double total_frm) {
        this.total_frm = total_frm;
    }

    public static EtatRecapitulatif[] getRecap(String mois_infrap,String annee_infrap)throws Exception {
        Connection c = null;
        EtatRecapitulatif[] tab = null;
        try {
            c = new UtilDB().GetConn();
            String reqf = " select * from recapitulatif_salaire2 where mois="+mois_infrap +" and annee="+annee_infrap;
            tab = (EtatRecapitulatif[]) CGenUtil.rechercher(new EtatRecapitulatif(), reqf, c);
            System.out.println("tab = " + tab.length);
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }finally{
            if(c!=null)c.close();
        }
        return tab;
    }


    @Override
    public String getTuppleID() {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public String getAttributIDName() {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    public double getHeuresup() {
        return heuresup;
    }

    public void setHeuresup(double heuresup) {
        this.heuresup = heuresup;
    }

    public String getMoislib() {
        return moislib;
    }

    public void setMoislib(String moislib) {
        this.moislib = moislib;
    }
}
