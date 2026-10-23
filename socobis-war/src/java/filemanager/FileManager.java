/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package filemanager;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.List;

/**
 *
 * @author Princie
 */
@WebServlet(name = "FileManager", urlPatterns = {"/FileManager"})
public class FileManager extends HttpServlet {

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
            String parent_dir = request.getParameter("parent");
//            File parent = new File(Util.BASE_DIR + (parent_dir == null || parent_dir.isEmpty()  ? "" : parent_dir));
            configuration.CynthiaConf.load();
            File parent = new File(configuration.CynthiaConf.properties.getProperty("localRepository") + (parent_dir == null || parent_dir.isEmpty() ? "" : parent_dir));
            if (parent.isDirectory()) {
                MyFileFilter fileFilter = new MyFileFilter();
                fileFilter.setName(request.getParameter("name"));
                fileFilter.setSort(request.getParameter("sort"));
                List<File> files = fileFilter.applyTo(parent);
                request.setAttribute("files", files);
                request.setAttribute("parent", parent_dir);
                request.setAttribute("prevpath", MyFileFilter.getPreviousPath(parent_dir));
                RequestDispatcher rd = request.getRequestDispatcher("/pages/module.jsp?but=filemanager/file-list.jsp");
                rd.forward(request, response);
            } else {
                downloadFile(parent, request, response);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    protected void downloadFile(File file, HttpServletRequest request, HttpServletResponse response) throws Exception {
        try (InputStream inputStream = new FileInputStream(file)) {
            String mimeType = getServletContext().getMimeType(file.getAbsolutePath());

            response.setContentType(mimeType != null ? mimeType : "application/octet-stream");
            response.setContentLength((int) file.length());
            response.setHeader("Content-Disposition", "attachment; filename=\"" + file.getName() + "\"");
            ServletOutputStream os = response.getOutputStream();
            byte[] bufferData = new byte[1024];
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

}
