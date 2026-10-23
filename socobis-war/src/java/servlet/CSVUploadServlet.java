package servlet;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import rapprochement.ImportRelever;
import rapprochement.Relever;
import user.UserEJB;
import utilitaire.UtilDB;
import utils.csv.CsvReader;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.Date;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "CSVUploadServlet", urlPatterns = {"/uploadCSV"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 3,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 15
)
public class CSVUploadServlet extends HttpServlet {

    private final Gson gson = new GsonBuilder().setPrettyPrinting().create();

    private void setCORS(HttpServletResponse response) {
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        setCORS(response);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        Map<String, Object> responseMap = new HashMap<>();

        try {
            // Récupérer le fichier
            Part filePart = request.getPart("etat");

            if (filePart == null || filePart.getSize() == 0) {
                responseMap.put("success", false);
                responseMap.put("message", "Aucun fichier n'a été sélectionné");
                response.getWriter().write(gson.toJson(responseMap));
                return;
            }

            // Vérifier l'extension
            String fileName = filePart.getName();
//            if (!fileName.toLowerCase().endsWith(".csv")) {
//                responseMap.put("success", false);
//                responseMap.put("message", "Veuillez uploader un fichier CSV (.csv)");
//                response.getWriter().write(gson.toJson(responseMap));
//                return;
//            }

            // Récupérer le délimiteur
            String delimiter = request.getParameter("delimiter");
            if (delimiter == null || delimiter.trim().isEmpty()) {
                delimiter = ";";
            }

            // Lire le fichier CSV
            InputStream fileContent = filePart.getInputStream();
            String idCaisse = request.getParameter("idCaisse");
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
            String daty = request.getParameter("daty");
            Date date = Date.valueOf(LocalDate.parse(daty,formatter));
            UserEJB user = (UserEJB) request.getSession().getAttribute("u");
            String lien = (String) request.getSession().getAttribute("lien");
            Connection con = new UtilDB().GetConn();
            ImportRelever importRelever = new ImportRelever();
            Relever relever = importRelever.genererReleverFixe(fileContent,";",idCaisse,date);
            Relever retour = (Relever) relever.createObject(String.valueOf(user.getUser().getRefuser()),con);
            con.close();
            responseMap.put("success", true);
            responseMap.put("message", String.format("Fichier '%s' traité avec succès", fileName));
            response.sendRedirect(request.getContextPath()+"/pages/module.jsp?but="+request.getParameter("bute")+ "&id="+ retour.getId());
        } catch (Exception e) {
            e.printStackTrace();
            String retour = request.getParameter("retour");
            if (retour == null || retour.trim().isEmpty()) {
                retour = request.getParameter("bute");
            }
            request.getSession().setAttribute("erreur", "Erreur lors du traitement: " + e.getMessage());
            response.sendRedirect(request.getContextPath()+"/pages/module.jsp?but="+retour);
        }
    }

    @Override
    protected void doOptions(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        setCORS(response);
        response.setStatus(HttpServletResponse.SC_OK);
    }
}
