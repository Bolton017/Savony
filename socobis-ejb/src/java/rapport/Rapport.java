package rapport;

import java.sql.Connection;
import java.sql.Date;

import bean.CGenUtil;
import rapport.mail.Mail;
import rapport.mail.MailContent;
import rapport.mail.PageMail;
import rapport.mapping.CRConfig;
import rapport.mapping.MailRapport;
import rapport.utilitaire.ConstanteCR;
import rapport.utilitaire.PdfGeneratorUtil;
import rapport.utilitaire.UtilitaireCR;
import utilitaire.UtilDB;

import utilitaire.Utilitaire;

import rapport.utilitaire.ExcelGeneratorUtil;
public class Rapport {

    public void sendEMails(Date daty)throws Exception{

        Connection c = new UtilDB().GetConn();

        CRConfig crConfig = new CRConfig();
        CRConfig[] crConfigs = (CRConfig[]) CGenUtil.rechercher(crConfig,null, null, c, "");
        if(crConfigs.length == 0){
            System.out.println("Configuration introuvable");
            return;
        }

        crConfig = crConfigs[0];

        String objet = "";
        String htmlBody = "";
        PageMail pageMail = new PageMail();
        MailContent[] mailContents = pageMail.allMailContent(c);
        int nature;
        if(crConfig.getJournaliere() == 1){
            objet = "Rapport Journalier du "+daty;

            nature = 1;
            htmlBody = pageMail.genererPageMail(mailContents, nature, daty, c);

//            String dir = PdfGeneratorUtil.pdfUrl(1, daty);
//            PdfGeneratorUtil.generatePdfFromHtml(htmlBody, dir);
//            ExcelGeneratorUtil.convertHtmlToExcel(htmlBody, dir.replace("pdf", "xlsx"));

            this.sendMail(htmlBody, objet, c);
        }
        if(crConfig.getHebdomadaire() == 1 && crConfig.getJourEnvoi().equals(Utilitaire.getJourDate(daty))){
            Date semaineDerniere = UtilitaireCR.dateSemaineDerniere(daty);
            objet = "Rapport Hebdomadaire du "+semaineDerniere+" au "+daty;

            nature = 2;
            htmlBody = pageMail.genererPageMail(mailContents, nature, daty, c);

//            String dir = PdfGeneratorUtil.pdfUrl(2, daty);
//            PdfGeneratorUtil.generatePdfFromHtml(htmlBody, dir);
//            ExcelGeneratorUtil.convertHtmlToExcel(htmlBody, dir.replace("pdf", "xlsx"));

            this.sendMail(htmlBody, objet, c);
        }
        if(crConfig.getMensuel() == 1){

            int finMois = crConfig.getFinMois();
            Date moisDernier = UtilitaireCR.dateMoisDernier(daty);
            objet = "Rapport Mensuel du "+moisDernier+" au "+daty;

            nature = 3;
            htmlBody = pageMail.genererPageMail(mailContents, nature, daty, c);
            if(finMois == 1){
                if (Utilitaire.testFinDuMois(daty)){
                    this.sendMail(htmlBody, objet, c);
                }
            }else {
                String jourString = Utilitaire.getJour(Utilitaire.datetostring(daty));
                int jour = Integer.parseInt(jourString);
                if(jour == crConfig.getDateEnvoi()){
                    this.sendMail(htmlBody, objet, c);
                }
            }
        }
    }

    public void sendMailDate(Date daty, Connection c)throws Exception{
        if(c!=null){
            c = new UtilDB().GetConn();
        }
        PageMail pageMail = new PageMail();
        MailContent[] mailContents = pageMail.allMailContent(c);
        String objet = "Rapport Journaliere du "+daty;

        int nature = 1;
        String htmlBody = pageMail.genererPageMail(mailContents, nature, daty, c);

        String dir = PdfGeneratorUtil.pdfUrl(1, daty);
        PdfGeneratorUtil.generatePdfFromHtml(htmlBody, dir);

        this.sendMail(htmlBody, objet, c);
    }

    public void sendMail(String htmlBody, String objet, Connection c)throws Exception{
        try{

            MailRapport[] mail=getListeMail("MAILRAPPORT",c);

            if(mail!=null && mail.length>0){
                String corpsMail = htmlBody;

                System.out.println("---------------------------------");
//                System.out.println(objet);
//                System.out.println(corpsMail);
                System.out.println("---------------------------------");

                Mail retour=new Mail(ConstanteCR.getMailRapport()[0],ConstanteCR.getMailRapport()[1],objet,corpsMail);
                retour.setTo(mail[0].getVal());
                if(mail.length>1){
                    String[] cc=new String[mail.length-1];
                    for(int i=1;i<mail.length;i++){
                        cc[i-1]=mail[i].getVal();
                    }
                    retour.setCc(cc);
                }
                retour.send();
            }

        }catch(Exception e){
            e.printStackTrace();
            throw e;
        }finally{
            if(c!=null)c.close();
        }


    }

    public static MailRapport[] getListeMail(String nomTable, Connection c)throws Exception{
        try{
            MailRapport mail=new MailRapport();
            return (MailRapport[])CGenUtil.rechercher(mail,null,null,c,"");
        }catch(Exception e){
            e.printStackTrace();
            throw e;
        }
    }
}