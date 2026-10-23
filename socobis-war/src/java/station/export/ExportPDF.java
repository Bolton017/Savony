
/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package socobis.export;


import bean.AdminGen;
import bean.CGenUtil;
import caisse.ClotureCaisse;
import caisse.MvtCaisseCpl;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.Date;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServletResponseWrapper;

import caisse.MvtCaisseParCaissePDF;
import declaration.DeclarationTva;
import declaration.DeclarationTvaLib;
import declaration.ImprimerDeclaration;
import magasin.Magasin;
import net.sf.jasperreports.engine.JRException;
import produits.IngredientsRemise;
import proforma.ProformaDetailsLib;
import proforma.ProformaLib;
import reporting.ReportingCdn;
import societe.Societe;
import stock.MvtStockFilleTheorique;
import user.UserEJB;
import utils.ConstanteAsync;
import web.mg.cnaps.servlet.etat.UtilitaireImpression;
import encaissement.*;
import fabrication.*;

import java.util.Arrays;
import java.util.Comparator;
import java.util.Collections;
import org.xhtmlrenderer.css.style.derived.StringValue;
import prelevement.PrelevementPompiste;
import utils.ConstanteVente;
import vente.*;
import faturefournisseur.*;
import client.*;
import faturefournisseur.historique.HistoriqueValidationDmdAchat;
import utilitaire.*;
import faturefournisseur.proforma.*;
import stock.TransfertStockCpl;
import stock.TransfertStockDetailsCpl;
import stock.MvtStockFilleLib;
import stock.MvtStockLib;

import java.util.stream.Collectors;
/**
 *
 * @author Admin
 */
@WebServlet(name = "ExportPDF", urlPatterns = {"/ExportPDF"})
public class ExportPDF extends HttpServlet {
    String nomJasper = "";
    ReportingCdn.Fonctionnalite fonctionnalite = ReportingCdn.Fonctionnalite.RECETTE;
    
    public String getReportPath() throws IOException {
        return getServletContext().getRealPath(File.separator + "report" + File.separator + getNomJasper() + ".jasper");
    }
    public String getNomJasper() {
        return nomJasper;
    }

    public void setNomJasper(String nomJasper) {
        this.nomJasper = nomJasper;
    }

    private static class InlineDispositionResponse extends HttpServletResponseWrapper {

        InlineDispositionResponse(HttpServletResponse response) {
            super(response);
        }

        @Override
        public void addHeader(String name, String value) {
            if ("Content-disposition".equalsIgnoreCase(name)) {
                setHeader(name, value);
                return;
            }
            super.addHeader(name, value);
        }

        @Override
        public void setHeader(String name, String value) {
            if ("Content-disposition".equalsIgnoreCase(name)) {
                super.setHeader("Content-Disposition", toInline(value));
                return;
            }
            super.setHeader(name, value);
        }

        private static String toInline(String value) {
            String fn = "";
            if (value != null) {
                int i = value.toLowerCase().indexOf("filename=");
                if (i >= 0) {
                    fn = value.substring(i + "filename=".length())
                            .replace("\"", "").replace("\r", "").replace("\n", "").trim();
                }
            }
            return fn.isEmpty() ? "inline" : "inline; filename=\"" + fn + "\"";
        }
    }

    private static String htmlEscape(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
                .replace("\"", "&quot;").replace("'", "&#39;");
    }

    /**
     * Rend l'erreur DANS l'iframe d'apercu : une redirection y reafficherait
     * l'application entiere imbriquee dans le modal.
     * Entites HTML plutot que des accents litteraux : les sources sont en UTF-8 mais Ant
     * compile en iso-8859-1, un accent litteral sortirait double-encode dans le navigateur.
     */
    private static void rendreErreurApercu(HttpServletResponse response, String error) throws IOException {
        try {
            response.reset();
        } catch (IllegalStateException dejaCommittee) {
            // PDF deja partiellement ecrit : plus rien a reinitialiser, on laisse le flux tel quel.
            return;
        }
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        out.println("<html><body style=\"font-family:sans-serif;padding:24px;color:#a94442;background:#fff\">");
        out.println("<h3>Impossible de g&eacute;n&eacute;rer le PDF</h3>");
        out.println("<p>" + htmlEscape(error) + "</p>");
        out.println("</body></html>");
        out.flush();
    }

    private static boolean estApercu(HttpServletRequest request) {
        return "1".equals(request.getParameter("inline"));
    }

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, Exception {
        String action = request.getParameter("action");
        if (estApercu(request)) {
            response.setContentType("application/pdf");
            response.setHeader("X-Content-Type-Options", "nosniff");
            response = new InlineDispositionResponse(response);
        }
        if (action.equalsIgnoreCase("fiche_encaissement")) impressionEncaissement(request, response);
        if (action.equalsIgnoreCase("fiche_encaissement_pompiste")) impressionEncaissementPompist(request, response);
        if (action.equalsIgnoreCase("fiche_vente")) fiche_vente(request, response);
        if (action.equalsIgnoreCase("fiche_bc")) fiche_bc(request, response);
        if (action.equalsIgnoreCase("fiche_transfert")) fiche_transfert(request, response);
        if (action.equalsIgnoreCase("fiche_ff")) fiche_ff(request, response);
        if (action.equalsIgnoreCase("fiche_bl")) fiche_bl(request, response);
        if (action.equalsIgnoreCase("fiche_ordre_fabrication")) fiche_ordre_fabrication(request, response);
        if (action.equalsIgnoreCase("fiche_vente_nouveau")) fiche_vente_nouveau(request, response);
        if (action.equalsIgnoreCase("situation_globale")) situation_globale(request, response);
        if (action.equalsIgnoreCase("offille_situation_globale")) offille_situation_globale(request, response);
        if (action.equalsIgnoreCase("vente_liste")) vente_liste(request, response);
        if (action.equalsIgnoreCase("vente_liste_mere_fille")) vente_liste_mere_fille(request, response);
        if (action.equalsIgnoreCase("proforma")) proforma(request, response);
        if (action.equalsIgnoreCase("imprimerDeclaration")) imprimerDeclaration(request, response);
        if (action.equalsIgnoreCase("imprimerBL")) imprimerBL(request, response);
        if (action.equalsIgnoreCase("imprimerMvtStock")) imprimerMvtStock(request, response);
        if (action.equalsIgnoreCase("proformaFF")) proformaFF(request, response);
        if (action.equalsIgnoreCase("proforma_vente")) proforma_vente(request, response);
        if (action.equalsIgnoreCase("fiche_vente_bc")) fiche_vente_bc(request, response);
        if (action.equalsIgnoreCase("mvtcaisse")) mvtcaisse(request, response);
        if (action.equalsIgnoreCase("preparation")) preparation(request, response);
        if (action.equalsIgnoreCase("imprimer_ticket_caisse")) imprimer_ticket_caisse(request, response);
        if (action.equalsIgnoreCase("cloturecaisse")) cloturecaisse(request, response);
    }
    private void imprimer_ticket_caisse(HttpServletRequest request, HttpServletResponse response) throws IOException, JRException, Exception{
        Connection c = new UtilDB().GetConn();
        Map param = new HashMap();
        List dataSource = new ArrayList();
        String id = request.getParameter("id");
        VenteLib v = new VenteLib();
        v.setNomTable("VENTE_DIRECTE_CPL_PDF");
        VenteLib[] enc_mere = (VenteLib[]) CGenUtil.rechercher(v, null, null, c,
                " AND ID = '" + id + "'");
        Date datyVente = null;
        String idClient = null;
        String idPoint = null;
        if (enc_mere.length > 0) {
            VenteLib ventelib = enc_mere[0];

            datyVente = ventelib.getDaty();
            idClient = ventelib.getIdClient();
            idPoint = ventelib.getIdMagasin();
            param.put("montantPaye", ventelib.getMontantpaye());
            param.put("montantretour", ventelib.getMontantRetourner());
            param.put("heure", Utilitaire.heureCouranteHMS());
            param.put("designation", ventelib.getDesignation());
            param.put("MAGASINCONSIDERER", ventelib.getIdMagasinLib());
            param.put("daty", ventelib.getDaty());
            param.put("remarque",ventelib.getRemarque());
            // param.put("montanttotal", enc_mere[0].getMontanttotal());
            param.put("devise", ventelib.getIdDevise());
            param.put("numFact", id);
            param.put("num" , id);

            param.put("daty" , ventelib.getDaty());
            param.put("modeDePaie" , ventelib.getIdModePaiementLib());
            //param.put("datyEcheance" , enc_mere[0].ge());
            param.put("montantApayer" , ventelib.getMontantpaye());
            param.put("montantReste" , ventelib.getMontantreste());
            //param.put("reduction" , enc_mere[0].getMonta());
            //param.put("contact" , tiers[0].getContact());
            param.put("nom" , ventelib.getIdClientLib());
            param.put("pseudo" , ventelib.getNomClientDivers());

            param.put("montantAvoir" , ventelib.getMontantreste() < 0 ? ventelib.getMontantreste() : 0);
            param.put("montantDonne", ventelib.getMontantDonne());
            param.put("responsable", ventelib.getIdResponsable());

        }
        param.put("lieu" , "CODAL");

        param.put("MAGASINCONSIDERER" , "ASYNC");
        param.put("tel" , ConstanteVente.tel);
        param.put("tel1" , ConstanteVente.tel1);
        param.put("tel2" , ConstanteVente.tel2);

        param.put("nif" , ConstanteVente.nif);
        param.put("stat" , ConstanteVente.stat);

        VenteDetailsLib vf = new VenteDetailsLib();
        vf.setNomTable("VENTE_DETAILS_TICKET");
        VenteDetailsLib[] v_fille = (VenteDetailsLib[]) CGenUtil.rechercher(vf, null, null, c,
                " AND idVente = '" + id + "'");
        for (VenteDetailsLib vd : v_fille) {
            if (!"APP".equals(vd.getIdProduit())) {
                double remiseAr = IngredientsRemise.getRemiseFromCertainIngredient(idClient, idPoint, vd.getIdProduit(), datyVente,c);
                vd.setRemiseMontant(remiseAr);
                double puTotal = (vd.getPvTva()* vd.getQte()) - (remiseAr * vd.getQte());
                vd.setPuTotal(puTotal);
                dataSource.add(vd);
            }
        }
        //dataSource.addAll(Arrays.asList(v_fille));
        String devise = v_fille[0].getIdDevise();
        double montantHT = AdminGen.calculSommeDouble(v_fille,"montantHTLocal");
        double montantTVA = AdminGen.calculSommeDouble(v_fille,"montantTvaLocal");
        double montantTTC = AdminGen.calculSommeDouble(v_fille,"montantTTCLocal");

        param.put("niflib" , "Nif");
        param.put("totallib" , "TOTAL");
        param.put("montantavoirlib" , "Montant Avoir");
        param.put("montantaplib" , "Net a Payer");
        param.put("montantpayelib" , "Montant Paye");
        param.put("resteapayelib" , "Reste a Payer");
        param.put("statlib" , "Stat");
        param.put("date" , "Date");
        param.put("client" , "Client");


        param.put("montantHT", montantHT);
        param.put("montantTVA", montantTVA);
        param.put("montantTTC", montantTTC);
        param.put("devise", devise);
        param.put("mail", ConstanteVente.email);
        UserEJB u = (UserEJB) request.getSession().getAttribute("u");
        Societe societe = u.getMaSociete();
        if (societe.getLogo() != null && !societe.getLogo().trim().isEmpty()&& !"-".equals(societe.getLogo().trim())) {
            param.put("logo", societe.getLogo());
        }
        param.put("disponibilite1", societe.getDisponnibilite());
        param.put("disponibilite2", "");
        param.put("tel", ConstanteVente.tel);
        int nbLignes = (v_fille != null) ? v_fille.length : 0;
//        if (nbLignes > 1){
//            nbLignes = nbLignes - 1 ;
//        }
        param.put("nbArticles", nbLignes);


        ArrayList<VenteDetailsLib> arrList = new ArrayList<VenteDetailsLib>();

        param.put("netapayer" , enc_mere[0].getMontantttc());
//        param.put("list_table",arrList);
        param.put("montanttotal",enc_mere[0].getMontantttc());
        param.put("idmodepaiementlib",enc_mere[0].getIdModePaiementLib());
        double reste = enc_mere[0].getMontantDonne()-enc_mere[0].getMontantttc();
        param.put("reste",reste);
        List<Map<String, Object>> modesPaiement = new ArrayList<>();

        Map<String, Object> m1 = new HashMap<>();
        m1.put("libelle", "Especes");
        m1.put("montant", enc_mere[0].getMontantDonne()); // exemple : montant total payé
        modesPaiement.add(m1);

        Map<String, Object> m2 = new HashMap<>();
        m2.put("libelle", "Cheque");
        m2.put("montant", 0.0);
        modesPaiement.add(m2);

        Map<String, Object> m3 = new HashMap<>();
        m3.put("libelle", "Carte");
        m3.put("montant", 0.0);
        modesPaiement.add(m3);

        // On passe la liste dans les paramètres Jasper
        param.put("LISTE_MODE_PAIEMENT", modesPaiement);
        // setNomJasper("FC");

        setNomJasper("ticket_caisse");
        String filename = "Ticket n°" + id;
        String currentAppPath = request.getServletContext().getRealPath("/");
        File currentAppDir = new File(currentAppPath);
        File deploymentsDir = currentAppDir.getParentFile();
        String deploymentsPath = deploymentsDir.getAbsolutePath();
        String targetWar = "dossier.war";
        String appRelativePath = "/async/codebarre/vente/";
        String filenames = id+".png";
        String fullPathToSignature = deploymentsPath + File.separator + targetWar + appRelativePath + File.separator + filenames;
        File sigFile = new File(fullPathToSignature);
        if (sigFile.exists()) {
            param.put("codebarre" , fullPathToSignature);
        }else{
            param.put("codebarre", null);
        }

        UtilitaireImpression.imprimer(request, response, filename, param, dataSource, getReportPath());
    }


