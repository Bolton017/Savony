/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlet;

import bean.CGenUtil;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import net.sf.jasperreports.engine.data.JRBeanCollectionDataSource;
import net.sf.jasperreports.engine.JRDataSource;
//import org.omg.CORBA.SystemException;
import java.util.Date;
import mg.cnaps.compta.*;
import utilitaire.Utilitaire;
import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JasperPrint;
import reporting.ReportingCdn;
import reporting.ReportingUtils;
import affichage.*;
import web.servlet.etat.Reporting;
import web.mg.cnaps.servlet.etat.UtilitaireImpression;
import utilitaire.UtilDB;
import java.sql.Connection;

@WebServlet(name = "EtatComptableServlet", urlPatterns = {"/EtatComptable"})
public class EtatComptableServlet extends HttpServlet {

    Reporting reporting = new Reporting();
    String nomJasper = "";

    public String getReportPath() throws IOException {
        return getServletContext().getRealPath(File.separator + "report" + File.separator + getNomJasper() + ".jasper");
    }

    public String getNomJasper() {
        return nomJasper;
    }

    public void setNomJasper(String nomJasper) {
        this.nomJasper = nomJasper;
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
            String action = request.getParameter("action");
            if (action.equalsIgnoreCase("exportBalance")) {
                balanceGenerale(request, response);
            }
            if (action.equalsIgnoreCase("exportGrandLivrePDF")) {
                exportGrandLivrePDF(request, response);
            }
            if (action.equalsIgnoreCase("balanceCompta")) {
                balanceCompta(request, response);
            } 
    }

