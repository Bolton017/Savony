package fabrication;

public class HeureSupFabricationCPL extends  HeureSupFabrication{
    String etatlib, idPersonneLib;
    double montantTotal, valeurHS, valeurHD, valeurIF, valeurMN, valeurJF, th;

    public String getEtatlib() {
        return etatlib;
    }

    public void setEtatlib(String etatlib) {
        this.etatlib = etatlib;
    }

    public HeureSupFabricationCPL(){
        this.setNomTable("heureSupFabrication_cpl");
    }

    public String getIdPersonneLib() {
        return idPersonneLib;
    }

    public void setIdPersonneLib(String idPersonneLib) {
        this.idPersonneLib = idPersonneLib;
    }

    public double getMontantTotal() {
        return montantTotal;
    }

    public void setMontantTotal(double montantTotal) {
        this.montantTotal = montantTotal;
    }

    public double getValeurHS() {
        return valeurHS;
    }

    public void setValeurHS(double valeurHS) {
        this.valeurHS = valeurHS;
    }

    public double getValeurHD() {
        return valeurHD;
    }

    public void setValeurHD(double valeurHD) {
        this.valeurHD = valeurHD;
    }

    public double getValeurIF() {
        return valeurIF;
    }

    public void setValeurIF(double valeurIF) {
        this.valeurIF = valeurIF;
    }

    public double getValeurMN() {
        return valeurMN;
    }

    public void setValeurMN(double valeurMN) {
        this.valeurMN = valeurMN;
    }

    public double getValeurJF() {
        return valeurJF;
    }

    public void setValeurJF(double valeurJF) {
        this.valeurJF = valeurJF;
    }

    public double getTh() {
        return th;
    }

    public void setTh(double th) {
        this.th = th;
    }
}
