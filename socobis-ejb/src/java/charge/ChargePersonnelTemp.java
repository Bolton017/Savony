package charge;

import annexe.Poste;
import bean.CGenUtil;
import bean.ClassMAPTable;
import fabrication.HeureSupFabrication;
import fabrication.RessourceParFabrication;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import paie.employe.PaieInfoPersonnel;
import rh.QualificationPaie;
import utilitaire.UtilDB;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.Map;

public class ChargePersonnelTemp extends ClassMAPTable {
    private String id;
    private String idPersonnel;
    private String idPoste;
    private String idClasse;
    private String idFab;
    private double heureNormal;
    private double hs;
    private double ferie;
    private double dim;
    private double nuit;
    private double iff;
    private double taux;
    private Sheet sheet;
    private String matriculeCol;
    private Map<String, Integer> colIndex;
    private int headerRow;

    public ChargePersonnelTemp() {
        this.setNomTable("CHARGEPERSONNELTEMP");
    }

    public Sheet getSheet() { return sheet; }
    public void setSheet(Sheet sheet) { this.sheet = sheet; }
    public String getMatriculeCol() { return matriculeCol; }
    public void setMatriculeCol(String matriculeCol) { this.matriculeCol = matriculeCol; }
    public Map<String, Integer> getColIndex() { return colIndex; }
    public void setColIndex(Map<String, Integer> colIndex) { this.colIndex = colIndex; }
    public int getHeaderRow() { return headerRow; }
    public void setHeaderRow(int headerRow) { this.headerRow = headerRow; }

