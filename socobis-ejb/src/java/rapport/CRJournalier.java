package rapport;

import bean.CGenUtil;
import caisse.EtatCaisse;
import fabrication.Of;
import fabrication.OfFilleCpl;
import faturefournisseur.FactureFournisseurRecapJournalier;
import paie.avance.Avance;
import prevision.AdminPrevision;
import prevision.Prevision;
import reporting.mail.Mail;
import reporting.mail.MailContent;
import reporting.mail.MailRappel;
import reporting.mail.PageMail;
import reporting.utilitaire.ConstanteCR;
import stock.EtatStockParEntree;
import utilitaire.Utilitaire;
import vente.VenteRecapJournalier;

import java.sql.Date;
import java.util.HashMap;
import java.util.Map;

public class CRJournalier {

//    private  String to = "baovolarajaonarison@gmail.com";
//    private  String[] cc = new String[]{"fitia.razafinjoelina@bici.mg"};


    private  String to = "savtrop@blueline.mg";
    private  String[] cc = new String[]{};
    private  void sendMail(String object, String message, String to, String[] cc) throws Exception {
        Mail mail = new Mail(ConstanteCR.getMailRapport()[0], ConstanteCR.getMailRapport()[1], object, message);
        mail.setTo(to);
        if (cc != null) {
            mail.setCc(cc);
        }

        mail.send();
//        System.out.printf("Le message est : " + message);
    }

    public void sendMailRappel() throws Exception {
        sendMail("Objtect Mail Rappele", contentMailRappel(), getTo(), getCc());
    }

    private  String contentMailRappel() throws  Exception {
        MailRappel mailRappel = new MailRappel();

        mailRappel.setLienLogo("https://images.unsplash.com/photo-1563013544-824ae1b704d3?w=300");
        mailRappel.setNom("Digital Business");
        mailRappel.setTitre("Rappel de votre facture");

        mailRappel.setParagraphe(new String[]{
                "Nous vous remercions de votre confiance. La facture n°[id-facture] reste en attente de règlement.",
                "Le montant dû est de [montant] et la date limite de paiement est fixée au [date].",
                "Pour toute assistance concernant cette facture, notre service client est à votre disposition."
        });

        mailRappel.setContacts(new String[]{
                "Digital Business",
                "+261 38 00 000 00",
                "facturation@digitalbusiness.com"
        });

        Map<String, Object> dataMail = new HashMap<>();
        dataMail.put("id-facture", "INV-2026-1042");
        dataMail.put("montant", "2 450 000 Ar");
        dataMail.put("date", "20/07/2026");

        mailRappel.setData(dataMail);

        return  mailRappel.genererMailRappel();
    }


    private String  contentAchat(Date datejour) throws  Exception {
        String[] libEntete = new String[]{"daty","nombre","montantttc", "montantpaye", "montantreste", "montantresteacejour"};
        String[] libEnteteAffiche = new String[] {"Date", "Nombre", "Montant TTC", "Montant Paye", "Montant Reste", "Montant Reste &agrave; ce jour"};

        FactureFournisseurRecapJournalier ffrecap = new FactureFournisseurRecapJournalier();

        PageMail pageMail = new PageMail();
        MailContent[] mailContents = new MailContent[1];
        MailContent mailContent = new MailContent(ffrecap, "Récapitulation des Achats", libEntete);
        mailContent.setLibEnteteAffiche(libEnteteAffiche);
        mailContents[0] = mailContent;

        String datetest = "2026-07-30";

        return pageMail.genererPageMailAWhere(mailContents, null, "and daty = DATE '" + datejour + "'");
    }

