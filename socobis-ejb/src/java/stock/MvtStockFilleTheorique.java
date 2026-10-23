package stock;

import bean.AdminGen;
import bean.CGenUtil;
import chatbot.AiColDesc;
import chatbot.AiTabDesc;
import chatbot.ClassIA;
import utilitaire.Utilitaire;
import vente.BonDeCommande;
import utilitaire.UtilDB;

import java.sql.Connection;
import java.sql.Date;
import java.util.HashMap;
import java.util.Vector;
//import java.util.*;

public class MvtStockFilleTheorique extends MvtStockFille{

    @AiColDesc("IDOBJET est l'id de la fabrication (id commencant par OF)")
    String idObjet;
    @AiColDesc("qte theorique")
    double qteth;
    @AiColDesc("pu theorique")
    double puth;
    @AiColDesc("montant theorique")
    double montth;

    @AiColDesc("montant pratique")
    double montantsortie;

    String categorieingredient;
    String idcategorieingredient;

    String categorieIngredientLib;

    double ecart;
    double ecartqte;
    double ecartmontant;
    double total;
    double pourcentage;

    double pourcentageth;
    Date daty;

    double poidsTheorique;

    public void setEcartqte(double ecartqte) {
        this.ecartqte = ecartqte;
    }

    public void setEcartmontant(double ecartmontant) {
        this.ecartmontant = ecartmontant;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public MvtStockFilleTheorique() throws Exception{
        this.setNomTable("stockEtDepenseOfFabThe");
    }

    public String getIdcategorieingredient() {
        return idcategorieingredient;
    }

    public void setIdcategorieingredient(String idcategorieingredient) {
        this.idcategorieingredient = idcategorieingredient;
    }

    public String getIdObjet() {
        return idObjet;
    }

    public void setIdObjet(String idObjet) {
        this.idObjet = idObjet;
    }

    public double getQteth() {
        return qteth;
    }

    public void setQteth(double qteth) {
        this.qteth = qteth;
    }

    public double getPuth() {
        return puth;
    }

    public void setPuth(double puth) {
        this.puth = puth;
    }

    public double getMontth() {
        return montth;
    }

    public void setMontth(double montth) {
        this.montth = montth;
    }

    public double getMontantsortie() {
        return montantsortie;
    }

    public void setMontantsortie(double montantsortie) {
        this.montantsortie = montantsortie;
    }

    public double getEcartqte(){
        return this.getSortie() - this.getQteth();
    }

    public double getEcartmontant(){
        return this.getMontantsortie() - this.getMontth() ;
    }

    public double getEcartpu(){
        return this.getPu() - this.getPuth();
    }

    public String getCategorieingredient() {
        return categorieingredient;
    }

    public void setCategorieingredient(String categorieingredient) {
        this.categorieingredient = categorieingredient;
    }

    public double getEcart() {
        return ecart;
    }

    public double getTotal() {
        return total;
    }

    public void setTotal(double total) {
        this.total = total;
    }

    public double getPourcentage() {
        return pourcentage;
    }

    public void setPourcentage(double pourcentage) {
        this.pourcentage = pourcentage;
    }

    public void setEcart(double ecart) {
        this.ecart = ecart;
    }

    public double getPourcentageth() {
        return pourcentageth;
    }

    public void setPourcentageth(double pourcentageth) {
        this.pourcentageth = pourcentageth;
    }

    public String getCategorieIngredientLib() {
        return categorieIngredientLib;
    }

    public void setCategorieIngredientLib(String categorieIngredientLib) {
        this.categorieIngredientLib = categorieIngredientLib;
    }

    public double getPoidsTheorique() {
        return poidsTheorique;
    }

    public void setPoidsTheorique(double poidsTheorique) {
        this.poidsTheorique = poidsTheorique;
    }

    @Override
    public String toString() {
        return "MvtStockFilleTheorique{" +
                "idObjet='" + idObjet + '\'' +
                ", qteth=" + qteth +
                ", puth=" + puth +
                ", montth=" + montth +
                ", montantsortie=" + montantsortie +
                ", categorieingredient='" + categorieingredient + '\'' +
                ", idcategorieingredient='" + idcategorieingredient + '\'' +
                ", categorieIngredientLib='" + categorieIngredientLib + '\'' +
                ", ecart=" + ecart +
                ", ecartqte=" + ecartqte +
                ", ecartmontant=" + ecartmontant +
                ", total=" + total +
                ", pourcentage=" + pourcentage +
                ", pourcentageth=" + pourcentageth +
                '}';
    }

    public static void calculerPourcentage(MvtStockFilleTheorique[] liste) throws Exception{
        double totalP = AdminGen.calculSommeDouble(liste,"montantsortie");
        double totalth = AdminGen.calculSommeDouble(liste,"montth");
        for(int i=0;i<liste.length;i++){
            liste[i].setPourcentage(Utilitaire.arrondir(100*liste[i].getMontantsortie()/totalP,2));
            liste[i].setPourcentageth(Utilitaire.arrondir(100*liste[i].getMontth()/totalth,2));
        }
    }

    public HashMap<String, Vector> getRapprochementParCategorie(String idOf, String nt, Connection c) throws Exception{
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
            }
            MvtStockFilleTheorique ctr = new MvtStockFilleTheorique();
            if(nt == null || nt.trim().isEmpty()) {
                nt = "stockEtDepenseOfFabThe";
            }
            ctr.setNomTable(nt);
            ctr.setIdObjet(idOf);
            HashMap<String, Vector> rep = (HashMap<String,Vector>)CGenUtil.rechercher2D(ctr, null, null, "categorieIngredientLib", c, "");
            return rep;
        } catch (Exception e) {
            throw e;
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
    }
}
