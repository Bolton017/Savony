package servlet.paie.export.ostie;

import java.io.IOException;
import java.io.OutputStream;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.Workbook;

import paie.ostie.OstieAffiche;

@WebServlet("/ExportOstie")
@MultipartConfig
public class ExportServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            
            configureResponse(response);
            
            
            List<OstieAffiche> employes = ExportUtil.getDonneesStatiques();
            
            
            Workbook workbook = ExportUtil.createOstieWorkbook(employes);
            
            
            sendWorkbook(workbook, response);
            
        } catch (Exception e) {
            
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                             "Erreur lors de la génération du fichier Excel");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
    
    
    
    private void configureResponse(HttpServletResponse response) {
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=export_paie_ostie.xlsx");
    }
    
    private void sendWorkbook(Workbook workbook, HttpServletResponse response) throws IOException {
        try (OutputStream outputStream = response.getOutputStream()) {
            workbook.write(outputStream);
        } finally {
            workbook.close();
        }
    }
}