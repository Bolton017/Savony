package rapport;

import bean.AdminGen;
import bean.ClassMAPTable;

import java.lang.reflect.Method;
import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.util.Locale;

public class Utilitaire {

    public static String tableHeader(String[] headers){
        String tableHeader = "<table>" +
                "<thead>";
        if(headers!=null){
            tableHeader += "<tr>";
            for (int i = 0; i < headers.length; i++) {
                tableHeader += "<th>"+headers[i]+"</th>";
            }
            tableHeader +="</tr>";
        }
        tableHeader += "</thead><tbody>";
        return tableHeader;
    }

    public static String tableFooter(){
        return "</tbody></table><br>";
    }

    public static String sommeTable(ClassMAPTable[] data, String[] libAfficher, String[] attributs)throws Exception{
        String somme = "<table class=\"total-table\">\n";
        for (int i = 0; i < libAfficher.length; i++) {
            somme += "<tr>\n";
            somme += "<td><b>"+libAfficher[i]+"</b></td>\n";
            somme += "<td><b>"+ formatNombre(AdminGen.calculSommeDouble(data,attributs[i]))+" Ar</b></td>\n";
            somme += "</tr>\n";

        }

        somme += "</table><br>";

        return somme;
    }

    public static String ficheTable(ClassMAPTable data, String[] libAfficher, String[] attributs)throws Exception{
        String fiche = "<table class=\"total-table\">\n";
        Method methode;
        for (int i = 0; i < libAfficher.length; i++) {
            methode = data.getClass().getMethod("get"+ utilitaire.Utilitaire.convertDebutMajuscule(attributs[i]));
            Object valeur = methode.invoke(data);

            if(valeur==null)valeur="-";

            fiche += "<tr>\n";
            fiche += "<td><b>"+libAfficher[i]+"</b></td>\n";
            fiche += "<td><b>"+valeur+"</b></td>\n";
            fiche += "</tr>\n";
        }

        fiche += "</table><br>";
        return fiche;
    }

    public static String toHtmlRow(ClassMAPTable data, String[] attributs)throws Exception{
        String row = "";
        Method methode;
        for (int i = 0; i < attributs.length; i++) {
            methode = data.getClass().getMethod("get"+ utilitaire.Utilitaire.convertDebutMajuscule(attributs[i]));
            Object valeur = methode.invoke(data);

            if(valeur==null)valeur="-";

            if(valeur instanceof Number){
                valeur = formatNombre(valeur);
            }

            row += "<td>"+valeur+"</td>\n";
        }
        return row;
    }


    public static String formatNombre(Object valeur) {
        if (valeur instanceof Number) {
            double num = ((Number) valeur).doubleValue();

            DecimalFormatSymbols symbols = new DecimalFormatSymbols(Locale.FRANCE);
            symbols.setGroupingSeparator(' ');
            symbols.setDecimalSeparator(',');

            DecimalFormat df = new DecimalFormat("#,##0.00", symbols);
            return df.format(num);
        }
        return valeur.toString();
    }
}
