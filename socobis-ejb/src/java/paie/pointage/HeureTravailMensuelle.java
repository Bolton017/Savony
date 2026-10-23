package paie.pointage;

import bean.ClassEtat;

public class HeureTravailMensuelle extends ClassEtat {

    String id;
    String idPaiePersonnel;
    String matric;
    String period;

    String annee;
    int mois;

    double total_heures_travaillees;
    double total_hs_30;
    double total_hs_50;
    double total_hs_taux;
    double total_heures_nuit;
    double total_absence_paye;
    double total_heure_normale;

    double total_retards;
    double total_jours_sans_retard;
    String nomPersonnel;
    String buLib;
    String bu;
    String moislib;
    String moisanneelib;

    private String uniteLib;
    private String idSectionLib;
    private String directionLib;
    private double workDay;
    private double totalConge;
    private double heureAbsence;
    private double over60;

    private String etatLib;

    public String getNomPersonnel() {
        return nomPersonnel;
    }

    public void setNomPersonnel(String nomPersonnel) {
        this.nomPersonnel = nomPersonnel;
    }

    public String getBuLib() {
        return buLib;
    }

    public void setBuLib(String buLib) {
        this.buLib = buLib;
    }

    public String getBu() {
        return bu;
    }

    public void setBu(String bu) {
        this.bu = bu;
    }

    public void setMoisanneelib(String moisanneelib) {
        this.moisanneelib = moisanneelib;
    }

    public String getMoisanneelib() {
        return moisanneelib;
    }

    public String getMoislib() {
        return moislib;
    }

    public void setMoislib(String moislib) {
        this.moislib = moislib;
    }

    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    public HeureTravailMensuelle() {
        setNomTable("vue_totaux_heures");
    }

    // Getters and Setters

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getMatric() {
        return matric;
    }

    public void setMatric(String matric) {
        this.matric = matric;
    }

    public String getPeriod() {
        return period;
    }

    public void setPeriod(String period) {
        this.period = period;
    }

    public String getAnnee() {
        return annee;
    }

    public void setAnnee(String annee) {
        this.annee = annee;
    }

    public int getMois() {
        return mois;
    }

    public void setMois(int mois) {
        this.mois = mois;
    }

    public double getTotal_heures_travaillees() {
        return total_heures_travaillees;
    }

    public void setTotal_heures_travaillees(double total_heures_travaillees) {
        this.total_heures_travaillees = total_heures_travaillees;
    }

    public double getTotal_hs_30() {
        return total_hs_30;
    }

    public void setTotal_hs_30(double total_hs_30) {
        this.total_hs_30 = total_hs_30;
    }

    public double getTotal_hs_50() {
        return total_hs_50;
    }

    public void setTotal_hs_50(double total_hs_50) {
        this.total_hs_50 = total_hs_50;
    }

    public double getTotal_hs_taux() {
        return total_hs_taux;
    }

    public void setTotal_hs_taux(double total_hs_taux) {
        this.total_hs_taux = total_hs_taux;
    }

    public double getTotal_heures_nuit() {
        return total_heures_nuit;
    }

    public void setTotal_heures_nuit(double total_heures_nuit) {
        this.total_heures_nuit = total_heures_nuit;
    }

    public double getTotal_absence_paye() {
        return total_absence_paye;
    }

    public void setTotal_absence_paye(double total_absence_paye) {
        this.total_absence_paye = total_absence_paye;
    }

    public double getTotal_heure_normale() {
        return total_heure_normale;
    }

    public void setTotal_heure_normale(double total_heure_normale) {
        this.total_heure_normale = total_heure_normale;
    }

    public double getTotal_retards() {
        return total_retards;
    }

    public void setTotal_retards(double total_retards) {
        this.total_retards = total_retards;
    }

    public double getTotal_jours_sans_retard() {
        return total_jours_sans_retard;
    }

    public void setTotal_jours_sans_retard(double total_jours_sans_retard) {
        this.total_jours_sans_retard = total_jours_sans_retard;
    }

    public String getUniteLib() {
        return uniteLib;
    }

    public void setUniteLib(String uniteLib) {
        this.uniteLib = uniteLib;
    }

    public String getIdSectionLib() {
        return idSectionLib;
    }

    public void setIdSectionLib(String idSectionLib) {
        this.idSectionLib = idSectionLib;
    }

    public String getDirectionLib() {
        return directionLib;
    }

    public void setDirectionLib(String directionLib) {
        this.directionLib = directionLib;
    }

    public double getWorkDay() {
        return workDay;
    }

    public void setWorkDay(double workDay) {
        this.workDay = workDay;
    }

    public double getTotalConge() {
        return totalConge;
    }

    public void setTotalConge(double totalConge) {
        this.totalConge = totalConge;
    }

    public double getHeureAbsence() {
        return heureAbsence;
    }

    public void setHeureAbsence(double heureAbsence) {
        this.heureAbsence = heureAbsence;
    }

    public double getOver60() {
        return over60;
    }

    public void setOver60(double over60) {
        this.over60 = over60;
    }
    public String getEtatLib() {
        return etatLib;
    }

    public void setEtatLib(String etatLib) {
        this.etatLib = etatLib;
    }

    public String getIdPaiePersonnel() {
        return idPaiePersonnel;
    }

    public void setIdPaiePersonnel(String idPaiePersonnel) {
        this.idPaiePersonnel = idPaiePersonnel;
    }
}