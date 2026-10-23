package servlet.reporting;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.*;
import org.apache.poi.hssf.usermodel.*;
import org.apache.poi.ss.usermodel.*;
import mg.cnaps.compta.*;

@WebServlet("/export-balance")
public class BalanceExportServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Récupérer la balance depuis la session
        BalanceDetails[] balanceDetails =
                (BalanceDetails[]) request.getSession().getAttribute("balanceDetails");
                request.getSession().removeAttribute("balanceDetails");

        if (balanceDetails == null) {
            response.getWriter().println("Aucune donnée à exporter.");
            return;
        }

        exportBalanceExcel(balanceDetails, response);
    }

    // ===================== EXPORT EXCEL =====================
    private void exportBalanceExcel(BalanceDetails[] balanceDetails,
                                    HttpServletResponse response) throws IOException {
        try {
            HSSFWorkbook workbook = new HSSFWorkbook();
            HSSFSheet sheet = workbook.createSheet("Balance comptable");

            // ===================== STYLE ENTÊTE =====================
            HSSFCellStyle headerStyle = workbook.createCellStyle();
            HSSFFont bold = workbook.createFont();
            bold.setBoldweight(Font.BOLDWEIGHT_BOLD);
            headerStyle.setFont(bold);

            // Compatibilité ancienne version POI
            headerStyle.setAlignment((short) HSSFCellStyle.ALIGN_CENTER);
            headerStyle.setBorderBottom((short) HSSFCellStyle.BORDER_THIN);

            // ===================== STYLE CELLULE NUMERIQUE =====================
            HSSFCellStyle numberStyle = workbook.createCellStyle();
            numberStyle.setDataFormat(workbook.createDataFormat().getFormat("#,##0.00"));

            // ===================== ENTÊTES =====================
            String[] headers = {
                    "Compte", "Libelle Compte",
                    "Cumul Debit", "Cumul Credit",
                    "Debit", "Credit",
                    "Solde Debit", "Solde Credit"
            };

            HSSFRow headerRow = sheet.createRow(0);
            for (int i = 0; i < headers.length; i++) {
                HSSFCell cell = headerRow.createCell(i);
                cell.setCellValue(headers[i]);
                cell.setCellStyle(headerStyle);
            }

            // ===================== DONNÉES =====================
            int rowIndex = 1;

            for (BalanceDetails b : balanceDetails) {
                if (!b.estValide()) {
                    continue;
                }

                HSSFRow row = sheet.createRow(rowIndex++);

                row.createCell(0).setCellValue(b.getCompte());
                row.createCell(1).setCellValue(b.getLibelleCompte());

                createNumberCell(row, 2, b.getCumulDebit(), numberStyle);
                createNumberCell(row, 3, b.getCumulCredit(), numberStyle);
                createNumberCell(row, 4, b.getDebit(), numberStyle);
                createNumberCell(row, 5, b.getCredit(), numberStyle);
                createNumberCell(row, 6, b.getSoldeDebit(), numberStyle);
                createNumberCell(row, 7, b.getSoldeCredit(), numberStyle);
            }

            // Auto-size colonnes
            for (int i = 0; i < headers.length; i++) {
                sheet.autoSizeColumn(i);
            }

            // ===================== TÉLÉCHARGEMENT =====================
            response.setContentType("application/vnd.ms-excel");
            response.setHeader("Content-Disposition",
                    "attachment; filename=balance_comptable.xls");

            OutputStream out = response.getOutputStream();
            workbook.write(out);
            workbook.close();
            out.close();
        } catch (Exception e) {
            throw new IOException("Erreur lors de l'exportation de la balance : " + e.getMessage());
        }
    }

    private void createNumberCell(Row row, int index,
                                  double value, CellStyle style) {

        Cell cell = row.createCell(index);
        cell.setCellValue(value);
        cell.setCellStyle(style);
    }
}
