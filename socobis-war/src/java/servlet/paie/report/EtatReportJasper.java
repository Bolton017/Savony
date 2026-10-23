/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlet.paie.report;

import bean.CGenUtil;
import configuration.Configuration;
//import facturefournisseur.EtatFacture;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.Arrays;
import java.sql.Date;
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
//import mg.amadia.data.FactureFournisseurFicheData;
//import mg.amadia.facture.FactureDetailFournisseur;
import paie.jasper.FichePaieA4;
import paie.log.Fiche_poste_Export;
import paie.log.LogPersonnelNonValide;
import paie.node.NodePersonnelFin;
import paie.avancement.PaieAvancement;
import paie.avancement.PaieAvancementLibelle;
import paie.employe.EmployeComplet;
import paie.employe.EmployeCompletPdf;
import paie.employe.PaieInfoPersonnelLib;
import reporting.ReportingUtils;
import servlet.UtilitaireImpression;
import utilitaire.Utilitaire;
//import mg.allosakafo.stock.*;
import paie.edition.FichePaie;
import paie.edition.PaieEditionDetails;
import paie.edition.PaieEditionmoisanneeLib;
import paie.employe.EmployeAvenant;
import paie.employe.EmployeContratTravail;
import paie.employe.PaieInfoPersonnelPdf;
import utilitaire.ChiffreLettre;
import utilitaire.UtilDB;
import configuration.Configuration;

/**
 *
 * @author Axel
 */
@WebServlet(name = "EtatReportJasper", urlPatterns = {"/EtatReportJasper"})
public class EtatReportJasper extends HttpServlet {

    String nomJasper = "";

    NodePersonnelFin nf;

    public String getReportPath() throws IOException {
        return getServletContext().getRealPath(File.separator + "report" + File.separator + getNomJasper() + ".jasper");
    }

    public String getNomJasper() {
        return nomJasper;
    }

