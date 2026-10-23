package fabrication;

public class FabricationFilleCpl extends FabricationFille {
    String idingredientsLib;
    String idingredientslibexacte;
    String idunitelib;
    double montant;
    String idMachineLib;

    public FabricationFilleCpl() throws Exception {
        super.setNomTable("FABRICATIONFILLECPL");
    }

    public String getIdMachineLib() {
        return idMachineLib;
    }

    public void setIdMachineLib(String idMachineLib) {
        this.idMachineLib = idMachineLib;
    }

    public String getIdingredientsLib(){
        return this.idingredientsLib;
    }

    public void setIdingredientsLib(String idingredientsLib){
        this.idingredientsLib = idingredientsLib;
    }

    public String getIdingredientslibexacte() {
        return idingredientslibexacte;
    }

    public void setIdingredientslibexacte(String idingredientslibexacte) {
        this.idingredientslibexacte = idingredientslibexacte;
    }

    public String getIdunitelib() {
        return idunitelib;
    }

    public void setIdunitelib(String idunitelib) {
        this.idunitelib = idunitelib;
    }

    public double getMontant() {
        return montant;
    }

    public void setMontant(double montant) {
        this.montant = montant;
    }
}