    private  String  contentVente(Date datejour) throws  Exception {
        String[] libEntete = new String[]{"daty","nombre","montantttc", "montantpaye", "montantreste", "montantresteacejour"};
        String[] libEnteteAffiche = new String[] {"Date","Nombre", "Montant TTC", "Montant Paye", "Montant Reste", "Montant reste &agrave; ce jour"};

        VenteRecapJournalier ventesrecap = new VenteRecapJournalier();

        PageMail pageMail = new PageMail();
        MailContent[] mailContents = new MailContent[1];

        MailContent mailContent = new MailContent(ventesrecap, "Récapitulation des ventes", libEntete);
        mailContent.setLibEnteteAffiche(libEnteteAffiche);
        mailContents[0] = mailContent;


        String datetest = "2026-07-30";

        return pageMail.genererPageMailAWhere(mailContents, null, "and daty = DATE '" + datejour + "'");
    }

    private  String  contentStock(Date datejour) throws  Exception {

        String datetest = "2026-06-18";
        String libEntete[] = {"idTypeProduitLib","idMagasinLib","entree","sortie","reste"};
        String libEnteteAffiche[] = {"Cat&eacute;gorie","Magasin","entr&eacute;e","sortie","quantit&eacute;"};

        EtatStockParEntree t = new EtatStockParEntree();

        EtatStockParEntree[] etatStockParEntreeStandards = t.getEtatDeStock(datejour);

        PageMail pageMail = new PageMail();
        MailContent[] mailContents = new MailContent[1];

        MailContent mailContent = new MailContent(t, "Stock", libEntete);
        mailContent.setDataDirect(etatStockParEntreeStandards);
        mailContent.setLibEnteteAffiche(libEnteteAffiche);
        mailContents[0] = mailContent;

        return pageMail.genererPageMailAWhere(mailContents, null, "and daty = DATE '" + datejour + "'");
    }
    private  String  contentEtatCaisse() throws  Exception {
        String libEntete[] = {"idCaisselib","idPointlib","idTypeCaisselib","dateDernierReport","montantDernierReport","credit","debit", "reste"};
        String libEnteteAffiche[] = {"Caisse","Point","Type de Caisse","Date du dernier report","Solde initial","Crédit","Débit", "Solde Final"};
    
        EtatCaisse t = new EtatCaisse();

        PageMail pageMail = new PageMail();
        MailContent[] mailContents = new MailContent[1];

        MailContent mailContent = new MailContent(t, "caisse", libEntete);
        mailContent.setLibEnteteAffiche(libEnteteAffiche);
        mailContents[0] = mailContent;

        Date datejour = Utilitaire.dateDuJourSql();
        String datetest = "2024-07-17";
        return pageMail.genererPageMailAWhere(mailContents, null, "and dateDernierReport =  DATE'" + datejour + "'");
    }

    private  String  contentPaie() throws  Exception {
        String libEntete[] = {"id", "idpersonnel","matricule", "montant","interet", "nbremboursement","etatlib"};
        String libEnteteAffiche[] =  {"ID", "Personnel","Matricule", "Montant(Ar)","Int&eacute;r&ecirc;t (%)","Nombre de remboursement","&Eacute;tat"};

        Avance lv = new Avance();
        lv.setNomTable("AVANCE_LIB2");

        PageMail pageMail = new PageMail();
        MailContent[] mailContents = new MailContent[1];

        MailContent mailContent = new MailContent(lv, "Avances", libEntete);
        mailContent.setLibEnteteAffiche(libEnteteAffiche);
        mailContents[0] = mailContent;

        Date datejour = Utilitaire.dateDuJourSql();
        String datetest = "2026-06-18";
        return pageMail.genererPageMailAWhere(mailContents, null, "and DATEAVANCE = DATE '" + datejour + "'");
    }




