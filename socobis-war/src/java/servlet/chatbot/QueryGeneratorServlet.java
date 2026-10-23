package servlet.chatbot;

import chatbot.ChatBot;
import chatbot.FilleOcr;
import chatbot.MereOcr;
import chatbot.StaticQuery;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import faturefournisseur.FactureFournisseur;
import faturefournisseur.FactureFournisseurDetails;
import faturefournisseur.FactureFournisseurDetailsCpl;
import user.UserEJB;
import utilitaire.UtilDB;
import vente.BonDeCommande;
import vente.VenteDetails;
import utils.ConstanteAsync;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.*;
import java.sql.Connection;

@MultipartConfig
@WebServlet("/query-generator")
public class QueryGeneratorServlet extends HttpServlet {
    private String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        for (String cd : contentDisp.split(";")) {
            if (cd.trim().startsWith("filename")) {
                return cd.substring(cd.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        return null;
    }

    private ChatBot handleFile(HttpServletRequest req,String message) throws Exception {
        try {
            System.out.println("debuugggg");
            Part filePart = req.getPart("file");
            //String filePath = getServletContext().getRealPath("/WEB-INF/img/pho.png");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = getFileName(filePart);
                File tempFile = File.createTempFile("upload_", "_" + fileName);

                try (InputStream input = filePart.getInputStream();
                     FileOutputStream fos = new FileOutputStream(tempFile)) {
                    byte[] buffer = new byte[1024];
                    int len;
                    while ((len = input.read(buffer)) > 0) {
                        fos.write(buffer, 0, len);
                    }
                    String response = ChatBot.sendMessageWithFile(message, tempFile, ConstanteAsync.ADK_URL+"/run");
                    System.out.println("Server Response: " + response);
                    MereOcr facture = MereOcr.extractOcr(response);
                    System.out.println("Fournisseur: " + facture.getIdOrigine());
                    System.out.println("Designation: "+facture.getDesignation());
                    System.out.println("Type: "+facture.getType());
                    System.out.println("Produits:");
                    for (FilleOcr d : facture.getDetails()) {
                        System.out.printf(" - %s: %.1f x %.1f\n", d.getIdProduit(), d.getQte(), d.getPu());
                    }
                    if(facture.getType().equals("FF")){
                        FactureFournisseur ocr = FactureFournisseur.fromOcr(facture);
                        req.getSession().setAttribute("ocr",ocr);
                        FactureFournisseurDetailsCpl ia = new FactureFournisseurDetailsCpl();
                        return new ChatBot("ocr",ia.getUrlSaisie());
                    }
                    if(facture.getType().equals("BC")){
                        BonDeCommande ocr = BonDeCommande.fromOcr(facture);
                        req.getSession().setAttribute("ocr",ocr);
                        BonDeCommande ia = new BonDeCommande();
                        return new ChatBot("ocr",ia.getUrlSaisie());
                    }
                }
                catch (Exception e) {
                    e.printStackTrace();
                    throw e;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }
        return null;
    }
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Connection c = null;
        String message = req.getParameter("message");
        UserEJB user = (UserEJB)req.getSession().getValue("u");
        boolean log = user != null;

        if (message == null || message.isEmpty()) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("Parameter 'message' is required.");
            return;
        }

        String aiResponse = null;
        try {
            c = new UtilDB().GetConn();
            if(log){
                ChatBot file = handleFile(req,message);
                if(file!=null){
                    Gson json = new Gson();
                    String data = json.toJson(file);
                    resp.setContentType("application/json");
                    resp.setCharacterEncoding("UTF-8");
                    resp.getWriter().write(data);
                    return;
                }

                aiResponse = ChatBot.callGenerativeAI(StaticQuery.dateToday+" "+StaticQuery.generateQueryType(ConstanteAsync.AI_CONTEXT,ConstanteAsync.AI_DEFINITIONS)+" "+message, ConstanteAsync.API_URL);
                System.out.println("AI RESPONSE = " + aiResponse);
                JsonParser parser = new JsonParser();
                JsonObject jsonObject = parser.parse(aiResponse).getAsJsonObject();

                String type = jsonObject.get("type").getAsString();
                if(type.equals("saisie")){
                    aiResponse = ChatBot.callGenerativeAI(StaticQuery.generateQuerySaisie(ConstanteAsync.iaClasses,c)+" "+message, ConstanteAsync.API_URL);
                } else if (type.equals("lister")) {
                    aiResponse = ChatBot.callGenerativeAI(StaticQuery.dateToday+" "+StaticQuery.queryLister+" "+message, ConstanteAsync.API_URL);
                } else if (type.equals("liste") || type.equals("analyse")) {
                    aiResponse = ChatBot.callGenerativeAI(StaticQuery.dateToday+" "+StaticQuery.generateQueryDB(ConstanteAsync.iaClasses,c)+" "+message, ConstanteAsync.API_URL);
                } else if (type.equals("prevision")) {
                    aiResponse = ChatBot.callGenerativeAI(StaticQuery.dateToday+" "+StaticQuery.queryPrevi+" "+message, ConstanteAsync.API_URL);
                }
            }
            else aiResponse = ChatBot.callGenerativeAI(StaticQuery.dateToday+" "+StaticQuery.queryLog+" "+message, ConstanteAsync.API_URL);
            System.out.println("ai: "+ aiResponse);
        } catch (Exception e) {
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
            return;
        }

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        PrintWriter writer = resp.getWriter();
        writer.write(aiResponse);
        System.out.println("done");
        writer.flush();
    }

    //avadika dynamique
    /*private String getTables(){
        return  "    La structure de ma table de vente VENTE_DETAILS_CPL_2 est comme ceci : ID : string, IDVENTE : string, IDVENTELIB : string, IDPRODUIT : string, IDPRODUITLIB : string, IDORIGINE : string, QTE : decimal, PU : decimal, puTotal : decimal(30,2), puTotalAchat : decimal(30,2), puRevient : decimal(30,2), IDCATEGORIE : string, IDCATEGORIELIB : string, daty : date, IDMAGASIN : string, IDMAGASINLIB : string, IDPOINT : string, IDPOINTLIB : string, IDDEVISE : string, IDDEVISELIB : string.\n" +
                "    La structure de ma table FACTUREFOURNISSEURFILLECPL est comme ceci : ID : string, IDFACTUREFOURNISSEUR : string, IDPRODUIT : string, IDPRODUITLIB : string, QTE : number, PU : number, REMISES : number, IDBCDETAIL : string, TVA : number, IDDEVISE : string, DATY : date, MONTANTHT : number, MONTANTTTC : number, MONTANTTVA : number, MONTANTREMISE : number, MONTANT : number.\n" +
                "    Tu ne peux pas utiliser d'autres colonnes que ce que je t'ai donner car je vais mapper la requete a un objet deja defini donc pas d'alias mais met dans les colonnes existant la reponse des sommes, groupes, counts, etc"+
                "    Pas de FETCH FIRST ROWS ONLY, tu ne peux en aucun cas l'utiliser\n" +
                "    Base de donnee: Oracle 11g\n";
    }
    //avadika dynamique
    private String getClassFilles() throws Exception {
        return "la classe 'VenteDetails':"+ChatBot.removeAllDoubleQuotes(new VenteDetails().toJson())+","+
                "la classe 'FactureFournsisseurDetails':"+ChatBot.removeAllDoubleQuotes(new FactureFournisseurDetails().toJson())
                ;
    }

    private String buildQuery(String message,boolean isLogged) throws Exception {
        if(isLogged){
            return
                    "Je veux que tu traites une requete, 1er etape, savoir le type de requete, 2e etape, analyser la requete, 3e etape me donner la reponse"+
                            "    Ta reponse doit être de cette forme (format JSON) et pas d'autre réponse:\n" +
                            "    {\n" +
                            "        type: string,\n" +
                            "        nomTable: string,\n" +
                            "        nomClasse: string, \n"+
                            "        date1: dd/MM/yyyy,\n" +
                            "        date2: dd/MM/yyyy,\n" +
                            "        requeteSql: string,\n" +
                            "        reponseJson: string\n" +
                            "        reponseIa: string\n" +
                            "        "+
                            "    }\n" +
                            "    - type: Classifie mes requêtes SQL en fonction de leur objectif :'saisie' si la requete veut saisir quelque chose, 'liste' si la requête extrait des données générales comme des totaux, des montants ou des transactions, et 'analyse' si elle identifie des tendances, des éléments les plus fréquents, les plus rentables, ou toute autre donnée nécessitant une comparaison ou une interprétation,'aucun' si aucun n'applique\n" +
                            "    - si le type correspond a 'liste' ou 'analyse' utilise les tables pour creer la requeteSql:'"+getTables()+"'"+
                            "    - si le type correspond a 'saisie' utilise les classes pour mapper la responseJson: '"+getClassFilles()+"'"+
                            "    - nomTable correspond a la table que la requete devrait etre execute\n"+
                            "    - nomClasse correspond a la classe ou la saisie va se faire\n"+
                            "    - date1 et date2 sont facultatifs et remplis uniquement si il y a une intervalle de date dans la requete.\n" +
                            "    - requeteSql: Si le type est 'analyse' ou 'liste' procede ,la requete SQL oracle correspondant a la requete sans ajouter de nouvelles colonnes ou alias qui n'existent pas déjà. La requête doit uniquement utiliser les noms de colonnes existants et n'utilise pas FETCH FIRST ROWS.\n" +
                            "      bien verifier les erreurs dans la requete sql (ne pas utiliser FETCH FIRST ROWS dans la requete sql)\n" +
                            "    - responseJson: Si le type est 'saisie' procede, le json de l'objet correspondent au saisie que ma requete veut effectuer avec par defaut date d'aujourd'hui"+
                            "    - responseIa: Si le type est 'aucun' procede, repond juste a ma requete "+
                            "    Ma requete:\n" + message;
        }
        else return "Dis que l'utilisateur doit etre logged dans l'app avant de pouvoir utiliser le chat"+
                "    Ta reponse doit être de cette forme (format JSON) et pas d'autre réponse:\n" +
                "    {\n" +
                "        type: string,\n" +
                "        reponseIa: string\n" +
                "        "+
                "    }\n"+
                "- reponseIa : ta reponse"+
                "- type: 'noUser'";
    }*/
}
