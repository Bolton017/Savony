package faturefournisseur;

import reporting.mail.Mail;
import reporting.utilitaire.ConstanteCR;
import utilitaire.Utilitaire;

public class SendMail {

    public void sendMail(String object, String message, String destination, String[] cc) throws Exception {
        Mail mail = new Mail(ConstanteCR.getMailRapport()[0], ConstanteCR.getMailRapport()[1], object, message);
        if (cc != null && cc.length > 0) {
            mail.setCc(cc);
        }
        if (destination != null && !destination.isEmpty()) {
            mail.setTo(destination);
        } else {
            throw new Exception("Destionation ne doit pas etre vide");
        }
        mail.send();
    }

    public String prepareContenuMailDG(As_BonDeCommande asBonDeCommande) {
        StringBuilder builder = new StringBuilder();

        builder.append("<p>Bonjour Monsieur le PDG,</p>");

        builder.append("<p>");
        builder.append("Nous nous permettons de vous rappeler que le bon de commande suivant est toujours ");
        builder.append("en attente de votre <strong>validation</strong>.");
        builder.append("</p>");

        builder.append("<table style='border-collapse:collapse;'>");

        builder.append("<tr>");
        builder.append("<td><strong>Date :</strong></td>");
        builder.append("<td style='padding-left:10px;'>")
                .append(Utilitaire.formatterDaty(asBonDeCommande.getDaty()))
                .append("</td>");
        builder.append("</tr>");

        if (asBonDeCommande.getDesignation() != null && !asBonDeCommande.getDesignation().isEmpty()) {
            builder.append("<tr>");
            builder.append("<td><strong>Désignation :</strong></td>");
            builder.append("<td style='padding-left:10px;'>")
                    .append(asBonDeCommande.getDesignation())
                    .append("</td>");
            builder.append("</tr>");
        }

        builder.append("</table>");

        builder.append("<br>");

        builder.append("<p>");
        builder.append("Nous vous remercions de bien vouloir procéder à sa validation dès que votre disponibilité le permettra afin de permettre la poursuite de son traitement.");
        builder.append("</p>");

        builder.append("<p>");
        builder.append("Nous vous remercions par avance pour votre attention.");
        builder.append("</p>");

        builder.append("<p>");
        builder.append("Cordialement,<br>");
        builder.append("</p>");

        return builder.toString();
    }
}