    private void preparation(HttpServletRequest request, HttpServletResponse response) throws IOException, JRException, Exception{
        Connection c = null;
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
            }
        Map param = new HashMap();
        List dataSource = new ArrayList();
        String id = request.getParameter("id");
        BonDeCommandeCpl v = new BonDeCommandeCpl();
        v.setNomTable("BONDECOMMANDE_CLIENT_CPL");
        BonDeCommandeCpl[] enc_mere = (BonDeCommandeCpl[]) CGenUtil.rechercher(v, null, null, null,
                " AND ID = '" + id + "'");
        if (enc_mere.length > 0) {
            BonDeCommandeCpl liste = enc_mere[0];
                param.put("client",liste.getIdclientlib());
                param.put("daty",liste.getDaty());
            }
        BonDeCommandeFIlleCpl f = new BonDeCommandeFIlleCpl();
        v.setNomTable("BC_CLIENT_FILLE_CPL_LIB");
        BonDeCommandeFIlleCpl[] fille = (BonDeCommandeFIlleCpl[]) CGenUtil.rechercher(f, null, null, null,
                " AND idbc = '" + id + "'");
        dataSource.addAll(Arrays.asList(fille));
        setNomJasper("preparation");
        UtilitaireImpression.imprimer(request, response, "preparation "+id, param, dataSource, getReportPath());
        } catch (Exception e) {
            throw e;
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
    }
    private void mvtcaisse(HttpServletRequest request, HttpServletResponse response) throws IOException, JRException, Exception{
        Connection c = null;
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
            }
        Map param = new HashMap();
        List dataSource = new ArrayList();
        String id = request.getParameter("id");
        MvtCaisseCpl v = new MvtCaisseCpl();
        v.setNomTable("MOUVEMENTCAISSECPL");
        MvtCaisseCpl[] enc_mere = (MvtCaisseCpl[]) CGenUtil.rechercher(v, null, null, c,
                " AND ID = '" + id + "'");
        if (enc_mere.length > 0) {
            MvtCaisseCpl liste = enc_mere[0];
                param.put("num",id);
                param.put("id",id);
                param.put("tiers",liste.getTiers());
                param.put("daty",liste.getDaty());
                double montant = 0;
                if(liste.getCredit() > 0){
                    montant = liste.getCredit();
                }
                else{
                    montant = liste.getDebit();
                }
                param.put("montant",montant);
                param.put("ref",liste.getReference());
            }
            
        
        setNomJasper("mouvement-caisse");
        UtilitaireImpression.imprimer(request, response, "mouvement de caisse "+id, param, dataSource, getReportPath());
        } catch (Exception e) {
            throw e;
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
    }
    private void imprimerBL(HttpServletRequest request, HttpServletResponse response) throws IOException, JRException, Exception{
        Connection c = null;
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
            }
        Map param = new HashMap();
        List dataSource = new ArrayList();
        String id = request.getParameter("id");
        As_BondeLivraisonClient_Cpl v = new As_BondeLivraisonClient_Cpl();
        v.setNomTable("AS_BONDELIVRAISON_CLIENT_CPL");
        As_BondeLivraisonClient_Cpl[] enc_mere = (As_BondeLivraisonClient_Cpl[]) CGenUtil.rechercher(v, null, null, c,
                " AND ID = '" + id + "'");
        if (enc_mere.length > 0) {
            ClientLib cl = new ClientLib();
            cl.setNomTable("CLIENT");
            ClientLib client = (ClientLib) cl.getById(enc_mere[0].getIdclient(),"CLIENT" , c);
            if (client != null) {
                param.put("idclient",client.getCodeclient());
                param.put("nomClient",client.getNom());
                param.put("adresseClient",client.getAdresse());
                param.put("lieuClient",client.getProvinceLib());
                param.put("telClient",client.getTelephone());
                param.put("nifclient",client.getNif());
                param.put("statclient",client.getStat());
                param.put("cp",client.getCarte());
                param.put("quit","");
                param.put("datyclient",client.getDatecarte());
            }
            param.put("nomChauffeur", enc_mere[0].getChauffeur());
            param.put("numVehicule", enc_mere[0].getVehicule());
        }
        param.put("numfact", id);
        param.put("daty", Utilitaire.dateDuJour());
        param.put("tel", ConstanteVente.tel);
        param.put("fax", ConstanteVente.fax);
        param.put("tel1", ConstanteVente.tel1);
        param.put("tel2", ConstanteVente.tel2);
        param.put("email", ConstanteVente.email);
        param.put("bni_cl", ConstanteVente.bni_cl);
        param.put("boa", ConstanteVente.boa);
        param.put("bmoi", ConstanteVente.bmoi);
        param.put("bfv_sg", ConstanteVente.bfv_sg);
        param.put("cf", ConstanteVente.cf);
        param.put("stat", ConstanteVente.stat);
        param.put("nif", ConstanteVente.nif);
        param.put("rcs", ConstanteVente.rcs);
        param.put("adresse1", ConstanteVente.ADRESSE_CENTRE);
        param.put("adresse2", ConstanteVente.CENTRE_FISCAL);
        param.put("datyJour", Utilitaire.dateDuJour());
        param.put("rcs", ConstanteVente.rcs);
        param.put("adresse1", ConstanteVente.ADRESSE_CENTRE);
        param.put("adresse2", ConstanteVente.CENTRE_FISCAL);

        As_BondeLivraisonClientFille_Cpl vf = new As_BondeLivraisonClientFille_Cpl();
        vf.setNomTable("AS_BONLIVRFILLE_CLIENT_CPL");
        As_BondeLivraisonClientFille_Cpl[] v_fille = (As_BondeLivraisonClientFille_Cpl[]) CGenUtil.rechercher(vf, null, null, c,
                " AND numbl = '" + id + "'");
        dataSource.addAll(Arrays.asList(v_fille));
        setNomJasper("BL");
        UtilitaireImpression.imprimer(request, response, getNomJasper(), param, dataSource, getReportPath());
        } catch (Exception e) {
            throw e;
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
    }
    private void imprimerMvtStock(HttpServletRequest request, HttpServletResponse response) throws IOException, JRException, Exception{
        Connection c = null;
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
            }
            String id = request.getParameter("id");

            MvtStockLib mvt = new MvtStockLib();
            mvt.setNomTable("mvtstocklib");
            MvtStockLib[] mouvements = (MvtStockLib[]) CGenUtil.rechercher(mvt, null, null, c,
                    " AND ID = '" + id + "'");
                if (mouvements.length == 0) {
                mouvements = (MvtStockLib[]) CGenUtil.rechercher(mvt, null, null, c,
                    " AND IDOBJET = '" + id + "'");
                }
            if (mouvements.length == 0) {
                throw new Exception("Mouvement de stock introuvable: " + id);
            }

            MvtStockLib mouvement = mouvements[0];
            MvtStockFilleLib fille = new MvtStockFilleLib();
            fille.setNomTable("mvtstockfillelib");
            MvtStockFilleLib[] filles = (MvtStockFilleLib[]) CGenUtil.rechercher(fille, null, null, c,
                    " AND IDMVTSTOCK = '" + mouvement.getId() + "'");
            if (filles == null || filles.length == 0) {
                filles = new MvtStockFilleLib[0];
            }
            Map param = new HashMap();
            param.put("id", mouvement.getId() != null ? mouvement.getId() : "-");
            param.put("designation", mouvement.getDesignation() != null ? mouvement.getDesignation() : "-");
            param.put("daty", mouvement.getDaty());
            param.put("heure", mouvement.getHeure() != null ? mouvement.getHeure() : "-");
            param.put("magasin", mouvement.getIdMagasinlib() != null ? mouvement.getIdMagasinlib() : "-");
            param.put("typeMouvement", mouvement.getIdTypeMvStocklib() != null ? mouvement.getIdTypeMvStocklib() : "-");
            param.put("categorie", mouvement.getIdCategorieStockLib() != null ? mouvement.getIdCategorieStockLib() : "-");
            param.put("objet", mouvement.getIdobjet() != null ? mouvement.getIdobjet() : "-");
            param.put("remarque", mouvement.getRemarque() != null ? mouvement.getRemarque() : "-");
            param.put("etat", mouvement.getEtat());
            param.put("adresse1", ConstanteVente.ADRESSE_CENTRE);
            param.put("adresse2", ConstanteVente.CENTRE_FISCAL);
            param.put("tel", ConstanteVente.tel);
            param.put("tel1", ConstanteVente.tel1);
            param.put("tel2", ConstanteVente.tel2);
            param.put("email", ConstanteVente.email);
            param.put("cf", ConstanteVente.cf);
            param.put("stat", ConstanteVente.stat);
            param.put("nif", ConstanteVente.nif);
            param.put("rcs", ConstanteVente.rcs);
            param.put("datyJour", Utilitaire.dateDuJour());
            param.put("client", "-");
            param.put("adresseClient", "-");
            param.put("lieuClient", "-");
            param.put("telClient", "-");
            param.put("statclient", "-");
            param.put("nifclient", "-");
            param.put("vehicule", "-");
            param.put("chauffeur", "-");
            if (mouvement.getIdobjet() != null && mouvement.getIdobjet().startsWith("BLC")) {
                As_BondeLivraisonClient_Cpl blc = new As_BondeLivraisonClient_Cpl();
                blc.setNomTable("AS_BONDELIVRAISON_CLIENT_CPL");
                As_BondeLivraisonClient_Cpl[] livraisons = (As_BondeLivraisonClient_Cpl[]) CGenUtil.rechercher(blc, null, null, c,
                        " AND ID = '" + mouvement.getIdobjet() + "'");
                if (livraisons.length > 0) {
                    param.put("vehicule", livraisons[0].getVehicule() != null ? livraisons[0].getVehicule() : "-");
                    param.put("chauffeur", livraisons[0].getChauffeur() != null ? livraisons[0].getChauffeur() : "-");
                    ClientLib client = new ClientLib();
                    client.setNomTable("CLIENT");
                    ClientLib clientLivre = (ClientLib) client.getById(livraisons[0].getIdclient(), "CLIENT", c);
                    if (clientLivre != null) {
                        param.put("client", clientLivre.getNom() != null ? clientLivre.getNom() : "-");
                        param.put("adresseClient", clientLivre.getAdresse() != null ? clientLivre.getAdresse() : "-");
                        param.put("lieuClient", clientLivre.getProvinceLib() != null ? clientLivre.getProvinceLib() : "-");
                        param.put("telClient", clientLivre.getTelephone() != null ? clientLivre.getTelephone() : "-");
                        param.put("statclient", clientLivre.getStat() != null ? clientLivre.getStat() : "-");
                        param.put("nifclient", clientLivre.getNif() != null ? clientLivre.getNif() : "-");
                    }
                }
            }

                setNomJasper("MvtStock");
                UtilitaireImpression.imprimer(request, response, "Mouvement-stock-" + id,
                    param, Arrays.asList(filles), getReportPath());
        } finally {
            if (c != null && estOuvert) {
                c.close();
            }
        }
    }
    private void fiche_bc(HttpServletRequest request, HttpServletResponse response) throws IOException, JRException, Exception{
        Connection c = null;
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
            }
        Map param = new HashMap();
        List dataSource = new ArrayList();
         String id = request.getParameter("id");
        As_BonDeCommandeCpl v = new As_BonDeCommandeCpl();
        v.setNomTable("As_BonDeCommande_MERECPL");
        As_BonDeCommandeCpl[] enc_mere = (As_BonDeCommandeCpl[]) CGenUtil.rechercher(v, null, null, c,
                " AND ID = '" + id + "'");
        param.put("tel", ConstanteVente.tel);
        param.put("fax", ConstanteVente.fax);
        param.put("tel1", ConstanteVente.tel1);
        param.put("tel2", ConstanteVente.tel2);
        param.put("email", ConstanteVente.email);
        param.put("bni_cl", ConstanteVente.bni_cl);
        param.put("boa", ConstanteVente.boa);
        param.put("bmoi", ConstanteVente.bmoi);
        param.put("bfv_sg", ConstanteVente.bfv_sg);
        param.put("cf", ConstanteVente.cf);
        param.put("stat", ConstanteVente.stat);
        param.put("nif", ConstanteVente.nif);
        param.put("rcs", ConstanteVente.rcs);
        param.put("adresse1", ConstanteVente.ADRESSE_CENTRE);
        param.put("adresse2", ConstanteVente.CENTRE_FISCAL);
        param.put("pdg", ConstanteVente.pdg);
        if (enc_mere.length > 0) {
            param.put("etat", enc_mere[0].getEtat());
            param.put("daty", enc_mere[0].getDaty());
            if (enc_mere[0].getIdOrigine() != null && enc_mere[0].getIdOrigine().startsWith("DMD")) {
                    List listeHistorique = new ArrayList();
                    HistoriqueValidationDmdAchat histo = new HistoriqueValidationDmdAchat();
                    histo.setNomTable("HISTORIQUEVALIDATIONDMDACHAT");
                    HistoriqueValidationDmdAchat[] historique = (HistoriqueValidationDmdAchat[]) CGenUtil.rechercher(histo, null, null, c," and idDmdAchat = '"+enc_mere[0].getIdOrigine()+"' ORDER BY daty, heure desc");
                    if(historique.length >  0){
                         listeHistorique.addAll(Arrays.asList(historique));
                         param.put("listeDetails", listeHistorique);
                    }
               
                }
            Fournisseur cl = new Fournisseur();
            cl.setNomTable("FOURNISSEUR");
            Fournisseur fournisseur = (Fournisseur) cl.getById(enc_mere[0].getFournisseur(),"FOURNISSEUR" , c);
            if(fournisseur != null) {
                param.put("idclient",fournisseur.getCode());
                param.put("nomClient",fournisseur.getNom());
                param.put("adresseClient",fournisseur.getAdresse());
                param.put("telClient",fournisseur.getContact());
                param.put("nifclient",fournisseur.getNif());
                param.put("statclient",fournisseur.getStat());
                param.put("quit","");
                param.put("numbc",id);
            }
          
          param.put("designation", enc_mere[0].getDesignation());
          String[] numP = enc_mere[0].getDesignation().split(" ");
          String idproforma = numP[numP.length - 1];
          param.put("numProforma", idproforma);
          param.put("modepai", enc_mere[0].getModepaiementlib());
          param.put("ref", enc_mere[0].getReference());
          param.put("daty", enc_mere[0].getDaty());
          param.put("remarque", enc_mere[0].getRemarque());
          param.put("fournisseur", enc_mere[0].getFournisseurlib());
          param.put("modeP", enc_mere[0].getModepaiementlib());
          param.put("num", id);
          param.put("iddevise", enc_mere[0].getIdDevise());
          param.put("montantHT", enc_mere[0].getMontantHT());
          param.put("montantTVA", enc_mere[0].getMontantTVA());
          param.put("montantTTC", enc_mere[0].getMontantTTC());
          param.put("devise", enc_mere[0].getIdDeviselib());
        }
       
        As_BonDeCommande_Fille_CPL vf = new As_BonDeCommande_Fille_CPL();
        vf.setNomTable("AS_BONDECOMMANDE_CPL_PDF");
        As_BonDeCommande_Fille_CPL[] v_fille = (As_BonDeCommande_Fille_CPL[]) CGenUtil.rechercher(vf, null, null, c,
                " AND idbc = '" + id + "'");
        dataSource.addAll(Arrays.asList(v_fille));
        double montantHT = AdminGen.calculSommeDouble(v_fille,"montantHT");
        double montantTVA = AdminGen.calculSommeDouble(v_fille,"montantTVA");
        double montantTTC = AdminGen.calculSommeDouble(v_fille,"montantTTC");
        double montantRemise = AdminGen.calculSommeDouble(v_fille,"remiseMontant");
        
        param.put("montantHt" , montantHT);
        param.put("montantTva" , montantTVA);
        param.put("montantTTC" , montantTTC);
        param.put("montantRemise" , montantRemise);
        setNomJasper("bon_de_commande");
        UtilitaireImpression.imprimer(request, response, getNomJasper(), param, dataSource, getReportPath());
        } catch (Exception e) {
                throw e;
            } finally {
                if (c != null && estOuvert == true) {
                    c.close();
                }
            }
        }
    private void fiche_transfert(HttpServletRequest request, HttpServletResponse response) throws IOException, JRException, Exception{
        Connection c = null;
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
            }
        Map param = new HashMap();
        List dataSource = new ArrayList();
         String id = request.getParameter("id");
        TransfertStockCpl v = new TransfertStockCpl();
        TransfertStockCpl[] enc_mere = (TransfertStockCpl[]) CGenUtil.rechercher(v, null, null, c,
                " AND ID = '" + id + "'");
        param.put("id", id);
        param.put("tel", ConstanteVente.tel);
        param.put("fax", ConstanteVente.fax);
        param.put("tel1", ConstanteVente.tel1);
        param.put("tel2", ConstanteVente.tel2);
        param.put("email", ConstanteVente.email);
        param.put("bni_cl", ConstanteVente.bni_cl);
        param.put("boa", ConstanteVente.boa);
        param.put("bmoi", ConstanteVente.bmoi);
        param.put("bfv_sg", ConstanteVente.bfv_sg);
        param.put("cf", ConstanteVente.cf);
        param.put("stat", ConstanteVente.stat);
        param.put("nif", ConstanteVente.nif);
        param.put("rcs", ConstanteVente.rcs);
        param.put("adresse1", ConstanteVente.ADRESSE_CENTRE);
        param.put("adresse2", ConstanteVente.CENTRE_FISCAL);
        param.put("pdg", ConstanteVente.pdg);
        if (enc_mere.length > 0) {
            TransfertStockCpl transfert = enc_mere[0];
            param.put("designation", transfert.getDesignation());
            param.put("daty", transfert.getDaty());
            param.put("magasinDepart",transfert.getIdMagasinDepartLib());
            param.put("magasinArrive" , transfert.getIdMagasinArriveLib());
            
        }
       
        TransfertStockDetailsCpl vf = new TransfertStockDetailsCpl();
        vf.setNomTable("TransfertStockDetailsCpl");
        TransfertStockDetailsCpl[] v_fille = (TransfertStockDetailsCpl[]) CGenUtil.rechercher(vf, null, null, c,
                " AND idTransfertStock = '" + id + "'");
        dataSource.addAll(Arrays.asList(v_fille));
        
        setNomJasper("transfert");
        UtilitaireImpression.imprimer(request, response, "transfert de stock", param, dataSource, getReportPath());
        } catch (Exception e) {
            throw e;
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
    }
    
    private void fiche_ff(HttpServletRequest request, HttpServletResponse response) throws IOException, JRException, Exception{
        Connection c = null;
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
            }
        Map param = new HashMap();
        List dataSource = new ArrayList();
         String id = request.getParameter("id");
        FactureFournisseurCpl v = new FactureFournisseurCpl();
        v.setNomTable("FACTUREFOURNISSEURCPL2");
        FactureFournisseurCpl[] enc_mere = (FactureFournisseurCpl[]) CGenUtil.rechercher(v, null, null, c,
                " AND ID = '" + id + "'");
        param.put("tel", ConstanteVente.tel);
        param.put("fax", ConstanteVente.fax);
        param.put("tel1", ConstanteVente.tel1);
        param.put("tel2", ConstanteVente.tel2);
        param.put("email", ConstanteVente.email);
        param.put("bni_cl", ConstanteVente.bni_cl);
        param.put("boa", ConstanteVente.boa);
        param.put("bmoi", ConstanteVente.bmoi);
        param.put("bfv_sg", ConstanteVente.bfv_sg);
        param.put("cf", ConstanteVente.cf);
        param.put("stat", ConstanteVente.stat);
        param.put("nif", ConstanteVente.nif);
        param.put("rcs", ConstanteVente.rcs);
        param.put("adresse1", ConstanteVente.ADRESSE_CENTRE);
        param.put("adresse2", ConstanteVente.CENTRE_FISCAL);
        if (enc_mere.length > 0) {
            Fournisseur cl = new Fournisseur();
            cl.setNomTable("FOURNISSEUR");
            Fournisseur fournisseur = (Fournisseur) cl.getById(enc_mere[0].getIdFournisseur(),"FOURNISSEUR" , c);
            if(fournisseur != null) {
                param.put("idclient",fournisseur.getCode());
                param.put("nomClient",fournisseur.getNom());
                param.put("adresseClient",fournisseur.getAdresse());
                param.put("telClient",fournisseur.getContact());
                param.put("nifclient",fournisseur.getNif());
                param.put("statclient",fournisseur.getStat());
                param.put("quit","");
                param.put("numbc",id);
            }
       
        }
       
        FactureFournisseurDetailsCpl vf = new FactureFournisseurDetailsCpl();
        FactureFournisseurDetailsCpl[] v_fille = (FactureFournisseurDetailsCpl[]) CGenUtil.rechercher(vf, null, null, c,
                " AND idFactureFournisseur = '" + id + "'");
        dataSource.addAll(Arrays.asList(v_fille));
        setNomJasper("facturefournisseur");
        UtilitaireImpression.imprimer(request, response, getNomJasper(), param, dataSource, getReportPath());
        } catch (Exception e) {
            throw e;
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
    }
    
    private void fiche_bl(HttpServletRequest request, HttpServletResponse response) throws IOException, JRException, Exception{
        Connection c = null;
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
            }
        Map param = new HashMap();
        List dataSource = new ArrayList();
        String id = request.getParameter("id");
        As_BondeLivraisonClient_Cpl v = new As_BondeLivraisonClient_Cpl();
        v.setNomTable("AS_BONDELIVRAISON_CLIENT_CPL");
        As_BondeLivraisonClient_Cpl[] enc_mere = (As_BondeLivraisonClient_Cpl[]) CGenUtil.rechercher(v, null, null, c,
                " AND id = '" + id + "'");
        if (enc_mere.length > 0) {
          param.put("designation", enc_mere[0].getDesignation());
          param.put("daty", enc_mere[0].getDaty());
          param.put("remarque", enc_mere[0].getRemarque());
          param.put("magasin", enc_mere[0].getMagasin());
          param.put("client", enc_mere[0].getIdclientlib());
          param.put("num", id);

        }
        As_BondeLivraisonClientFille_Cpl vf = new As_BondeLivraisonClientFille_Cpl();
        vf.setNomTable("AS_BONLIVRFILLE_CLIENT_CPL");
        As_BondeLivraisonClientFille_Cpl[] v_fille = (As_BondeLivraisonClientFille_Cpl[]) CGenUtil.rechercher(vf, null, null, c,
                " AND numbl = '" + id + "'");
        dataSource.addAll(Arrays.asList(v_fille));
        setNomJasper("BonDeLivraison");
        UtilitaireImpression.imprimer(request, response, getNomJasper(), param, dataSource, getReportPath());
        } catch (Exception e) {
            throw e;
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
    }
    private void fiche_vente(HttpServletRequest request, HttpServletResponse response) throws IOException, JRException, Exception{
        Connection c = null;
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
            }
        Map param = new HashMap();
        List dataSource = new ArrayList();
         String id = request.getParameter("id");
        VenteLib v = new VenteLib();
        VenteLib[] enc_mere = (VenteLib[]) CGenUtil.rechercher(v, null, null, c,
                " AND ID = '" + id + "'");
        if (enc_mere.length > 0) {
          param.put("designation", enc_mere[0].getDesignation());
          param.put("magasin", enc_mere[0].getIdMagasinLib());
          param.put("daty", enc_mere[0].getDaty());
          param.put("remarque", enc_mere[0].getRemarque());
          param.put("devise", enc_mere[0].getIdDevise());
          param.put("numFact", id);
        }
       
        VenteDetailsLib vf = new VenteDetailsLib();
        vf.setNomTable("VENTE_DETAILS_CPL");
        VenteDetailsLib[] v_fille = (VenteDetailsLib[]) CGenUtil.rechercher(vf, null, null, c,
                " AND idVente = '" + id + "'");
        dataSource.addAll(Arrays.asList(v_fille));
         String devise = v_fille[0].getIdDevise();
        double montantHT = AdminGen.calculSommeDouble(v_fille,"montantHTLocal");
        double montantTVA = AdminGen.calculSommeDouble(v_fille,"montantTvaLocal");
        double montantTTC = AdminGen.calculSommeDouble(v_fille,"montantTTCLocal");
        
        param.put("montantHT", montantHT);
        param.put("montantTVA", montantTVA);
        param.put("montantTTC", montantTTC);
        param.put("devise", devise);
        
        setNomJasper("factureclient");
        UtilitaireImpression.imprimer(request, response, getNomJasper(), param, dataSource, getReportPath());
        } catch (Exception e) {
            throw e;
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
    }
    private void impressionEncaissement(HttpServletRequest request, HttpServletResponse response) throws IOException, JRException, Exception{
        Connection c = null;
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
            }
        Map param = new HashMap();
        List dataSource = new ArrayList();
         String id = request.getParameter("id");
        EncaissementLib eM = new EncaissementLib();
        eM.setNomTable("ENCAISSEMENT_LIB");
        EncaissementLib[] enc_mere = (EncaissementLib[]) CGenUtil.rechercher(eM, null, null, c,
                " AND ID = '" + id + "'");
        if (enc_mere.length > 0) {
          param.put("carburants", Utilitaire.formaterAr(enc_mere[0].getVenteCarburant()));
          param.put("lubrifiants", Utilitaire.formaterAr(enc_mere[0].getVenteLubrifiant()));
          param.put("totalrecette", Utilitaire.formaterAr(enc_mere[0].getTotalRecette()));
          param.put("depense", Utilitaire.formaterAr(enc_mere[0].getDepense()));
          param.put("montantecart", Utilitaire.formaterAr(enc_mere[0].getEcart()));
          param.put("versement", Utilitaire.formaterAr(enc_mere[0].getTotalVersement()));
         
        }
        EncaissementDetailsLib eF = new EncaissementDetailsLib();
        eF.setNomTable("Encaissement_Details_Lib");
        EncaissementDetailsLib[] enc_fille = (EncaissementDetailsLib[]) CGenUtil.rechercher(eF, null, null, c,
                " AND idEncaissement = '" + id + "'");
        dataSource.addAll(Arrays.asList(enc_fille));
        setNomJasper("encaissement");
        UtilitaireImpression.imprimer(request, response, getNomJasper(), param, dataSource, getReportPath());
        } catch (Exception e) {
            throw e;
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
    }

     private void impressionEncaissementPompist (HttpServletRequest request, HttpServletResponse response) throws IOException, JRException, Exception{
        Connection c = null;
        Map param = new HashMap();
        List dataSource = new ArrayList();
         String id = request.getParameter("id");
        EncaissementFichePdf eM = new EncaissementFichePdf();
       
        EncaissementFichePdf[] enc_mere = (EncaissementFichePdf[]) CGenUtil.rechercher(eM, null, null, null,
                " AND ID = '" + id + "'");

      
        EncaissementReport er=new EncaissementReport();
        er.setId(id);
        er.init(c);

        if (enc_mere.length > 0) {
          param.put("date", enc_mere[0].getDaty());
          param.put("nom", enc_mere[0].getIdPompisteLib());
          param.put("ecart", enc_mere[0].getEcart());
          param.put("versement", enc_mere[0].getTotalVersement());
          param.put("espece", enc_mere[0].getTotalEspece());
          param.put("om", enc_mere[0].getTotalOrangeMoney());
        }
       
        dataSource.add(er);


        setNomJasper("encaissementPompiste");
        UtilitaireImpression.imprimer(request, response, getNomJasper(), param, dataSource, getReportPath());
    }
    private void fiche_ordre_fabrication(HttpServletRequest request, HttpServletResponse response) throws IOException, JRException, Exception{
        Connection c = null;
         boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
            }
        Map param = new HashMap();
       //List dataSource = new ArrayList();
        String id = request.getParameter("id");
        Of t = new Of();
        t.setId(id);
        Of[] of_mere = (Of[]) CGenUtil.rechercher(t, null, null, c,
        " AND ID = '" + id + "'");
        if (of_mere.length > 0) {
          param.put("daty", of_mere[0].getDaty());
          param.put("id", of_mere[0].getId());
        }
      
        MvtStockFilleTheorique mvtst = new MvtStockFilleTheorique();
        HashMap<String, Vector> map = mvtst.getRapprochementParCategorie(id, null, c);
        List dataSource = new ArrayList();
        for (Vector v : map.values()) {
            for (Object obj : v) {
                if (obj instanceof MvtStockFilleTheorique) {
                    dataSource.add((MvtStockFilleTheorique) obj);
                }
            }
        }
        setNomJasper("fiche_ordre_fabrication");
        UtilitaireImpression.imprimer(request, response, getNomJasper(), param, dataSource, getReportPath());
        } catch (Exception e) {
            throw e;
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
    }
    private void fiche_vente_nouveau(HttpServletRequest request, HttpServletResponse response) throws IOException, JRException, Exception{
        Connection c = null;
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
            }
        Map param = new HashMap();
        List dataSource = new ArrayList();
        List dataSource1 = new ArrayList();
         String id = request.getParameter("id");
        VenteLib v = new VenteLib();
        VenteLib[] enc_mere = (VenteLib[]) CGenUtil.rechercher(v, null, null, c,
                " AND ID = '" + id + "'");
        param.put("tel", ConstanteVente.tel);
        param.put("fax", ConstanteVente.fax);
        param.put("tel1", ConstanteVente.tel1);
        param.put("tel2", ConstanteVente.tel2);
        param.put("email", ConstanteVente.email);
        param.put("bni_cl", ConstanteVente.bni_cl);
        param.put("boa", ConstanteVente.boa);
        param.put("bmoi", ConstanteVente.bmoi);
        param.put("bfv_sg", ConstanteVente.bfv_sg);
        param.put("cf", ConstanteVente.cf);
        param.put("stat", ConstanteVente.stat);
        param.put("nif", ConstanteVente.nif);
        param.put("rcs", ConstanteVente.rcs);
        param.put("adresse1", ConstanteVente.ADRESSE_CENTRE);
        param.put("adresse2", ConstanteVente.CENTRE_FISCAL);
        param.put("datyJour", Utilitaire.dateDuJour());
        param.put("rcs", ConstanteVente.rcs);
        param.put("adresse1", ConstanteVente.ADRESSE_CENTRE);
        param.put("adresse2", ConstanteVente.CENTRE_FISCAL);
        if (enc_mere.length > 0) {
            VenteLib[] ListefacturenonPayer = enc_mere[0].getFactureNonPayer();
            int nombreFactureAfficher = 4;
            if (ListefacturenonPayer != null && ListefacturenonPayer.length > 0) {
                List<VenteLib> factures = Arrays.stream(ListefacturenonPayer)
                        .sorted(Comparator.comparing(VenteLib::getDatyPrevu,
                                Comparator.nullsLast(Comparator.naturalOrder())))
                        .limit(nombreFactureAfficher)
                        .collect(Collectors.toList());

                dataSource1.addAll(factures);
                param.put("listeDetails", dataSource1);
            }
            param.put("montantreste", AdminGen.calculSommeDouble(ListefacturenonPayer, "montantreste"));
            
            ClientLib cl = new ClientLib();
            cl.setNomTable("CLIENT");
            ClientLib client = (ClientLib) cl.getById(enc_mere[0].getIdClient(),"CLIENT" , c);
            if (enc_mere.length > 0) {
                param.put("idclient",client.getCodeclient());
                param.put("nomClient",client.getNom());
                param.put("adresseClient",client.getAdresse());
                param.put("lieuClient",client.getProvinceLib());
                param.put("telClient",client.getTelephone());
                param.put("nifclient",client.getNif());
                param.put("statclient",client.getStat());
                param.put("cp",client.getCarte());
                param.put("quit","");
                param.put("datyclient",client.getDatecarte());
                String nomClientMere = "";
                if (client.getRemarque() != null) {
                    ClientLib cli = (ClientLib) cl.getById(client.getRemarque(),"CLIENT" , c);
                    if (cli != null) {
                        nomClientMere = cli.getNom();
                    }
                }
                param.put("nomClientMere",nomClientMere);
            } 
            if (enc_mere[0].getNumerofacture() != null) {
                param.put("numfact", enc_mere[0].getNumerofacture());
            } else {
                param.put("numfact", id);
            }
            param.put("datyfact",enc_mere[0].getDaty());
            param.put("lieu_livraison",enc_mere[0].getLieuLivraison());
            param.put("remarque",enc_mere[0].getRemarque());
            param.put("totalcolis",enc_mere[0].getColis());
            param.put("totalpoids",enc_mere[0].getPoids());
            param.put("modepaiement",enc_mere[0].getModepaiementlib());
            param.put("reference",enc_mere[0].getIdOrigine());
            param.put("echeance",enc_mere[0].getEcheancefacture());
            param.put("dateEcheance", String.valueOf(enc_mere[0].getDatyPrevu()));
            String modeDeLiv = enc_mere[0].getModelivraisonlib();
            String livraison = modeDeLiv.replace("<span style=color: green;>", "")
                 .replace("</span>", "");
            param.put("livraison",livraison);
            param.put("transport",enc_mere[0].getFrais());
            param.put("devise", enc_mere[0].getIdDevise());
        }
       
        VenteDetailsLib vf = new VenteDetailsLib();
        vf.setNomTable("VENTE_DETAILS_POIDS");
        VenteDetailsLib[] v_fille = (VenteDetailsLib[]) CGenUtil.rechercher(vf, null, null, c,
                " AND idVente = '" + id + "'");
        dataSource.addAll(Arrays.asList(v_fille));
        double montant = AdminGen.calculSommeDouble(v_fille,"montant");
        double montantHT = AdminGen.calculSommeDouble(v_fille,"montantht");
        double montantTVA = AdminGen.calculSommeDouble(v_fille,"montantTva");
        double montantTTC = AdminGen.calculSommeDouble(v_fille,"montantttc");
        double frais = AdminGen.calculSommeDouble(v_fille,"frais");
        if (v_fille.length > 0) {
            boolean isRistourne = false;
            if (v_fille[0].getRistourne() > 0) {
                isRistourne = true;
                double totalRistourne = AdminGen.calculSommeDouble(v_fille,"MONTANTRISTOURNE");
                param.put("totalRistourne", totalRistourne);
            } else {
                double totalRemise = AdminGen.calculSommeDouble(v_fille,"REMISEMONTANT");
                param.put("totalRemise", totalRemise);
            }
            param.put("isRistourne", isRistourne);
        }

        System.out.println("montant = "+Utilitaire.formaterAr(montantTVA));
        String montantNetLettre = ChiffreLettre.convertRealToString(montantTTC);
            if (montantNetLettre.contains(",")) {
                montantNetLettre = montantNetLettre.replace(",", " Ariary ");
            } else {
                montantNetLettre += " Ariary";
            }
        param.put("montantNetLettre", montantNetLettre);
        param.put("totalbrut",montant);
        param.put("participation_transport",frais);
        param.put("totalHt",montantHT);
        param.put("total_taxes",montantTVA);
        param.put("montantttc",montantTTC);
        //param.put("escompte","");
        param.put("net_payer",montantTTC);
        param.put("net_payer_fmg",montantTTC*5);
        
        setNomJasper("facture-vente");
        String nomFichier = enc_mere[0].getNumerofacture() != null ? enc_mere[0].getNumerofacture() : id;
        UtilitaireImpression.imprimer(request, response, nomFichier, param, dataSource, getReportPath());
        } catch (Exception e) {
            throw e;
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
    }
    
    private void fiche_vente_bc(HttpServletRequest request, HttpServletResponse response) throws IOException, JRException, Exception{
        Connection c = null;
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
            }
        Map param = new HashMap();
        List dataSource = new ArrayList();
        List dataSource1 = new ArrayList();
         String id = request.getParameter("id");
        BonDeCommandeCpl v = new BonDeCommandeCpl();
        v.setNomTable("BONDECOMMANDE_CLIENT_CPL");
        BonDeCommandeCpl[] enc_mere = (BonDeCommandeCpl[]) CGenUtil.rechercher(v, null, null, c,
                " AND ID = '" + id + "'");
        System.out.println("id======="+id);
        param.put("id", id);
        param.put("tel", ConstanteVente.tel);
        param.put("fax", ConstanteVente.fax);
        param.put("tel1", ConstanteVente.tel1);
        param.put("tel2", ConstanteVente.tel2);
        param.put("email", ConstanteVente.email);
        param.put("bni_cl", ConstanteVente.bni_cl);
        param.put("boa", ConstanteVente.boa);
        param.put("bmoi", ConstanteVente.bmoi);
        param.put("bfv_sg", ConstanteVente.bfv_sg);
        param.put("cf", ConstanteVente.cf);
        param.put("stat", ConstanteVente.stat);
        param.put("nif", ConstanteVente.nif);
        param.put("rcs", ConstanteVente.rcs);
        param.put("adresse1", ConstanteVente.ADRESSE_CENTRE);
        param.put("adresse2", ConstanteVente.CENTRE_FISCAL);
        param.put("datyJour", Utilitaire.dateDuJour());
        param.put("rcs", ConstanteVente.rcs);
        param.put("adresse1", ConstanteVente.ADRESSE_CENTRE);
        param.put("adresse2", ConstanteVente.CENTRE_FISCAL);
        int limit = 13;
        int filleSize = 0;
        if (enc_mere.length > 0) {
            ClientLib cl = new ClientLib();
            cl.setNomTable("CLIENT");
            ClientLib client = (ClientLib) cl.getById(enc_mere[0].getIdClient(),"CLIENT" , c);
            if (enc_mere.length > 0) {
                param.put("idclient",client.getCodeclient());
                param.put("nomClient",client.getNom());
                param.put("adresseClient",client.getAdresse());
                param.put("lieuClient",client.getProvinceLib());
                param.put("telClient",client.getTelephone());
                param.put("nifclient",client.getNif());
                param.put("statclient",client.getStat());
                param.put("cp",client.getCarte());
                param.put("quit","");
                param.put("datyclient",client.getDatecarte());
                String nomClientMere = "";
                if (client.getRemarque() != null) {
                    ClientLib cli = (ClientLib) cl.getById(client.getRemarque(),"CLIENT" , c);
                    if (cli != null) {
                        nomClientMere = cli.getNom();
                    }
                }
                param.put("nomClientMere",nomClientMere);
            } 
            param.put("numfact"," ");
            param.put("datyfact",enc_mere[0].getDaty());
            //param.put("totalcolis", " ");
            //param.put("totalpoids", " ");
            param.put("modepaiement",enc_mere[0].getModepaiementlib());
            param.put("reference",enc_mere[0].getReference());
            param.put("devise", enc_mere[0].getIdDevise());
//            param.put("echeance",enc_mere[0].);
//            param.put("dateEcheance", enc_mere[0].);
            param.put("livraison", enc_mere[0].getModelivraisonlib());

        }
       
        BonDeCommandeFIlleCpl vf = new BonDeCommandeFIlleCpl();
        vf.setNomTable("BC_CLIENT_FILLE_CPL_LIB_PDF");
        BonDeCommandeFIlleCpl[] v_fille = (BonDeCommandeFIlleCpl[]) CGenUtil.rechercher(vf, null, null, c,
                " AND idbc = '" + id + "'");
        dataSource.addAll(Arrays.asList(v_fille));
        if (v_fille != null && v_fille.length > 0) {
            filleSize = v_fille.length;
        }
        double montant = AdminGen.calculSommeDouble(v_fille,"montant");
        double montantHT = AdminGen.calculSommeDouble(v_fille,"montantremise");
        double montantTVA = AdminGen.calculSommeDouble(v_fille,"montantTva");
        double montantTTC = AdminGen.calculSommeDouble(v_fille,"montantttc");
        double frais = AdminGen.calculSommeDouble(v_fille,"frais");

        BonDeCommandeFIlleCpl[] v_fille_service = (BonDeCommandeFIlleCpl[]) AdminGen.find(v_fille, new String[]{"categorieingredient"}, new String[]{ConstanteAsync.CATEGORIE_SERVICES});
        double totalColis = 0;
        double totalPoids = 0;
        if (v_fille_service != null && v_fille_service.length > 0) {
            List<BonDeCommandeFIlleCpl> res = new ArrayList<>();
            for (BonDeCommandeFIlleCpl d : v_fille) {
                boolean aRetirer = false;
                for (BonDeCommandeFIlleCpl s : v_fille_service) {
                    if (d.getId().equals(s.getId())) {
                        aRetirer = true;
                        break;
                    }
                }
                if (!aRetirer) res.add(d);
            }
            BonDeCommandeFIlleCpl[] v_fille_filtre = res.toArray(new BonDeCommandeFIlleCpl[0]);
            totalColis = AdminGen.calculSommeDouble(v_fille_filtre,"QUANTITE");
            totalPoids = AdminGen.calculSommeDouble(v_fille_filtre,"POIDSTOTAL");

        }else{
            totalColis = AdminGen.calculSommeDouble(v_fille,"QUANTITE");
            totalPoids = AdminGen.calculSommeDouble(v_fille,"POIDSTOTAL");
        }

        String montantNetLettre = ChiffreLettre.convertRealToString(montantTTC);
            if (montantNetLettre.contains(",")) {
                montantNetLettre = montantNetLettre.replace(",", " virgule ");
            }
