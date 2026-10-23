package servlet;

import mg.cnaps.compta.Balance;
import mg.cnaps.compta.BalanceDetails;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.*;
import utilitaire.UtilDB;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.OutputStream;
import java.sql.Connection;

@WebServlet(name = "EtatComptableExcelServlet", urlPatterns = {"/EtatComptableExcelServlet"})
public class EtatComptableExcelServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Connection c = null;
        try {
            String typecompte = request.getParameter("typeCompte");
            String mois1 = request.getParameter("moisDebut");
            String mois2 = request.getParameter("moisFin");
            String plage1 = request.getParameter("debutCompte");
            String plage2 = request.getParameter("finCompte");
            String exercice = request.getParameter("exercice");
            String isAuxParam = request.getParameter("isAuxiliaire");
            boolean isAux = "true".equalsIgnoreCase(isAuxParam);

            c = (new UtilDB()).GetConn();
            Balance balance;
            if (isAux) {
                balance = new Balance(exercice, typecompte, mois1, mois2, plage1, plage2, true);
            } else {
                balance = new Balance(exercice, typecompte, mois1, mois2, plage1, plage2);
            }
            BalanceDetails[] balanceDetails = balance.getBalanceDetails();
            BalanceDetails total = balance.getTotal();

            Workbook workbook = new HSSFWorkbook();
            String sheetName = isAux ? "Balance Auxiliaire" : "Balance Generale";
            Sheet sheet = workbook.createSheet(sheetName);

            CellStyle headerStyle = workbook.createCellStyle();
            Font headerFont = workbook.createFont();
            headerFont.setBoldweight(Font.BOLDWEIGHT_BOLD);
            headerFont.setFontName("Calibri");
            headerStyle.setFont(headerFont);
            headerStyle.setAlignment(CellStyle.ALIGN_CENTER);
            headerStyle.setBorderBottom(CellStyle.BORDER_THIN);
            headerStyle.setBorderTop(CellStyle.BORDER_THIN);
            headerStyle.setBorderLeft(CellStyle.BORDER_THIN);
            headerStyle.setBorderRight(CellStyle.BORDER_THIN);
            headerStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
            headerStyle.setFillPattern(CellStyle.SOLID_FOREGROUND);

            CellStyle dataStyle = workbook.createCellStyle();
            Font dataFont = workbook.createFont();
            dataFont.setFontName("Calibri");
            dataStyle.setFont(dataFont);
            dataStyle.setBorderBottom(CellStyle.BORDER_THIN);
            dataStyle.setBorderTop(CellStyle.BORDER_THIN);
            dataStyle.setBorderLeft(CellStyle.BORDER_THIN);
            dataStyle.setBorderRight(CellStyle.BORDER_THIN);

            CellStyle numberStyle = workbook.createCellStyle();
            numberStyle.cloneStyleFrom(dataStyle);
            numberStyle.setAlignment(CellStyle.ALIGN_RIGHT);
            DataFormat format = workbook.createDataFormat();
            numberStyle.setDataFormat(format.getFormat("#,##0.00"));

            int rowIdx = 1;

            Row headerRow = sheet.createRow(rowIdx++);
            String[] headers = {"Compte","Intitulé du compte", "Cumul DB", "Cumul CR", "Mouvement DB", "Mouvement CR", "Solde DB", "Solde CR"};
            for (int i = 0; i < headers.length; i++) {
                Cell cell = headerRow.createCell(i);
                cell.setCellValue(headers[i]);
                cell.setCellStyle(headerStyle);
            }

            for (int i = 0; i < balanceDetails.length; i++) {
                if (balanceDetails[i].estValide()) {
                    Row row = sheet.createRow(rowIdx++);

                    Cell c0 = row.createCell(0);
                    c0.setCellValue(balanceDetails[i].getCompte());
                    c0.setCellStyle(dataStyle);

                    Cell c1 = row.createCell(1);
                    c1.setCellValue(balanceDetails[i].getLibelleCompte());
                    c1.setCellStyle(dataStyle);

                    Cell c2 = row.createCell(2);
                    c2.setCellValue(balanceDetails[i].getCumulDebit());
                    c2.setCellStyle(numberStyle);

                    Cell c3 = row.createCell(3);
                    c3.setCellValue(balanceDetails[i].getCumulCredit());
                    c3.setCellStyle(numberStyle);

                    Cell c4 = row.createCell(4);
                    c4.setCellValue(balanceDetails[i].getDebit());
                    c4.setCellStyle(numberStyle);

                    Cell c5 = row.createCell(5);
                    c5.setCellValue(balanceDetails[i].getCredit());
                    c5.setCellStyle(numberStyle);

                    Cell c6 = row.createCell(6);
                    c6.setCellValue(balanceDetails[i].getSoldeDebit());
                    c6.setCellStyle(numberStyle);

                    Cell c7 = row.createCell(7);
                    c7.setCellValue(balanceDetails[i].getSoldeCredit());
                    c7.setCellStyle(numberStyle);
                }
            }

            Row totalRow = sheet.createRow(rowIdx++);

            Cell t0 = totalRow.createCell(0);
            t0.setCellStyle(dataStyle);

            Cell t1 = totalRow.createCell(1);
            t1.setCellValue("Totaux");
            t1.setCellStyle(headerStyle);

            Cell t2 = totalRow.createCell(2);
            t2.setCellValue(total.getCumulDebit());
            t2.setCellStyle(numberStyle);

            Cell t3 = totalRow.createCell(3);
            t3.setCellValue(total.getCumulCredit());
            t3.setCellStyle(numberStyle);

            Cell t4 = totalRow.createCell(4);
            t4.setCellValue(total.getDebit());
            t4.setCellStyle(numberStyle);

            Cell t5 = totalRow.createCell(5);
            t5.setCellValue(total.getCredit());
            t5.setCellStyle(numberStyle);

            Cell t6 = totalRow.createCell(6);
            t6.setCellValue(total.getSoldeDebit());
            t6.setCellStyle(numberStyle);

            Cell t7 = totalRow.createCell(7);
            t7.setCellValue(total.getSoldeCredit());
            t7.setCellStyle(numberStyle);

            for (int i = 0; i < headers.length; i++) {
                sheet.autoSizeColumn(i);
            }

            String fileName = isAux ? "Balance_compta_auxiliaire.xls" : "Balance_compta_general.xls";
            response.setContentType("application/vnd.ms-excel");
            response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");

            OutputStream out = response.getOutputStream();
            workbook.write(out);
            out.close();
            workbook.close();

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erreur lors de la génération de l'Excel");
        } finally {
            if (c != null) {
                try {
                    c.close();
                } catch (Exception ignored) {}
            }
        }
    }
}
