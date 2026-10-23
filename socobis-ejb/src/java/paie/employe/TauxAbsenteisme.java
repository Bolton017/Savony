package paie.employe;

import bean.CGenUtil;
import bean.ClassMAPTable;

import java.util.LinkedHashMap;
import java.util.Map;

public class TauxAbsenteisme extends ClassMAPTable {

    private String idDirection;
    private String moisLib;
    private int mois;
    private int annee;
    private double heureAbsence;
    private double heureTheorique;
    private double tauxAbsence;

    public TauxAbsenteisme() {
        this.setNomTable("tauxabsenteisme");
    }

    public static Map<String, Double> getDataChart() throws Exception {
        TauxAbsenteisme[] all = (TauxAbsenteisme[]) CGenUtil.rechercher(new TauxAbsenteisme(), null, null, "");

        Map<String, Double> dataChart = new LinkedHashMap<>();
        for (TauxAbsenteisme item : all) {
            String periode = item.getMoisLib() + "-" +  item.getAnnee();
            dataChart.put(periode, item.getTauxAbsence());
        }

        return dataChart;
    }

    public static Map<String, Double> getDataChart(int mois, int annee) throws Exception {
        Map<String, Double> dataChart = getDataChart();
        Map<String, Double> result = new LinkedHashMap<>();

        for (String periode : dataChart.keySet()) {
            String[] parts = periode.split("-");
            if (parts.length >= 2) {
                try {
                    int moisFromData = getMoisFromLibelle(parts[0]);
                    int anneeFromData = Integer.valueOf(parts[1]);

                    if (mois == moisFromData && annee == anneeFromData) {
                        result.put(periode, dataChart.get(periode));
                    }
                } catch (NumberFormatException e) {

                }
            }
        }

        return result;
    }

    public static Map<String, Double> getDataChartByMois(int mois) throws Exception {
        Map<String, Double> dataChart = getDataChart();
        Map<String, Double> result = new LinkedHashMap<>();

        for (String periode : dataChart.keySet()) {
            String[] parts = periode.split("-");
            if (parts.length >= 2) {
                try {
                    int moisFromData = getMoisFromLibelle(parts[0]);

                    if (mois == moisFromData) {
                        result.put(periode, dataChart.get(periode));
                    }
                } catch (NumberFormatException e) {
                    continue;
                }
            }
        }

        return result;
    }

    public static Map<String, Double> getDataChartByAnnee(int annee) throws Exception {
        Map<String, Double> dataChart = getDataChart();
        Map<String, Double> result = new LinkedHashMap<>();

        for (String periode : dataChart.keySet()) {
            String[] parts = periode.split("-");
            if (parts.length >= 2) {
                try {
                    int anneeFromData = Integer.valueOf(parts[1]);

                    if (annee == anneeFromData) {
                        result.put(periode, dataChart.get(periode));
                    }
                } catch (NumberFormatException e) {
                    continue;
                }
            }
        }

        return result;
    }

    private static int getMoisFromLibelle(String moisLib) {
        switch (moisLib.toLowerCase()) {
            case "janvier": return 1;
            case "février":
            case "fevrier": return 2;
            case "mars": return 3;
            case "avril": return 4;
            case "mai": return 5;
            case "juin": return 6;
            case "juillet": return 7;
            case "août":
            case "aout": return 8;
            case "septembre": return 9;
            case "octobre": return 10;
            case "novembre": return 11;
            case "décembre":
            case "decembre": return 12;
            default:
                try {
                    return Integer.parseInt(moisLib);
                } catch (NumberFormatException e) {
                    return 0;
                }
        }
    }

    public static Map<Integer, String> getMoisMap() {
        Map<Integer, String> moisMap = new LinkedHashMap<>();
        moisMap.put(1, "Janvier");
        moisMap.put(2, "F&eacute;vrier");
        moisMap.put(3, "Mars");
        moisMap.put(4, "Avril");
        moisMap.put(5, "Mai");
        moisMap.put(6, "Juin");
        moisMap.put(7, "Juillet");
        moisMap.put(8, "Aout");
        moisMap.put(9, "Septembre");
        moisMap.put(10, "Octobre");
        moisMap.put(11, "Novembre");
        moisMap.put(12, "D&eacute;cembre");
        return moisMap;
    }


    public String getIdDirection() {
        return idDirection;
    }

    public void setIdDirection(String idDirection) {
        this.idDirection = idDirection;
    }

    public String getMoisLib() {
        return moisLib;
    }

    public void setMoisLib(String moisLib) {
        this.moisLib = moisLib;
    }

    public int getMois() {
        return mois;
    }

    public void setMois(int mois) {
        this.mois = mois;
    }

    public int getAnnee() {
        return annee;
    }

    public void setAnnee(int annee) {
        this.annee = annee;
    }

    public double getHeureAbsence() {
        return heureAbsence;
    }

    public void setHeureAbsence(double heureAbsence) {
        this.heureAbsence = heureAbsence;
    }

    public double getHeureTheorique() {
        return heureTheorique;
    }

    public void setHeureTheorique(double heureTheorique) {
        this.heureTheorique = heureTheorique;
    }

    public double getTauxAbsence() {
        return tauxAbsence;
    }

    public void setTauxAbsence(double tauxAbsence) {
        this.tauxAbsence = tauxAbsence;
    }

    @Override
    public String getTuppleID() {
        return idDirection;
    }

    @Override
    public String getAttributIDName() {
        return "idDirection";
    }
}