//            } else {
//                montantNetLettre += " Ariary";
//            }
        if (v_fille.length > 0) {
            boolean isRistourne = false;
            if (v_fille[0].getRistourne() > 0){
                isRistourne = true;
                double totalRistourne = AdminGen.calculSommeDouble(v_fille,"MONTANTRISTOURNE");
                param.put("totalRistourne", totalRistourne);
            }else{
                double totalRemise = AdminGen.calculSommeDouble(v_fille,"MONTANTDELAREMISE");
                param.put("totalRemise", totalRemise);
            }
            param.put("isRistourne", isRistourne);
        }
        param.put("montantNetLettre", montantNetLettre);
        param.put("totalbrut",montant);
        param.put("participation_transport",frais);
        param.put("totalHt",montantHT);
        param.put("total_taxes",montantTVA);
        param.put("montantttc",montantTTC);
        //param.put("escompte","");
        param.put("net_payer",montantTTC);
        param.put("net_payer_fmg",montantTTC*5);
        param.put("totalcolis",totalColis);
        param.put("totalPoids",totalPoids);
        param.put("limit", limit);
        param.put("filleSize", filleSize);
        setNomJasper("bc-vente2");
        UtilitaireImpression.imprimer(request, response,id, param, dataSource, getReportPath());
         } catch (Exception e) {
            throw e;
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
    }
    private void situation_globale(HttpServletRequest request, HttpServletResponse response) throws IOException, JRException, Exception{
        Connection c = null;
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
            }
        Map param = new HashMap();
        List dataSource = new ArrayList();
        String id = request.getParameter("id");
        Of t = new Of();
        t.setId(id);
        Of[] of_mere = (Of[]) CGenUtil.rechercher(t, null, null, c,
        " AND ID = '" + id + "'");
        if (of_mere.length > 0) {
          param.put("daty", of_mere[0].getDaty());
          param.put("id", of_mere[0].getId());
        }

        OfEtatGlobal ofGlobal = new OfEtatGlobal(id);
        Of of = ofGlobal.getOf();
        HashMap<String, Vector> mapRapprochement = ofGlobal.getRapprochement();
        MvtStockFilleTheorique[] rapprochementGlobal = ofGlobal.getRapprochementGlobal();
        OfFilleCpl[] details = ofGlobal.getDetails();

        List<MvtStockFilleTheorique> rapprochement = new ArrayList();
        for (Vector v : mapRapprochement.values()) {
            for (Object obj : v) {
                if (obj instanceof MvtStockFilleTheorique) {
                    rapprochement.add((MvtStockFilleTheorique) obj);
                }
            }
        }

        MvtStockFilleTheorique.calculerPourcentage(rapprochementGlobal);
        List<MvtStockFilleTheorique> listerapproche_globales = new ArrayList<>();
        if (rapprochementGlobal != null) {
            Collections.addAll(listerapproche_globales, rapprochementGlobal);
        }
        
        List<OfFilleCpl> listeDetails = new ArrayList<>();
        if (details != null) {
            Collections.addAll(listeDetails, details);
        }
        System.out.println("details = "+details.length);
        param.put("rapprochement", rapprochement);
        param.put("listeDetails", listeDetails);
        param.put("listerapproche_globales", listerapproche_globales);
        setNomJasper("situation_globale");
        UtilitaireImpression.imprimer(request, response, getNomJasper(), param, dataSource, getReportPath());
        } catch (Exception e) {
            throw e;
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
    }

    private void offille_situation_globale(HttpServletRequest request, HttpServletResponse response) throws IOException, JRException, Exception{
        Connection c = null;
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
            }
        Map param = new HashMap();
        List dataSource = new ArrayList();
        String id = request.getParameter("id");

        OffilleEtatGlobal etatGlobal = new OffilleEtatGlobal(id);
        OfFilleCpl offille = etatGlobal.getOffille();
        String idMere = offille.getIdMere();

        Of[] of_mere = (Of[]) CGenUtil.rechercher(new Of(), null, null, c,
                " AND ID = '" + idMere + "'");
        if (of_mere.length > 0) {
            param.put("daty", of_mere[0].getDaty());
            param.put("id", of_mere[0].getId());
            param.put("idfille", id);
        }

        param.put("article","Carton de 18 CB(PF)");
        param.put("qte", offille.getQte());
        param.put("qteFabrique", offille.getQteFabrique());
        param.put("qteReste", offille.getQteReste());
        param.put("puRevient", offille.getPuRevient());
        param.put("pv", offille.getPv());
        param.put("montantRevient", Utilitaire.enleverExponentielleDouble(offille.getMontantRevient()));
        param.put("montantEntree", Utilitaire.enleverExponentielleDouble(offille.getMontantentree()));
        param.put("montantSortie", Utilitaire.enleverExponentielleDouble(offille.getMontantsortie()));
        param.put("tauxRevient", Utilitaire.enleverExponentielleDouble(offille.getTauxRevient()));

        HashMap<String, Vector> mapRapprochement = etatGlobal.getRapprochement();
        MvtStockFilleTheorique[] rapprochementGlobal = etatGlobal.getRapprochementGlobal();

        List<MvtStockFilleTheorique> rapprochement = new ArrayList();
        for (Vector v : mapRapprochement.values()) {
            for (Object obj : v) {
                if (obj instanceof MvtStockFilleTheorique) {
                    rapprochement.add((MvtStockFilleTheorique) obj);
                }
            }
        }

        MvtStockFilleTheorique.calculerPourcentage(rapprochementGlobal);
        List<MvtStockFilleTheorique> listerapproche_globales = new ArrayList<>();
        if (rapprochementGlobal != null) {
            Collections.addAll(listerapproche_globales, rapprochementGlobal);
        }

        param.put("rapprochement", rapprochement);
        param.put("listerapproche_globales", listerapproche_globales);
        setNomJasper("offille_situation_globale");
        UtilitaireImpression.imprimer(request, response, getNomJasper(), param, dataSource, getReportPath());
        } catch (Exception e) {
            throw e;
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
    }
    private void vente_liste(HttpServletRequest request, HttpServletResponse response) throws IOException, JRException, Exception{
        Connection c = null;
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
            }
        Map param = new HashMap();
        List dataSource = new ArrayList();
        String id = request.getParameter("id");
        String designation = request.getParameter("designation");
        String idClientLib = request.getParameter("idClientLib");
        String daty1 = request.getParameter("daty1");
        String daty2 = request.getParameter("daty2");
        String awhere="";
        VenteLib v = new VenteLib();
        v.setNomTable("VENTE_CPL");
        v.setId(id);
        v.setDesignation(designation);
        v.setIdClientLib(idClientLib);
        if ((daty1 != null && !daty1.trim().isEmpty()) || (daty2 != null && !daty2.trim().isEmpty())) {
            if (daty1 != null && !daty1.trim().isEmpty()) {
                awhere += " and daty >= to_date('" + daty1 + "', 'dd/mm/yyyy') ";
                param.put("datymin", daty1);
            }
            if (daty2 != null && !daty2.trim().isEmpty()) {
                awhere += " and daty <= to_date('" + daty2 + "', 'dd/mm/yyyy') ";
                param.put("datymax", daty2);
            }
        }
        VenteLib[] enc_mere = (VenteLib[]) CGenUtil.rechercher(v, null, null, c,awhere);
        //double montantHT = AdminGen.calculSommeDouble(enc_mere,"montantHT");
        dataSource.addAll(Arrays.asList(enc_mere));
        setNomJasper("facture_vente_mere");
        UtilitaireImpression.imprimer(request, response, getNomJasper(), param, dataSource, getReportPath());
        } catch (Exception e) {
            throw e;
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
    }
    private void vente_liste_mere_fille(HttpServletRequest request, HttpServletResponse response) throws IOException, JRException, Exception{
        Connection c = null;
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
            }
        Map param = new HashMap();
        List dataSource = new ArrayList();
        String id = request.getParameter("id");
        String designation = request.getParameter("designation");
        String idClientLib = request.getParameter("idClientLib");
        String daty1 = request.getParameter("daty1");
        String daty2 = request.getParameter("daty2");
        String awhere="";
        VenteLib v = new VenteLib();
        v.setNomTable("VENTE_CPL");
        v.setId(id);
        v.setDesignation(designation);
        v.setIdClientLib(idClientLib);
        if ((daty1 != null && !daty1.trim().isEmpty()) || (daty2 != null && !daty2.trim().isEmpty())) {
            if (daty1 != null && !daty1.trim().isEmpty()) {
                awhere += " and daty >= to_date('" + daty1 + "', 'dd/mm/yyyy') ";
                param.put("datymin", daty1);
            }
            if (daty2 != null && !daty2.trim().isEmpty()) {
                awhere += " and daty <= to_date('" + daty2 + "', 'dd/mm/yyyy') ";
                param.put("datymax", daty2);
            }
        }
        VenteLib[] enc_mere = (VenteLib[]) CGenUtil.rechercher(v, null, null, c, awhere);
        Map<String, List<VenteDetailsLib>> listedetailsMap = new HashMap<>();
        for (VenteLib venteMere : enc_mere) {
            VenteDetailsLib vf = new VenteDetailsLib();
            vf.setNomTable("VENTE_DETAILS_CPL");
            vf.setIdVente(venteMere.getId());
            VenteDetailsLib[] enc_fille = (VenteDetailsLib[]) CGenUtil.rechercher(vf, null, null, c, "");
            if (enc_fille != null) {
                listedetailsMap.put(venteMere.getId(), Arrays.asList(enc_fille));
            } else {
                listedetailsMap.put(venteMere.getId(), new ArrayList<>());
            }
        }
        param.put("listedetails", listedetailsMap);
        List<VenteLib> dataSourceMere = Arrays.asList(enc_mere);
        setNomJasper("facture_vente_mere_fille");
        UtilitaireImpression.imprimer(request, response, getNomJasper(), param, dataSourceMere, getReportPath());
        } catch (Exception e) {
            throw e;
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }

    }

    private void proforma(HttpServletRequest request, HttpServletResponse response) throws IOException, JRException, Exception{
        Connection c = null;
        Map param = new HashMap();
        List dataSource = new ArrayList();
        String id = request.getParameter("id");
        ProformaLib v = new ProformaLib();
        v.setNomTable("PROFORMA_CPL");
        ProformaLib[] enc_mere = (ProformaLib[]) CGenUtil.rechercher(v, null, null, null,
                " AND ID = '" + id + "'");
        v = enc_mere[0];
        param.put("tel", ConstanteVente.tel);
        param.put("fax", ConstanteVente.fax);
        param.put("tel1", ConstanteVente.tel1);
        param.put("tel2", ConstanteVente.tel2);
        param.put("email", ConstanteVente.email);
        param.put("bni_cl", ConstanteVente.bni_cl);
        param.put("boa", ConstanteVente.boa);
        param.put("bmoi", ConstanteVente.bmoi);
        param.put("bfv_sg", ConstanteVente.bfv_sg);
        param.put("cf", ConstanteVente.cf);
        param.put("stat", ConstanteVente.stat);
        param.put("nif", ConstanteVente.nif);
        param.put("datyJour", Utilitaire.dateDuJour());
        if (enc_mere.length > 0) {
             ClientLib cl = new ClientLib();
            cl.setNomTable("CLIENT");
            ClientLib client = (ClientLib) cl.getById(enc_mere[0].getIdClient(),"CLIENT" , null);
            if (enc_mere.length > 0) {
                param.put("idclient",client.getCodeclient());
                param.put("nomClient",client.getNom());
                param.put("adresseClient",client.getAdresse());
                param.put("lieuClient",client.getProvinceLib());
                param.put("telClient",client.getTelephone());
                param.put("statclient",client.getStat());
                param.put("nifclient",client.getNif());
                param.put("cp",client.getCarte());
                param.put("quit","");
                param.put("datyclient",client.getDatecarte());
            }
            param.put("numfact",enc_mere[0].getId());
            param.put("datyfact",enc_mere[0].getDaty());
            //param.put("totalcolis","");
            //param.put("totalpoids","");
            param.put("modepaiement","");
            param.put("reference","");
            param.put("livraison","");
            param.put("transport","");
            if (client != null){
                double resteFacture = 0;
                VenteLib bc = new VenteLib();
                bc.setNomTable("VENTE_CPL");
                bc.setEtat(ConstanteEtat.getEtatValider());
                bc.setIdClient(client.getId());
                VenteLib[] venteLibs = (VenteLib[]) CGenUtil.rechercher(bc, null, null, " ");
                if (venteLibs.length > 0){
                    for (int i = 0; i < venteLibs.length; i++) {
                        if (venteLibs[i].getMontantreste() > 0){
                            resteFacture += venteLibs[i].getMontantreste();
                        }
                    }
                }
                param.put("resteFacture", resteFacture);
            }
        }
        }
        private void proformaFF(HttpServletRequest request, HttpServletResponse response) throws IOException, JRException, Exception{
        Connection c = null;
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
            }
        Map param = new HashMap();
        List dataSource = new ArrayList();
        String id = request.getParameter("id");
        ProformaFournisseurCpl v = new ProformaFournisseurCpl();
        v.setNomTable("proformafournisseur_merecpl");
        ProformaFournisseurCpl[] enc_mere = (ProformaFournisseurCpl[]) CGenUtil.rechercher(v, null, null, c,
                " AND ID = '" + id + "'");
        v = enc_mere[0];
        param.put("tel", ConstanteVente.tel);
        param.put("fax", ConstanteVente.fax);
        param.put("tel1", ConstanteVente.tel1);
        param.put("tel2", ConstanteVente.tel2);
        param.put("email", ConstanteVente.email);
        param.put("bni_cl", ConstanteVente.bni_cl);
        param.put("boa", ConstanteVente.boa);
        param.put("bmoi", ConstanteVente.bmoi);
        param.put("bfv_sg", ConstanteVente.bfv_sg);
        param.put("cf", ConstanteVente.cf);
        param.put("stat", ConstanteVente.stat);
        param.put("nif", ConstanteVente.nif);
        param.put("datyJour", Utilitaire.dateDuJour());
        if (enc_mere.length > 0) {
             Fournisseur cl = new Fournisseur();
            cl.setNomTable("FOURNISSEUR");
            Fournisseur client = (Fournisseur) cl.getById(enc_mere[0].getFournisseur(),"Fournisseur" , c);
            if (enc_mere.length > 0) {
                param.put("idclient",client.getId());
                param.put("nomClient",client.getNom());
                param.put("adresseClient",client.getAdresse());
                param.put("telClient",client.getContact());
                param.put("statclient",client.getStat());
                param.put("nifclient",client.getNif());
                param.put("quit","");
                
            }
            param.put("numfact",enc_mere[0].getId());
            param.put("datyfact",enc_mere[0].getDaty());
            //param.put("totalcolis","");
            //param.put("totalpoids","");
            param.put("modepaiement","");
            param.put("reference","");
            param.put("livraison","");
            param.put("transport","");
           
        }


        ProformaFournisseurDetailsCpl vf = new ProformaFournisseurDetailsCpl();
        ProformaFournisseurDetailsCpl[] v_fille = (ProformaFournisseurDetailsCpl[]) CGenUtil.rechercher(vf, null, null, c,
                " and idmere='" + id + "'");
        dataSource.addAll(Arrays.asList(v_fille));
        double montantHT = AdminGen.calculSommeDouble(v_fille,"montantHT");
        //double fraistransport = AdminGen.calculSommeDouble(v_fille, "fraistransport")
        double montantNetHt = AdminGen.calculSommeDouble(v_fille,"montanttotal");
        double totalTaxe = AdminGen.calculSommeDouble(v_fille,"montanttva");
        double montantTTC = AdminGen.calculSommeDouble(v_fille,"montantttc");

        //double frais = AdminGen.calculSommeDouble(v_fille,"frais");
        param.put("montantNetLettre",ChiffreLettre.convertRealToString(montantTTC));
        param.put("total_HT",montantHT);
