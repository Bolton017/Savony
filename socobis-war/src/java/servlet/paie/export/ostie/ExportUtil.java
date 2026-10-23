package servlet.paie.export.ostie;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import paie.ostie.OstieAffiche;

public class ExportUtil {
    
    private static final SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("dd/MM/yyyy");
    
    
    private static final String[] HEADERS = {
        "N", "MATRICULE", "NOM DU TRAVAILLEUR", "PRENOMS DU TRAVAILLEUR", "SEXE", 
        "DATE DE NAISSANCE", "DATE D'EMBAUCHE", "DATE DE DEBAUCHE", "FONCTION", 
        "N CNAPS", "N CIN", "SALAIRE 1er MOIS", "SALAIRE 2eme MOIS", 
        "SALAIRE 3eme MOIS", "TOTAUX SALAIRES NON PLAFONNES", "TOTAUX SALAIRES PLAFONNES",
        "COTISATION PATRONALE 5%", "COTISATION SALARIALE 1%"
    };
    
    
    private static final String[] LEFT_INFO = {
        "Adresse: Rue Dr Zamenhof Behoririka 101 ANTANANARIVO",
        "Contact: Tel.: 22 265 78 / 22 274 76 / 22 251 42  FAX : 22 265 66",
        "BP: 165 Antananarivo",
        "Contact: e-mail: sadhostie@moov.mg         site web: www.ostie.mg",
        "Compte: BOA Andravoahangy   00009 05600 10762050010 23",
        "Compte: BNI-CL Analakely  00005 00001 01232020200 71",
        "Compte: BFV-SG  Antaninarenina  00008 00005 21000155438 43",
        "Compte: BMOI Analamahitsy 00004 00003 01500800184 32",
        "Compte: ACCES BANQUE Antaninandro  00011 00003 24100035111 77",
        "Mobile Money: ORANGE MONEY  032 24 704 67  - MVOLA 034 31 564 90"
    };
    
    private static final String[] CENTER_INFO = {
        null, 
        "CODE ADHERENT: 012529   FOLIO: 1",
        "Raison Sociale: XPERIENCE-C SARL",
        "Adresse: Zone Thuya Maximus 1 Andohatapenaka",
        "Tel: 0344227610   eMail: srajaobelison@xc-factory.com",
        "STAT: 74909 11 2007 011030   NIF: 2000030340",
        "ACTIVITE: Audit qualite, marketing digital   REGIME: GENERAL",
        "Taux Employeur: 5%   Travailleur: 1%",
        "N° Cnaps Employeur: 980068",
        null 
    };
    
    
    public static Workbook createOstieWorkbook(List<OstieAffiche> employes) {
        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("OSTIE - Donnees Paie");
        
        
        StylesContainer styles = createStyles(workbook);
        
        int currentRow = 0;
        
        
        createInfoSection(sheet, currentRow, styles, workbook);
        currentRow += 12;
        
        
        createHeaderRow(sheet, currentRow++, styles.headerStyle);
        
        
        adjustColumnWidths(sheet);
        
        
        for (int i = 0; i < employes.size(); i++) {
            createEmployeeRow(sheet, currentRow++, employes.get(i), styles);
        }
        
        
        createTotalRow(sheet, currentRow, employes, styles);
        
        return workbook;
    }
    
    
    public static List<OstieAffiche> getDonneesStatiques() {
        List<OstieAffiche> employes = new ArrayList<>();
        
        
        OstieAffiche emp1 = new OstieAffiche();
        emp1.setNumero(1);
        emp1.setMatricule("01-XC");
        emp1.setNom("RABEMANATSOA");
        emp1.setPrenoms("Louis");
        emp1.setSexe("M");
        emp1.setDate_naissance(Date.valueOf("1965-08-08"));
        emp1.setDateembauche(Date.valueOf("2018-04-27"));
        emp1.setDate_depart(null);
        emp1.setFonction("Chauffeur");
        emp1.setCnaps("650810100270");
        emp1.setCin("301 991 069 930");
        emp1.setMois1(450000);
        emp1.setMois2(450000);
        emp1.setMois3(450000);
        emp1.setSalaires_non_plafonnes(1350000);
        emp1.setSalaires_plafonnes(1350000);
        emp1.setEmployeur(1350000 * 0.05);
        emp1.setTravailleur(1350000 * 0.01);
        employes.add(emp1);
        
        
        OstieAffiche emp2 = new OstieAffiche();
        emp2.setNumero(2);
        emp2.setMatricule("02-XC");
        emp2.setNom("RANDRIAMAMPIONONA");
        emp2.setPrenoms("Marie");
        emp2.setSexe("F");
        emp2.setDate_naissance(Date.valueOf("1980-03-15"));
        emp2.setDateembauche(Date.valueOf("2019-06-01"));
        emp2.setDate_depart(null);
        emp2.setFonction("Secretaire");
        emp2.setCnaps("650820200350");
        emp2.setCin("302 123 456 789");
        emp2.setMois1(380000);
        emp2.setMois2(380000);
        emp2.setMois3(380000);
        emp2.setSalaires_non_plafonnes(1140000);
        emp2.setSalaires_plafonnes(1140000);
        emp2.setEmployeur(1140000 * 0.05);
        emp2.setTravailleur(1140000 * 0.01);
        employes.add(emp2);
        
        
        OstieAffiche emp3 = new OstieAffiche();
        emp3.setNumero(3);
        emp3.setMatricule("03-XC");
        emp3.setNom("RAKOTOMALALA");
        emp3.setPrenoms("Jean");
        emp3.setSexe("M");
        emp3.setDate_naissance(Date.valueOf("1975-11-22"));
        emp3.setDateembauche(Date.valueOf("2020-01-10"));
        emp3.setDate_depart(null);
        emp3.setFonction("Comptable");
        emp3.setCnaps("650830300450");
        emp3.setCin("303 987 654 321");
        emp3.setMois1(520000);
        emp3.setMois2(520000);
        emp3.setMois3(520000);
        emp3.setSalaires_non_plafonnes(1560000);
        emp3.setSalaires_plafonnes(1560000);
        emp3.setEmployeur(1560000 * 0.05);
        emp3.setTravailleur(1560000 * 0.01);
        employes.add(emp3);
        
        return employes;
    }
    
    
    
