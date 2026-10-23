package servlet;

import bean.CGenUtil;
import bean.TypeObjet;
import produits.ImportPrix;
import produits.ImportPrixDetails;
import produits.Ingredients;
import user.UserEJB;
import utilitaire.UtilDB;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.sql.Connection;
import java.sql.Date;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.DateUtil;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;

@WebServlet(name = "ImportPrixDetailsServlet", urlPatterns = {"/ImportPrixDetailsServlet"})
@MultipartConfig
public class ImportPrixDetailsServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        UserEJB uBean = (UserEJB) session.getAttribute("u");
        if (uBean == null || uBean.getUser() == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Session utilisateur manquante");
            return;
        }

        // Récupérer les paramètres du formulaire pour ImportPrix
        String daty = request.getParameter("daty");
        String desce = request.getParameter("desce");
        if (daty == null || daty.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Date obligatoire");
            return;
        }

        Part filePart = request.getPart("excelFile");
        if (filePart == null || filePart.getSize() == 0) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Aucun fichier fourni");
            return;
        }

        int imported = 0;
        List<String> errors = new ArrayList<>();
        Connection c = null;
        StringBuilder debugLog = new StringBuilder();

        Workbook workbook;
        try {
            InputStream is = filePart.getInputStream();
            workbook = WorkbookFactory.create(is);
            c = new UtilDB().GetConn();
            c.setAutoCommit(false);

            Sheet sheet = workbook.getSheetAt(0);
            int headerRowIndex = findHeaderRow(sheet);
            if (headerRowIndex < 0) {
                errors.add("En-tête introuvable dans le fichier XLS/XLSX");
            }

            if (errors.isEmpty()) {
                Row headerRow = sheet.getRow(headerRowIndex);
                Map<String, Integer> headerIndex = buildHeaderIndex(headerRow);
                debugLog.append("En-tête trouvé ligne ").append(headerRowIndex).append("\n");
                debugLog.append("Colonnes trouvées: ").append(headerIndex.keySet()).append("\n");

                // Créer le parent ImportPrix
                ImportPrix importPrix = new ImportPrix();
                importPrix.setDaty(parseDate(daty));
                importPrix.setDesce(desce);
                importPrix.construirePK(c);
                debugLog.append("ImportPrix ID créé: ").append(importPrix.getId()).append("\n");

                // Valider toutes les lignes d'abord
                List<ImportPrixDetails> validRows = new ArrayList<>();

                for (int i = headerRowIndex + 1; i <= sheet.getLastRowNum(); i++) {
                    Row row = sheet.getRow(i);
                    if (row == null) continue;

                    List<String> lineErrors = new ArrayList<>();
                    try {
                        ImportPrixDetails detail = mapRow(headerIndex, row);

                        // Validation : vérifier que les champs obligatoires sont remplis
                        String rawIdIng = detail.getIdIngredient();
                        debugLog.append("Ligne ").append(i + 1).append(": rawIdIng='").append(rawIdIng).append("'\n");

                        if (rawIdIng == null || rawIdIng.trim().isEmpty()) {
                            lineErrors.add("Ligne " + (i + 1) + ": idIngredient manquant");
                        } else {
                            // Vérifier que l'ingrédient existe
                            try {
                                Ingredients ing = getIngredients(c, rawIdIng);
                                if (ing == null) {
                                    lineErrors.add("Ligne " + (i + 1) + ": Ingr&eacute;dient '" + rawIdIng + "' introuvable");
                                    debugLog.append("  Ingr&eacute;dient NOT FOUND: ").append(rawIdIng).append("\n");
                                } else {
                                    debugLog.append("  Ingr&eacute;dient trouv&eacute;: ").append(ing.getId()).append("\n");
                                }
                            } catch (Exception e) {
                                lineErrors.add("Ligne " + (i + 1) + ": Erreur lors de la v&eacute;rification d'ingr&eacute;dient - " + e.getMessage());
                                debugLog.append("  Exception: ").append(e.toString()).append("\n");
                            }
                        }

                        String rawIdTypeClient = detail.getIdTypeClient();
                        debugLog.append("Ligne ").append(i + 1).append(": rawIdTypeClient='").append(rawIdTypeClient).append("'\n");

                        if (rawIdTypeClient == null || rawIdTypeClient.trim().isEmpty()) {
                            lineErrors.add("Ligne " + (i + 1) + ": idTypeClient manquant");
                        } else {
                            // Vérifier que le type client existe
                            try {
                                TypeObjet typeClient = getIdTypeClient(c, rawIdTypeClient);
                                if (typeClient == null) {
                                    lineErrors.add("Ligne " + (i + 1) + ": Type Client '" + rawIdTypeClient + "' introuvable");
                                    debugLog.append("  TypeClient NOT FOUND: ").append(rawIdTypeClient).append("\n");
                                } else {
                                    debugLog.append("  TypeClient trouv&eacute;: ").append(typeClient.getId()).append("\n");
                                }
                            } catch (Exception e) {
                                lineErrors.add("Ligne " + (i + 1) + ": Erreur lors de la vérification de Type Client - " + e.getMessage());
                                debugLog.append("  Exception: ").append(e).append("\n");
                            }
                        }

                        if (detail.getDaty() == null) {
                            lineErrors.add("Ligne " + (i + 1) + ": Date manquante");
                        }

                        if (detail.getPrixUnitaire() <= 0) {
                            lineErrors.add("Ligne " + (i + 1) + ": Prix unitaire invalide ou manquant");
                        }

                        if (!lineErrors.isEmpty()) {
                            errors.addAll(lineErrors);
                        } else {
                            validRows.add(detail);
                        }
                    } catch (Exception e) {
                        lineErrors.add("Ligne " + (i + 1) + ": Exception lors du parsing - " + e.getMessage());
                        errors.addAll(lineErrors);
                    }
                }

                if (errors.isEmpty() && !validRows.isEmpty()) {
                    try {
                        // Créer le parent ImportPrix une seule fois
                        ImportPrix importPrix2 = (ImportPrix) importPrix.createObject(uBean.getUser().getRefuser()+"", c);
                        debugLog.append("ImportPrix créé avec succès, ID: ").append(importPrix2.getId()).append("\n");

                        for (ImportPrixDetails detail : validRows) {
                            detail.setIdmere(importPrix2.getId());
                            detail.setUnite(getIngredients(c,detail.getIdIngredient()).getUnite());
                            detail.construirePK(c);
                            debugLog.append("Ligne: idIng=").append(detail.getIdIngredient())
                                    .append(", idTypeClient=").append(detail.getIdTypeClient())
                                    .append(", prix=").append(detail.getPrixUnitaire())
                                    .append(", ID généré=").append(detail.getId()).append("\n");

                            detail.createObject(uBean.getUser().getRefuser()+"", c);
                            imported++;
                        }

                        c.commit();
                        debugLog.append("Commit réussi\n");
                    } catch (Exception e) {
                        try {
                            c.rollback();
                        } catch (Exception ignoreRollback) { }
                        errors.add("Erreur lors de l'insertion: " + e.getMessage());
                        StringWriter sw = new StringWriter();
                        e.printStackTrace(new PrintWriter(sw));
                        debugLog.append("ERREUR: ").append(sw).append("\n");
                    }
                }
            }

        } catch (Exception e) {
            System.err.println("DEBUG LOG:\n" + debugLog);
            errors.add("Erreur fatale lors du traitement du fichier: " + e.getMessage());
        } finally {
            if (c != null) {
                try { c.close(); } catch (Exception ignore) { }
            }
        }

        System.out.println("DEBUG LOG:\n" + debugLog);
        System.out.println("Import terminé: " + imported + " insérées, " + errors.size() + " erreurs");

        // Redirection avec gestion des erreurs
        if (!errors.isEmpty()) {
            // Stocker les erreurs en session et rediriger vers l'import
            session.setAttribute("importErrors", errors);
            session.setAttribute("importDaty", daty);
            session.setAttribute("importDesce", desce);
            String but = request.getContextPath() + "/pages/module.jsp?but=produits/tarifIngredients/tarifIngredients-import.jsp";
            response.sendRedirect(but);
        } else {
            // Succès: rediriger vers la page de gestion des tarifs ingrédients
            String but = request.getContextPath() + "/pages/module.jsp?but=cantine/pointage-cantine.jsp";
            response.sendRedirect(but);
        }
    }

    private ImportPrixDetails mapRow(Map<String, Integer> idx, Row row) throws Exception {
        ImportPrixDetails detail = new ImportPrixDetails();

        String idIngredient = string(idx, row, "idingredient");
        String idTypeClient = string(idx, row, "idtypeclient");
        Date daty = date(idx, row, "date");
        double prixUnitaire = number(idx, row, "prixunitaire");

        // Trim et nettoyer les espaces
        if (idIngredient != null) {
            idIngredient = idIngredient.trim();
        }
        if (idTypeClient != null) {
            idTypeClient = idTypeClient.trim();
        }

        detail.setIdIngredient(idIngredient);
        detail.setIdTypeClient(idTypeClient);
        detail.setDaty(daty);
        detail.setPrixUnitaire(prixUnitaire);

        return detail;
    }

    private Map<String, Integer> buildHeaderIndex(Row headerRow) {
        Map<String, Integer> map = new HashMap<>();
        for (int i = 0; i < headerRow.getLastCellNum(); i++) {
            Cell c = headerRow.getCell(i);
            String raw = cellToString(c);
            String key = normalize(raw);
            if (!map.containsKey(key)) map.put(key, i);
        }
        return map;
    }

    private int findHeaderRow(Sheet sheet) {
        for (int i = 0; i <= sheet.getLastRowNum() && i < 10; i++) {
            Row r = sheet.getRow(i);
            if (r == null) continue;
            for (int j = 0; j < r.getLastCellNum(); j++) {
                Cell c = r.getCell(j);
                String v = cellToString(c);
                if (v != null && (normalize(v).contains("idingredient") || normalize(v).contains("ingredient"))) {
                    return i;
                }
            }
        }
        return -1;
    }

    private String normalize(String value) {
        if (value == null) return "";
        String cleaned = value.replace("\uFEFF", "").trim().toLowerCase();
        return cleaned.replaceAll("[^a-z0-9]", "");
    }

    private String cellToString(Cell c) {
        if (c == null) return null;
        switch (c.getCellType()) {
            case Cell.CELL_TYPE_STRING:
                return c.getStringCellValue().trim();
            case Cell.CELL_TYPE_NUMERIC:
                if (DateUtil.isCellDateFormatted(c)) {
                    java.util.Date d = c.getDateCellValue();
                    if (d == null) return null;
                    return new SimpleDateFormat("yyyy-MM-dd").format(d);
                }
                double n = c.getNumericCellValue();
                if (n == (long) n) return String.valueOf((long) n);
                return String.valueOf(n);
            case Cell.CELL_TYPE_BOOLEAN:
                return String.valueOf(c.getBooleanCellValue());
            case Cell.CELL_TYPE_FORMULA:
                try { return c.getStringCellValue().trim(); }
                catch (Exception e) {
                    try {
                        double n2 = c.getNumericCellValue();
                        if (DateUtil.isCellDateFormatted(c)) {
                            java.util.Date d2 = DateUtil.getJavaDate(n2);
                            return new SimpleDateFormat("yyyy-MM-dd").format(d2);
                        }
                        if (n2 == (long) n2) return String.valueOf((long) n2);
                        return String.valueOf(n2);
                    } catch (Exception ignored) { return null; }
                }
            default:
                return null;
        }
    }

    private String string(Map<String, Integer> idx, Row row, String key) {
        Integer position = idx.get(normalize(key));
        if (position == null) return null;
        Cell c = row.getCell(position);
        if (c == null) return null;

        String v = cellToString(c);
        if (v == null) return null;
        v = v.trim();
        return v.isEmpty() ? null : v;
    }

    private double number(Map<String, Integer> idx, Row row, String key) {
        Integer position = idx.get(normalize(key));
        if (position == null) return 0d;
        Cell c = row.getCell(position);
        if (c == null) return 0d;

        try {
            if (c.getCellType() == Cell.CELL_TYPE_NUMERIC && !DateUtil.isCellDateFormatted(c)) {
                return c.getNumericCellValue();
            }
            String raw = cellToString(c);
            if (raw == null) return 0d;
            String cleaned = raw.trim().replace(" ", "").replace("\u00A0", "").replace(',', '.');
            if (cleaned.isEmpty()) return 0d;
            return Double.parseDouble(cleaned);
        } catch (Exception e) {
            return 0d;
        }
    }

    private Date date(Map<String, Integer> idx, Row row, String key) {
        Integer position = idx.get(normalize(key));
        if (position == null) return null;
        Cell c = row.getCell(position);
        if (c == null) return null;

        try {
            if (c.getCellType() == Cell.CELL_TYPE_NUMERIC && DateUtil.isCellDateFormatted(c)) {
                java.util.Date d = c.getDateCellValue();
                if (d == null) return null;
                java.util.Calendar cal = java.util.Calendar.getInstance();
                cal.setTime(d);
                cal.set(java.util.Calendar.HOUR_OF_DAY, 0);
                cal.set(java.util.Calendar.MINUTE, 0);
                cal.set(java.util.Calendar.SECOND, 0);
                cal.set(java.util.Calendar.MILLISECOND, 0);
                return new Date(cal.getTimeInMillis());
            }
            String raw = cellToString(c);
            if (raw == null) return null;

            String[] formats = {
                    "yyyy-MM-dd HH:mm:ss", "dd/MM/yyyy HH:mm:ss", "d/M/yyyy HH:mm:ss",
                    "MM/dd/yyyy HH:mm:ss", "M/d/yyyy HH:mm:ss",
                    "yyyy-MM-dd", "dd-MM-yyyy", "d-M-yyyy", "M-d-yyyy",
                    "dd/MM/yyyy", "d/M/yyyy", "M/d/yyyy",
                    "MM/dd/yyyy", "yyyy/MM/dd", "yyyy/dd/MM"
            };
            for (String f : formats) {
                try {
                    java.util.Date parsed = new SimpleDateFormat(f).parse(raw);
                    java.util.Calendar cal = java.util.Calendar.getInstance();
                    cal.setTime(parsed);
                    cal.set(java.util.Calendar.HOUR_OF_DAY, 0);
                    cal.set(java.util.Calendar.MINUTE, 0);
                    cal.set(java.util.Calendar.SECOND, 0);
                    cal.set(java.util.Calendar.MILLISECOND, 0);
                    return new Date(cal.getTimeInMillis());
                } catch (ParseException ignored) { }
            }
            try {
                double serial = Double.parseDouble(raw.replace(",", "."));
                if (serial > 10000 && serial < 70000) {
                    java.util.Date fromSerial = DateUtil.getJavaDate(serial);
                    if (fromSerial == null) return null;
                    java.util.Calendar cal = java.util.Calendar.getInstance();
                    cal.setTime(fromSerial);
                    cal.set(java.util.Calendar.HOUR_OF_DAY, 0);
                    cal.set(java.util.Calendar.MINUTE, 0);
                    cal.set(java.util.Calendar.SECOND, 0);
                    cal.set(java.util.Calendar.MILLISECOND, 0);
                    return new Date(cal.getTimeInMillis());
                }
            } catch (NumberFormatException ignored) { }
        } catch (Exception ignored) {
        }
        return null;
    }

    private Date parseDate(String dateStr) {
        if (dateStr == null || dateStr.isEmpty()) return null;
        try {
            String[] formats = {"yyyy-MM-dd", "dd/MM/yyyy", "d/M/yyyy", "MM/dd/yyyy"};
            for (String f : formats) {
                try {
                    java.util.Date parsed = new SimpleDateFormat(f).parse(dateStr);
                    return new Date(parsed.getTime());
                } catch (ParseException ignored) { }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    private Ingredients getIngredients(Connection con, String idIng) throws Exception {
        Ingredients i = null;
        Ingredients[] list = (Ingredients[]) CGenUtil.rechercher(new Ingredients(), null, null, con, " and id = '" + idIng + "'");
        if (list.length > 0) {
            i = list[0];
        }
        return i;
    }

    private TypeObjet getIdTypeClient(Connection con, String idTypeClient) throws Exception {
        TypeObjet i = null;
        TypeObjet temp = new TypeObjet("TYPECLIENT");
        TypeObjet[] list = (TypeObjet[]) CGenUtil.rechercher(temp, null, null, con, " and id = '" + idTypeClient + "'");
        if (list.length > 0) {
            i = list[0];
        }
        return i;
    }
}

