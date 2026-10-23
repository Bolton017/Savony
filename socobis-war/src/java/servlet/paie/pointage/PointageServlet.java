/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlet.paie.pointage;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import paie.service.PointageService;
import user.UserEJB;

@WebServlet(name = "PointageServlet", urlPatterns = {"/PointageServlet"})
public class PointageServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, Exception {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            UserEJB u = (UserEJB) request.getSession().getAttribute("u");
            String lien_pers = "";
            String apres_lien = "";
            /*
            if (request.getParameter("action") != null && request.getParameter("action").equals("enregistrerPointage")) {
                PointService.enregistrerPointage(request, u);
                lien_pers = "?but=paie/pointage/pointage-saisie.jsp&currentMenu=ELM000743";
                System.out.println("enregistrerPointage");
            }
            if (request.getParameter("action") != null && request.getParameter("action").equals("validerPointage")) {
                lien_pers = "?but=paie/pointage/pointage-saisie.jsp&currentMenu=ELM0007453";
                System.out.println("validerpointage");
            }
            */
            if (request.getParameter("action") != null && request.getParameter("action").equals("enregistrerPointageVisee")) {
                PointageService.enregistrerPointageVisee(request, u);
                lien_pers = "?but=paie/pointage/pointage-saisie.jsp&currentMenu=MENDYN00001";
                System.out.println("enregistrerPointageVisee");
            }

            String lien = (String) request.getSession().getAttribute("lien");
            response.sendRedirect("/savonnerie/pages/" + lien + lien_pers + apres_lien);
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("<script>alert('" + e.getMessage() + "');history.back();</script>");
            throw e;
        } finally {
        }

    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (Exception ex) {
            ex.printStackTrace();
            //Logger.getLogger(SaveAtPrestation.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (Exception ex) {
            ex.printStackTrace();
            //Logger.getLogger(SaveAtPrestation.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
