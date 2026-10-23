package servlet;

import rapport.utilitaire.ConstanteCR;

import java.io.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name="CRServlet", urlPatterns={"/pages/crfilemanager"})
public class CRServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getParameter("path");
        String action = null;
        if(request.getParameter("action")!=null){
            action = request.getParameter("action");
        }

        if (path == null || path.contains("..")) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Chemin invalide");
            return;
        }

        File file = new File(ConstanteCR.BASE_DIR + File.separator + path);
        if (!file.exists() || file.isDirectory()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        response.setContentType(getServletContext().getMimeType(file.getName()));
        if(action==null){
            response.setHeader("Content-Disposition", "attachment;filename=\"" + file.getName() + "\"");
//            action = "download";
        }else {
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "inline; filename=\"" + file.getName() + "\"");
        }
        /*try {
            UserEJB u = (UserEJB) request.getSession().getAttribute("u");
            this.addToHistorique(file.getName(), String.valueOf(u.getUser().getRefuser()), action);
        }catch (Exception e){
            e.printStackTrace();
        }*/
        response.setContentLength((int) file.length());

        try (BufferedInputStream in = new BufferedInputStream(new FileInputStream(file));
             BufferedOutputStream out = new BufferedOutputStream(response.getOutputStream())) {
            byte[] buffer = new byte[8192];
            int len;
            while ((len = in.read(buffer)) != -1) {
                out.write(buffer, 0, len);
            }
        }
    }

    /*public void addToHistorique(String fileName, String refuser, String action)throws Exception{
        String objet = action+" file";
        MapHistorique histo = new MapHistorique(objet, action, refuser, fileName);

        String heure = LocalTime.now().toString();
        heure = heure.replace(".", ":");
        histo.setHeure(heure);

        histo.insertToTable();
    }*/
}
