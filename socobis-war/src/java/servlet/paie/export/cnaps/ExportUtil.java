package servlet.paie.export.cnaps;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

public class ExportUtil {
    
    private static final List<String> HEADERS_LIGNE1 = Arrays.asList(
        "Matricule travailleur",
        "N CIN", 
        "Nom",
        "Prenom (s)",
        "Reference Employeur",
        "Date Embauche",
        "Date Debauche",
        "M1",          
        "",            
        "",            
        "",            
        "M2",          
        "",            
        "",            
        "",            
        "M3",          
        "",            
        "",            
        "",            
        "Occasionnel (O/N) O(oui) et N(non)",
        "N Telephone",
        "Adresse mail"
    );
    
    private static final List<String> HEADERS_LIGNE2 = Arrays.asList(
        "",            
        "",            
        "",            
        "",            
        "",            
        "",            
        "",            
        "Salaire",     
        "Avantage",    
        "TP (Numerique)", 
        "Plafond",     
        "Salaire",     
        "Avantage",    
        "TP (Numerique)", 
        "Plafond",     
        "Salaire",     
        "Avantage",    
        "TP (Numerique)", 
        "Plafond",     
        "",            
        "",            
        ""             
    );
    
    public static Workbook createCnapsWorkbook(List<List<String>> donneesEmployes) {
        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("CNAPS - Export Paie");
        
        StylesContainer styles = createStyles(workbook);
        
        int currentRow = 0;
        
        createHeadersWithMerging(sheet, currentRow, styles, workbook);
        currentRow += 2; 
        
        for (List<String> employeData : donneesEmployes) {
            createEmployeeRow(sheet, currentRow++, employeData, styles);
        }
        
        adjustColumnWidths(sheet, donneesEmployes);
        
        return workbook;
    }
    
    public static List<List<String>> getDonneesStatiques() {
        List<List<String>> employes = new ArrayList<>();
        
        List<String> emp1 = Arrays.asList(
            "970705002161",           
            "117071021768",           
            "RASAMISON",              
            "TOLOJANAHARY TANTELINIAINA MICHAEL", 
            "",                       
            "08/07/2024",            
            "",                       
            "1 457 600,00",          
            "0.0",                   
            "173,33",                
            "2 101 440,00",          
            "1 408 052,00",          
            "0.0",                   
            "168,00",                
            "2 101 440,00",          
            "1 437 130,00",          
            "0.0",                   
            "173,33",                
            "2 101 440,00",          
            "N",                     
            "",                      
            ""                       
        );
        employes.add(emp1);
        
        List<String> emp2 = Arrays.asList(
            "980306001234",
            "201234567890",
            "RANDRIAMAMPIONONA", 
            "MARIE CLAIRE",
            "",
            "15/03/2023",
            "",
            "1 200 000,00",
            "50 000,00",
            "150,00",
            "2 101 440,00",
            "1 250 000,00", 
            "50 000,00",
            "155,00",
            "2 101 440,00",
            "1 300 000,00",
            "50 000,00", 
            "160,00",
            "2 101 440,00",
            "N",
            "032 12 345 67",
            "marie.r@example.com"
        );
        employes.add(emp2);
        
        List<String> emp3 = Arrays.asList(
            "751122003456",
            "301987654321", 
            "RAKOTOMALALA",
            "JEAN BAPTISTE",
            "",
            "10/01/2022",
            "",
            "1 800 000,00",
            "100 000,00",
            "230,00", 
            "2 101 440,00",
            "1 850 000,00",
            "100 000,00",
            "235,00",
            "2 101 440,00", 
            "1 900 000,00",
            "100 000,00",
            "240,00",
            "2 101 440,00",
            "N",
            "034 56 789 01", 
            "jean.r@example.com"
        );
        employes.add(emp3);
        
        return employes;
    }
    
    private static StylesContainer createStyles(Workbook workbook) {
        StylesContainer styles = new StylesContainer();
        
        
        styles.headerStyle = workbook.createCellStyle();
        styles.headerStyle.setFillForegroundColor(IndexedColors.WHITE.getIndex());
        styles.headerStyle.setFillPattern(CellStyle.SOLID_FOREGROUND);
        styles.headerStyle.setBorderBottom(CellStyle.BORDER_THIN);
        styles.headerStyle.setBorderTop(CellStyle.BORDER_THIN);
        styles.headerStyle.setBorderRight(CellStyle.BORDER_THIN);
        styles.headerStyle.setBorderLeft(CellStyle.BORDER_THIN);
        styles.headerStyle.setAlignment(CellStyle.ALIGN_CENTER);
        styles.headerStyle.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        styles.headerStyle.setWrapText(true);
        
        Font headerFont = workbook.createFont();
        headerFont.setBoldweight(Font.BOLDWEIGHT_BOLD);
        headerFont.setFontHeightInPoints((short) 9);
        styles.headerStyle.setFont(headerFont);
        
        
        styles.subHeaderStyle = workbook.createCellStyle();
        styles.subHeaderStyle.setFillForegroundColor(IndexedColors.WHITE.getIndex());
        styles.subHeaderStyle.setFillPattern(CellStyle.SOLID_FOREGROUND);
        styles.subHeaderStyle.setBorderBottom(CellStyle.BORDER_THIN);
        styles.subHeaderStyle.setBorderTop(CellStyle.BORDER_THIN);
        styles.subHeaderStyle.setBorderRight(CellStyle.BORDER_THIN);
        styles.subHeaderStyle.setBorderLeft(CellStyle.BORDER_THIN);
        styles.subHeaderStyle.setAlignment(CellStyle.ALIGN_CENTER);
        styles.subHeaderStyle.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        
        Font subHeaderFont = workbook.createFont();
        subHeaderFont.setBoldweight(Font.BOLDWEIGHT_BOLD);
        subHeaderFont.setFontHeightInPoints((short) 8);
        styles.subHeaderStyle.setFont(subHeaderFont);
        
        
        styles.dataStyle = workbook.createCellStyle();
        styles.dataStyle.setBorderBottom(CellStyle.BORDER_THIN);
        styles.dataStyle.setBorderTop(CellStyle.BORDER_THIN);
        styles.dataStyle.setBorderRight(CellStyle.BORDER_THIN);
        styles.dataStyle.setBorderLeft(CellStyle.BORDER_THIN);
        styles.dataStyle.setAlignment(CellStyle.ALIGN_CENTER);
        styles.dataStyle.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        
        
        styles.numberStyle = workbook.createCellStyle();
        styles.numberStyle.setBorderBottom(CellStyle.BORDER_THIN);
        styles.numberStyle.setBorderTop(CellStyle.BORDER_THIN);
        styles.numberStyle.setBorderRight(CellStyle.BORDER_THIN);
        styles.numberStyle.setBorderLeft(CellStyle.BORDER_THIN);
        styles.numberStyle.setAlignment(CellStyle.ALIGN_RIGHT);
        styles.numberStyle.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        
        return styles;
    }
    
