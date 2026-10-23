package rapport.utilitaire;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import java.io.FileOutputStream;
import java.io.IOException;

public class ExcelGeneratorUtil {
    public static void convertHtmlToExcel(String html, String outputFilePath) throws IOException {
        Document doc = Jsoup.parse(html);

        Workbook workbook = new XSSFWorkbook();

        CellStyle headerStyle = workbook.createCellStyle();
        Font headerFont = workbook.createFont();
        CellStyle infoStyle = workbook.createCellStyle();
        headerFont.setBold(true);
        headerStyle.setFont(headerFont);

        Elements sections = doc.select("div.crcontent");

        for (Element section : sections) {
            String sheetName = section.selectFirst("h3") != null ? section.selectFirst("h3").text() : "SansTitre";
            if (sheetName.length() > 31) sheetName = sheetName.substring(0, 31);

            String originalName = sheetName;
            int counter = 1;
            while (workbook.getSheet(sheetName) != null) {
                sheetName = originalName + "_" + counter++;
            }

            Sheet sheet = workbook.createSheet(sheetName);
            int rowIndex = 0;

            Element totalTable = section.selectFirst("table.total-table");
            if (totalTable != null) {
                Elements totalRows = totalTable.select("tr");
                for (Element row : totalRows) {
                    Row excelRow = sheet.createRow(rowIndex++);
                    Elements cols = row.select("td, th");
                    for (int i = 0; i < cols.size(); i++) {
                        Cell cell = excelRow.createCell(i);
                        String value = cols.get(i).text();
                        cell.setCellValue(value);
                        if (row.select("th").size() > 0) cell.setCellStyle(headerStyle);
                    }
                }
                rowIndex++;
            }

            Element mainTable = section.selectFirst("table.crcontentfille");
            if (mainTable != null) {
                Elements rows = mainTable.select("tr");

                if (rows.isEmpty() || mainTable.select("tbody tr").isEmpty()) {
                    Row row = sheet.createRow(rowIndex++);
                    Cell cell = row.createCell(0);
                    cell.setCellValue("Aucune donnée disponible");
                    cell.setCellStyle(infoStyle);
                }else {
                    for (Element row : rows) {
                        Row excelRow = sheet.createRow(rowIndex++);
                        Elements cols = row.select("th, td");

                        for (int i = 0; i < cols.size(); i++) {
                            Cell cell = excelRow.createCell(i);
                            String value = cols.get(i).text();

                            try {
                                double numericValue = Double.parseDouble(value.replace(",", "."));
                                cell.setCellValue(numericValue);
                            } catch (NumberFormatException e) {
                                cell.setCellValue(value);
                            }

                            if (row.select("th").size() > 0) {
                                cell.setCellStyle(headerStyle);
                            }
                        }
                    }

                    if (!rows.isEmpty()) {
                        int colCount = rows.first().select("th, td").size();
                        for (int i = 0; i < colCount; i++) {
                            sheet.autoSizeColumn(i);
                        }
                    }
                }
            }
        }

        try (FileOutputStream out = new FileOutputStream(outputFilePath)) {
            workbook.write(out);
        }

        workbook.close();
        System.out.println("Export HTML ? Excel réussi : " + outputFilePath);
    }
}

