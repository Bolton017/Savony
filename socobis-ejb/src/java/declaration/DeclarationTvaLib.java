package declaration;

public class DeclarationTvaLib extends DeclarationTva{
    public String etatLib;
    double montantpayer;
    String payementLib;

    public String getPayementLib() {
        return payementLib;
    }

    public void setPayementLib(String payementLib) {
        this.payementLib = payementLib;
    }

    public double getMontantpayer() {
        return montantpayer;
    }

    public void setMontantpayer(double montantpayer) {
        this.montantpayer = montantpayer;
    }

    public String getEtatLib() {
        return etatLib;
    }

    public void setEtatLib(String etatLib) {
        this.etatLib = etatLib;
    }

    public  DeclarationTvaLib() {
        this.setNomTable("DeclarationTVALib");
    }

}
