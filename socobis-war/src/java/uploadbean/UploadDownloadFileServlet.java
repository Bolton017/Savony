package uploadbean;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import user.UserEJB;
import utilitaire.Utilitaire;

@WebServlet("/UploadDownloadFileServlet")
public class UploadDownloadFileServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private ServletFileUpload uploader = null;

    private void createDir(String path) {
        File file = new File(path);
        if (!file.exists()) {
            file.mkdirs();
        }
    }

    @Override
    public void init() {
        DiskFileItemFactory fileFactory = new DiskFileItemFactory();
        File filesDir = (File) getServletContext().getAttribute(StringUtil.FILES_DIR_FILE);
        fileFactory.setRepository(filesDir);
        this.uploader = new ServletFileUpload(fileFactory);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) {
        try {
            String fileName = request.getParameter(StringUtil.FILE_NAME);

            if (fileName == null || fileName.equals("")) {
                throw new ServletException("File Name can't be null or empty");
            }
            File file = new File(request.getServletContext().getAttribute(StringUtil.FILES_DIR) + fileName);

            if (!file.exists()) {
                throw new ServletException("File doesn't exists on server.");
            }

            InputStream inputStream = new FileInputStream(file);
            ServletContext context = getServletContext();
            String mimeType = context.getMimeType(file.getAbsolutePath());

            response.setContentType(mimeType != null ? mimeType : "application/octet-stream");
            response.setContentLength((int) file.length());
            response.setHeader("Content-Disposition", "attachment; name=\"" + fileName + "\"");

            ServletOutputStream os = response.getOutputStream();
            byte[] bufferData = new byte[1024];
            int read;
            while ((read = inputStream.read(bufferData)) != -1) {
                os.write(bufferData, 0, read);
            }
            os.flush();
            os.close();
            inputStream.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        PrintWriter out = response.getWriter();
        HashMap<String, String> params = new HashMap<>();
        HashMap<String, String> fichiers = new HashMap<>();
        try {
            if (!ServletFileUpload.isMultipartContent(request)) {
                throw new ServletException("Content type is not multipart/form-data");
            }
            String dossier = request.getParameter(StringUtil.DOSS);
            String path = StringUtil.PATH_DIR + File.separator + "async" + File.separator +dossier;
            createDir(path);
            // System.out.println("eto "+dossier+" mety ooo  " + path);
            List<FileItem> fileItemsList = uploader.parseRequest(request);

            for (FileItem fileItem : fileItemsList) {
                if (fileItem.getName() != null && !fileItem.isFormField()) {
//                    fileItem.
                    String filename = fileItem.getName();
                    int i = filename.lastIndexOf('.');
                    String ext = i > 0 ? filename.substring(i + 1) : "";
                    String name = fileItem.getName().split("." + ext)[0] + "-" + Utilitaire.heureCourante() + Utilitaire.dateDuJour() + "." + ext;
//              

                    String nameVal = name
                            .replace(":", "")
                            .replace("/", "-")
                            .replace(" ", "");

                    String dir = path + File.separator + nameVal;
                    File file = new File(dir);
                    fileItem.write(file);
                    fichiers.put(nameVal, fileItem.getFieldName());
                } else {
                    params.put(fileItem.getFieldName(), fileItem.getString());
                }
            }
            //AttacherFichier fichier
            String iddossier = params.get("dossier");
            String natureDuDossierchoix = params.get("natureDuDossierchoix");
            String lienenf = "";
            if (iddossier != null) {
                lienenf = "&iddossier=" + iddossier;
            }

            if (natureDuDossierchoix != null) {
                lienenf = "&natureDuDossierchoix=" + natureDuDossierchoix;
            }

            UserEJB u = (UserEJB) request.getSession().getAttribute("u");
            Iterator it = fichiers.entrySet().iterator();

//            u.createUploadedPjService(iddossier, params, it, params.get("nomtable"), params.get("procedure"), params.get("id"));
            System.out.println("----but " + params.get("bute"));
            String mere = null;
            String lienRedirection = "pages/module.jsp?but=" + params.get("bute");
            if (params.get("id") != null) {
                lienRedirection += "&id=" + params.get("id");
                mere = params.get("id");
            }
            if (params.get("idDir") != null) {
                lienRedirection += "&idDir=" + params.get("idDir");
                mere = params.get("idDir");
            }
            if (params.get("tab") != null) {
                lienRedirection += "&tab=" + params.get("tab");
            }
            String id = params.get("id");
            if ( params.get("classe") != null && !params.get("classe").isEmpty() && !params.get("classe").equalsIgnoreCase("null")) {
                u.createUploadedPjService(dossier, params, it, params.get("nomtable"), params.get("procedure"), mere, params.get("classe"), id);
            }else u.createUploadedPjService(dossier, params, it, params.get("nomtable"), params.get("procedure"), mere);
            response.sendRedirect(lienRedirection);
        } catch (Exception e) {
            e.printStackTrace();
            out.write("Exception in uploading file. Cause : " + e.getMessage());
            //throw e;
        } finally {
            if (out != null) {
                out.close();
            }
        }
    }

}
