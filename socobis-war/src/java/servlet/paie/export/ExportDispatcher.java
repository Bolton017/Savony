package servlet.paie.export;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/ExportDispatcher")
@MultipartConfig
public class ExportDispatcher extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
    
    private void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        
        String acte = request.getParameter("action");
        
        if (acte == null || acte.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.setContentType("text/plain; charset=UTF-8");
            response.getWriter().write("Paramètre 'action' manquant ou vide");
            return;
        }
        
        try {
            switch (acte.toLowerCase().trim()) {
                case "ostie":
                    
                    request.getRequestDispatcher("/ExportOstie").forward(request, response);
                    break;
                    
                case "cnaps":
                    
                    request.getRequestDispatcher("/ExportCnaps").forward(request, response);
                    break;
                    
                default:
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.setContentType("text/plain; charset=UTF-8");
                    response.getWriter().write("Type d'acte non supporté: " + acte + 
                        ". Types supportés: ostie, cnaps");
                    break;
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.setContentType("text/plain; charset=UTF-8");
            response.getWriter().write("Erreur lors du traitement: " + e.getMessage());
        }
    }
}