    /**
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (Exception ex) {
            ex.printStackTrace();
            Logger.getLogger(EtatComptableServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (Exception ex) {
            Logger.getLogger(EtatComptableServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }

    private void balanceGenerale(HttpServletRequest request, HttpServletResponse response)
            throws IOException, JRException, Exception {
        ComptaEtatBalanceGenerator generale = new ComptaEtatBalanceGenerator();
        generale.setNomTable("v_compta_etat_balance");
        PageInsert pi = new PageInsert(generale, request);
        ComptaEtatBalanceGenerator rep = (ComptaEtatBalanceGenerator) pi.getObjectAvecValeur();
        ComptaEtatBalanceChiffre2[] tab = rep.genererBalance(null);
        Map param = new HashMap();
        reporting.setParametreJasper("balance_generale", "BALANCE_GENERAL", Arrays.asList(tab), param,
                ReportingUtils.ReportType.PDF, null);
        reporting.setTypeImpression(Reporting.TypeImpression.SIMPLE);
    }
    private void exportGrandLivrePDF(HttpServletRequest request, HttpServletResponse response) throws IOException, JRException, Exception {
    System.out.println("MIDITRA EXPORT GRAND LIBRE PDF");
    try {
        String mois = request.getParameter("date1");   
        String mois2 = request.getParameter("date2");  
        String excercice = request.getParameter("exercice");
        String typecompte = request.getParameter("typecompte");
        String plage1 = request.getParameter("plage1");
        String plage2 = request.getParameter("plage2");
        String etat = request.getParameter("etat");
        String type = request.getParameter("type");
        Date debut = Utilitaire.stringToDate("yyyy-MM-dd", mois);
        Date fin = Utilitaire.stringToDate("yyyy-MM-dd", mois2);
        java.sql.Date debutSql = new java.sql.Date(debut.getTime());
        java.sql.Date finSql = new java.sql.Date(fin.getTime());
        int moisDebut = Utilitaire.getMois(debutSql);
        int moisFin = Utilitaire.getMois(finSql);
       String moisToPut = "";
        if (mois.equals(mois2)) {
                moisToPut = Utilitaire.nbToMois(moisDebut);
        } else {
                moisToPut = Utilitaire.nbToMois(moisDebut) + " - " + Utilitaire.nbToMois(moisFin);
        }
        ComptaEtatGrandLivreGenerator grandLivre = new ComptaEtatGrandLivreGenerator();
        grandLivre.setNomTable("v_compta_etat_balance");
        grandLivre.setDateDebut(mois);
        grandLivre.setDateFin(mois2);
        grandLivre.setCompteDebut(plage1);
        grandLivre.setCompteFin(plage2);
        grandLivre.setTypeCompte(typecompte);
        grandLivre.setExercice(Integer.parseInt(excercice));
        grandLivre.setEtat(Integer.parseInt(etat));
        grandLivre.normalizeComptes();
        grandLivre.fillComptesWithMouvementAndReport(null);
        JasperPrint jp1 = null;
        for (Map.Entry<String, ComptaCompte> entry : grandLivre.getComptes().entrySet()) {
            ComptaCompte cc = entry.getValue();

            boolean hasMouvements = cc.getMouvements() != null && !cc.getMouvements().isEmpty();
            if (cc.getReportDebit() == 0 && cc.getReportCredit() == 0 && !hasMouvements) {
                continue;
            }
            Map param = new HashMap();
            param.put("DATE_JOUR", Utilitaire.dateDuJour());
            param.put("NUMERO_COMPTE", cc.getCompte());
            param.put("COMPTE", "");
            param.put("MOIS", moisToPut);
            param.put("ANNEE", excercice);
            setNomJasper("GRAND_LIVRE_EXPORT");
            reporting.setNomJasper("GRAND_LIVRE_EXPORT");
            if (type != null && type.equalsIgnoreCase("xls")) {
                param.put("TOTAUX_MOIS_DEBIT", cc.getTotalDebit());
                param.put("TOTAUX_MOIS_CREDIT", cc.getTotalCredit());
                param.put("CUMULS_DEBIT", cc.getReportDebit());
                param.put("CUMULS_CREDIT", cc.getReportCredit());
                param.put("SOLDE_DEBIT", cc.getSoldeCredit());
                param.put("SOLDE_CREDIT", cc.getSoldeDebit());
                setNomJasper("GRAND_LIVRE_EXPORT_XLS");
                reporting.setNomJasper("GRAND_LIVRE_EXPORT_XLS");
            } else {
                param.put("TOTAUX_MOIS_DEBIT", Utilitaire.formaterAr(cc.getTotalDebit()));
                param.put("TOTAUX_MOIS_CREDIT", Utilitaire.formaterAr(cc.getTotalCredit()));
                param.put("CUMULS_DEBIT", Utilitaire.formaterAr(cc.getReportDebit()));
                param.put("CUMULS_CREDIT", Utilitaire.formaterAr(cc.getReportCredit()));
                param.put("SOLDE_DEBIT", Utilitaire.formaterAr(cc.getSoldeCredit()));
                param.put("SOLDE_CREDIT", Utilitaire.formaterAr(cc.getSoldeDebit()));
            }
            reporting.setReportPath(getServletContext().getRealPath(
                    File.separator + "report" + File.separator + reporting.getNomJasper() + ".jasper"));
            List<ComptaSousEcriture> mouvements = cc.getMouvements() != null
                    ? cc.getMouvements()
                    : new ArrayList<ComptaSousEcriture>();
            if (jp1 == null) {
                jp1 = UtilitaireImpression.fillReport(response, mouvements, param, reporting.getReportPath());
            } else {
                JasperPrint jp2 = UtilitaireImpression.fillReport(response, mouvements, param, reporting.getReportPath());
                jp1 = UtilitaireImpression.multipageLink(jp1, jp2);
            }
        }
      UtilitaireImpression.imprimerEnUn(request, response, jp1, "GRAND_LIVRE_EXPORT", type);
        System.out.println("------- TAFAVOAKA");
        } catch (JRException ex) {
            ex.printStackTrace();
        } catch (IOException ex) {
            ex.printStackTrace();
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }
    private void balanceCompta(HttpServletRequest request, HttpServletResponse response) throws Exception {
       Connection c = null;
        try{
        String typecompte = request.getParameter("typeCompte"), mois1 = request.getParameter("moisDebut"), mois2 = request.getParameter("moisFin"), plage1 = request.getParameter("debutCompte"), plage2 = request.getParameter("finCompte"), exercice = request.getParameter("exercice"), date1 = request.getParameter("date1"), date2 = request.getParameter("date2");
        c = (new UtilDB()).GetConn();

        Balance balance;
        String nomfichier = "BALANCE_COMPTE_GENERAUX";
        if (typecompte.equals(ConstanteCompta.type_compte_auxiliaire)) {
            balance = new Balance(exercice, typecompte, mois1, mois2, plage1, plage2, true);
            nomfichier = "BALANCE_COMPTE_AUXILIAIRES";
        }else { 
            balance = new Balance(exercice, typecompte, mois1, mois2, plage1, plage2);
        } 
        BalanceDetails[] balanceDetails = balance.getBalanceDetails();
        System.out.println("balance details ="+balanceDetails.length);
         ArrayList<BalanceDetails> retour = new ArrayList<>();
        for(int i=0;i<balanceDetails.length;i++){
            if(balanceDetails[i].estValide()){
                    retour.addAll(Arrays.asList(balanceDetails[i]));
            }   
        }
        List dataSource = new ArrayList();
        Map param = new HashMap();
        param.put("DATE_MIN", date1);
        param.put("DATE_MAX", date2);
        param.put("DATE_JOUR", Utilitaire.dateDuJour());
        String dateEdition = "";
        int moisToSet1 = Integer.valueOf(mois1);
        int moisToSet2 = Integer.valueOf(mois2);
        if (moisToSet1 == moisToSet2) {
            dateEdition += Utilitaire.nbToMois(moisToSet1) + " " + exercice;
        } else {
            dateEdition += Utilitaire.nbToMois(moisToSet1) + " " + exercice + " - " + Utilitaire.nbToMois(moisToSet2) + " " + exercice;
        }
        param.put("DATE_EDITION", dateEdition);
        param.put("OPTION", plage1.startsWith("9") ? "ANALYTIQUE" : "GENERALE");
         dataSource.addAll(retour);
        setNomJasper("BALANCE_COMPTE_GENERAUX");
        UtilitaireImpression.imprimer(request, response, nomfichier, param, dataSource,getReportPath());
        } catch (Exception e) {
            e.printStackTrace();
        } 
        finally {
            if (c != null) {
                c.close();
            }
        }
    }

}
