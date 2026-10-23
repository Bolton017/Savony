package vente;

import bean.AdminGen;
import bean.CGenUtil;
import java.io.File;
import java.sql.Connection;
import java.sql.Date;
import net.sf.jasperreports.engine.*;
import net.sf.jasperreports.engine.data.JRBeanCollectionDataSource;
import net.sf.jasperreports.engine.export.JRPrintServiceExporter;
import net.sf.jasperreports.engine.export.JRPrintServiceExporterParameter;
import utilitaire.UtilDB;
import utilitaire.Utilitaire;
//import utils.ConstanteAigledor;
import utilisateur.Utilisateur;


import javax.print.PrintService;
import javax.print.PrintServiceLookup;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import produits.IngredientsRemise;
import user.UserEJB;
import societe.Societe;


public class ExportPDFDirect {

    /**
     * Génère et imprime la facture d'une vente.
     *
     * @param idVente l'ID de la vente
     */
    public static void ficheVente(String idVente) {
        try {
            Map<String, Object> param = new HashMap<>();
            List<VenteDetailsLib> dataSource = new ArrayList<>();

            VenteLib v = new VenteLib();
            VenteLib[] enc_mere = (VenteLib[]) CGenUtil.rechercher(v, null, null, null,
                    " AND ID = '" + idVente + "'");
            if (enc_mere.length > 0) {
                VenteLib vente = enc_mere[0];

                param.put("montantPaye", vente.getMontantpaye());
                param.put("montantretour", vente.getMontantRetourner());
                param.put("heure", Utilitaire.heureCouranteHMS());
                param.put("designation", vente.getDesignation());
                param.put("MAGASINCONSIDERER", vente.getIdMagasinLib());
                param.put("daty", vente.getDaty());
                param.put("remarque", vente.getRemarque());
                param.put("devise", vente.getIdDevise());
                param.put("numFact", idVente);
                param.put("num", idVente);
                param.put("modeDePaie", vente.getIdModePaiementLib());
                param.put("montantApayer", vente.getMontantpaye());
                param.put("montantReste", vente.getMontantreste());
                param.put("nom", vente.getNomClientDivers());
                param.put("montantAvoir", vente.getMontantreste() < 0 ? vente.getMontantreste() : 0);
                param.put("montantDonne", vente.getMontantDonne());
                param.put("netapayer", vente.getMontantttc());
                param.put("montanttotal", vente.getMontantttc());
                param.put("idmodepaiementlib", vente.getIdModePaiementLib());

                double reste = vente.getMontantDonne() - vente.getMontantttc();
                param.put("reste", reste);

            }

            // Infos société
//        param.put("lieu", ConstanteAigledor.lieuMagasin);
//        param.put("MAGASINCONSIDERER", "Aigle D'Or");
//        param.put("tel", ConstanteAigledor.tel);
//        param.put("tel1", ConstanteAigledor.tel1);
//        param.put("tel2", ConstanteAigledor.tel2);
//        param.put("nif", ConstanteAigledor.nif);
//        param.put("stat", ConstanteAigledor.stat);
//        param.put("mail", ConstanteAigledor.mail);
//        param.put("disponibilite1", ConstanteAigledor.disponibilite1);
//        param.put("disponibilite2", ConstanteAigledor.disponibilite2);

            // Libellés
            param.put("niflib", "Nif");
            param.put("totallib", "TOTAL");
            param.put("montantavoirlib", "Montant Avoir");
            param.put("montantaplib", "Net à Payer");
            param.put("montantpayelib", "Montant Payé");
            param.put("resteapayelib", "Reste à Payer");
            param.put("statlib", "Stat");
            param.put("date", "Date");
            param.put("client", "Client");

            // Détails vente
            VenteDetailsLib vf = new VenteDetailsLib();
            vf.setNomTable("VENTE_DETAILS_CPL");
            vf.setIdVente(idVente);
            VenteDetailsLib[] v_fille = (VenteDetailsLib[]) CGenUtil.rechercher(vf, null, null, null,
                    " AND idVente = '" + idVente + "'");
            for (VenteDetailsLib vd : v_fille) {
                if (!"APP".equals(vd.getIdProduit())) {
                    dataSource.add(vd);
                }
            }
            //dataSource.addAll(Arrays.asList(v_fille));

            // Sommes
            double montantHT = AdminGen.calculSommeDouble(v_fille, "montantHTLocal");
            double montantTVA = AdminGen.calculSommeDouble(v_fille, "montantTvaLocal");
            double montantTTC = AdminGen.calculSommeDouble(v_fille, "montantTTCLocal");

            param.put("montantHT", montantHT);
            param.put("montantTVA", montantTVA);
            param.put("montantTTC", montantTTC);
            param.put("devise", v_fille.length > 0 ? v_fille[0].getIdDevise() : "MGA");
            param.put("list_table", new ArrayList<VenteDetailsLib>());
            param.put("nbArticles", v_fille.length);

            // Liste des modes de paiement simulée
            List<Map<String, Object>> modesPaiement = new ArrayList<>();
            Map<String, Object> m1 = new HashMap<>();
            m1.put("libelle", "Espèces");
            m1.put("montant", enc_mere[0].getMontantDonne());
            modesPaiement.add(m1);

            Map<String, Object> m2 = new HashMap<>();
            m2.put("libelle", "Chèque");
            m2.put("montant", 0.0);
            modesPaiement.add(m2);

            Map<String, Object> m3 = new HashMap<>();
            m3.put("libelle", "Carte");
            m3.put("montant", 0.0);
            modesPaiement.add(m3);

//JRBeanCollectionDataSource subDataSource = new JRBeanCollectionDataSource(modesPaiement);
//param.put("LISTE_MODE_PAIEMENT", subDataSource);


            // Rapport Jasper principal
            String reportPath = "D:\\Work\\BICI\\log\\wildfly-10.0.0.Final\\standalone\\deployments\\codal.war\\report\\ticket_caisse.jasper";


            JRBeanCollectionDataSource jrDataSource = new JRBeanCollectionDataSource(dataSource);
            JasperPrint jasperPrint = JasperFillManager.fillReport(reportPath, param, jrDataSource);

            // Impression directe
            PrintService[] services = PrintServiceLookup.lookupPrintServices(null, null);
            String nomImprimante = "POS-80";
            PrintService imprimanteChoisie = null;

            for (PrintService ps : services) {
                if (ps.getName().equalsIgnoreCase(nomImprimante)) {
                    imprimanteChoisie = ps;
                    break;
                }
            }

            if (imprimanteChoisie != null) {
                JRPrintServiceExporter exporter = new JRPrintServiceExporter();
                exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
                exporter.setParameter(JRPrintServiceExporterParameter.PRINT_SERVICE, imprimanteChoisie);
                exporter.setParameter(JRPrintServiceExporterParameter.DISPLAY_PAGE_DIALOG, false);
                exporter.setParameter(JRPrintServiceExporterParameter.DISPLAY_PRINT_DIALOG, false);
                exporter.exportReport();
            } else {
                System.out.println("Imprimante non trouvée !");
            }

            System.out.println("Impression de la vente " + idVente + " terminée !");
        } catch (JRException e) {
            System.out.println("Imprimante not found !");
//        e.printStackTrace();
        } catch (Exception e) {
            System.out.println("Imprimante not found !");
//        throw new RuntimeException(e);
        }
    }

