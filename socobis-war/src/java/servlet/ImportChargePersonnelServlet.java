package servlet;

import charge.ChargePersonnelTemp;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.Map;

import org.apache.poi.ss.usermodel.*;
import user.UserEJB;

@WebServlet("/ImportChargePersonnel")
@MultipartConfig
public class ImportChargePersonnelServlet extends HttpServlet {

    private final String[] matriculeKeywords = { "MLLE", "MAT", "MATRIC", "MATRICULE", "N°" };

    private final String[] requiredDataColumns = {
            "HEURE NORMAL", "HEURE NORMALE",
            "HEURE HS", "HEURE FERIE", "HEURE DIM",
            "HEURE NUIT", "HEURE IF", "TAUX"
    };

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        UserEJB u = (UserEJB) request.getSession().getAttribute("u");
        String refUser = String.valueOf(u.getUser().getRefuser());
        String idFab = request.getParameter("idFab");
        Part filePart = request.getPart("excelFile");

        if (filePart == null || filePart.getSize() == 0) {
            redirect(response, request, idFab);
            return;
        }

        try (InputStream is = filePart.getInputStream();
             Workbook workbook = WorkbookFactory.create(is)) {

            Sheet sheet = workbook.getSheetAt(0);

            int headerRow = findHeaderRow(sheet);
            if (headerRow == -1) {
                System.out.println("DEBUG: Header row not found!");
                redirect(response, request, idFab);
                return;
            }

            Map<String, Integer> colIndex = readColumnIndex(sheet.getRow(headerRow));

            // DEBUG: Print found columns
            System.out.println("DEBUG: Columns found in Excel: " + colIndex.keySet());

            String matriculeCol = detectMatriculeColumn(colIndex);
            if (matriculeCol == null) {
                System.out.println("DEBUG: Matricule column not found!");
                redirect(response, request, idFab);
                return;
            }

            cleanAndExpandSheetData(sheet, headerRow, colIndex, matriculeCol);

            ChargePersonnelTemp chargeTemp = new ChargePersonnelTemp();
            chargeTemp.setIdFab(idFab);
            chargeTemp.setSheet(sheet);
            chargeTemp.setColIndex(colIndex);
            chargeTemp.setHeaderRow(headerRow);
            chargeTemp.setMatriculeCol(matriculeCol);

            System.out.println("DEBUG: Starting import logic...");
            chargeTemp.importerChargePersonnel(refUser, null);
            System.out.println("DEBUG: Import logic finished.");

            redirect(response, request, idFab);

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }

    private void cleanAndExpandSheetData(Sheet sheet, int headerRow,
                                         Map<String, Integer> colIndex,
                                         String matriculeCol) {

        Integer matriculeIdx = colIndex.get(matriculeCol);
        if (matriculeIdx == null) return;

        Map<String, Integer> dataColIndices = new HashMap<>();
        for (String colName : requiredDataColumns) {
            Integer idx = colIndex.get(colName);
            if (idx != null) {
                dataColIndices.put(colName, idx);
            }
        }

        for (int i = sheet.getLastRowNum(); i > headerRow; i--) {
            Row row = sheet.getRow(i);
            if (row == null) continue;

            Cell matriculeCell = row.getCell(matriculeIdx);
            String matricule = safe(matriculeCell);

            if (matricule == null || matricule.trim().isEmpty()) {
                clearRow(row, matriculeIdx);
                continue;
            }

            String[] matricules = splitMatricules(matricule);

            for (int j = 0; j < matricules.length; j++) {
                matricules[j] = sanitizeMatricule(matricules[j]);
            }

            if (matricules.length > 1) {
                matriculeCell.setCellValue(matricules[0]);

                for (int j = 1; j < matricules.length; j++) {
                    Row newRow = sheet.createRow(sheet.getLastRowNum() + 1);
                    copyRowData(row, newRow, colIndex);
                    Cell newMatriculeCell = newRow.getCell(matriculeIdx);
                    if (newMatriculeCell == null) {
                        newMatriculeCell = newRow.createCell(matriculeIdx);
                    }
                    newMatriculeCell.setCellValue(matricules[j]);
                }
            } else {
                if (matricule.endsWith("-")) {
                    matricule = matricule.substring(0, matricule.length() - 1);
                    matriculeCell.setCellValue(matricule);
                }
            }

            matricule = safe(matriculeCell);
            if (matricule != null && !matricule.trim().isEmpty()) {
                boolean hasData = false;
                for (Integer colIdx : dataColIndices.values()) {
                    Cell cell = row.getCell(colIdx);
                    String value = safe(cell);
                    if (value != null && !value.trim().isEmpty()) {
                        hasData = true;
                        break;
                    }
                }

                if (!hasData) {
                    clearRow(row, matriculeIdx);
                }
            }
        }
    }

