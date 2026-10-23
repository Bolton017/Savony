package servlet;

import bean.CGenUtil;
import bean.TypeObjet;
import mg.cnaps.compta.ComptaCompte;
import user.UserEJB;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "CompteServlet", urlPatterns = {"/CompteServlet"})
public class CompteServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, Exception {
        
        String action = request.getParameter("action");
        if ("getComptes".equals(action)) {
            response.setContentType("application/json;charset=UTF-8");
            PrintWriter out = response.getWriter();
            try {
                ComptaCompte cpt = new ComptaCompte();
                // On récupère tous les comptes, triés par numéro de compte pour un meilleur ordre
                ComptaCompte[] comptaComptes = (ComptaCompte[]) CGenUtil.rechercher(cpt, null, null, " ORDER BY COMPTE ASC");
                
                StringBuilder jsons = new StringBuilder("[");
                for (int i = 0; i < comptaComptes.length; i++) {
                    // Échappement des guillemets dans le libellé pour éviter de casser le JSON
                    String libelle = comptaComptes[i].getLibelle() != null ? comptaComptes[i].getLibelle() : "";
                    libelle = libelle.replace("\\", "\\\\")  
                                     .replace("\"", "\\\"")   
                                     .replace("\n", "\\n")    
                                     .replace("\r", "\\r")    
                                     .replace("\t", "\\t")    
                                     .replace("\b", "\\b")    
                                     .replace("\f", "\\f");   
                    String compte = comptaComptes[i].getCompte();
                    jsons.append("{\"value\":\"").append(compte).append("\",\"label\":\"")
                         .append(compte).append(" : ").append(libelle).append("\"}");
                    

                                     if (i < comptaComptes.length - 1) {
                        jsons.append(", ");
                    }
                }
                jsons.append("]");
                out.print(jsons.toString());
            } finally {
                out.close();
            }
            return; 
        }

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            UserEJB u = (UserEJB) request.getSession().getAttribute("u");
            String compte = request.getParameter("compte");
            String libelle = request.getParameter("libelle");
            String idjournal = request.getParameter("idjournal");

            String typecompte = "";
            String classe = "";
            if (compte != null) {
                if (compte.startsWith("1")) { typecompte = "1"; classe = "1"; }
                else if (compte.startsWith("2")) { typecompte = "1"; classe = "2"; }
                else if (compte.startsWith("3")) { typecompte = "1"; classe = "3"; }
                else if (compte.startsWith("4")) { typecompte = "1"; classe = "4"; }
                else if (compte.startsWith("5")) { typecompte = "1"; classe = "5"; }
                else if (compte.startsWith("6")) { typecompte = "1"; classe = "6"; }
                else if (compte.startsWith("7")) { typecompte = "1"; classe = "7"; }
                else if (compte.startsWith("8")) { typecompte = "2"; classe = "8"; }
                else if (compte.startsWith("9")) { typecompte = "3"; classe = "8"; }
            }

            if (compte == null || compte.isEmpty()) {
                Exception ex = new Exception("Veuillez remplir le champ compte");
                out.print("<script>alert('" + ex.getMessage() + "');history.back();</script>");
                throw ex;
            }
            
            ComptaCompte cpt = new ComptaCompte();
            ComptaCompte[] listCompta = (ComptaCompte[]) CGenUtil.rechercher(cpt, null, null, " AND COMPTE = '" + compte + "'");
            if (listCompta != null && listCompta.length > 0) {
                Exception ex = new Exception("Compte deja existant");
                out.print("<script>alert('" + ex.getMessage() + "');history.back();</script>");
                throw ex;
            }
            if (libelle == null || libelle.isEmpty()) {
                Exception ex = new Exception("Veuillez remplir le champ libelle");
                out.print("<script>alert('" + ex.getMessage() + "');history.back();</script>");
                throw ex;
            }
            
            cpt.setCompte(compte);
            cpt.setLibelle(libelle);
            cpt.setTypeCompte(typecompte);
            cpt.setClasse(classe);
            cpt.setIdjournal(idjournal);
            u.createObject(cpt);
            
            if (compte.startsWith("512")) {
                TypeObjet to = new TypeObjet("JOURNALCOMPTE", "GETSEQJOURNALCOMPTE", "JC", idjournal, compte);
                u.createObject(to);
            }

            // SUPPRIMÉ : Ne plus mettre à jour la session avec la liste des comptes
            // request.getSession().setAttribute("comptaComptes", jsons); 
            
            response.sendRedirect("/gallois/pages/module.jsp?but=compta/compte/compte-liste.jsp?id=" + cpt.getId());
        } finally {
            out.close();
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (Exception ex) {
            Logger.getLogger(CompteServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (Exception ex) {
            Logger.getLogger(CompteServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}