//Test
/*String html = "<div class=\"crcontent\">\n" +
        "    <h3>Etat de Caisse</h3>\n" +
        "    <table class=\"crcontentfille\">\n" +
        "        <thead><tr><th>ID</th><th>Nom</th><th>Valeur</th></tr></thead>\n" +
        "        <tbody>\n" +
        "        <tr><td>1</td><td>Caisse BRED MG</td><td>1000</td></tr>\n" +
        "        <tr><td>2</td><td>Caisse MCB</td><td>2000</td></tr>\n" +
        "        </tbody>\n" +
        "    </table>\n" +
        "</div>\n" +
        "\n" +
        "<div class=\"crcontent\">\n" +
        "    <h3>Etat des Banques</h3>\n" +
        "    <table class=\"crcontentfille\">\n" +
        "        <thead><tr><th>ID</th><th>Banque</th><th>Montant</th></tr></thead>\n" +
        "        <tbody>\n" +
        "        <tr><td>1</td><td>BNI</td><td>500000</td></tr>\n" +
        "        <tr><td>2</td><td>SBM</td><td>200000</td></tr>\n" +
        "        </tbody>\n" +
        "    </table>\n" +
        "</div>\n" +
        "\n" +
        "<div class=\"crcontent\">\n" +
        "    <h3>Etat Mvola</h3>\n" +
        "    <table class=\"crcontentfille\">\n" +
        "        <thead><tr><th>ID</th><th>Compte</th><th>Montant</th></tr></thead>\n" +
        "        <tbody>\n" +
        "        <tr><td>1</td><td>Mvola principal</td><td>100000</td></tr>\n" +
        "        </tbody>\n" +
        "    </table>\n" +
        "</div>"+
        "<div class=\"crcontent\">\n" +
        " <h3>Etat de Caisse</h3>\n" +
        "     <table class=\"total-table\" align=\"center\">\n" +
        "  <tr>\n" +
        "        <td><b>Total credit :</b></td>\n" +
        "        <td><b>8224091.0</b></td>\n" +
        "      </tr>\n" +
        "  <tr>\n" +
        "        <td><b>Total debit :</b></td>\n" +
        "        <td><b>1.267316E7</b></td>\n" +
        "      </tr>\n" +
        "    </table><b>Recapitulation: </b>\n" +
        "     <table class=\"crcontentfille\">\n" +
        "         <thead>\n" +
        "            <tr>\n" +
        "                <th>ID</th>\n" +
        "                <th>Reference</th>\n" +
        "                <th>credit</th>\n" +
        "                <th>debit</th>\n" +
        "                <th>reste</th>\n" +
        "            </tr>\n" +
        "         </thead>\n" +
        "         <tbody>\n" +
        "             <tr>\n" +
        "                 <td>(1)</td>\n" +
        "                 <td>Caisse BRED MG</td>\n" +
        "                 <td>3701591.0</td>\n" +
        "                 <td>1.2053E7</td>\n" +
        "                 <td>-3351409.0</td>\n" +
        "             </tr>\n" +
        "             <tr>\n" +
        "                 <td>(2)</td>\n" +
        "                 <td>Mvola </td>\n" +
        "                 <td>14000.0</td>\n" +
        "                 <td>0.0</td>\n" +
        "                 <td>14000.0</td>\n" +
        "             </tr>\n" +
        "             <tr>\n" +
        "                 <td>(3)</td>\n" +
        "                 <td>Caisse SBM MG</td>\n" +
        "                 <td>120003.0</td>\n" +
        "                 <td>0.0</td>\n" +
        "                 <td>5120003.0</td>\n" +
        "             </tr>\n" +
        "             <tr>\n" +
        "                 <td>(4)</td>\n" +
        "                 <td>Cheque</td>\n" +
        "                 <td>6000.0</td>\n" +
        "                 <td>0.0</td>\n" +
        "                 <td>6000.0</td>\n" +
        "             </tr>\n" +
        "             <tr>\n" +
        "                 <td>(5)</td>\n" +
        "                 <td>Caisse Ankorondrano</td>\n" +
        "                 <td>4357495.0</td>\n" +
        "                 <td>620160.0</td>\n" +
        "                 <td>3737335.0</td>\n" +
        "             </tr>\n" +
        "             <tr>\n" +
        "                 <td>(6)</td>\n" +
        "                 <td>Banque BAOBAB MGA</td>\n" +
        "                 <td>25000.0</td>\n" +
        "                 <td>0.0</td>\n" +
        "                 <td>5025000.0</td>\n" +
        "             </tr>\n" +
        "             <tr>\n" +
        "                 <td>(7)</td>\n" +
        "                 <td>Banque BNI MGA</td>\n" +
        "                 <td>2.0</td>\n" +
        "                 <td>0.0</td>\n" +
        "                 <td>5000002.0</td>\n" +
        "             </tr>\n" +
        "             <tr>\n" +
        "                 <td>(8)</td>\n" +
        "                 <td>Caisse JCR</td>\n" +
        "                 <td>0.0</td>\n" +
        "                 <td>0.0</td>\n" +
        "                 <td>0.0</td>\n" +
        "             </tr>\n" +
        "             <tr>\n" +
        "                 <td>(9)</td>\n" +
        "                 <td>Caisse Clinique</td>\n" +
        "                 <td>0.0</td>\n" +
        "                 <td>0.0</td>\n" +
        "                 <td>0.0</td>\n" +
        "             </tr>\n" +
        "             <tr>\n" +
        "                 <td>(10)</td>\n" +
        "                 <td>Caisse  MCB MG</td>\n" +
        "                 <td>0.0</td>\n" +
        "                 <td>0.0</td>\n" +
        "                 <td>5000000.0</td>\n" +
        "             </tr>\n" +
        "             <tr>\n" +
        "                 <td>(11)</td>\n" +
        "                 <td>caisse BMOI MG</td>\n" +
        "                 <td>0.0</td>\n" +
        "                 <td>0.0</td>\n" +
        "                 <td>0.0</td>\n" +
        "             </tr>\n" +
        "             <tr>\n" +
        "                 <td>(12)</td>\n" +
        "                 <td>Cyrpto</td>\n" +
        "                 <td>0.0</td>\n" +
        "                 <td>0.0</td>\n" +
        "                 <td>0.0</td>\n" +
        "             </tr>\n" +
        "         </tbody>\n" +
        "     </table><br></br><br></br>\n" +
        "    <p>L'?tat de caisse montre des soldes vari?s pour diff?rentes caisses et banques. La <strong>Caisse BRED MG</strong> pr?sente un solde n?gatif (-3,351,409.0), ce qui indique une situation d?favorable avec des d?bits sup?rieurs aux cr?dits. ? l'inverse, des caisses comme <strong>Mvola</strong>, <strong>Caisse SBM MG</strong>, et <strong>Cheque</strong> ont des soldes positifs, indiquant une bonne liquidit?. Certaines caisses comme <strong>Caisse JCR</strong>, <strong>Caisse Clinique</strong>, et <strong>Crypto</strong> n'ont enregistr? aucune activit? (cr?dit et d?bit ? 0).</p>\n" +
        "   <p>Pour am?liorer l'?tat de caisse, il serait judicieux de :</p><ul><li>Analyser les raisons du solde n?gatif de la <strong>Caisse BRED MG</strong> et prendre des mesures correctives (ex : r?duire les d?bits ou augmenter les cr?dits).</li><li>Mettre en place un suivi r?gulier des caisses inactives (<strong style=\"color: red;\">Caisse JCR</strong>, <strong>Caisse Clinique</strong>, etc.) pour optimiser leur utilisation.</li><li>Automatiser le rapprochement bancaire pour d?tecter plus rapidement les d?s?quilibres.</li><li>Consolider les donn?es dans un tableau de bord visuel pour une meilleure lisibilit?.</li></ul>\n" +
        "   <p>L'?tat de caisse actuel r?v?le des disparit?s entre les diff?rentes caisses, avec certaines en exc?dent et d'autres en d?ficit. Une gestion proactive et des outils de suivi am?lior?s permettraient d'?quilibrer les flux et d'optimiser la tr?sorerie globale.</p>\n" +
        " </div>";
            ExcelGeneratorUtil.convertHtmlToExcel(html, ConstanteCR.BASE_DIR+"/"+ConstanteCR.PROJECT_NAME+"/rapport.xlsx");*/
