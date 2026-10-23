package demande;
public class DemandeTransfertCpl extends DemandeTransfert {
    private String idMagasinDepartLib,idMagasinArriveLib,etatlib,categorieIngredientLib;
    private String idDepartementLibDepart, idDepartementLibArrive, idDepartementDepart, idDepartementArrive;
    private double montantQuantite;

    public DemandeTransfertCpl() throws Exception{
        this.setNomTable("demandetransfertcpl");
    }

    public String getIdMagasinDepartLib() {
        return idMagasinDepartLib;
    }

    public void setIdMagasinDepartLib(String idMagasinDepartLib) {
        this.idMagasinDepartLib = idMagasinDepartLib;
    }

    public String getIdMagasinArriveLib() {
        return idMagasinArriveLib;
    }

    public void setIdMagasinArriveLib(String idMagasinArriveLib) {
        this.idMagasinArriveLib = idMagasinArriveLib;
    }

    public String getEtatlib() {
        return etatlib;
    }

    public void setEtatlib(String etatlib) {
        this.etatlib = etatlib;
    }

    public String getCategorieIngredientLib() {
        return categorieIngredientLib;
    }

    public void setCategorieIngredientLib(String categorieIngredientLib) {
        this.categorieIngredientLib = categorieIngredientLib;
    }

    public String getIdDepartementArrive() {
        return idDepartementArrive;
    }

    public void setIdDepartementArrive(String idDepartementArrive) {
        this.idDepartementArrive = idDepartementArrive;
    }

    public String getIdDepartementDepart() {
        return idDepartementDepart;
    }

    public void setIdDepartementDepart(String idDepartementDepart) {
        this.idDepartementDepart = idDepartementDepart;
    }

    public String getIdDepartementLibDepart() {
        return idDepartementLibDepart;
    }

    public void setIdDepartementLibDepart(String idDepartementLibDepart) {
        this.idDepartementLibDepart = idDepartementLibDepart;
    }

    public String getIdDepartementLibArrive() {
        return idDepartementLibArrive;
    }

    public void setIdDepartementLibArrive(String idDepartementLibArrive) {
        this.idDepartementLibArrive = idDepartementLibArrive;
    }

    public double getMontantQuantite() {
        return montantQuantite;
    }

    public void setMontantQuantite(double montantQuantite) {
        this.montantQuantite = montantQuantite;
    }
}