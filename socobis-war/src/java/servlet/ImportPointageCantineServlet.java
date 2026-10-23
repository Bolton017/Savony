package servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;

import org.apache.poi.ss.usermodel.*;
import paie.employe.PaieInfoPersonnel;
import paie.pointage.PointageCantine;
import utilitaire.UtilDB;
import utilitaire.Utilitaire;
import user.UserEJB;

@WebServlet("/ImportPointageCantineServlet")
@MultipartConfig
public class ImportPointageCantineServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        UserEJB uBean = (UserEJB) session.getAttribute("u");
        String refUser = uBean.getUser().getTuppleID();

        Part filePart = request.getPart("excelFile");
        if (filePart == null || filePart.getSize() == 0) {
            response.getWriter().println("Error: No file uploaded.");
            return;
        }

        Connection c = null;
        try (InputStream is = filePart.getInputStream();
             Workbook workbook = WorkbookFactory.create(is)) {

            c = new UtilDB().GetConn();
            Sheet sheet = workbook.getSheetAt(0);

            int headerRowIndex = findHeaderRow(sheet);
            if (headerRowIndex == -1) {
                System.out.println("Error: Header not found.");
                return;
            }

            Row headerRow = sheet.getRow(headerRowIndex);
            int colIndexNo = -1;
            int colIndexAttend = -1;

            for (Cell cell : headerRow) {
                String val = getCellValue(cell).toUpperCase();
                if (val.equals("NO")) colIndexNo = cell.getColumnIndex();
                else if (val.contains("ATTEND") && val.contains("REQ")) colIndexAttend = cell.getColumnIndex();
            }

            if (colIndexNo == -1 || colIndexAttend == -1) {
                System.out.println("Error: Columns not found.");
                return;
            }

            int countImported = 0;

            for (int i = headerRowIndex + 2; i <= sheet.getLastRowNum(); i++) {
                Row row = sheet.getRow(i);
                if (row == null) continue;

                String noValue = getCellValue(row.getCell(colIndexNo));
                String attendValue = getCellValue(row.getCell(colIndexAttend)); // e.g., "9/1" or "9/0"

                if (noValue != null && !noValue.trim().isEmpty()) {
                    try {
                        PaieInfoPersonnel personnel = (PaieInfoPersonnel) new PaieInfoPersonnel().getById(noValue, "PAIE_INFO_PERSONNEL", c);

                        if (personnel != null && personnel.getId() != null) {

                            double nombreVal = 0;
                            if (attendValue.contains("/")) {
                                String[] parts = attendValue.split("/");
                                if (parts.length > 1) {
                                    try {
                                        nombreVal = Double.parseDouble(parts[1].trim());
                                    } catch (NumberFormatException nfe) {
                                        System.out.println("Warning: Invalid number format in attend col: " + attendValue);
                                    }
                                }
                            }

                            PointageCantine p = new PointageCantine();
                            p.setIdpersonnel(personnel.getId());
                            p.setDaty(Utilitaire.dateDuJourSql());
                            p.setNombre(nombreVal);
                            p.createObject(refUser, c);

                            countImported++;
                            System.out.println("Saved: " + personnel.getId() + " with Nombre: " + nombreVal);
                        } else {
                            System.out.println("Personnel not found for NO: " + noValue);
                        }

                    } catch (Exception ex) {
                        System.out.println("Error creating object for line " + i + ": " + ex.getMessage());
                        ex.printStackTrace();
                    }
                }
            }

            System.out.println("Import Finished. Total records: " + countImported);
            String referer = request.getHeader("referer");
            if(referer != null) {
                response.sendRedirect(referer);
            } else {
                response.sendRedirect(request.getContextPath() + "/pages/module.jsp?but=cantine/pointage-cantine.jsp");
            }

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Global Error processing file", e);
        } finally {
            if (c != null) {
                try { c.close(); } catch (Exception ignore) {}
            }
        }
    }

    private int findHeaderRow(Sheet sheet) {
        for (int i = 0; i < 10; i++) {
            Row row = sheet.getRow(i);
            if (row == null) continue;
            for (Cell cell : row) {
                if (getCellValue(cell).trim().equalsIgnoreCase("No")) return i;
            }
        }
        return -1;
    }

    private String getCellValue(Cell cell) {
        if (cell == null) return "";
        switch (cell.getCellType()) {
            case Cell.CELL_TYPE_STRING: return cell.getStringCellValue().trim();
            case Cell.CELL_TYPE_NUMERIC:
                if (DateUtil.isCellDateFormatted(cell)) return cell.getDateCellValue().toString();
                double num = cell.getNumericCellValue();
                if (num == (long) num) return String.valueOf((long) num);
                return String.valueOf(num);
            case Cell.CELL_TYPE_BOOLEAN: return String.valueOf(cell.getBooleanCellValue());
            case Cell.CELL_TYPE_FORMULA:
                try { return cell.getStringCellValue(); }
                catch (Exception e) { return String.valueOf(cell.getNumericCellValue()); }
            default: return "";
        }
    }
}