    private static void createHeadersWithMerging(Sheet sheet, int startRow, StylesContainer styles, Workbook workbook) {
        Row headerRow1 = sheet.createRow(startRow);
        Row headerRow2 = sheet.createRow(startRow + 1);
        
        for (int i = 0; i < HEADERS_LIGNE1.size(); i++) {
            Cell cell1 = headerRow1.createCell(i);
            String headerValue = HEADERS_LIGNE1.get(i);
            
            if (!headerValue.isEmpty()) {
                cell1.setCellValue(headerValue);
                cell1.setCellStyle(styles.headerStyle);
            }
        }
        
        for (int i = 0; i < HEADERS_LIGNE2.size(); i++) {
            Cell cell2 = headerRow2.createCell(i);
            String subHeaderValue = HEADERS_LIGNE2.get(i);
            
            if (!subHeaderValue.isEmpty()) {
                cell2.setCellValue(subHeaderValue);
                cell2.setCellStyle(styles.subHeaderStyle);
            } else {
                cell2.setCellStyle(styles.headerStyle);
            }
        }
        
        sheet.addMergedRegion(new CellRangeAddress(startRow, startRow, 7, 10));      
        sheet.addMergedRegion(new CellRangeAddress(startRow, startRow, 11, 14));     
        sheet.addMergedRegion(new CellRangeAddress(startRow, startRow, 15, 18));     
        
        int[] columnsToMergeVertically = {0, 1, 2, 3, 4, 5, 6, 19, 20, 21};
        for (int col : columnsToMergeVertically) {
            sheet.addMergedRegion(new CellRangeAddress(startRow, startRow + 1, col, col));
        }
        
        headerRow1.setHeightInPoints(25);
        headerRow2.setHeightInPoints(20);
    }
    
    private static void adjustColumnWidths(Sheet sheet, List<List<String>> donneesEmployes) {
        
        int[] maxColumnWidths = new int[HEADERS_LIGNE1.size()];
        
        
        for (List<String> employeData : donneesEmployes) {
            for (int i = 0; i < employeData.size() && i < HEADERS_LIGNE1.size(); i++) {
                String value = employeData.get(i);
                if (value != null && !value.isEmpty()) {
                    
                    int contentLength = value.length();
                    maxColumnWidths[i] = Math.max(maxColumnWidths[i], contentLength);
                }
            }
        }
        
        
        for (int i = 0; i < maxColumnWidths.length; i++) {
            
            sheet.autoSizeColumn(i);
            int currentWidth = sheet.getColumnWidth(i);
            int minWidth = 2000; 
            int maxWidth = 10000; 
            int adjustedWidth = Math.min(Math.max(currentWidth, minWidth), maxWidth);
            sheet.setColumnWidth(i, adjustedWidth);
        }
    }
    
    private static void createEmployeeRow(Sheet sheet, int rowNum, List<String> employeData, StylesContainer styles) {
        Row dataRow = sheet.createRow(rowNum);
        
        for (int i = 0; i < employeData.size() && i < HEADERS_LIGNE1.size(); i++) {
            Cell cell = dataRow.createCell(i);
            String value = employeData.get(i);
            
            if (isNumericColumn(i)) {
                cell.setCellValue(value);
                cell.setCellStyle(styles.numberStyle);
            } else {
                cell.setCellValue(value);
                cell.setCellStyle(styles.dataStyle);
            }
        }
    }
    
    private static boolean isNumericColumn(int columnIndex) {
        return (columnIndex >= 7 && columnIndex <= 10) ||  
               (columnIndex >= 11 && columnIndex <= 14) || 
               (columnIndex >= 15 && columnIndex <= 18);   
    }
    
    private static class StylesContainer {
        CellStyle headerStyle;
        CellStyle subHeaderStyle;
        CellStyle dataStyle;
        CellStyle numberStyle;
    }
}