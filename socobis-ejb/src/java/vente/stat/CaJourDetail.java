package vente.stat;

import bean.CGenUtil;
import bean.ClassMAPTable;
import utilitaire.UtilDB;
import utilitaire.Utilitaire;
import vente.CaJournalier;

import java.sql.Connection;
import java.util.LinkedHashMap;
import java.util.Map;

public class CaJourDetail extends ClassMAPTable {
    private double montant;
    private int jour, annee, mois;
    private String jourlib, idjoursemaine;

    public CaJourDetail() {
        this.setNomTable("CA_JOUR_DETAILS");
    }
    public double getMontant() { return montant; }
    public void setMontant(double montant) { this.montant = montant; }

    public int getJour() { return jour; }
    public void setJour(int jour) { this.jour = jour; }

    public int getAnnee() { return annee; }
    public void setAnnee(int annee) { this.annee = annee; }

    public int getMois() { return mois; }
    public void setMois(int mois) { this.mois = mois; }

    public String getJourlib() { return jourlib; }
    public void setJourlib(String jourlib) { this.jourlib = jourlib; }

    public String getIdjoursemaine() { return idjoursemaine; }
    public void setIdjoursemaine(String idjoursemaine) { this.idjoursemaine = idjoursemaine; }

    @Override
    public String getAttributIDName() { return ""; }

    @Override
    public String getTuppleID() { return ""; }

    public CaJourDetail[] getByMoisAnnee(String moisStr, String anneeStr, Connection conn) throws Exception {
        boolean ouvert = false;
        try {
            if (conn == null) {
                conn = new UtilDB().GetConn();
                ouvert = true;
            }

            int mois = Utilitaire.stringToInt(moisStr);
            int annee = Utilitaire.stringToInt(anneeStr);

            String filtre = " AND mois=" + mois + " AND annee=" + annee;
            CaJourDetail[] details = (CaJourDetail[]) CGenUtil.rechercher(new CaJourDetail(), null, null, conn, filtre);

            Map<String, CaJourDetail> mapDetails = new LinkedHashMap<>();
            for (CaJourDetail d : details) {
                mapDetails.put(d.getIdjoursemaine(), d);
            }

            CaJourSemaine[] jours = (CaJourSemaine[]) CGenUtil.rechercher(new CaJourSemaine(), null, null, conn, "");

            CaJourDetail[] result = new CaJourDetail[jours.length];
            for (int i = 0; i < jours.length; i++) {
                CaJourSemaine jour = jours[i];
                CaJourDetail d = mapDetails.getOrDefault(jour.getId(), new CaJourDetail());
                d.setAnnee(annee);
                d.setMois(mois);
                d.setIdjoursemaine(jour.getId());
                d.setJourlib(jour.getLibjour());
                if (d.getMontant() == 0) d.setMontant(0);
                result[i] = d;
            }

            return result;
        } finally {
            if (ouvert && conn != null) conn.close();
        }
    }

    public Map<String, CaJourDetail[]> getAll() throws Exception {
        Map<String, CaJourDetail[]> list = new LinkedHashMap<>();
        Connection c = null;
        try {
            c = new UtilDB().GetConn();
            vente.CaJournalier caj = new vente.CaJournalier();
            caj.setNomTable("V_MOIS_ANNEE_DISTINCTS");
            vente.CaJournalier[] colums = (vente.CaJournalier[]) CGenUtil.rechercher(caj, null, null, c, "");
            for(vente.CaJournalier col : colums){
                String key = col.getMoislib()+" "+col.getAnnee();
                CaJourDetail[] value = this.getByMoisAnnee(col.getMois(),col.getAnnee(),c);
                list.put(key,value);
            }
            return list;
        } catch (Exception ex) {
            throw ex;
        } finally {
            if (c != null)
                c.close();
        }
    }

    public Map<String, CaJourDetail[]> getAllOptimised() throws Exception {
        Map<String, CaJourDetail[]> result = new LinkedHashMap<>();

        try (Connection conn = new UtilDB().GetConn()) {
            CaJourDetail[] allDetails = (CaJourDetail[]) CGenUtil.rechercher(new CaJourDetail(), null, null, conn, " order by ANNEE, mois, jour");

            Map<String, Map<String, CaJourDetail>> index = new LinkedHashMap<>();
            for (CaJourDetail d : allDetails) {
                String key = d.getMois() + "-" + d.getAnnee();
                index.computeIfAbsent(key, k -> new LinkedHashMap<>()).put(d.getIdjoursemaine(), d);
            }

            vente.CaJournalier caj = new vente.CaJournalier();
            caj.setNomTable("V_MOIS_ANNEE_DISTINCTS");
            vente.CaJournalier[] moisAnnees = (vente.CaJournalier[]) CGenUtil.rechercher(caj, null, null, conn, "");

            CaJourSemaine[] jours = (CaJourSemaine[]) CGenUtil.rechercher(new CaJourSemaine(), null, null, conn, "");
            for (CaJournalier ma : moisAnnees) {
                int mois = Utilitaire.stringToInt(ma.getMois());
                int annee = Utilitaire.stringToInt(ma.getAnnee());
                String key = mois + "-" + annee;

                CaJourDetail[] tab = new CaJourDetail[jours.length+2];
                Map<String, CaJourDetail> currentDetails = index.getOrDefault(key, new LinkedHashMap<>());
                double totalAr = 0;
                double totalMoyen = 0;
                int nombre = 0;
                for (int i = 0; i < jours.length; i++) {
                    CaJourSemaine j = jours[i];
                    CaJourDetail d = currentDetails.getOrDefault(j.getId(), new CaJourDetail());
                    d.setMois(mois);
                    d.setAnnee(annee);
                    d.setIdjoursemaine(j.getId());
                    d.setJourlib(j.getLibjour());
                    if (d.getMontant() > 0){
                        nombre++;
                    }
                    tab[i] = d;
                    totalAr += d.getMontant();
                    totalMoyen += d.getMontant();
                    if(i==jours.length-1){
                        CaJourDetail dT = new CaJourDetail();
                        dT.setMois(mois);
                        dT.setAnnee(annee);
                        dT.setJourlib("TOTAL CA Ar");
                        dT.setMontant(totalAr);
                        tab[i+1] = dT;
                        CaJourDetail dM = new CaJourDetail();
                        dM.setMois(mois);
                        dM.setAnnee(annee);
                        dM.setJourlib("CA JR moyen");
                        dM.setMontant(totalMoyen/nombre);
                        tab[i+2] = dM;
                        break;
                    }
                }

                String label = ma.getMoislib() + " " + ma.getAnnee();
                result.put(label, tab);
            }

            return result;
        }
    }

}
