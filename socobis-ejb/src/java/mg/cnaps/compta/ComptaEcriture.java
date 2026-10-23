/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package mg.cnaps.compta;

import bean.*;

import faturefournisseur.FactureFournisseur;

import java.sql.Connection;
import java.sql.Date;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import utilitaire.*;
import vente.FactureCF;
import vente.Vente;

/**
 *
 * @author Jetta
 */
public class ComptaEcriture extends ClassMere {

    private String id;
    private Date daty, dateComptable;
    private String exercice, designation, remarque, periode, idobjet;

    //private double etat;
    private double horsExercice;
    private String journal, od, origine;
    private double debit, credit;
    private int annee, trimestre;
    private Date dateSaisie,dateModif;
    private String idModificateur;

    public Date getDateSaisie() {
        return dateSaisie;
    }

    public void setDateSaisie(Date dateSaisie) {
        this.dateSaisie = dateSaisie;
    }

    public Date getDateModif() {
        return dateModif;
    }

    public void setDateModif(Date dateModif) {
        this.dateModif = dateModif;
    }

    public String getIdModificateur() {
        return idModificateur;
    }

    public void setIdModificateur(String idModificateur) {
        this.idModificateur = idModificateur;
    }

    private String lettrage;

    public void setLettrage(String lettrage) {
        this.lettrage = lettrage;
    }

    public String getLettrage() {
        return lettrage;
    }

    public void setIdobjet(String idobjet) {
        this.idobjet = idobjet;
    }

    public String getIdobjet() {
        return idobjet;
    }

    public int getAnnee() {
        return annee;
    }

    public void setAnnee(int annee) {
        if(getMode().compareTo("modif")==0 && this.annee!=0){
            this.annee = annee;
        }
    }

    @Override
    public String getLiaisonFille() {
        return "idMere";
    }

    public int getTrimestre() {
        return trimestre;
    }

    public void setTrimestre(int trimestre) throws Exception {
        if (getMode().compareTo("modif") != 0) {
            this.trimestre = trimestre;
            return;
        }
        this.trimestre = trimestre;
    }

    public double getDebit() {
        return debit;
    }

    public String getPeriode() {
        return periode;
    }

    public void setPeriode(String periode) {
        if(getMode().compareTo("modif")==0 && periode != null && periode.contains("/")){
            String[] g = Utilitaire.split(periode, "/");
            this.periode = g[1]+Utilitaire.completerInt(2, g[0]);
            return;
        }
        this.periode = periode;
    }

    public void setDebit(double debit) throws Exception {
        // if(getMode().compareTo("modif")==0){
        //     if(debit <= 0)
        //         throw new Exception("Montant negatif ou 0 inacceptable");
        // }
        this.debit = debit;
    }

    public double getCredit() {
        return credit;
    }