    public static byte[] ficheVenteDirect(String idVente , UserEJB u , String currentAppPath) {
        Connection con=new UtilDB().GetConn();
        try {
            Map<String, Object> param = new HashMap<>();
            List<VenteDetailsLib> dataSource = new ArrayList<>();

            VenteLib v = new VenteLib();
            v.setNomTable("VENTE_DIRECTE_CPL_PDF");
            VenteLib[] enc_mere = (VenteLib[]) CGenUtil.rechercher(v, null, null, con,
                    " AND ID = '" + idVente + "'");
            Date datyVente = null;
            String idClient = null;
            String idPoint = null;
            File currentAppDir = new File(currentAppPath);
            File deploymentsDir = currentAppDir.getParentFile();
            String deploymentsPath = deploymentsDir.getAbsolutePath();
            String targetWar = "dossier.war";
            String appRelativePath = "/async/codebarre/vente/";
            String filenames = idVente+".png";
            String fullPathToSignature = deploymentsPath + File.separator + targetWar + appRelativePath + File.separator + filenames;
            File sigFile = new File(fullPathToSignature);
            if (sigFile.exists()) {
                param.put("codebarre" , fullPathToSignature);
            }else{
                param.put("codebarre", null);
            }
            if (enc_mere.length > 0) {
                VenteLib vente = enc_mere[0];
                param.put("responsable" , "");

                datyVente = vente.getDaty();
                idClient = vente.getIdClient();
                idPoint = vente.getIdMagasin();
                Societe societe = u.getMaSociete();
                if (societe.getLogo() != null && !societe.getLogo().trim().isEmpty()&& !"-".equals(societe.getLogo().trim())) {
                    param.put("logo", societe.getLogo());
                }
                param.put("disponibilite1" , societe.getDisponnibilite());
                param.put("montantPaye", vente.getMontantpaye());
                param.put("montantretour", vente.getMontantRetourner());
                param.put("heure", Utilitaire.heureCouranteHMS());
                param.put("designation", vente.getDesignation());
                param.put("MAGASINCONSIDERER", vente.getIdMagasinLib());
                param.put("daty", vente.getDaty());
                param.put("remarque", vente.getRemarque());
                param.put("devise", vente.getIdDevise());
                param.put("numFact", idVente);
                param.put("num", idVente);
                param.put("modeDePaie", vente.getIdModePaiementLib());
                param.put("montantApayer", vente.getMontantpaye());
                param.put("montantReste", vente.getMontantreste());
                param.put("nom", vente.getIdClientLib());
                param.put("pseudo", vente.getNomClientDivers());
                param.put("montantAvoir", vente.getMontantreste() < 0 ? vente.getMontantreste() : 0);
                param.put("montantDonne", vente.getMontantDonne());
                param.put("netapayer", vente.getMontantttc());
                param.put("montanttotal", vente.getMontantttc());
                param.put("idmodepaiementlib", vente.getIdModePaiementLib());

                double reste = vente.getMontantDonne() - vente.getMontantttc();
                param.put("reste", reste);
            }

            // Infos société
//            param.put("lieu", ConstanteAigledor.lieuMagasin);
//            param.put("MAGASINCONSIDERER", "Aigle D'Or");
//            param.put("tel", ConstanteAigledor.tel);
//            param.put("tel1", ConstanteAigledor.tel1);
//            param.put("tel2", ConstanteAigledor.tel2);
//            param.put("nif", ConstanteAigledor.nif);
//            param.put("stat", ConstanteAigledor.stat);
//            param.put("mail", ConstanteAigledor.mail);
//            param.put("disponibilite1", ConstanteAigledor.disponibilite1);
//            param.put("disponibilite2", ConstanteAigledor.disponibilite2);

            // Libellés
            param.put("niflib", "Nif");
            param.put("totallib", "TOTAL");
            param.put("montantavoirlib", "Montant Avoir");
            param.put("montantaplib", "Net à Payer");
            param.put("montantpayelib", "Montant Payé");
            param.put("resteapayelib", "Reste à Payer");
            param.put("statlib", "Stat");
            param.put("date", "Date");
            param.put("client", "Client");

            // Détails vente
            VenteDetailsLib vf = new VenteDetailsLib();
            vf.setNomTable("VENTE_DETAILS_TICKET");
            vf.setIdVente(idVente);
            VenteDetailsLib[] v_fille = (VenteDetailsLib[]) CGenUtil.rechercher(vf, null, null, con,
                    " AND idVente = '" + idVente + "'");
            for (VenteDetailsLib vd : v_fille) {
                if (!"APP".equals(vd.getIdProduit())) {
                    double remiseAr = IngredientsRemise.getRemiseFromCertainIngredient(idClient, idPoint, vd.getIdProduit(), datyVente,null);
                    vd.setRemiseMontant(remiseAr);
                    double puTotal = (vd.getPu() * vd.getQte()) - (remiseAr * vd.getQte());
                    vd.setPuTotal(puTotal);
                    dataSource.add(vd);
                }
            }
            //dataSource.addAll(Arrays.asList(v_fille));

            // Sommes
            double montantHT = AdminGen.calculSommeDouble(v_fille, "montantHTLocal");
            double montantTVA = AdminGen.calculSommeDouble(v_fille, "montantTvaLocal");
            double montantTTC = AdminGen.calculSommeDouble(v_fille, "montantTTCLocal");

            param.put("montantHT", montantHT);
            param.put("montantTVA", montantTVA);
            param.put("montantTTC", montantTTC);
            param.put("devise", v_fille.length > 0 ? v_fille[0].getIdDevise() : "MGA");
            param.put("list_table", new ArrayList<VenteDetailsLib>());
            param.put("nbArticles", v_fille.length);

            // Liste des modes de paiement simulée
            List<Map<String, Object>> modesPaiement = new ArrayList<>();
            Map<String, Object> m1 = new HashMap<>();
            m1.put("libelle", "Espèces");
            m1.put("montant", enc_mere[0].getMontantDonne());
            modesPaiement.add(m1);

            Map<String, Object> m2 = new HashMap<>();
            m2.put("libelle", "Chèque");
            m2.put("montant", 0.0);
            modesPaiement.add(m2);

            Map<String, Object> m3 = new HashMap<>();
            m3.put("libelle", "Carte");
            m3.put("montant", 0.0);
            modesPaiement.add(m3);

//JRBeanCollectionDataSource subDataSource = new JRBeanCollectionDataSource(modesPaiement);
//param.put("LISTE_MODE_PAIEMENT", subDataSource);


            // Rapport Jasper principal
            String reportPath = "D:\\Work\\BICI\\log\\wildfly-10.0.0.Final\\standalone\\deployments\\codal.war\\report\\ticket_caisse.jasper";


            JRBeanCollectionDataSource jrDataSource = new JRBeanCollectionDataSource(dataSource);
            JasperPrint jasperPrint = JasperFillManager.fillReport(reportPath, param, jrDataSource);

            // Au lieu de l'impression physique, on exporte en byte array (PDF)
            return JasperExportManager.exportReportToPdf(jasperPrint);
        } catch (JRException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

}
