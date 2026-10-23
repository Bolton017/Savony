<%@page import="user.UserEJB"%>
<%@ page import="vente.ExportPDFDirect" %><%@ page import="java.io.OutputStream" %><%
    String idVente = request.getParameter("idVente");
    UserEJB u = (UserEJB) request.getSession().getAttribute("u");
    String currentAppPath = request.getServletContext().getRealPath("/");
    if (idVente != null && !idVente.isEmpty()) {
        try {
            byte[] pdfBytes = ExportPDFDirect.ficheVenteDirect(idVente , u , currentAppPath);

            if (pdfBytes != null && pdfBytes.length > 0) {
                response.setContentType("application/pdf");
                response.setHeader("Content-Disposition", "inline; filename=facture_" + idVente + ".pdf");
                response.setContentLength(pdfBytes.length);

                // Tr�s important pour �viter les conflits avec le Writer du JSP
                out.clear();
                out = pageContext.pushBody();

                OutputStream os = response.getOutputStream();
                os.write(pdfBytes);
                os.flush();
                os.close();
            } else {
                out.println("Erreur : Le fichier PDF est vide ou n'a pas pu etre genere pour l'ID : " + idVente);
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.println("Erreur lors de la generation du PDF : " + e.getMessage());
        }
    } else {
        out.println("ID Vente manquant.");
    }
%>