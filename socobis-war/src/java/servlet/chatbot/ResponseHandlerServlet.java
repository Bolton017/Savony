package servlet.chatbot;

import bean.ClassMAPTable;
import chatbot.ChatBot;
import chatbot.ClassIA;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import fabrication.Fabrication;
import fabrication.FabricationFille;
import fabrication.FabricationFilleCpl2;
import prevision.AdminPrevision;
import produits.Ingredients;
import stock.RapprochementOF;
import user.UserEJB;
import utils.ConstanteAsync;
import utils.ConstanteStation;
import utils.DateFormat;
import vente.BonDeCommandeFIlleCpl;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.swing.text.DateFormatter;
import java.io.IOException;
import java.lang.reflect.Method;
import java.lang.reflect.Type;
import java.sql.Connection;
import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.Locale;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@WebServlet("/response-generator")
public class ResponseHandlerServlet extends HttpServlet {

    public static String replaceAliasWithArg(String sql) {
        // Regex pattern to find aggregated functions with aliases
        String regex = "(SUM|AVG|COUNT|MIN|MAX|ROUND)\\((\\w+)\\)\\s+AS\\s+(\\w+)";
        Pattern pattern = Pattern.compile(regex, Pattern.CASE_INSENSITIVE);
        Matcher matcher = pattern.matcher(sql);

        StringBuffer result = new StringBuffer();
        while (matcher.find()) {
            String function = matcher.group(1); // Aggregation function (SUM, AVG, etc.)
            String arg = matcher.group(2);      // Argument inside function
            matcher.appendReplacement(result, function + "(" + arg + ") AS " + arg);
        }
        matcher.appendTail(result);

        return result.toString().split(" LIMIT")[0];
    }
    public static String removeNombreParGroupe(String sqlQuery) {
        if (sqlQuery == null || sqlQuery.trim().isEmpty()) {
            return sqlQuery;
        }

        // Extract the part between SELECT and FROM
        String upperQuery = sqlQuery.toUpperCase();
        int selectIndex = upperQuery.indexOf("SELECT");
        int fromIndex = upperQuery.indexOf("FROM");

        if (selectIndex == -1 || fromIndex == -1 || fromIndex < selectIndex) {
            return sqlQuery; // invalid query structure
        }

        String selectPart = sqlQuery.substring(selectIndex + 6, fromIndex); // after SELECT, before FROM
        String fromPart = sqlQuery.substring(fromIndex); // FROM ... rest of query

        // Split columns, remove 'nombrepargroupe', and rejoin
        String[] columns = selectPart.split(",");
        StringBuilder newSelect = new StringBuilder("SELECT");

        for (String col : columns) {
            if (!col.trim().equalsIgnoreCase("nombrepargroupe")) {
                newSelect.append(" ").append(col.trim()).append(",");
            }
        }

        // Remove the trailing comma
        if (newSelect.charAt(newSelect.length() - 1) == ',') {
            newSelect.setLength(newSelect.length() - 1);
        }

        // Combine cleaned SELECT part with original FROM clause
        return newSelect.toString() + " " + fromPart.trim();
    }


    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        super.doGet(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        try {String nomTable = req.getParameter("nomTable");
            UserEJB user = (UserEJB)req.getSession().getValue("u");
            String query = req.getParameter("requeteSql");
            if(query!=null){
                query = replaceAliasWithArg(query);
                if(query.contains("FETCH")){
                    query = query.split("FETCH")[0];
                }
                if(query.contains("LIMIT")){
                    query = query.split("LIMIT")[1];
                }
                query = removeNombreParGroupe(query);
            }
            System.out.println("queryyyy "+query);
            String type = req.getParameter("type");
            ClassMAPTable[] maptables = null;
            String lien = "";
            String dateDebut = req.getParameter("dateDebut");
            String dateFin = req.getParameter("dateFin");
            String jsonResp = req.getParameter("jsonResp");
            String datyFiltre = req.getParameter("datyFiltre");
            String deb = req.getParameter("deb");
            String fin = req.getParameter("fin");
            String grouper = req.getParameter("grouper");
            String dataSaisie = req.getParameter("dataSaisie");
            String baseUrl = req.getParameter("baseUrl");
            String id = req.getParameter("id");


            System.out.println("typee "+type);
            if(type.equals("noUser") || type.equals("aucun")) {
                ChatBot bot = new ChatBot(req.getParameter("iaResp"),null);
                Gson json = new Gson();
                String data = json.toJson(bot);

                resp.setContentType("application/json");
                resp.setCharacterEncoding("UTF-8");
                resp.getWriter().write(data);
                return;
            }
            else{
                if (type.equals("prevision")) {

                    SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd");
                    Date dateF = inputFormat.parse(datyFiltre);
                    Date dateDeb = inputFormat.parse(deb);
                    Date dateFi = inputFormat.parse(fin);
                    SimpleDateFormat oracleDateFormat = new SimpleDateFormat("dd/MM/yyyy");
                    datyFiltre = oracleDateFormat.format(dateF);
                    deb = oracleDateFormat.format(dateDeb);
                    fin = oracleDateFormat.format(dateFi);

                    AdminPrevision adminPrevision = new AdminPrevision();
                    adminPrevision.getPrevision(datyFiltre,deb,fin,grouper);

                    lien+="/savonnerie/pages/module.jsp?but=prevision/resultat-prevision.jsp&currentMenu=MENUDYN0020003&datyFiltre="+datyFiltre+"&datyDebut="+deb+"&datyFin="+fin+"&grouper="+grouper;

                    DecimalFormatSymbols symbols = new DecimalFormatSymbols(Locale.FRANCE);
                    symbols.setGroupingSeparator(' ');
                    symbols.setDecimalSeparator(',');

                    DecimalFormat decimalFormat = new DecimalFormat("#,##0.00", symbols);

                    String formattedNumber = decimalFormat.format(adminPrevision.getMinimum().getSoldeFinale());


                    ChatBot chat = new ChatBot("La tresorerie la plus basse etait le "+adminPrevision.getMinimum().getDaty().toString()+" avec un montant de "+formattedNumber,lien);
                    System.out.println(chat.getValue());
                    Gson json = new Gson();
                    String data = json.toJson(chat);

                    resp.setContentType("application/json");
                    resp.setCharacterEncoding("UTF-8");
                    resp.getWriter().write(data);
                    return;

                }
                if(type.equals("liste")) {
                    ClassIA ia = ClassIA.getCorrespondingClass(ConstanteAsync.iaClasses,nomTable,type);
                    ClassMAPTable mapTable =(ClassMAPTable) ia.getClass().newInstance();
                    String table = mapTable.getNomTable();
                    mapTable.setNomTable(nomTable);
                    maptables = user.getDataPage(mapTable,query,null);
                    Method staticMethod = ia.getClass().getDeclaredMethod("getUrlListe");
                    staticMethod.setAccessible(true);
                    lien = (String) staticMethod.invoke(ia);
                    if(dateDebut!=null && !dateDebut.isEmpty()){
                        lien+="&daty1="+DateFormat.formatDate(dateDebut,"dd/MM/yyyy","dd/MM/yyyy");
                    }
                    if(dateFin!=null && !dateFin.isEmpty()){
                        lien+="&daty2="+DateFormat.formatDate(dateFin,"dd/MM/yyyy","dd/MM/yyyy");
                    }
                    if(ia instanceof RapprochementOF){

                    }
                    else if(!(ia instanceof BonDeCommandeFIlleCpl))lien+="&etat=11";
                    else lien+="&etaty=11";
                    if(id!=null && !id.isEmpty()){

                        if(ia instanceof RapprochementOF){
                            lien = "/savonnerie/pages/module.jsp?but=fabrication/ordre-fabrication-fiche.jsp";
                            lien+="&id="+id;
                            lien+="&tab=inc/ordre-fabrication-rapprochement";
                        }else{
                            lien+="&id="+id;
                        }
                    }

                    mapTable.setNomTable(table);

                }
                else if(type.equals("analyse")) {

                    ClassIA ia = ClassIA.getCorrespondingClass(ConstanteAsync.iaClasses,nomTable,type);
                    ClassMAPTable mapTable =(ClassMAPTable) ia.getClass().newInstance();
                    String table = mapTable.getNomTable();
                    mapTable.setNomTable(nomTable);
                    maptables = user.getDataPage(mapTable,query,null);
                    Method staticMethod = ia.getClass().getDeclaredMethod("getUrlAnalyse");
                    staticMethod.setAccessible(true);
                    lien = (String) staticMethod.invoke(ia);
                    if(dateDebut!=null && !dateDebut.isEmpty()){
                        lien+="&daty1="+DateFormat.formatDate(dateDebut,"dd/MM/yyyy","dd/MM/yyyy");
                    }
                    if(dateFin!=null && !dateFin.isEmpty()){
                        lien+="&daty2="+DateFormat.formatDate(dateFin,"dd/MM/yyyy","dd/MM/yyyy");
                    }
                    lien+="&order=order%20by%20qte%20desc";
                    if(!grouper.isEmpty()){
                        lien+="&grouper="+grouper;
                    }
                    if(ia instanceof RapprochementOF){

                    }
                    else if(!(ia instanceof BonDeCommandeFIlleCpl))lien+="&etat=11";
                    else lien+="&etaty=11";
                    if(id!=null && !id.isEmpty()){

                        if(ia instanceof RapprochementOF){
                            lien = "/savonnerie/pages/module.jsp?but=fabrication/ordre-fabrication-fiche.jsp";
                            lien+="&id="+id;
                            lien+="&tab=inc/ordre-fabrication-rapprochement";
                        }else{
                            lien+="&id="+id;
                        }
                    }
                    mapTable.setNomTable(table);
                }
                else if(type.equals("lister")) {
                    ClassIA ia = ClassIA.getCorrespondingClass(ConstanteAsync.iaClasses,nomTable,type);
                    Method staticMethod = ia.getClass().getDeclaredMethod("getUrlListe");
                    staticMethod.setAccessible(true);
                    lien = (String) staticMethod.invoke(ia);
                    if(dateDebut!=null && !dateDebut.isEmpty()){
                        lien+="&daty1="+DateFormat.formatDate(dateDebut,"dd/MM/yyyy","dd/MM/yyyy");
                    }
                    if(dateFin!=null && !dateFin.isEmpty()){
                        lien+="&daty2="+DateFormat.formatDate(dateFin,"dd/MM/yyyy","dd/MM/yyyy");
                    }
                    if(!(ia instanceof BonDeCommandeFIlleCpl))lien+="&etat=11";
                    else lien+="&etaty=11";


                    ChatBot chat = new ChatBot("action",lien);
                    Gson json = new Gson();
                    String data = json.toJson(chat);
                    resp.setContentType("application/json");
                    resp.setCharacterEncoding("UTF-8");
                    resp.getWriter().write(data);
                    return;
                }
                else if(type.equals("saisie")) {
                    ClassIA ia = ClassIA.getCorrespondingClass(ConstanteAsync.iaClasses,nomTable,type);

                    Method staticMethod = ia.getClass().getDeclaredMethod("getUrlSaisie");
                    staticMethod.setAccessible(true);
                    lien = (String) staticMethod.invoke(ia);

                    if(dataSaisie.compareToIgnoreCase("[]")!=0){
                        Gson gson = new Gson();
                        Type typaa = new TypeToken<FabricationFilleCpl2[]>() {}.getType();
                        FabricationFilleCpl2[] saisieIA = gson.fromJson(dataSaisie,typaa);

                        if(ia instanceof FabricationFille){;
                            FabricationFille[] fabricationFilles = new FabricationFille[saisieIA.length];
                            for (int i = 0; i < saisieIA.length; i++) {
                                fabricationFilles[i] = new FabricationFille();

                                Ingredients ing = new Ingredients();
                                Ingredients[] ingredients = (Ingredients[]) user.getData(ing,null,null,null," and upper(libelle) like upper('%"+saisieIA[i].getLibelle()+"%')");
                                fabricationFilles[i].setQte(saisieIA[i].getQte());
                                fabricationFilles[i].setRemarque(ingredients[0].getLibelle());
                                fabricationFilles[i].setIdIngredients(ingredients[0].getId());
                                fabricationFilles[i].setIdBcFille(saisieIA[i].getIdBcFille());
                            }
                            req.setAttribute("fillesIA", fabricationFilles);
                            req.getSession().setAttribute("fillesIA", fabricationFilles);

                            /*try {
                                String path = baseUrl + lien;
                                RequestDispatcher dispatcher = req.getRequestDispatcher(path);
                                dispatcher.forward(req, resp);
                                return;
                            } catch (Exception e) {
                                System.out.println("Error occurred while forwarding to JSP.");
                                e.printStackTrace();
                            }*/

                        }
                    }
                    ChatBot chat = new ChatBot("action",lien);
                    Gson json = new Gson();
                    String data = json.toJson(chat);
                    resp.setContentType("application/json");
                    resp.setCharacterEncoding("UTF-8");
                    resp.getWriter().write(data);
                    return;
                }
                /*else if(type.equals("saisie")) {
                    ClassIA ia = ClassIA.getCorrespondingClass(ConstanteAsync.iaClasses,nomTable,type);
                    ClassMAPTable obj = (ClassMAPTable) ia.getClass().newInstance();
                    obj.fromJson(jsonResp);
                    Method staticMethod = ia.getClass().getDeclaredMethod("getUrlSaisie");
                    staticMethod.setAccessible(true);
                    lien = (String) staticMethod.invoke(null);
                    req.getSession().setAttribute("objIa", obj);
                    resp.sendRedirect(lien);
                }*/
            }
            String json = ClassMAPTable.toJson(maptables);
            req.setAttribute("lien", lien);
            req.setAttribute("maptables", json);
            RequestDispatcher dispatcher = req.getRequestDispatcher("response-formattor");
            dispatcher.forward(req, resp);

        }
        catch (Exception e) {
            e.printStackTrace();
            String error = e.getMessage();
            if (e.getCause() != null) {
                error = e.getCause().getMessage();
            }
            ChatBot chat = new ChatBot("error",error);
            Gson json = new Gson();
            String data = json.toJson(chat);
            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            resp.getWriter().write(data);
        }
    }
}
