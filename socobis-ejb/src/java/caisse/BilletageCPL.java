package caisse;

public class BilletageCPL extends Billetage {
    private String idcloture ;
    private double valeurBillet, montant;


    public String getIdcloture() {
        return idcloture;
    }

    public void setIdcloture(String idcloture) {
        this.idcloture = idcloture;
    }


    public double getValeurBillet() {
        return valeurBillet;
    }

    public void setValeurBillet(double valeurBillet) {
        this.valeurBillet = valeurBillet;
    }

    public double getMontant() {
        return montant;
    }

    public void setMontant(double montant) {
        this.montant = montant;
    }

    public BilletageCPL() {
        super.setNomTable("BILLETAGE_CPL");
    }


}
