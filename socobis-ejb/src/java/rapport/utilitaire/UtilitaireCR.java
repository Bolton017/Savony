package rapport.utilitaire;

import bean.AdminGen;
import bean.ClassMAPTable;

import java.io.File;
import java.lang.reflect.Method;
import java.sql.Date;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.util.Locale;

public class UtilitaireCR {

    public static String pageEntete(){
        String entete = "<html>\n" +
                "<head>\n" +
                "  <style>\n" +
                "    table {\n" +
                "      border-collapse: collapse;\n" +
                "      width: 100%;\n" +
                "      max-width: 800px;\n" +
                "      font-family: Tahoma, sans-serif;\n" +
                "      font-size: 9px;\n" +
                "    }\n" +
                "    th {\n" +
                "      background-color: #004080;\n" +
                "      color: white;\n" +
                "      padding: 6px;\n" +
                "      border: 1px solid #004080;\n" +
                "    }\n" +
                "    td {\n" +
                "      padding: 6px;\n" +
                "      border: 1px solid #ddd;\n" +
                "      text-align: center;\n" +
                "    }\n" +
                "    table.total-table {\n" +
                "        width: 50%;\n" +
                "        margin-top: 10px;\n" +
                "        border: 1px solid #f2f8ff;\n" +
                "    }\n" +
                "    table.total-table td {\n" +
                "        padding: 6px;\n" +
                "        border: 1px solid #f2f8ff;\n" +
                "        font-size: 9px;\n" +
                "    }\n" +
                "    table.total-table td:last-child {\n" +
                "        font-weight: bold;\n" +
                "        color: #000;\n" +
                "        text-align: right;\n" +
                "    }  </style>\n" +
                "</head>\n" +
                " <body>";
        return entete;
    }

    public static String basPage() { return "</body></html>"; }

    public static String tableHeader(String[] headers){
        String tableHeader = "<table class=\"crcontentfille\">" +
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
        return "</tbody></table><br></br>";
    }

    public static String sommeTable(ClassMAPTable[] data, String[] colSomme)throws Exception{
        String somme = "<table class=\"total-table\" align=\"center\">\n";
        for (int i = 0; i < colSomme.length; i++) {
                somme += "<tr>\n" +
                "      <td><b>Total "+colSomme[i]+" :</b></td>\n" +
                "      <td><b>"+ AdminGen.calculSommeDouble(data,colSomme[i])+"</b></td>\n" +
                "    </tr>\n" ;
        }

        somme += "  </table><br></br>";

        return somme;
    }

    public static String mappingContent(ClassMAPTable data, String[] libEntete)throws Exception{
        String content = "";

        Object obj;
        String maj;
        for (int i = 0; i < libEntete.length; i++) {
            maj = utilitaire.Utilitaire.convertDebutMajuscule(libEntete[i]);
            obj = mappingAttributContent(data, maj);

            if(obj instanceof Number){
                obj = formatNombre(obj);
            }

            content += "<td>"+obj+"</td>";
        }

        return content;
    }

    public static List<Object> mappingContentList(ClassMAPTable[] data, String libEntete)throws Exception{
        List<Object> content = new ArrayList<>();

        Object obj;
        String maj = utilitaire.Utilitaire.convertDebutMajuscule(libEntete);
        for (int i = 0; i < data.length; i++) {
            obj = mappingAttributContent(data[i], maj);
            content.add(obj);
        }

        return content;
    }

    public static Object mappingAttributContent(ClassMAPTable data, String libEntete)throws Exception{
        Method method;
        Object obj;
        String maj = utilitaire.Utilitaire.convertDebutMajuscule(libEntete);
        method = data.getClass().getMethod("get"+maj, null);
        obj = method.invoke(data, null);
        return obj;
    }

    public static List<String> castListString(List<Object> list) {
        List<String> strings = list.stream()
                .map(o -> (String) o)
                .collect(Collectors.toList());

        return strings;
    }

    public static List<Double> castListDouble(List<Object> list) {
        List<Double> doubles = list.stream()
                .map(o -> ((Number) o).doubleValue())
                .collect(Collectors.toList());

        return doubles;
    }

    public static String tableContent(ClassMAPTable[] mappings, String[] libEntete) throws Exception{

        String content = "";

        if(mappings.length==0){
            content += tableFooter();
            content += "<p>Aucune donnees disponible</p>";
            return content;
        }

        for (int i = 0; i < mappings.length; i++) {
            content += "<tr>";
            content += mappingContent(mappings[i], libEntete);
            content += "</tr>";
        }

        content += tableFooter();
        return content;
    }

    public static Date dateSemaineDerniere(Date daty)throws Exception{
        LocalDate localDate = daty.toLocalDate();
        LocalDate semaineDerniere = localDate.minusWeeks(1);
        return Date.valueOf(semaineDerniere);
    }

    public static Date dateMoisDernier(Date daty)throws Exception{
        LocalDate localDate = daty.toLocalDate();
        LocalDate moisDernier = localDate.minusMonths(1);
        return Date.valueOf(moisDernier);
    }

    public static String dateRequete(Date daty){
        return "TO_DATE('"+daty+"', 'yyyy-MM-dd')";
    }

    public static boolean isNumericType(String typeName) {
        return typeName.equals("int") || typeName.equals("float") || typeName.equals("double");
    }

    public static void createDirectory(String url)throws Exception{
        File file = new File(url);
        if (!file.exists()){
            file.mkdirs();
        }
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
