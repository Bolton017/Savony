package vente;

import bean.CGenUtil;
import bean.ClassMAPTable;

import java.util.LinkedHashMap;
import java.util.Map;

public class ChiffreAffaireAnnuel extends ClassMAPTable {
    private int annee;
    private double janvier;
    private double fevrier;
    private double mars;
    private double avril;
    private double mai;
    private double juin;
    private double juillet;
    private double aout;
    private double septembre;
    private double octobre;
    private double novembre;
    private double decembre;

    public ChiffreAffaireAnnuel() {
        this.setNomTable("CA_ANNEE_MOIS");
    }

    public static Map<String, Double> getDataChart(int annee) throws Exception {
        String where = " AND annee = " + annee;
        ChiffreAffaireAnnuel[] rows = (ChiffreAffaireAnnuel[])
                CGenUtil.rechercher(new ChiffreAffaireAnnuel(), null, null, where);

        Map<String, Double> data = new LinkedHashMap<>();
        if (rows != null && rows.length > 0) {
            ChiffreAffaireAnnuel ca = rows[0];
            data.put("Janvier", ca.getJanvier());
            data.put("F\u00E9vrier", ca.getFevrier());
            data.put("Mars", ca.getMars());
            data.put("Avril", ca.getAvril());
            data.put("Mai", ca.getMai());
            data.put("Juin", ca.getJuin());
            data.put("Juillet", ca.getJuillet());
            data.put("Ao\u00FBt", ca.getAout());
            data.put("Septembre", ca.getSeptembre());
            data.put("Octobre", ca.getOctobre());
            data.put("Novembre", ca.getNovembre());
            data.put("D\u00E9cembre", ca.getDecembre());
        }
        return data;
    }

    public static Map<String, Map<String, Double>> getDataChartAllYears() throws Exception {
        ChiffreAffaireAnnuel[] rows = (ChiffreAffaireAnnuel[])
                CGenUtil.rechercher(new ChiffreAffaireAnnuel(), null, null, "");

        Map<String, Map<String, Double>> data = new LinkedHashMap<>();

        for (ChiffreAffaireAnnuel ca : rows) {
            Map<String, Double> yearData = new LinkedHashMap<>();
            yearData.put("Janvier", ca.getJanvier());
            yearData.put("Février", ca.getFevrier());
            yearData.put("Mars", ca.getMars());
            yearData.put("Avril", ca.getAvril());
            yearData.put("Mai", ca.getMai());
            yearData.put("Juin", ca.getJuin());
            yearData.put("Juillet", ca.getJuillet());
            yearData.put("Août", ca.getAout());
            yearData.put("Septembre", ca.getSeptembre());
            yearData.put("Octobre", ca.getOctobre());
            yearData.put("Novembre", ca.getNovembre());
            yearData.put("Décembre", ca.getDecembre());

            data.put(String.valueOf(ca.getAnnee()), yearData);
        }

        return data;
    }

    // getters & setters
    public int getAnnee() { return annee; }
    public void setAnnee(int annee) { this.annee = annee; }
    public double getJanvier() { return janvier; }
    public void setJanvier(double janvier) { this.janvier = janvier; }
    public double getFevrier() { return fevrier; }
    public void setFevrier(double fevrier) { this.fevrier = fevrier; }
    public double getMars() { return mars; }
    public void setMars(double mars) { this.mars = mars; }
    public double getAvril() { return avril; }
    public void setAvril(double avril) { this.avril = avril; }
    public double getMai() { return mai; }
    public void setMai(double mai) { this.mai = mai; }
    public double getJuin() { return juin; }
    public void setJuin(double juin) { this.juin = juin; }
    public double getJuillet() { return juillet; }
    public void setJuillet(double juillet) { this.juillet = juillet; }
    public double getAout() { return aout; }
    public void setAout(double aout) { this.aout = aout; }
    public double getSeptembre() { return septembre; }
    public void setSeptembre(double septembre) { this.septembre = septembre; }
    public double getOctobre() { return octobre; }
    public void setOctobre(double octobre) { this.octobre = octobre; }
    public double getNovembre() { return novembre; }
    public void setNovembre(double novembre) { this.novembre = novembre; }
    public double getDecembre() { return decembre; }
    public void setDecembre(double decembre) { this.decembre = decembre; }

    @Override
    public String getTuppleID() {
        return String.valueOf(annee);
    }

    @Override
    public String getAttributIDName() {
        return "annee";
    }
}