    public void setCredit(double credit) throws Exception {
        // if(getMode().compareTo("modif")==0){
        //     if(credit <= 0)
        //         throw new Exception("Montant negatif ou 0 inacceptable");
        // }
        this.credit = credit;
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("ECR", "GETSEQCOMPTAECRITURE");
        this.setId(makePK(c));
    }

    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }
    public void updateComptaEcritureWithLettrage(String idLettrage, String u, Connection c) throws Exception{
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
            }
            this.setNomTable("COMPTA_ECRITURE");
            this.setLettrage(idLettrage);
            this.updateToTableWithHisto(u, c);

         } catch (Exception e) {
            throw e;
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
        
    }
    public ComptaEcriture(String id, Date daty, Date dateComptable, String exercice, String designation, String remarque, int etat, double horsExercice, String journal, String od, String origine, double debit, double credit) throws Exception {
        super.setNomTable("compta_ecriture");
        this.setNomClasseFille("mg.cnaps.compta.ComptaSousEcriture");
        this.setId(id);
        this.setDaty(daty);
        this.setDateComptable(dateComptable);
        this.setExercice(exercice);
        this.setDesignation(designation);
        this.setRemarque(remarque);
        this.setEtat(etat);
        this.setHorsExercice(horsExercice);
        this.setJournal(journal);
        this.setOd(od);
        this.setOrigine(origine);
        this.setDebit(debit);
        this.setCredit(credit);
        this.setIdobjet(origine);
    }

    public ComptaEcriture(String id, double debit, double credit) throws Exception {
        super.setNomTable("compta_ecriture");
        this.setNomClasseFille("mg.cnaps.compta.ComptaSousEcriture");
        this.setId(id);
        this.setDebit(debit);
        this.setCredit(credit);
    }
    //        ComptaEcriture ce = new ComptaEcriture(,
    //             exercice, libelleOd, "", 1, 0, journal.getId(), "", origineOd1, 0, 0);

    public ComptaEcriture(Date daty, Date dateComptable, String exercice, String designation, String remarque, int etat, double horsExercice, String journal, String od, String origine, double debit, double credit) throws Exception {
        super.setNomTable("compta_ecriture");
        this.setNomClasseFille("mg.cnaps.compta.ComptaSousEcriture");
        this.setDaty(daty);
        this.setDateComptable(dateComptable);
        this.setExercice(exercice);
        this.setDesignation(designation);
        this.setRemarque(remarque);
        this.setEtat(etat);
        this.setHorsExercice(horsExercice);
        this.setJournal(journal);
        this.setOd(od);
        this.setOrigine(origine);
        this.setDebit(debit);
        this.setCredit(credit);
        this.setIdobjet(origine);
    }

    public ComptaEcriture(String id, Date daty, Date dateComptable, String exercice, String designation, String remarque, int etat, double horsExercice, String journal, String od, String origine, double debit, double credit, String idobjet) throws Exception {
        super.setNomTable("compta_ecriture");
        this.setNomClasseFille("mg.cnaps.compta.ComptaSousEcriture");
        this.setId(id);
        this.setDaty(daty);
        this.setDateComptable(dateComptable);
        this.setExercice(exercice);
        this.setDesignation(designation);
        this.setRemarque(remarque);
        this.setEtat(etat);
        this.setHorsExercice(horsExercice);
        this.setJournal(journal);
        this.setOd(od);
        this.setOrigine(origine);
        this.setDebit(debit);
        this.setCredit(credit);
        this.setIdobjet(idobjet);
    }

    public ComptaEcriture(Date daty, Date dateComptable, String exercice, String designation, String remarque, String periode, String idobjet, double horsExercice, String journal, String od, String origine, double debit, double credit, int annee, int trimestre) throws Exception {
        this.setDaty(daty);
        this.setDateComptable(dateComptable);
        this.setExercice(exercice);
        this.setDesignation(designation);
        this.setRemarque(remarque);
        this.setPeriode(periode);
        this.setIdobjet(idobjet);
        this.setHorsExercice(horsExercice);
        this.setJournal(journal);
        this.setOd(od);
        this.setOrigine(origine);
        this.setDebit(debit);
        this.setCredit(credit);
        this.setAnnee(annee);
        this.setTrimestre(trimestre);
        super.setNomTable("COMPTA_ECRITURE");
        this.setNomClasseFille("mg.cnaps.compta.ComptaSousEcriture");
    }

    public ComptaEcriture()throws Exception {
        super.setNomTable("compta_ecriture");
        this.setNomClasseFille("mg.cnaps.compta.ComptaSousEcriture");
    }
    

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) throws Exception {
        if (daty == null) {
            throw new Exception("Jour Obligatoire");
        }
        this.daty = daty;
    }

    public Date getDateComptable() {
        return dateComptable;
    }

    public void setDateComptable(Date dateComptable) throws Exception {
        if (dateComptable == null) {
            throw new Exception("Date comptable Obligatoire");
        }
        this.dateComptable = dateComptable;
    }

    public String getExercice() {
        return Utilitaire.champNull(exercice);
    }

    public void setExercice(String exercice) throws Exception {
//        System.out.println("exercice=^======"+exercice);
//        System.out.println("exercice1=^======"+this.exercice);
        if (this.getMode().compareTo("modif") == 0) {
            if(this.getDaty() != null && Utilitaire.getAnnee(this.getDaty()) != Utilitaire.stringToInt(exercice)){
//                System.out.println("exercice1=^======"+exercice  +"  "+this.getDateComptable() + "  "+Utilitaire.getAnnee(this.getDaty()));
                throw new Exception("Date non valide");
            }
            this.exercice = exercice;
            setAnnee(Integer.valueOf(this.exercice));
            return;
        }
        if (exercice == "") {
            throw new Exception("Champ exercice manquant");
        }
        this.exercice = exercice;
    }

    public String getDesignation() {
        return Utilitaire.champNull(designation);
    }

    public void setDesignation(String designation) {
        this.designation = designation;
    }

    public String getRemarque() {
        return Utilitaire.champNull(remarque);
    }

    public void setRemarque(String remarque) {
        this.remarque = remarque;
    }

    /*public double getEtat() {
     return etat;
     }

     public void setEtat(double etat) throws Exception {
     if(getMode().compareTo("modif")!=0)
     {
     this.etat = etat;
     return;
     }
     if(etat>99) throw new Exception("Etat invalide");
     this.etat = etat;
     }*/
    public double getHorsExercice() {
        return horsExercice;
    }

    public void setHorsExercice(double horsExercice) {
        this.horsExercice = horsExercice;
    }

    public String getJournal() {
        return Utilitaire.champNull(journal);
    }

    public void setJournal(String journal) throws Exception {
        if (getMode().compareTo("modif") != 0) {
            this.journal = journal;
            return;
        }
        if (journal == "") {
            throw new Exception("Champ Journal manquant");
        }
        this.journal = journal;
    }

    public String getOd() {
        return Utilitaire.champNull(od);
    }

    public void setOd(String od) throws Exception {
        /*if(getMode().compareTo("modif")!=0)
         {
         this.od = od;
         return;
         }
         if(od=="") throw new Exception("Champ OD manquant");*/
        this.od = od;
    }

    public String getOrigine() {
        return Utilitaire.champNull(origine);
    }

    public void setOrigine(String origine) throws Exception {
        if (getMode().compareTo("modif") != 0) {
            this.origine = origine;
            return;
        }
        this.origine = origine.substring(0, 3);
        // this.origine = origine;
    }
    
    @Override
    public void controler(Connection c) throws Exception {
        try{
            //ComptaEcritureService.testEtatMoisExercice(Utilitaire.stringToInt(Utilitaire.getAnnee(Utilitaire.formatterDaty(daty))), Utilitaire.getMois(daty), " D INSERER", c);
            ComptaExercice[] exercices = (ComptaExercice[]) CGenUtil.rechercher(new ComptaExercice(), null, null, c, " and id = " + this.getExercice());
            if(exercices.length > 0){
                if(exercices[0].getEtat() == 9)
                    throw new Exception("Exercice deja cloturé");
            }else{
                throw new Exception("L'exercice saisi n'est pas encore ouvert");
            }
        }
        catch(Exception e){
            throw e;
        }
    }
    
    // @Override
    // public int insertToTableWithHisto(String refUser, java.sql.Connection c) throws Exception {
    //     try{
    //         this.controler(c);
    //     }
    //     catch(Exception e){
    //         throw e;
    //     }
        
    //     return super.insertToTableWithHisto(refUser, c);
    // }

    @Override
    public void controlerAnnulationVisa(Connection c) throws Exception{
        this.controler(c);
    }

    public void controlerEquilibre(Connection c) throws Exception{
        ComptaSousEcriture [] filles = getSousEcrituresEnBase(c);
        verifierEquilibre(AdminGen.calculSommeDouble(filles, "debit"), AdminGen.calculSommeDouble(filles, "credit"));
    }

    @Override
    public Object validerObject(String u, Connection c) throws Exception {
        controlerEquilibre(c);
        if (this.getFille() == null || this.getFille().length == 0) {
            ComptaSousEcriture cse = new ComptaSousEcriture();
            this.getFille(cse.getNomTable(), c, "");
        }
        return super.validerObject(u, c);
    }


    @Override
    public ClassMAPTable createObject(String u, Connection c) throws Exception {
        ComptaSousEcriture[] comptaSousEcritures = (ComptaSousEcriture[]) this.getFille();
        this.setDateComptable(this.getDaty());
        if (comptaSousEcritures != null) {
            for (ComptaSousEcriture comptaSousEcriture : comptaSousEcritures) {
                comptaSousEcriture.setJournal(this.getJournal());
                comptaSousEcriture.setDaty(this.getDaty());
                comptaSousEcriture.setDateComptable(this.getDaty());
            }
        }
        this.setDateSaisie(Utilitaire.dateDuJourSql());
        return super.createObject(u, c);
    }

    @Override
    public int updateObject(String u, Connection c) throws Exception {
        this.setDateModif(Utilitaire.dateDuJourSql());
        System.out.println("Utilisateur modificateur mampiditra: "+u);
        this.setIdModificateur(u);
        return super.updateObject(u, c);
    }

    public ComptaSousEcriture[] getSousEcrituresEnBase(Connection c) throws Exception {
        ComptaSousEcriture cs = new ComptaSousEcriture();
        cs.setIdMere(this.getId());
        return (ComptaSousEcriture[]) CGenUtil.rechercher(cs, null, null, c, "");
    }

    public void annulerVisaSousEcriture(String u, Connection c) throws Exception{
        ComptaSousEcriture cs = new ComptaSousEcriture();
        cs.setIdMere(this.getId());
        ComptaSousEcriture [] filles = (ComptaSousEcriture [])  CGenUtil.rechercher(cs, null, null, c, "");
        if (filles != null) {
            for (ComptaSousEcriture comptaSousEcriture : filles) {
                comptaSousEcriture.annulerVisa(u, c);
            }
        }
    }
    @Override
    public void annulerVisa(String u, Connection c) throws Exception {
        annulerVisaSousEcriture(u, c);
        super.annulerVisa(u, c);
    }

    private String getIdobjetSansEspace() {
        return idobjet == null ? "" : idobjet.trim();
    }

    public boolean isOrigineControlee() {
        String idObjet = getIdobjetSansEspace();
        return idObjet.startsWith("VNT") || idObjet.startsWith("FCF");
    }

    public double getMontantOrigine(Connection c) throws Exception {
        String idObjet = getIdobjetSansEspace();
        FactureCF facture;
        if (idObjet.startsWith("VNT")) {
            facture = (FactureCF) new Vente().getById(idObjet, "VENTE_CPL", c);
        } else if (idObjet.startsWith("FCF")) {
            facture = (FactureCF) new FactureFournisseur().getById(idObjet, "FACTUREFOURNISSEURCPL", c);
        } else {
            throw new Exception("Origine " + idObjet + " non prise en charge pour le controle de montant");
        }
        if (facture == null) throw new Exception("Facture " + idObjet + " introuvable");
        return facture.getMontantttcAr();
    }




    public ComptaSousEcriture[] getSousEcrituresFinales(Connection c) throws Exception {
        ClassFille[] saisies = this.getFille();
        List<ComptaSousEcriture> lignes = new ArrayList<ComptaSousEcriture>();
        for (ComptaSousEcriture enBase : getSousEcrituresEnBase(c)) {
            boolean remplacee = false;
            for (ClassFille f : saisies) {
                if (enBase.getId().equals(((ComptaSousEcriture) f).getId())) {
                    remplacee = true;
                    break;
                }
            }
            if (!remplacee) lignes.add(enBase);
        }
        for (ClassFille f : saisies) lignes.add((ComptaSousEcriture) f);
        return lignes.toArray(new ComptaSousEcriture[lignes.size()]);
    }


    public void controlerMontantOrigine(Connection c) throws Exception {
        if (this.getFille() == null || this.getFille().length == 0) return;
        ComptaSousEcriture[] lignes = getSousEcrituresFinales(c);
        double totalDebit = AdminGen.calculSommeDouble(lignes, "debit");
        double totalCredit = AdminGen.calculSommeDouble(lignes, "credit");
        verifierEquilibre(totalDebit, totalCredit);
        if (!isOrigineControlee()) return;
        verifierMontantOrigine(getIdobjetSansEspace(), totalDebit, totalCredit, getMontantOrigine(c));
    }

    public static void verifierEquilibre(double totalDebit, double totalCredit) throws Exception {
        if (Math.round(totalDebit * 100) != Math.round(totalCredit * 100)) {
            throw new Exception("Ecriture non \u00e9quilibr\u00e9e : total d\u00e9bit " + Utilitaire.formaterAr(totalDebit)
                    + " Ar, total cr\u00e9dit " + Utilitaire.formaterAr(totalCredit) + " Ar");
        }
    }

    public static void verifierMontantOrigine(String idObjet, double totalDebit, double totalCredit, double montantOrigine) throws Exception {
        if (Math.round(totalDebit * 100) != Math.round(montantOrigine * 100) || Math.round(totalCredit * 100) != Math.round(montantOrigine * 100)) {
            throw new Exception("Total \u00e9criture (d\u00e9bit " + Utilitaire.formaterAr(totalDebit) + " Ar, cr\u00e9dit " + Utilitaire.formaterAr(totalCredit)
                    + " Ar) diff\u00e9rent du montant de la source " + idObjet + " : " + Utilitaire.formaterAr(montantOrigine) + " Ar");
        }
    }

    @Override
    public void controlerUpdate(Connection c) throws Exception {
        controlerMontantOrigine(c);
        super.controlerUpdate(c);
    }
}