    private static StylesContainer createStyles(Workbook workbook) {
        StylesContainer styles = new StylesContainer();
        
        
        styles.headerStyle = workbook.createCellStyle();
        styles.headerStyle.setFillForegroundColor(IndexedColors.LIGHT_GREEN.getIndex());
        styles.headerStyle.setFillPattern(CellStyle.SOLID_FOREGROUND);
        styles.headerStyle.setBorderBottom(CellStyle.BORDER_THIN);
        styles.headerStyle.setBorderTop(CellStyle.BORDER_THIN);
        styles.headerStyle.setBorderRight(CellStyle.BORDER_THIN);
        styles.headerStyle.setBorderLeft(CellStyle.BORDER_THIN);
        styles.headerStyle.setAlignment(CellStyle.ALIGN_CENTER);
        styles.headerStyle.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        
        Font headerFont = workbook.createFont();
        headerFont.setBoldweight(Font.BOLDWEIGHT_BOLD);
        headerFont.setFontHeightInPoints((short) 10);
        styles.headerStyle.setFont(headerFont);
        
        
        styles.infoStyle = workbook.createCellStyle();
        
        
        styles.dataStyle = workbook.createCellStyle();
        styles.dataStyle.setBorderBottom(CellStyle.BORDER_THIN);
        styles.dataStyle.setBorderTop(CellStyle.BORDER_THIN);
        styles.dataStyle.setBorderRight(CellStyle.BORDER_THIN);
        styles.dataStyle.setBorderLeft(CellStyle.BORDER_THIN);
        styles.dataStyle.setAlignment(CellStyle.ALIGN_CENTER);
        
        
        styles.numberStyle = workbook.createCellStyle();
        styles.numberStyle.setBorderBottom(CellStyle.BORDER_THIN);
        styles.numberStyle.setBorderTop(CellStyle.BORDER_THIN);
        styles.numberStyle.setBorderRight(CellStyle.BORDER_THIN);
        styles.numberStyle.setBorderLeft(CellStyle.BORDER_THIN);
        styles.numberStyle.setAlignment(CellStyle.ALIGN_RIGHT);
        DataFormat format = workbook.createDataFormat();
        styles.numberStyle.setDataFormat(format.getFormat("#,##0"));
        
        
        styles.boldDataStyle = workbook.createCellStyle();
        styles.boldDataStyle.cloneStyleFrom(styles.dataStyle);
        Font boldFont = workbook.createFont();
        boldFont.setBoldweight(Font.BOLDWEIGHT_BOLD);
        styles.boldDataStyle.setFont(boldFont);
        
        
        styles.boldNumberStyle = workbook.createCellStyle();
        styles.boldNumberStyle.cloneStyleFrom(styles.numberStyle);
        styles.boldNumberStyle.setFont(boldFont);
        
        return styles;
    }
    
    private static void createInfoSection(Sheet sheet, int startRow, StylesContainer styles, Workbook workbook) {
        CellStyle headerInfoStyle = workbook.createCellStyle();
        headerInfoStyle.cloneStyleFrom(styles.infoStyle);
        headerInfoStyle.setFillForegroundColor(IndexedColors.LIGHT_YELLOW.getIndex());
    
        CellStyle centerInfoStyle = workbook.createCellStyle();
        centerInfoStyle.cloneStyleFrom(styles.infoStyle);
        centerInfoStyle.setFillForegroundColor(IndexedColors.WHITE.getIndex());
        centerInfoStyle.setAlignment(CellStyle.ALIGN_CENTER);
    
        for (int i = 0; i < LEFT_INFO.length; i++) {
            Row row = sheet.createRow(startRow + i);
    
            if (LEFT_INFO[i] != null) {
                Cell leftCell = row.createCell(0);
                leftCell.setCellValue(LEFT_INFO[i]);
                leftCell.setCellStyle(headerInfoStyle);
            }
    
            if (CENTER_INFO[i] != null) {
                sheet.addMergedRegion(new CellRangeAddress(startRow + i, startRow + i, 5, 12));
                Cell centerCell = row.createCell(5);
                centerCell.setCellValue(CENTER_INFO[i]);
                centerCell.setCellStyle(centerInfoStyle);
            }
        }
    }
    
