package servlet;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import org.apache.poi.ss.usermodel.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.IOException;
import java.io.InputStream;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.usermodel.DateUtil;


import java.text.SimpleDateFormat;
import java.util.*;

@MultipartConfig
@WebServlet(name = "LoadCSV", urlPatterns = {"/LoadCSV"})
public class LoadFromCsv extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, Exception {
        getDataFromCSV(request,response);
    }

    public void getDataFromCSV(HttpServletRequest request, HttpServletResponse response) {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            Part filePart = request.getPart("file");
            InputStream fileContent = filePart.getInputStream();

            List<HashMap<String, String>> data = readExcel(fileContent);

            //Gson gson = new Gson();
            //String json = gson.toJson(data);
            Gson gson = new GsonBuilder()
                    .setDateFormat("dd/MM/yyyy")
                    .create();

            String json = gson.toJson(data);
            System.out.println("json = " + json);


            System.out.println("json = " + json);

            response.getWriter().write(json);

        } catch (Exception e) {
            e.printStackTrace();
            try {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"error\":\"Impossible de traiter le fichier CSV.\"}");
            } catch (Exception ignored) {}
        }
    }

    /*public static List<HashMap<String, String>> readExcel(InputStream inputStream) throws Exception {
        List<HashMap<String, String>> result = new ArrayList<>();
        DataFormatter formatter = new DataFormatter();

        try (Workbook workbook = WorkbookFactory.create(inputStream)) {
            Sheet sheet = workbook.getSheetAt(0);

            Iterator<Row> rowIterator = sheet.iterator();
            if (!rowIterator.hasNext()) {
                return result; 
            }

            Row headerRow = rowIterator.next();
            List<String> headers = new ArrayList<>();
            for (Cell cell : headerRow) {
                headers.add(formatter.formatCellValue(cell).trim());
            }

            while (rowIterator.hasNext()) {
                Row row = rowIterator.next();
                HashMap<String, String> map = new HashMap<>();

                for (int i = 0; i < headers.size(); i++) {
                    Cell cell = row.getCell(i);
                    String value = (cell != null) ? formatter.formatCellValue(cell).trim() : "";
                    map.put(headers.get(i), value);
                }

                boolean notEmpty = false;
                for (String v : map.values()) {
                    if (v != null && !v.isEmpty()) {
                        notEmpty = true;
                        break;
                    }
                }

                if (notEmpty) {
                    result.add(map);
                }
            }
        }

        return result;
    }*/

    public static List<HashMap<String, String>> readExcel(InputStream inputStream) throws Exception {
        List<HashMap<String, String>> result = new ArrayList<>();
        DataFormatter formatter = new DataFormatter();

        SimpleDateFormat sdfOut = new SimpleDateFormat("dd/MM/yyyy");
        SimpleDateFormat sdfInIso = new SimpleDateFormat("yyyy-MM-dd");

        try (Workbook workbook = WorkbookFactory.create(inputStream)) {
            Sheet sheet = workbook.getSheetAt(0);

            Iterator<Row> rowIterator = sheet.iterator();
            if (!rowIterator.hasNext()) {
                return result;
            }

            // headers
            Row headerRow = rowIterator.next();
            List<String> headers = new ArrayList<>();
            for (Cell cell : headerRow) {
                headers.add(formatter.formatCellValue(cell).trim());
            }

            while (rowIterator.hasNext()) {
                Row row = rowIterator.next();
                HashMap<String, String> map = new HashMap<>();

                for (int i = 0; i < headers.size(); i++) {
                    Cell cell = row.getCell(i);
                    String value = "";

                    if (cell != null) {

                        // ✅ POI 3.12: NUMERIC type check
                        if (cell.getCellType() == Cell.CELL_TYPE_NUMERIC && DateUtil.isCellDateFormatted(cell)) {
                            value = sdfOut.format(cell.getDateCellValue());

                        } else {
                            value = formatter.formatCellValue(cell).trim();

                            // ✅ ISO text date: 2025-01-30 -> 30/01/2025
                            if (value.matches("\\d{4}-\\d{2}-\\d{2}")) {
                                try {
                                    value = sdfOut.format(sdfInIso.parse(value));
                                } catch (Exception ignored) {}
                            }
                        }
                    }

                    map.put(headers.get(i), value);
                }

                // skip empty rows
                boolean notEmpty = false;
                for (String v : map.values()) {
                    if (v != null && !v.isEmpty()) {
                        notEmpty = true;
                        break;
                    }
                }

                if (notEmpty) {
                    result.add(map);
                }
            }
        }

        return result;
    }



    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (Exception ex) {
            Logger.getLogger(getClass().getName()).log(Level.SEVERE, null, ex);
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
            Logger.getLogger(getClass().getName()).log(Level.SEVERE, null, ex);
        }
    }
}
