package paie.employe;

public class EmployeEltPaie extends EmployeComplet {

    private String idelementpaie;
    private int mois;
    private String moisLib;
    private int annee;
    private double gain;
    private double retenue;
    private String idedition;
    private String desceRubrique;
    private String valRubrique;
    private String nomComplet;

    public EmployeEltPaie() {
        this.setNomTable("DETAILS_ELT_PAIE");
    }

    public String getIdelementpaie() {
        return idelementpaie;
    }

    public void setIdelementpaie(String idelementpaie) {
        this.idelementpaie = idelementpaie;
    }

    public int getMois() {
        return mois;
    }

    public void setMois(int mois) {
        this.mois = mois;
    }

    public String getMoisLib() {
        return moisLib;
    }

    public void setMoisLib(String moisLib) {
        this.moisLib = moisLib;
    }

    public int getAnnee() {
        return annee;
    }

    public void setAnnee(int annee) {
        this.annee = annee;
    }

    public double getGain() {
        return gain;
    }

    public void setGain(double gain) {
        this.gain = gain;
    }

    public double getRetenue() {
        return retenue;
    }

    public void setRetenue(double retenue) {
        this.retenue = retenue;
    }

    public String getIdedition() {
        return idedition;
    }

    public void setIdedition(String idedition) {
        this.idedition = idedition;
    }

    public String getDesceRubrique() {
        return desceRubrique;
    }

    public void setDesceRubrique(String desceRubrique) {
        this.desceRubrique = desceRubrique;
    }

    public String getValRubrique() {
        return valRubrique;
    }

    public void setValRubrique(String valRubrique) {
        this.valRubrique = valRubrique;
    }

    public String getNomComplet() {
        return nomComplet;
    }

    public void setNomComplet(String nomComplet) {
        this.nomComplet = nomComplet;
    }
}
