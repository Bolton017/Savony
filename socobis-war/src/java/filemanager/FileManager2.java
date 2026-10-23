/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package filemanager;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;

/**
 *
 * @author Princie
 */
@WebServlet(name = "FileManager2", urlPatterns = {"/FileManager2"})
public class FileManager2 extends HttpServlet {

   

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
        try{

            if (request.getSession(false) == null || request.getSession().getAttribute("u") == null) {
                response.sendRedirect(request.getContextPath() + "/index.jsp");
                return;
            }
            String parent_dir = request.getParameter("parent");

            File parent = Util.resolveSafe(parent_dir);
            if(parent != null && parent.isFile()){
                downloadFile(parent, request, response, isInlineRequested(request, parent));
            } else{
                throw new Exception("Fichier invalide");
            }
        } catch(Exception ex){
            ex.printStackTrace();
            response.setContentType("text/html");
            PrintWriter out = response.getWriter();
            out.println("<script>alert(\""+ex.getMessage()+"\"); history.back(); </script>");
            out.flush();
        }
    }

    protected void downloadFile(File file, HttpServletRequest request, HttpServletResponse response,
                                boolean inline) throws Exception {
        try (InputStream inputStream = new FileInputStream(file)) {
            response.setContentType(mimeFor(file));
            response.setContentLength((int) file.length());
            String safeName = file.getName().replace("\"", "").replace("\r", "").replace("\n", "");
            response.setHeader("Content-Disposition",
                    (inline ? "inline" : "attachment") + "; filename=\"" + safeName + "\"");
            response.setHeader("X-Content-Type-Options", "nosniff");
            ServletOutputStream os = response.getOutputStream();
            byte[] bufferData = new byte[8192];
            int read;
            while ((read = inputStream.read(bufferData)) != -1) {
                os.write(bufferData, 0, read);
            }
            os.flush();
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

    private boolean isInlineRequested(HttpServletRequest request, File file) {
        if (!"1".equals(request.getParameter("inline"))) {
            return false;
        }
        String n = file.getName().toLowerCase();
        return n.endsWith(".pdf") || n.endsWith(".png") || n.endsWith(".jpg")
                || n.endsWith(".jpeg") || n.endsWith(".gif");
    }

    private String mimeFor(File file) {
        String n = file.getName().toLowerCase();
        if (n.endsWith(".pdf"))  return "application/pdf";
        if (n.endsWith(".png"))  return "image/png";
        if (n.endsWith(".jpg") || n.endsWith(".jpeg")) return "image/jpeg";
        if (n.endsWith(".gif"))  return "image/gif";
        String m = getServletContext().getMimeType(file.getAbsolutePath());
        return m != null ? m : "application/octet-stream";
    }

}