//        param.put("transport",v.getFraislivraison());

        param.put("total_net_HT",montantNetHt);
        param.put("total_taxe",totalTaxe);
        param.put("net_payer",montantTTC);
        setNomJasper("proformaFF");
        UtilitaireImpression.imprimer(request, response, getNomJasper()+"-"+id, param, dataSource, getReportPath());
        } catch (Exception e) {
            throw e;
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
    }
        private void proforma_vente(HttpServletRequest request, HttpServletResponse response) throws IOException, JRException, Exception{
        Connection c = null;
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
            }
        Map param = new HashMap();
        List dataSource = new ArrayList();
        String id = request.getParameter("id");
        ProformaLib v = new ProformaLib();
        v.setNomTable("PROFORMA_CPL");
        ProformaLib[] enc_mere = (ProformaLib[]) CGenUtil.rechercher(v, null, null, c,
                " AND ID = '" + id + "'");
        v = enc_mere[0];
        param.put("id", id);
        param.put("tel", ConstanteVente.tel);
        param.put("fax", ConstanteVente.fax);
        param.put("tel1", ConstanteVente.tel1);
        param.put("tel2", ConstanteVente.tel2);
        param.put("email", ConstanteVente.email);
        param.put("bni_cl", ConstanteVente.bni_cl);
        param.put("boa", ConstanteVente.boa);
        param.put("bmoi", ConstanteVente.bmoi);
        param.put("bfv_sg", ConstanteVente.bfv_sg);
        param.put("cf", ConstanteVente.cf);
        param.put("stat", ConstanteVente.stat);
        param.put("nif", ConstanteVente.nif);
        param.put("rcs", ConstanteVente.rcs);
        param.put("datyJour", Utilitaire.dateDuJour());
        param.put("adresse1", ConstanteVente.ADRESSE_CENTRE);
        param.put("adresse2", ConstanteVente.CENTRE_FISCAL);
        String deviseDefault = ConstanteAsync.DEVISE_AR;
        int limit = 13;
        int filleSize = 0;
        if (enc_mere.length > 0) {
             ClientLib cl = new ClientLib();
            cl.setNomTable("CLIENTLIB");
            ClientLib client = (ClientLib) cl.getById(enc_mere[0].getIdClient(),"CLIENTLIB" , c);
            if (enc_mere.length > 0) {
                param.put("idclient",client.getId());
                param.put("nomClient",client.getNom());
                param.put("adresseClient",client.getAdresse());
                param.put("telClient",client.getTelephone());
                param.put("statclient",client.getStat());
                param.put("nifclient",client.getNif());
                param.put("quit","");
                param.put("datyclient",client.getDatecarte());
                
            }
            param.put("numfact"," ");
            param.put("datyfact",enc_mere[0].getDaty());
//            param.put("modepaiement","");
            param.put("reference",enc_mere[0].getIdOrigine());
            param.put("devise", enc_mere[0].getIdDevise());
            deviseDefault = enc_mere[0].getIdDevise();
        }


        ProformaDetailsLib vf = new ProformaDetailsLib();
        vf.setNomTable("PROFORMADETAILS_CPL_PDF");
        ProformaDetailsLib[] v_fille = (ProformaDetailsLib[]) CGenUtil.rechercher(vf, null, null, c,
                " and idProforma='" + id + "'");
        dataSource.addAll(Arrays.asList(v_fille));
        if (v_fille != null && v_fille.length > 0) {
            filleSize = v_fille.length;
        }
        ProformaDetailsLib[] v_fille_service = (ProformaDetailsLib[]) AdminGen.find(v_fille, new String[]{"categorieingredient"}, new String[]{ConstanteAsync.CATEGORIE_SERVICES});
        double totalColis = 0;
        double totalPoids = 0;
        if (v_fille_service != null && v_fille_service.length > 0) {
            List<ProformaDetailsLib> res = new ArrayList<>();
            for (ProformaDetailsLib d : v_fille) {
                boolean aRetirer = false;
                for (ProformaDetailsLib s : v_fille_service) {
                    if (d.getId().equals(s.getId())) {
                        aRetirer = true;
                        break;
                    }
                }
                if (!aRetirer) res.add(d);
            }
            ProformaDetailsLib[] v_fille_filtre = res.toArray(new ProformaDetailsLib[0]);
            totalColis = AdminGen.calculSommeDouble(v_fille_filtre,"QTE");
            totalPoids = AdminGen.calculSommeDouble(v_fille_filtre,"POIDSTOTAL");

        }else{
            totalColis = AdminGen.calculSommeDouble(v_fille,"QTE");
            totalPoids = AdminGen.calculSommeDouble(v_fille,"POIDSTOTAL");
        }
        if (v_fille.length > 0) {
            boolean isRistourne = false;
            if (v_fille[0].getRistourne() > 0){
                isRistourne = true;
                double totalRistourne = AdminGen.calculSommeDouble(v_fille,"MONTANTRISTOURNE");
                param.put("totalRistourne", totalRistourne);
            }else{
                double totalRemise = AdminGen.calculSommeDouble(v_fille,"REMISEMONTANT");
                param.put("totalRemise", totalRemise);
            }
            param.put("isRistourne", isRistourne);
        }
        double montantHT = AdminGen.calculSommeDouble(v_fille,"puTotal");
        //double fraistransport = AdminGen.calculSommeDouble(v_fille, "fraistransport")
        double montantNetHt = AdminGen.calculSommeDouble(v_fille,"montanttotal");
        double totalTaxe = AdminGen.calculSommeDouble(v_fille,"montanttva");
        double montantTTC = AdminGen.calculSommeDouble(v_fille,"montantttc");

        
        String montantNetLettre = ChiffreLettre.convertRealToString(montantTTC);
            if (montantNetLettre.contains(",")) {
                montantNetLettre = montantNetLettre.replace(",", " " + deviseDefault + " et");
            } else {
                montantNetLettre += " " + deviseDefault;
            }
        double montant = AdminGen.calculSommeDouble(v_fille,"montanttotal");
        param.put("montantNetLettre", montantNetLettre);
        param.put("totalbrut",montantHT);
        //param.put("participation_transport",frais);
        param.put("totalHt",montantNetHt);
        param.put("total_taxes",totalTaxe);
        param.put("montantttc",montantTTC);
        //param.put("escompte","");
        param.put("net_payer",montantTTC);
        param.put("net_payer_fmg",montantTTC*5);
        param.put("totalcolis",totalColis);
        param.put("totalPoids",totalPoids);
        param.put("limit", limit);
        param.put("filleSize", filleSize);
        setNomJasper("proforma_vente2");
        String filename = "PROFORMA-"+ id;
        UtilitaireImpression.imprimer(request, response, filename, param, dataSource, getReportPath());
        } catch (Exception e) {
            throw e;
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
    }


    private void imprimerDeclaration(HttpServletRequest request, HttpServletResponse response) throws Exception{
        Connection c = null;
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
            }
        String id = request.getParameter("id");

        DeclarationTvaLib declib = new DeclarationTvaLib();

        DeclarationTvaLib[] decls = (DeclarationTvaLib[]) CGenUtil.rechercher(declib, null, null, c," AND ID='"+id+"'");
        if(decls.length <1){
            throw new Exception("Pas de declaration pour : "+id);
        }


        Map param = new HashMap();
        List dataSource = new ArrayList();
        ImprimerDeclaration[] enc_mere = (ImprimerDeclaration[]) CGenUtil.rechercher(new ImprimerDeclaration(), null, null, c,"");

        DeclarationTva dec = new DeclarationTva(decls[0].getDatydebut(),decls[0].getDatyfin());
        HashMap<String, ImprimerDeclaration> res = dec.getDonnees();
        for (int j = 0; j < enc_mere.length; j++) {
            if(enc_mere[j].getId().compareToIgnoreCase(res.get(enc_mere[j].getId()).getId())==0){
                enc_mere[j].setMontant(res.get(enc_mere[j].getId()).getMontant()*(res.get(enc_mere[j].getId()).getTaux()/100));
                //enc_mere[j].setMontantadeclarer(calcule.getMontant()*(calcule.getTaux()/100));
                System.out.println(enc_mere[j].getNumero()+"====="+enc_mere[j].getMontant());
            }
        }
        param.put("nif", ConstanteVente.nif);
        param.put("raisonSocial", ConstanteVente.RAISON_SOCIAL);
        param.put("adresse", ConstanteVente.ADRESSE);
        param.put("adresseCentre", ConstanteVente.ADRESSE_CENTRE);
        param.put("centre", ConstanteVente.CENTRE_FISCAL);
        dataSource.addAll(Arrays.asList(enc_mere));
        setNomJasper("hetra");
        UtilitaireImpression.imprimer(request, response, "imprime-declaration", param, dataSource, getReportPath());
        } catch (Exception e) {
            throw e;
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
    }

    private void cloturecaisse(HttpServletRequest request, HttpServletResponse response) throws IOException, JRException, Exception{
        Connection c = null;
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
            }

            Map param = new HashMap();
            UserEJB u = (UserEJB) request.getSession().getAttribute("u");
            Societe societe = u.getMaSociete();
            if (societe.getLogo() != null && !societe.getLogo().trim().isEmpty()&& !"-".equals(societe.getLogo().trim())) {
                param.put("logo", societe.getLogo());
            }
            param.put("disponnibilite" , societe.getDisponnibilite());
            String id = request.getParameter("id");
            ClotureCaisse clotureCaisse = (ClotureCaisse) new ClotureCaisse().getById(id, "CLOTURECAISSE", c);

            String daty = clotureCaisse.getDaty().toString();
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
            LocalDate localDate = LocalDate.parse(daty, formatter);
            java.sql.Date sqlDate = java.sql.Date.valueOf(localDate);
            param.put("daty", sqlDate);

            String idMagasin = clotureCaisse.getIdPoint();
            Magasin magasin = new Magasin();
            Magasin[] listemagasin = (Magasin[]) CGenUtil.rechercher(magasin, null, null, c, " and id = '"+idMagasin+"'");
            param.put("magasin", listemagasin[0].getVal());
            param.put("devise",ConstanteAsync.DEVISE_AR);

            MvtCaisseParCaissePDF mvtCaisseParCaissePDF = new MvtCaisseParCaissePDF();
            MvtCaisseParCaissePDF[] listeMouvements = mvtCaisseParCaissePDF.getListeMvtCaisseParCaissePDFByDate(daty, c, idMagasin);

            List<MvtCaisseCpl> listeDetails = new ArrayList();
            for (int i = 0; i < listeMouvements.length; i++) {
                if (i != listeMouvements.length-1) {
                    for (int j = 0; j <listeMouvements[i].getListeMvtCaisseCpl().length; j++){
                        if(listeMouvements[i].getListeMvtCaisseCpl()[j].getCredit() != 0){
                            listeDetails.add(listeMouvements[i].getListeMvtCaisseCpl()[j]);
                        }
                    }
                }
                else {
                    for (int j = 0; j <listeMouvements[i].getListeMvtCaisseCpl().length; j++){
                        if(listeMouvements[i].getListeMvtCaisseCpl()[j].getDebit() != 0){
                            listeDetails.add(listeMouvements[i].getListeMvtCaisseCpl()[j]);
                        }
                    }
                }
            }

            param.put("listedetails", listeDetails);

            List dataSource = new ArrayList();
            dataSource.addAll((Arrays.asList(listeMouvements)));

            if (listeMouvements.length == 0) {
                param.put("detailsExiste", false);
            }else{
                param.put("detailsExiste", true);
            }

            double totalGeneral = AdminGen.calculSommeDouble(listeMouvements,"montant");
            param.put("totalgeneral", totalGeneral);
            setNomJasper("Cloturecaisse");
            String filename = "Ticket-Z-" + daty;
            UtilitaireImpression.imprimer(request, response, filename, param, dataSource, getReportPath());
        } catch (Exception e) {
            throw e;
        } finally {
            if (c != null && estOuvert == true) {
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
            Logger.getLogger(ExportPDF.class.getName()).log(Level.SEVERE, null, ex);
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
            Logger.getLogger(ExportPDF.class.getName()).log(Level.SEVERE, null, ex);
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
    
}