    public double getHeureNormal() { return heureNormal; }
    public void setHeureNormal(double heureNormal) { this.heureNormal = heureNormal; }
    public double getHs() { return hs; }
    public void setHs(double hs) { this.hs = hs; }
    public double getFerie() { return ferie; }
    public void setFerie(double ferie) { this.ferie = ferie; }
    public double getDim() { return dim; }
    public void setDim(double dim) { this.dim = dim; }
    public double getNuit() { return nuit; }
    public void setNuit(double nuit) { this.nuit = nuit; }
    public double getIff() { return iff; }
    public void setIff(double iff) { this.iff = iff; }
    public double getTaux() { return taux; }
    public void setTaux(double taux) { this.taux = taux; }
    public String getIdPersonnel() { return idPersonnel; }
    public void setIdPersonnel(String idPersonnel) { this.idPersonnel = idPersonnel; }
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public String getIdPoste() { return idPoste; }
    public void setIdPoste(String idPoste) { this.idPoste = idPoste; }
    public String getIdClasse() { return idClasse; }
    public void setIdClasse(String idClasse) { this.idClasse = idClasse; }
    public String getIdFab() { return idFab; }
    public void setIdFab(String idFab) { this.idFab = idFab; }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("CH-", "getseq_chargepersonneltemp");
        this.setId(makePK(c));
    }

    @Override
    public String getTuppleID() { return id; }
    @Override
    public String getAttributIDName() { return "id"; }

    public void createRessourceParFab(String u, Connection c) throws SQLException {
        boolean canClose = false;
        try {
            if (c == null){
                c = new UtilDB().GetConn();
                canClose = true;
            }
            RessourceParFabrication ressource = new RessourceParFabrication();
            ressource.setIdRessource(this.getIdPersonnel());
            ressource.setIdFabrication(this.getIdFab());
            RessourceParFabrication[] rs = (RessourceParFabrication[])CGenUtil.rechercher(ressource,null,null,c,"");

            String idRessourceParFab;

            if (rs.length > 0){
                System.out.println("DEBUG: Resource already exists for " + this.getIdPersonnel());
                idRessourceParFab = rs[0].getId();
            } else {
                ressource.setIdPoste(this.getIdPoste());
                ressource.setIdQualification(this.getIdClasse());
                ressource.createObject(u,c);
                idRessourceParFab = ressource.getId();
            }

            // Create Heure Sup
            HeureSupFabrication heureSup = new HeureSupFabrication();
            heureSup.setIdRessParFab(idRessourceParFab);
            heureSup.setHS(this.getHs());
            heureSup.setMN(this.getNuit());
            heureSup.setHD(this.getDim());
            heureSup.setJF(this.getFerie());
            heureSup.setTemporaire(0);
            heureSup.setIdFabrication(this.getIdFab());
            heureSup.setIF(this.getIff());
            heureSup.setMontant(0);

            // Assuming setter exists on HeureSupFabrication
            heureSup.setHeurenormale(this.getHeureNormal());

            System.out.println("DEBUG: Creating HeureSup - HN: " + this.getHeureNormal() + ", HS: " + this.getHs());
            heureSup.createObject(u,c);

        } catch (Exception e){
            e.printStackTrace(); // Log error
            if (canClose) c.rollback();
            throw new SQLException(e);
        } finally{
            if (canClose) c.close();
        }
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

    public void importerChargePersonnel(String u, Connection c) throws Exception {
        boolean canClose = false;

        String[] HEURE_NORMAL_ALIASES = {
                "HEURE NORMAL",
                "HEURE NORMALE",
                "HEURE HN",
                "HN"
        };

        try {
            if (c == null){
                c = new UtilDB().GetConn();
                canClose = true;
            }

            if (this.getColIndex().get("HEURE NORMAL") == null) {
                System.out.println("ERROR: 'HEURE NORMAL' column not found in mapping!");
            }

            for (int i = this.getHeaderRow() + 1; i <= this.getSheet().getLastRowNum(); i++) {
                Map<String,Integer> index = this.getColIndex();
                Row row = this.getSheet().getRow(i);
                if (row == null) continue;

                String matricule = normalizeMatricule(safe(row.getCell(index.get(this.getMatriculeCol()))));
                if (matricule == null || matricule.isEmpty()) continue;

                matricule = sanitizeMatricule(matricule);
                System.out.println("DEBUG: Searching for sanitized matricule: " + matricule);
                String idPersonnel = getIdPersonnel(matricule, c);
                if (idPersonnel == null) {
                    System.out.println("DEBUG: Personnel not found for matricule " + matricule);
                    continue;
                }

                String idPoste  = safe(getCell(row, index, "POSTE"));
                String idClasse = safe(getCell(row, index, "CLASS"));


                double hNormal = 0;
                String rawHN = null;

                for (String col : HEURE_NORMAL_ALIASES) {
                    if (index.get(col) == null) continue;

                    String val = getValue(row, index, col);
                    if (val != null && !val.trim().isEmpty()) {
                        rawHN = val;
                        hNormal = parseDouble(val);
                        if (hNormal != 0) break;
                    }
                }


                // Only print if there is data to avoid spamming 0s
                if (hNormal > 0 || (rawHN != null && !rawHN.isEmpty())) {
                    System.out.println("DEBUG: Row " + i + " Mat " + matricule + " -> Raw HN: [" + rawHN + "] Parsed: " + hNormal);
                }

                double hs       = parseDouble(getValue(row, index, "HEURE HS"));
                double ferie    = parseDouble(getValue(row, index, "HEURE FERIE"));
                double dim      = parseDouble(getValue(row, index, "HEURE DIM"));
                double nuit     = parseDouble(getValue(row, index, "HEURE NUIT"));
                double iff      = parseDouble(getValue(row, index, "HEURE IF"));
                double taux     = parseDouble(getValue(row, index, "TAUX"));

                if (hNormal == 0 &&
                        hs == 0 &&
                        ferie == 0 &&
                        dim == 0 &&
                        nuit == 0 &&
                        iff == 0) {

                    System.out.println("DEBUG: Ligne ignorée " + i +
                            " (aucune donnée d’heures) pour le matricule " + matricule);
                    continue;
                }


                ChargePersonnelTemp charge = new ChargePersonnelTemp();
                charge.setIdPersonnel(idPersonnel);
                charge.setIdPoste(idPoste);
                charge.setIdClasse(idClasse);
                charge.setHeureNormal(hNormal);
                charge.setHs(hs);
                charge.setFerie(ferie);
                charge.setDim(dim);
                charge.setNuit(nuit);
                charge.setIff(iff);
                charge.setTaux(taux);
                charge.setIdFab(this.getIdFab());

                // Logic for Classe and Poste mapping (unchanged)
                QualificationPaie qualificationPaie = new QualificationPaie();
                qualificationPaie.setVal(idClasse);
                QualificationPaie[] qualifications = (QualificationPaie[]) CGenUtil.rechercher(qualificationPaie,null,null,c,"");
                charge.setIdClasse(qualifications.length > 0 ? qualifications[0].getId() : null);

                Poste poste = new Poste();
                poste.setVal(idPoste);
                Poste[] postes = (Poste[])CGenUtil.rechercher(poste,null,null,c,"");
                charge.setIdPoste(postes.length > 0 ? postes[0].getId() : null);

                // Insert into Temp Table
                charge.createObject(u,c);

                // Insert into Real Production Tables
                charge.createRessourceParFab(u,c);
            }
        } catch (Exception e){
            e.printStackTrace();
            if (canClose) c.rollback();
            throw e;
        } finally{
            if (canClose) c.close();
        }
    }

    private String getIdPersonnel(String matricule, Connection con) throws Exception {
        PaieInfoPersonnel crit = new PaieInfoPersonnel();
        crit.setMatricule(matricule);
        PaieInfoPersonnel[] res = (PaieInfoPersonnel[]) CGenUtil.rechercher(
                crit, null, null, con, "AND matricule='"+matricule+"'"
        );
        if (res == null || res.length == 0) return null;
        return res[0].getId();
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

    private Cell getCell(Row r, Map<String,Integer> col, String key) {
        Integer idx = col.get(key);
        if (idx == null) return null;
        return r.getCell(idx);
    }

    private String getValue(Row r, Map<String,Integer> col, String key) {
        return safe(getCell(r, col, key));
    }

    private String normalizeMatricule(String m) {
        if (m == null) return null;
        return m.replace("-", "").replace(" ", "").trim();
    }

    private double parseDouble(String s) {
        if (s == null) return 0d;
        s = s.trim();
        if (s.isEmpty()) return 0d;
        s = s.replace("\u00A0", ""); // remove non-breaking space
        try {
            return Double.parseDouble(s);
        } catch (Exception ignore) {}

        // Handle commas/dots
        String digitsOnly = s.replaceAll("[^0-9\\.,\\-]", "");
        int lastDot = digitsOnly.lastIndexOf('.');
        int lastComma = digitsOnly.lastIndexOf(',');
        int sep = Math.max(lastDot, lastComma);

        if (sep == -1) {
            if (digitsOnly.isEmpty() || "-".equals(digitsOnly)) return 0d;
            try { return Double.parseDouble(digitsOnly); } catch(Exception e) { return 0d; }
        }

        String intPart = digitsOnly.substring(0, sep).replaceAll("[^0-9\\-]", "");
        String fracPart = digitsOnly.substring(sep + 1).replaceAll("[^0-9]", "");
        if (intPart.isEmpty() || "-".equals(intPart)) intPart = "0";
        if (fracPart.isEmpty()) return Double.parseDouble(intPart);
        try { return Double.parseDouble(intPart + "." + fracPart); } catch(Exception e) { return 0d; }
    }
}