    private static void createHeaderRow(Sheet sheet, int rowNum, CellStyle headerStyle) {
        Row headerRow = sheet.createRow(rowNum);
        
        for (int i = 0; i < HEADERS.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(HEADERS[i]);
            cell.setCellStyle(headerStyle);
        }
    }
    
    private static void adjustColumnWidths(Sheet sheet) {
        for (int i = 0; i < HEADERS.length; i++) {
            sheet.setColumnWidth(i, (HEADERS[i].length() + 5) * 256);
        }
    }
    
    private static void createEmployeeRow(Sheet sheet, int rowNum, OstieAffiche emp, StylesContainer styles) {
        Row dataRow = sheet.createRow(rowNum);
        
        createCell(dataRow, 0, String.valueOf(emp.getNumero()), styles.dataStyle);
        createCell(dataRow, 1, emp.getMatricule(), styles.dataStyle);
        createCell(dataRow, 2, emp.getNom(), styles.dataStyle);
        createCell(dataRow, 3, emp.getPrenoms(), styles.dataStyle);
        createCell(dataRow, 4, emp.getSexe(), styles.dataStyle);
        createCell(dataRow, 5, formatDate(emp.getDate_naissance()), styles.dataStyle);
        createCell(dataRow, 6, formatDate(emp.getDateembauche()), styles.dataStyle);
        createCell(dataRow, 7, formatDate(emp.getDate_depart()), styles.dataStyle);
        createCell(dataRow, 8, emp.getFonction(), styles.dataStyle);
        createCell(dataRow, 9, emp.getCnaps(), styles.dataStyle);
        createCell(dataRow, 10, emp.getCin(), styles.dataStyle);
        createCellNumber(dataRow, 11, emp.getMois1(), styles.numberStyle);
        createCellNumber(dataRow, 12, emp.getMois2(), styles.numberStyle);
        createCellNumber(dataRow, 13, emp.getMois3(), styles.numberStyle);
        createCellNumber(dataRow, 14, emp.getSalaires_non_plafonnes(), styles.numberStyle);
        createCellNumber(dataRow, 15, emp.getSalaires_plafonnes(), styles.numberStyle);
        createCellNumber(dataRow, 16, emp.getEmployeur(), styles.numberStyle);
        createCellNumber(dataRow, 17, emp.getTravailleur(), styles.numberStyle);
    }
    
    private static void createTotalRow(Sheet sheet, int rowNum, List<OstieAffiche> employes, StylesContainer styles) {
        Row totalRow = sheet.createRow(rowNum);
        
        
        for (int i = 0; i < 9; i++) {
            createCell(totalRow, i, "", styles.dataStyle);
        }
        
        
        createCell(totalRow, 9, "TOTAUX", styles.boldDataStyle);
        sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 9, 10));
        
        
        createCellNumber(totalRow, 11, employes.stream().mapToDouble(OstieAffiche::getMois1).sum(), styles.boldNumberStyle);
        createCellNumber(totalRow, 12, employes.stream().mapToDouble(OstieAffiche::getMois2).sum(), styles.boldNumberStyle);
        createCellNumber(totalRow, 13, employes.stream().mapToDouble(OstieAffiche::getMois3).sum(), styles.boldNumberStyle);
        createCellNumber(totalRow, 14, employes.stream().mapToDouble(OstieAffiche::getSalaires_non_plafonnes).sum(), styles.boldNumberStyle);
        createCellNumber(totalRow, 15, employes.stream().mapToDouble(OstieAffiche::getSalaires_plafonnes).sum(), styles.boldNumberStyle);
        createCellNumber(totalRow, 16, employes.stream().mapToDouble(OstieAffiche::getEmployeur).sum(), styles.boldNumberStyle);
        createCellNumber(totalRow, 17, employes.stream().mapToDouble(OstieAffiche::getTravailleur).sum(), styles.boldNumberStyle);
    }
    
    private static void createCell(Row row, int column, String value, CellStyle style) {
        Cell cell = row.createCell(column);
        cell.setCellValue(value);
        cell.setCellStyle(style);
    }
    
    private static void createCellNumber(Row row, int column, double value, CellStyle style) {
        Cell cell = row.createCell(column);
        cell.setCellValue(value);
        cell.setCellStyle(style);
    }
    
    private static String formatDate(Date date) {
        if (date == null) return "";
        return DATE_FORMAT.format(date);
    }
    
    
    private static class StylesContainer {
        CellStyle headerStyle;
        CellStyle infoStyle;
        CellStyle dataStyle;
        CellStyle numberStyle;
        CellStyle boldDataStyle;
        CellStyle boldNumberStyle;
    }
}