    public void setNomJasper(String nomJasper) {
        this.nomJasper = nomJasper;
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws Exception {
        try {
            
            String action = request.getParameter("action");
            
  
            System.out.println("Action ="+action);
            if (action.equalsIgnoreCase("fiche_poste")) {
                fiche_poste(request, response);
            } else if (action.equalsIgnoreCase("contrat_travail")) {
                contrat_travails(request, response);
            } else if (action.equalsIgnoreCase("contrat_travail_avenant")) {
                contrat_travails_avenant(request, response);
            }else if (action.equalsIgnoreCase("fiche_de_paie")) {
                fiche_de_paie(request, response);
            }else if (action.equalsIgnoreCase("factureFournisseur")) {
       //         factureFournisseur(request, response);
            }else if (action.equalsIgnoreCase("ficheLivraison")) {
       //         ficheLivraison(request, response);
            }else if (action.equalsIgnoreCase("etatPaiePdf")) {
                etatPaiePdf(request, response);
            }else if (action.equalsIgnoreCase("etatPaiePdfextra")) {
                etatPaiePdfextra(request, response);
            }else if (action.equalsIgnoreCase("fin_periode_essai")) {
                fin_periode_essai(request, response);
            }else if (action.equalsIgnoreCase("concluant")) {
                concluant(request, response);
            }else if (action.equalsIgnoreCase("rupture")) {
                rupture(request, response);
            }else if (action.equalsIgnoreCase("renouvellement")) {
                renouvellement(request, response);
            }else if (action.equalsIgnoreCase("notification_rupture")) {
                notification_rupture(request, response);
            }else if (action.equalsIgnoreCase("attestation")) {
                attestation(request, response);
            }else if (action.equalsIgnoreCase("certificat_mortalite")) {
                certificat_mortalite(request, response);
            }

        } catch (Exception ex) {
            ex.printStackTrace();
            response.setContentType("text/html");
            //response.setBufferSize(8192);
            PrintWriter out = response.getWriter();
            out.println("<html>");
            out.println("<head>");
            out.println("<script>alert('" + ex.getMessage() + "');history.back();</script>");
            out.println("</head>");
            out.println("</html>");
            out.close();

            throw ex;
        }
    }

    private void contrat_travail(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String id = request.getParameter("id");
        EmployeCompletPdf tmp = new EmployeCompletPdf();
        tmp.setId(request.getParameter("id"));
        EmployeCompletPdf e = tmp.findPdf(tmp);
        HashMap param = new HashMap();
        
        param.put("nom", e.getNom());
        param.put("prenom", e.getPrenom());
        param.put("sexe", e.getSexePdf());
        param.put("genre", e.getGenrePdf());
        param.put("nomcomplet", e.check(e.getNom() + " " + e.getPrenom(), 20));
        param.put("matricule", e.getMatricule());
        param.put("date_naissance", utilitaire.Utilitaire.formatterDaty(e.getDate_naissance()) + "");
        param.put("lieu_naissance_commune", e.getLieu_naissance_commune());
        param.put("adresse", e.check(e.getAdresse(), 10));
        param.put("numero_cin", utilitaire.Utilitaire.separerEnMillier(e.getNumero_cin()));
        param.put("date_cin", utilitaire.Utilitaire.formatterDaty(e.getDate_cin()) + "");
        param.put("dateembauche", utilitaire.Utilitaire.formatterDaty(e.getDateembauche()) + "");
        param.put("idcategorie_paie", e.check(e.getIdcategorie_paie(), 10));
        param.put("idcategorie", e.check(e.getIdcategorie(), 10));
        param.put("idfonction", e.check(e.getIdfonction(), 10));
        param.put("duree", e.check(utilitaire.ChiffreLettre.convertRealToString(e.getDuree()), 2));
        param.put("idqualification", e.check(e.getIdqualification(), 10));
        param.put("montant", e.check((e.getMontant() == 0 ? "" : utilitaire.Utilitaire.formaterAr(e.getMontant())), 4));
        param.put("montantlettre", e.check((e.getMontant() == 0 ? "" : utilitaire.ChiffreLettre.convertRealToStringDevise(e.getMontant(), "Ariary")), 10));
        
        
        
        List dataSources = null;
        ReportingUtils.ReportType rt = ReportingUtils.ReportType.PDF;
        setNomJasper("contrat_de_travail");
        UtilitaireImpression.imprimer(request, response, "contrat_de_travail", param, dataSources, getReportPath(), rt);
    }
    
    private void contrat_travails(HttpServletRequest request, HttpServletResponse response) throws Exception {

        String[] val = request.getParameterValues("ids");
        EmployeContratTravail emp_ctr = new EmployeContratTravail();
        ArrayList<EmployeContratTravail> e = emp_ctr.getData(val);
        ArrayList<PaieInfoPersonnelPdf> fps =  emp_ctr.ToPipPdf(e);
        String nomPdf="contrat_de_travail";
        for(int i=0;i<e.size();i++){
            HashMap param = new HashMap();
            List dataSources = new ArrayList();
            dataSources.addAll(fps);
            ReportingUtils.ReportType rt = ReportingUtils.ReportType.PDF;
            setNomJasper("contrat_de_travail");
            if(e.size()==1)nomPdf+="_"+e.get(i).getMatricule();
            UtilitaireImpression.imprimer(request, response, nomPdf, param, dataSources, getReportPath(), rt);        
        }
    }
    
    private void contrat_travails_avenant(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String[] val = request.getParameterValues("ids");
        EmployeAvenant emp_ctr = new EmployeAvenant();
        ArrayList<EmployeContratTravail> e = emp_ctr.getDataAvenant(val);
        ArrayList<PaieInfoPersonnelPdf> fps =  emp_ctr.ToPipPdfAvenant(e);
        String nomPdf="avenant_salaire";
        for(int i=0;i<e.size();i++){
            HashMap param = new HashMap();
            List dataSources = new ArrayList();
            dataSources.addAll(fps);
            ReportingUtils.ReportType rt = ReportingUtils.ReportType.PDF;
            setNomJasper("avenant_salaire");
            if(e.size()==1)nomPdf+="_"+e.get(i).getMatricule();
            UtilitaireImpression.imprimer(request, response, nomPdf, param, dataSources, getReportPath(), rt);        
        }

    }        

    private void fin_periode_essai(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String id = request.getParameter("id");
        EmployeCompletPdf tmp = new EmployeCompletPdf();
        tmp.setId(request.getParameter("id"));
        EmployeCompletPdf e = tmp.findPdf(tmp);
        HashMap param = new HashMap();
        if(this.getNf()==null){
            findpremier();
       }
        if(this.getNf()!=null){
            param.put("nomsecretaire", nf.getNom());
            param.put("prenomsecretaire", nf.getPrenom());
        }else {
            param.put("nomsecretaire", "Nom");
            param.put("prenomsecretaire", "Prenom");
        }
        param.put("nom", e.getNom());
        param.put("prenom", e.getPrenom());
        param.put("sexe", e.getSexePdf());
        param.put("matricule", e.getMatricule());
        param.put("nomcomplet", e.check(e.getNom() + " " + e.getPrenom(), 20));
        String datefinstring=Utilitaire.ajoutMoisDateString(e.getDateembauche(),e.getIndesirable());
        Date datefin=Utilitaire.string_date("dd/MM/yyyy", datefinstring);
        int mois=Utilitaire.getMois(datefin);
        String moisString=Utilitaire.nbToMois(mois);
        param.put("datefin", e.check(Utilitaire.getJour(datefinstring)+" "+moisString+" "+Utilitaire.getAnnee(datefin), 20));
        param.put("poste", e.check(e.getIdfonction(), 10));

        List dataSources = null;
        ReportingUtils.ReportType rt = ReportingUtils.ReportType.PDF;
        setNomJasper("fin_periode_essai");
        UtilitaireImpression.imprimer(request, response, "fin_periode_essai", param, dataSources, getReportPath(), rt);
    }

    private void attestation(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String id = request.getParameter("id");
        EmployeCompletPdf tmp = new EmployeCompletPdf();
        tmp.setId(request.getParameter("id"));
        EmployeCompletPdf e = tmp.findPdf(tmp);
        HashMap param = new HashMap();
        if(this.getNf()==null){
            findpremier();
       }
        if(this.getNf()!=null){
            param.put("nomsecretaire", nf.getNom());
            param.put("prenomsecretaire", nf.getPrenom());
        }else {
            param.put("nomsecretaire", "Nom");
            param.put("prenomsecretaire", "Prenom");
        }
        param.put("nom", e.getNom());
        param.put("prenom", e.getPrenom());
        param.put("sexe", e.getSexePdf());
        param.put("matricule", e.getMatricule());
        param.put("nomcomplet", e.check(e.getNom() + " " + e.getPrenom(), 20));
        /*
         * Vérifier s'il est déja renvoyer 
         */
        LogPersonnelNonValide templp =new LogPersonnelNonValide();
        templp.setIdlogpers(id);
        LogPersonnelNonValide lp=templp.find(templp);
        PaieAvancementLibelle tempav =new PaieAvancementLibelle();
        tempav.setIdpers(id);
            /*
            * Idmotif de pai avancement de personnel renvoyer TYD000008
            */
        tempav.setIdmotif("TYD000008");
        tempav.setNomTable("paie_avancement_libelle5");
        PaieAvancementLibelle [] histoav =tempav.findbymotif(tempav);
        String histoposte="";
        if(lp==null){
            //Encours de contrat
            histoposte+="travaille au sein du Fonds Routier en qualité de";
        }
        if(lp!=null){
            //Rupture de contrat
            histoposte+="a travaillé au sein du Fonds Routier en qualité de";
        }
            if(histoav.length<=1){
                String datedebutstring=Utilitaire.datetostring(e.getDateembauche());
                Date dated=Utilitaire.string_date("dd/MM/yyyy", datedebutstring);
                int mois=Utilitaire.getMois(dated);
                String moisString=Utilitaire.nbToMois(mois);
                String contrat="";
                PaieInfoPersonnelLib tip = new PaieInfoPersonnelLib();
                tip.setNomTable("paie_info_personnel_lib4");
                tip.setId(id);
                PaieInfoPersonnelLib tempip =tip.find(tip);
                if(tempip.getTypecontrat().equalsIgnoreCase("CDI")){
                    contrat+="pour une durée indéterminée.";
                }
                if(tempip.getTypecontrat().equalsIgnoreCase("STAGIAIRE")){
                    contrat+="comme stagiaire.";
                }
                if(tempip.getTypecontrat().equalsIgnoreCase("CONSULTANT")){
                    contrat+="comme consultant.";
                }
                if(tempip.getTypecontrat().equalsIgnoreCase("DETACHEMENT")){
                    contrat+="comme detachement.";
                }
                if(tempip.getTypecontrat().equalsIgnoreCase("CDD")){
                    String datefinstring=Utilitaire.ajoutMoisDateString(e.getDateembauche(),e.getIndesirable());
                    Date datefin=Utilitaire.string_date("dd/MM/yyyy", datefinstring);
                    int moisf=Utilitaire.getMois(datefin);
                    String moisStringf=Utilitaire.nbToMois(moisf);
                    contrat+="jusqu'au "+Utilitaire.getJour(datefinstring)+" "+moisStringf+" "+Utilitaire.getAnnee(datefin)+".";
                }
                histoposte+="« "+e.getIdfonction()+" » depuis le "+Utilitaire.getJour(datedebutstring)+" "+moisString+" "+Utilitaire.getAnnee(dated)+" "+contrat;
            } else {
                for(int i=histoav.length-1;i>-1;i--) {
                    PaieAvancementLibelle encav=histoav[i];
                    //Debut contrat
                    String datedebutstring=Utilitaire.datetostring(encav.getDate_application());
                    Date dated=Utilitaire.string_date("dd/MM/yyyy", datedebutstring);
                    int mois=Utilitaire.getMois(dated);
                    String moisString=Utilitaire.nbToMois(mois);
                    String debut=Utilitaire.getJour(datedebutstring)+" "+moisString+" "+Utilitaire.getAnnee(dated);

                    if(i!=0){
                        PaieAvancementLibelle nextav=histoav[i-1];
                        //Fin contrat
                        String datefinstring=Utilitaire.datetostring(nextav.getDate_application());
                        Date datefin=Utilitaire.string_date("dd/MM/yyyy", datefinstring);
                        int moisf=datefin.getMonth()+1;
                        String moisStringf=Utilitaire.nbToMois(moisf);
                        String fin=Utilitaire.getJour(datefinstring)+" "+moisStringf+" "+Utilitaire.getAnnee(datefin);
                        histoposte+="« "+encav.getIdfonction()+" » du "+debut+" jusqu’au "+fin+",";
                    }
                    if(i==0){
                        String contrat="";
                        PaieInfoPersonnelLib tip = new PaieInfoPersonnelLib();
                        tip.setNomTable("paie_info_personnel_lib4");
                        tip.setId(id);
                        PaieInfoPersonnelLib tempip =tip.find(tip);
                        if(lp==null){
                            if(tempip.getTypecontrat().equalsIgnoreCase("CDI")){
                                contrat+="pour une durée indéterminée.";
                            }
                            if(tempip.getTypecontrat().equalsIgnoreCase("STAGIAIRE")){
                                contrat+="comme stagiaire.";
                            }
                            if(tempip.getTypecontrat().equalsIgnoreCase("CONSULTANT")){
                                contrat+="comme consultant.";
                            }
                            if(tempip.getTypecontrat().equalsIgnoreCase("DETACHEMENT")){
                                contrat+="comme detachement.";
                            }
                            if(tempip.getTypecontrat().equalsIgnoreCase("CDD")){
                                String datefinstring=Utilitaire.ajoutMoisDateString(encav.getDate_application(),e.getIndesirable());
                                Date datefin=Utilitaire.string_date("dd/MM/yyyy", datefinstring);
                                int moisf=Utilitaire.getMois(datefin);
                                String moisStringf=Utilitaire.nbToMois(moisf);
                                contrat+="jusqu'au "+Utilitaire.getJour(datefinstring)+" "+moisStringf+" "+Utilitaire.getAnnee(datefin)+".";
                            }
                        } else {
                            String datefinstring=Utilitaire.datetostring(lp.getDateapplication());
                            Date datefin=Utilitaire.string_date("dd/MM/yyyy", datefinstring);
                            int moisf=Utilitaire.getMois(datefin);
                            String moisStringf=Utilitaire.nbToMois(moisf);
                            contrat+="jusqu'au "+Utilitaire.getJour(datefinstring)+" "+moisStringf+" "+Utilitaire.getAnnee(datefin)+".";
                        }
                        histoposte+="« "+encav.getIdfonction()+" » depuis le "+Utilitaire.getJour(datedebutstring)+" "+moisString+" "+Utilitaire.getAnnee(dated)+" "+contrat;
                    }
                }
            }
        param.put("histoposte", histoposte);


        List dataSources = null;
        ReportingUtils.ReportType rt = ReportingUtils.ReportType.PDF;
        setNomJasper("attestation");
        UtilitaireImpression.imprimer(request, response, "attestation", param, dataSources, getReportPath(), rt);
    }

    private void renouvellement(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String id = request.getParameter("id");
        EmployeCompletPdf tmp = new EmployeCompletPdf();
        tmp.setId(request.getParameter("id"));
        EmployeCompletPdf e = tmp.findPdf(tmp);
        HashMap param = new HashMap();
        if(this.getNf()==null){
            findpremier();
       }
        if(this.getNf()!=null){
            param.put("nomsecretaire", nf.getNom());
            param.put("prenomsecretaire", nf.getPrenom());
        }else {
            param.put("nomsecretaire", "Nom");
            param.put("prenomsecretaire", "Prenom");
        }
        param.put("nom", e.getNom());
        param.put("prenom", e.getPrenom());
        param.put("sexe", e.getSexePdf());
        param.put("matricule", e.getMatricule());
        param.put("nomcomplet", e.check(e.getNom() + " " + e.getPrenom(), 20));
        String datefinstring=Utilitaire.ajoutMoisDateString(e.getDateembauche(),e.getIndesirable());
        Date datefin=Utilitaire.string_date("dd/mm/yyyy", datefinstring);
        int mois=Utilitaire.getMois(datefin);
        String moisString=Utilitaire.nbToMois(mois);
        param.put("datefin", e.check(Utilitaire.getJour(datefinstring)+" "+moisString+" "+Utilitaire.getAnnee(datefin), 20));
        param.put("poste", e.check(e.getIdfonction(), 10));

        List dataSources = null;
        ReportingUtils.ReportType rt = ReportingUtils.ReportType.PDF;
        setNomJasper("renouvellement");
        UtilitaireImpression.imprimer(request, response, "renouvellement_contrat", param, dataSources, getReportPath(), rt);
    }

    private void rupture(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String id = request.getParameter("id");
        EmployeCompletPdf tmp = new EmployeCompletPdf();
        tmp.setId(request.getParameter("id"));
        EmployeCompletPdf e = tmp.findPdf(tmp);
        HashMap param = new HashMap();
        if(this.getNf()==null){
            findpremier();
       }
        if(this.getNf()!=null){
            param.put("nomsecretaire", nf.getNom());
            param.put("prenomsecretaire", nf.getPrenom());
        }else {
            param.put("nomsecretaire", "Nom");
            param.put("prenomsecretaire", "Prenom");
        }
        param.put("nom", e.getNom());
        param.put("prenom", e.getPrenom());
        param.put("sexe", e.getSexePdf());
        param.put("matricule", e.getMatricule());
        param.put("nomcomplet", e.check(e.getNom() + " " + e.getPrenom(), 20));
        String datefinstring=Utilitaire.ajoutMoisDateString(e.getDateembauche(),e.getIndesirable());
        Date datefin=Utilitaire.string_date("dd/mm/yyyy", datefinstring);
        int mois=Utilitaire.getMois(datefin);
        String moisString=Utilitaire.nbToMois(mois);
        param.put("datefin", e.check(Utilitaire.getJour(datefinstring)+" "+moisString+" "+Utilitaire.getAnnee(datefin), 20));
        param.put("poste", e.check(e.getIdfonction(), 10));

        List dataSources = null;
        ReportingUtils.ReportType rt = ReportingUtils.ReportType.PDF;
        setNomJasper("rupture");
        UtilitaireImpression.imprimer(request, response, "rupture_de_contrat", param, dataSources, getReportPath(), rt);
    }

    private void notification_rupture(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String id = request.getParameter("id");
        EmployeCompletPdf tmp = new EmployeCompletPdf();
        tmp.setId(request.getParameter("id"));
        EmployeCompletPdf e = tmp.findPdf(tmp);
        HashMap param = new HashMap();
        if(this.getNf()==null){
            findpremier();
       }
        if(this.getNf()!=null){
            param.put("nomsecretaire", nf.getNom());
            param.put("prenomsecretaire", nf.getPrenom());
        }else {
            param.put("nomsecretaire", "Nom");
            param.put("prenomsecretaire", "Prenom");
        }
        param.put("nom", e.getNom());
        param.put("prenom", e.getPrenom());
        param.put("sexe", e.getSexePdf());
        param.put("matricule", e.getMatricule());
        param.put("nomcomplet", e.check(e.getNom() + " " + e.getPrenom(), 20));
        String datefinstring=Utilitaire.ajoutMoisDateString(e.getDateembauche(),e.getIndesirable());
        Date datefin=Utilitaire.string_date("dd/mm/yyyy", datefinstring);
        int mois=Utilitaire.getMois(datefin);
        String moisString=Utilitaire.nbToMois(mois);
        param.put("datefin", e.check(Utilitaire.getJour(datefinstring)+" "+moisString+" "+Utilitaire.getAnnee(datefin), 20));
        param.put("poste", e.check(e.getIdfonction(), 10));

        List dataSources = null;
        ReportingUtils.ReportType rt = ReportingUtils.ReportType.PDF;
        setNomJasper("notification_rupture");
        UtilitaireImpression.imprimer(request, response, "notification_rupture_de_contrat", param, dataSources, getReportPath(), rt);
    }

    private void concluant(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String id = request.getParameter("id");
        EmployeCompletPdf tmp = new EmployeCompletPdf();
        tmp.setId(request.getParameter("id"));
        EmployeCompletPdf e = tmp.findPdf(tmp);
        HashMap param = new HashMap();
       if(this.getNf()==null){
            findpremier();
       }
        if(this.getNf()!=null){
            param.put("nomsecretaire", nf.getNom());
            param.put("prenomsecretaire", nf.getPrenom());
        }else {
            param.put("nomsecretaire", "Nom");
            param.put("prenomsecretaire", "Prenom");
        }
        param.put("nom", e.getNom());
        param.put("prenom", e.getPrenom());
        param.put("sexe", e.getSexePdf());
        param.put("matricule", e.getMatricule());
        param.put("nomcomplet", e.check(e.getNom() + " " + e.getPrenom(), 20));
        param.put("poste", e.check(e.getIdfonction(), 10));
        List dataSources = null;
        ReportingUtils.ReportType rt = ReportingUtils.ReportType.PDF;
        setNomJasper("concluant");
        UtilitaireImpression.imprimer(request, response, "concluant", param, dataSources, getReportPath(), rt);
    }

    private void certificat_mortalite(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String id = request.getParameter("id");
        EmployeCompletPdf tmp = new EmployeCompletPdf();
        tmp.setId(request.getParameter("id"));
        EmployeCompletPdf e = tmp.findPdf(tmp);
        HashMap param = new HashMap();
      
        if(this.getNf()==null){
            findpremier();
       }
        if(this.getNf()!=null){
            param.put("nomsecretaire", nf.getNom());
            param.put("prenomsecretaire", nf.getPrenom());
        }else {
            param.put("nomsecretaire", "Nom");
            param.put("prenomsecretaire", "Prenom");
        }
        param.put("nom", e.getNom());
        param.put("prenom", e.getPrenom());
        param.put("sexe", e.getSexePdf());
        param.put("persosujet", e.getPronompersonnelsujet());
        param.put("nomcomplet", e.check(e.getNom() + " " + e.getPrenom(), 20));
        param.put("poste", e.check(e.getIdfonction(), 10));

        List dataSources = null;
        ReportingUtils.ReportType rt = ReportingUtils.ReportType.PDF;
        setNomJasper("certificat_mortalite");
        UtilitaireImpression.imprimer(request, response, "certificat_mortalite", param, dataSources, getReportPath(), rt);
    }
    
    private void fiche_poste(HttpServletRequest request, HttpServletResponse response) throws Exception {
        try {
            String id = request.getParameter("id");
            HashMap param = new HashMap();
            List dataSources = new ArrayList();
            Fiche_poste_Export tmp = new Fiche_poste_Export();
            tmp.setId(request.getParameter("id"));
            tmp.setNomTable("fiche_poste_lib");
            Fiche_poste_Export fpe = tmp.getFichePost();
            dataSources.addAll(Arrays.asList(fpe));
            ReportingUtils.ReportType rt = ReportingUtils.ReportType.PDF;
            setNomJasper("fiche_poste");
            UtilitaireImpression.imprimer(request, response, "fiche_poste", param, dataSources, getReportPath(), rt);
        } catch (Exception e) {
            e.printStackTrace();
            e.getMessage();
        }
    }

    private void fiche_de_paie(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String mois = request.getParameter("mois");
        String annee = request.getParameter("annee");
        String edition = request.getParameter("edition");
        setNomJasper("BULLETIN_INDIVIDUEL");
        FichePaie fp = new FichePaie();
        List<FichePaie> fps  = fp.getListFichePaieEdition(edition);
//        List<FichePaieA4> listA4 =  FichePaieA4.listFichePaieIndividuel(fps );
        Map param = new HashMap();
        List dataSource = new ArrayList();
        
        for(FichePaie fptest:fps){
            System.out.println("Valeur Matricule====>"+fptest.getMatricule()+" Valeur Net a payer=====>"+fptest.getNet_a_payer());
        }
        
        dataSource.addAll(fps);
        UtilitaireImpression.imprimer(request, response, "Fiche_de_paie", param, dataSource, getReportPath());
    }
        
    /*
    private void factureFournisseur(HttpServletRequest request, HttpServletResponse response) throws Exception {
        System.out.println(" FACTURE EH !! ");
        String id = request.getParameter("id");
        
        EtatFacture fact = new EtatFacture();
        fact.setNomTable("etat_ff_avecavoir_etat");
        fact.setId(id);
        EtatFacture[] facture_tab = (EtatFacture[]) CGenUtil.rechercher(fact, null, null, null, "");
        
        Map param = new HashMap();
        if(facture_tab.length > 0){
            param.put("id", facture_tab[0].getId());
            param.put("daty", facture_tab[0].getDaty());
            param.put("tiers", facture_tab[0].getTiers());
            param.put("remarque", facture_tab[0].getRemarque());
            param.put("designation", facture_tab[0].getDesignation());
            param.put("devise", facture_tab[0].getDevise());
            param.put("montantttc", facture_tab[0].getMontantttc());
            param.put("montanttva", facture_tab[0].getMontanttva());
            param.put("remise", facture_tab[0].getRemise());
            param.put("montantPaye", facture_tab[0].getMontantPaye());
            param.put("reste", facture_tab[0].getReste());
            param.put("avoir", facture_tab[0].getAvoir());
        }
        
        FactureFournisseurFicheData ffsd = new FactureFournisseurFicheData(id);
        FactureDetailFournisseur[] listeFd = ffsd.getListeFd();
        
        List dataSource = new ArrayList();
        dataSource.addAll(Arrays.asList(listeFd));
                
        setNomJasper("facture-fournisseur-cemedi");
        UtilitaireImpression.imprimer(request, response, "facture-fournisseur-cemedi", param, dataSource, getReportPath());
    
    }*/
    
    /*
    private void ficheLivraison(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String id = request.getParameter("id");
        BonDeLivraisonLibComplet bl = new BonDeLivraisonLibComplet();
        bl.setId(id);
        bl.setNomTable("AS_BONLIVRAISONLIB_CMPL");
        BonDeLivraisonLibComplet[] sdas = (BonDeLivraisonLibComplet[]) CGenUtil.rechercher(bl, null, null, null, "");
        BonDeLivraisonDateFournisseur fille = new BonDeLivraisonDateFournisseur();
        fille.setNomTable("as_bondelivraison_fille_reste");
        BonDeLivraisonDateFournisseur[] filles = (BonDeLivraisonDateFournisseur[]) CGenUtil.rechercher(fille, null, null, " AND NUMBL = '" + id + "'");
        Map param = new HashMap();
        if (sdas.length != 0) {
            param.put("ID", sdas[0].getId());
            param.put("DATE", Utilitaire.formatterDaty(sdas[0].getDaty()));
            param.put("idbc", sdas[0].getIdbc());
            param.put("point", sdas[0].getPoint());
            param.put("fournisseur", sdas[0].getFournisseurlib());
            param.put("remarque", sdas[0].getRemarque());
        }
        List dataSource = new ArrayList();
        dataSource.addAll(Arrays.asList(filles));
        setNomJasper("FICHE_LIVRAISON2");
        UtilitaireImpression.imprimer(request, response, "FICHE_LIVRAISON", param, dataSource, getReportPath());
    }*/
    private void etatPaiePdf(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Connection c = null;
        try{
        c = new UtilDB().GetConn();
        ReportingUtils.ReportType rt =  request.getParameter("xls") !=null && request.getParameter("xls").equals("xls") ? ReportingUtils.ReportType.XLSX : ReportingUtils.ReportType.PDF ; 
        PaieEditionDetails dts = new PaieEditionDetails();
        String nomTable = "details_paie_edition_finalpdf";
        dts.setNomTable(nomTable);
        String idedition = request.getParameter("idedition");    
        
        PaieEditionmoisanneeLib paie = new PaieEditionmoisanneeLib();
        paie.setNomTable("PAIE_EDITIONMOISANNEE_lib");
        PaieEditionmoisanneeLib[] mere = (PaieEditionmoisanneeLib[]) CGenUtil.rechercher( paie, null, null,c, " and id='"+ idedition+"'");
        
        PaieEditionDetails[] lsdts = (PaieEditionDetails[]) CGenUtil.rechercher(dts, null, null,c, " and idedition='"+ idedition +"'  order by matricule asc");
        Map param = new HashMap();
        double totale = 0;
        for(int i=0; i<lsdts.length; i++){
            totale = totale + lsdts[i].getNet_a_payer();
            lsdts[i].setSalaire_de_base(lsdts[i].getJuillet());
        }
        
        param.put("montantlettre", ChiffreLettre.convertRealToString(new Double(totale)) + " Ariary");
//        param.put("mois", lsdts[0].getMois());
        param.put("mois_lettre",  Utilitaire.nbToMois(lsdts[0].getMois() ) );
        param.put("annee", lsdts[0].getAnnee()+"");
        if(mere[0].getDaty()!=null){
            param.put("date_jours", Utilitaire.getDateEnLettre( utilitaire.Utilitaire.datetostring(mere[0].getDaty())  )  );
        }else{
            param.put("date_jours","");
        }
        Configuration[] conf  = (Configuration[]) CGenUtil.rechercher(new Configuration(), null,null, " and id='CONFSIGN' ");
        if( conf != null ){
   //         param.put("signataie_1", conf[0].getValmin());
   //         param.put("signataie_2", conf[0].getValmax());       
        }
        
        List dataSource = new ArrayList();
        dataSource.addAll(Arrays.asList(lsdts));
        setNomJasper("EDITION_PAIE");
        UtilitaireImpression.imprimer(request, response, "edition_de_paie", param, dataSource, getReportPath(),rt );
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if (c != null) {
                c.close();
            }
        }
    }
    
    private void etatPaiePdfextra(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Connection c = null;
        try{
        c = new UtilDB().GetConn();
        ReportingUtils.ReportType rt =  request.getParameter("xls") !=null && request.getParameter("xls").equals("xls") ? ReportingUtils.ReportType.XLSX : ReportingUtils.ReportType.PDF ; 
        PaieEditionDetails dts = new PaieEditionDetails();
        String nomTable = "details_paie_edition_extra_finalpdf2";
        dts.setNomTable(nomTable);
        String idedition = request.getParameter("idedition");    
        
        PaieEditionmoisanneeLib paie = new PaieEditionmoisanneeLib();
        paie.setNomTable("PAIE_EDITIONMOISANNEE_extra_lib");
        PaieEditionmoisanneeLib[] mere = (PaieEditionmoisanneeLib[]) CGenUtil.rechercher( paie, null, null,c, " and id='"+ idedition+"'");
        
        PaieEditionDetails[] lsdts = (PaieEditionDetails[]) CGenUtil.rechercher(dts, null, null,c, " and idedition='"+ idedition +"'  order by matricule asc");
        Map param = new HashMap();
        double totale = 0;
        for(int i=0; i<lsdts.length; i++){
            totale = totale + lsdts[i].getNet_a_payer();
            lsdts[i].setSalaire_de_base(lsdts[i].getJuillet());
        }
        
        param.put("montantlettre", ChiffreLettre.convertRealToString(new Double(totale)) + " Ariary");
//        param.put("mois", lsdts[0].getMois());
        param.put("mois_lettre",  Utilitaire.nbToMois(  lsdts[0].getMois() ) );
        param.put("annee", lsdts[0].getAnnee()+"");
        if(mere[0].getDaty()!=null){
            param.put("date_jours", Utilitaire.getDateEnLettre( utilitaire.Utilitaire.datetostring(mere[0].getDaty())  )  );
        }else{
            param.put("date_jours","");
        }
        Configuration[] conf  = (Configuration[]) CGenUtil.rechercher(new Configuration(), null,null, " and id='CONFSIGN' ");
        if( conf != null ){
   //         param.put("signataie_1", conf[0].getValmin());
   //         param.put("signataie_2", conf[0].getValmax());       
        }
        
        List dataSource = new ArrayList();
        dataSource.addAll(Arrays.asList(lsdts));
        setNomJasper("EDITION_PAIE");
        UtilitaireImpression.imprimer(request, response, "edition_de_paie", param, dataSource, getReportPath(),rt );
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if (c != null) {
                c.close();
            }
        }
    }


    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (Exception ex) {
            Logger.getLogger(EtatReportJasper.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (Exception ex) {
            Logger.getLogger(EtatReportJasper.class.getName()).log(Level.SEVERE, null, ex);
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
    }// </editor-fold>

    public NodePersonnelFin getNf() {
        return nf;
    }

    public void setNf(NodePersonnelFin nf) {
        this.nf = nf;
    }

    public void findpremier()throws Exception{
        NodePersonnelFin test=new NodePersonnelFin();
        test.setNomTable("Rangnodes");
        NodePersonnelFin [] lnf=(NodePersonnelFin[]) CGenUtil.rechercher(test, null, null, null, " and rang=1" );
      
       if(lnf.length>0){
        this.setNf(lnf[0]);
        } 
    }
}