    private String[] splitMatricules(String matricule) {
        if (matricule == null || matricule.trim().isEmpty()) return new String[0];
        String[] parts = matricule.split("\\s*-\\s*");
        if (parts.length == 1) return new String[] { matricule };
        if (parts[parts.length - 1].trim().isEmpty()) return new String[] { matricule };

        boolean allValid = true;
        for (String part : parts) {
            if (part.trim().isEmpty()) {
                allValid = false;
                break;
            }
        }
        if (allValid) {
            String[] result = new String[parts.length];
            for (int i = 0; i < parts.length; i++) {
                result[i] = parts[i].trim();
            }
            return result;
        }
        return new String[] { matricule.trim() };
    }

    private String sanitizeMatricule(String matricule) {
        if (matricule == null) return null;

        // 1. Trim spaces
        String clean = matricule.trim();

        // 2. Remove all non-alphanumeric characters (keep letters and numbers)
        clean = clean.replaceAll("[^A-Za-z0-9]", "");

        // 3. Optional: uppercase everything
        clean = clean.toUpperCase();

        return clean;
    }


    private void copyRowData(Row sourceRow, Row targetRow, Map<String, Integer> colIndex) {
        for (Integer colIdx : colIndex.values()) {
            Cell sourceCell = sourceRow.getCell(colIdx);
            if (sourceCell == null) continue;
            Cell targetCell = targetRow.createCell(colIdx);
            switch (sourceCell.getCellType()) {
                case Cell.CELL_TYPE_STRING: targetCell.setCellValue(sourceCell.getStringCellValue()); break;
                case Cell.CELL_TYPE_NUMERIC: targetCell.setCellValue(sourceCell.getNumericCellValue()); break;
                case Cell.CELL_TYPE_BOOLEAN: targetCell.setCellValue(sourceCell.getBooleanCellValue()); break;
                case Cell.CELL_TYPE_FORMULA: targetCell.setCellFormula(sourceCell.getCellFormula()); break;
                default: break;
            }
            targetCell.setCellStyle(sourceCell.getCellStyle());
        }
    }

    private void clearRow(Row row, int matriculeIdx) {
        Cell matriculeCell = row.getCell(matriculeIdx);
        if (matriculeCell != null) matriculeCell.setCellValue("");
    }

    private void redirect(HttpServletResponse res, HttpServletRequest req, String idFab) throws IOException {
        String url = req.getContextPath() + "/pages/module.jsp?but=fabrication/fabrication-fiche.jsp&id=" + idFab;
        res.sendRedirect(url);
    }

    private String safe(Cell c) {
        if (c == null) return null;
        int type = c.getCellType();
        if (type == Cell.CELL_TYPE_STRING) return c.getStringCellValue().trim();
        if (type == Cell.CELL_TYPE_NUMERIC) {
            double n = c.getNumericCellValue();
            if (n == (long) n) return String.valueOf((long) n);
            return String.valueOf(n);
        }
        if (type == Cell.CELL_TYPE_FORMULA) {
            try { return c.getStringCellValue().trim(); }
            catch (Exception e) { return String.valueOf(c.getNumericCellValue()); }
        }
        if (type == Cell.CELL_TYPE_BOOLEAN) return String.valueOf(c.getBooleanCellValue());
        return null;
    }

    private int findHeaderRow(Sheet sheet) {
        for (int i = 0; i <= sheet.getLastRowNum(); i++) {
            Row r = sheet.getRow(i);
            if (r == null) continue;
            for (int j = 0; j < r.getLastCellNum(); j++) {
                String v = safe(r.getCell(j));
                if (v == null) continue;
                for (String key : matriculeKeywords)
                    if (v.toUpperCase().contains(key)) return i;
            }
        }
        return -1;
    }

    private Map<String, Integer> readColumnIndex(Row header) {
        Map<String, Integer> map = new HashMap<>();
        System.out.println("DEBUG: -------- Reading Header Row " + header.getRowNum() + " --------");

        for (int i = 0; i < header.getLastCellNum(); i++) {
            Cell c = header.getCell(i);
            String rawValue = safe(c);

            // Print exactly what is in the cell, wrapped in brackets to see spaces
            System.out.println("DEBUG: Cell " + i + " contains: [" + rawValue + "]");

            if (rawValue != null) {
                // Normalize: UPPERCASE, remove double spaces, remove invisible chars
                String cleaned = rawValue.trim().toUpperCase()
                        .replace("\u00A0", " ")  // Remove non-breaking space
                        .replace("  ", " ")      // Turn double space to single
                        .trim();

                map.put(cleaned, i);
            }
        }
        System.out.println("DEBUG: -------- End Header Reading --------");
        return map;
    }

    private String detectMatriculeColumn(Map<String, Integer> cols) {
        for (String col : cols.keySet()) {
            for (String key : matriculeKeywords)
                if (col.contains(key)) return col;
        }
        return null;
    }
}