    public String getTexte() {
        Date datejour = Utilitaire.dateDuJourSql();
        String datetest = "2026-07-30";

        StringBuilder html = new StringBuilder();

        html.append("<!DOCTYPE html>");
        html.append("<html>");
        html.append("<head>");
        html.append("<meta charset='UTF-8'>");

        html.append("<style>");
        html.append("body{");
        html.append("font-family:Arial,Helvetica,sans-serif;");
        html.append("font-size:14px;");
        html.append("color:#333333;");
        html.append("background:#f5f5f5;");
        html.append("margin:0;");
        html.append("padding:20px;");
        html.append("}");

        html.append(".container{");
        html.append("max-width:1100px;");
        html.append("margin:auto;");
        html.append("background:#ffffff;");
        html.append("padding:25px;");
        html.append("border:1px solid #dddddd;");
        html.append("}");

        html.append("h1{");
        html.append("font-size:22px;");
        html.append("margin:0 0 10px;");
        html.append("color:#222222;");
        html.append("}");

        html.append("h2{");
        html.append("font-size:17px;");
        html.append("margin:30px 0 12px;");
        html.append("padding-bottom:6px;");
        html.append("border-bottom:2px solid #444444;");
        html.append("color:#222222;");
        html.append("}");

        html.append("p{");
        html.append("margin:8px 0;");
        html.append("line-height:1.6;");
        html.append("}");

        html.append(".intro{");
        html.append("margin-bottom:25px;");
        html.append("}");

        html.append(".section{");
        html.append("margin-top:20px;");
        html.append("}");

        html.append(".footer{");
        html.append("margin-top:35px;");
        html.append("font-size:12px;");
        html.append("color:#777777;");
        html.append("border-top:1px solid #dddddd;");
        html.append("padding-top:15px;");
        html.append("}");

        html.append("table{");
        html.append("width:100%;");
        html.append("border-collapse:collapse;");
        html.append("margin-top:10px;");
        html.append("}");

        html.append("th,td{");
        html.append("border:1px solid #dcdcdc;");
        html.append("padding:8px;");
        html.append("text-align:left;");
        html.append("}");

        html.append("th{");
        html.append("background:#eeeeee;");
        html.append("}");
        html.append("</style>");

        html.append("</head>");
        html.append("<body>");
        html.append("<div class='container'>");

        html.append("<h1>Compte rendu journalier</h1>");

        html.append("<div class='intro'>");
        html.append("<p>Bonjour,</p>");
        html.append("<p>");
        html.append("Veuillez trouver ci-dessous le compte rendu des activités du <strong>");
        html.append(datejour);
        html.append("</strong>.");
        html.append("</p>");
        html.append("<p>");
        html.append("Ce rapport présente une synthèse des opérations d'achat, de vente enregistrées pour la journée.");
        html.append("</p>");
        html.append("</div>");

        return html.toString();
    }

    public void sendPageEmail(Date datejour) throws Exception {


        String datetest = "2026-07-30";

        String objet = "SAVONNERIE - Compte rendu journalier - " + datejour;

        StringBuilder message = new StringBuilder();

        message.append(getTexte());

        message.append("<div class='section'>");
        message.append("<h2>Achats</h2>");
        message.append("<p>Récapitulatif des opérations d'approvisionnement enregistrées au cours de la journée.</p>");
        message.append(contentAchat(datejour));
        message.append("</div>");

        message.append("<div class='section'>");
        message.append("<h2>Ventes</h2>");
        message.append("<p>Situation des ventes réalisées durant la journée.</p>");
        message.append(contentVente(datejour));
        message.append("</div>");

        message.append("<div class='section'>");
        message.append("<h2>Stock</h2>");
        message.append("<p>Situation du stock à la fin de la journée.</p>");
        message.append(contentStock(datejour));
        message.append("</div>");

        message.append("<div class='footer'>");
        message.append("Ce message a été généré automatiquement par le système d'information.");
        message.append("</div>");

        message.append("</div>");
        message.append("</body>");
        message.append("</html>");

        sendMail(objet, message.toString(), getTo(), getCc());
    }

    public String[] getCc() {
        return cc;
    }

    public CRJournalier setCc(String[] cc) {
        this.cc = cc;
        return this;
    }

    public  String getTo() {
        return  this.to;
    }

    public  void setTo(String to) {
        this.to = to;
    }

}

