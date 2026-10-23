package vente;

public class VenteCplVisee extends Vente
{
    String idmagasinlib;
    String etatlib;
    double montanttotal;
    double montantpaye;
    double montantreste;
    int avoir;
    String idreservation;
    String idorigine;
    String iddevise;

    public String getIddevise() {
        return iddevise;
    }

    public void setIddevise(String iddevise) {
        this.iddevise = iddevise;
    }

    public String getIdmagasinlib() {
        return idmagasinlib;
    }

    public void setIdmagasinlib(String idmagasinlib) {
        this.idmagasinlib = idmagasinlib;
    }

    public String getEtatlib() {
        return etatlib;
    }

    public void setEtatlib(String etatlib) {
        this.etatlib = etatlib;
    }

    public double getMontanttotal() {
        return montanttotal;
    }

    public void setMontanttotal(double montanttotal) {
        this.montanttotal = montanttotal;
    }

    public double getMontantpaye() {
        return montantpaye;
    }

    public void setMontantpaye(double montantpayer) {
        this.montantpaye = montantpayer;
    }

    public double getMontantreste() {
        return montantreste;
    }

    public void setMontantreste(double montantreste) {
        this.montantreste = montantreste;
    }

    public int getAvoir() {
        return avoir;
    }

    public void setAvoir(int avoir) {
        this.avoir = avoir;
    }

    public String getIdreservation() {
        return idreservation;
    }

    public void setIdreservation(String idreservation) {
        this.idreservation = idreservation;
    }

    public String getIdorigine() {
        return idorigine;
    }

    public void setIdorigine(String idorigine) {
        this.idorigine = idorigine;
    }

    public VenteCplVisee() {
        setNomTable("VENTE_CPL_VISEE");
    }
}
