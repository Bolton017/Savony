package produits;

public class    IngredientsLib extends Ingredients
{
    String idcategorieingredient;
    String idcategorie;
    String compte;
    String uniteLib;
    String idUnite;
    double taux;
    String  refpostLib;
    String refqualificationLib;
    String composelib,idFamilleLib,actifLib;
    private double montantTTC;

    public double getMontantTTC() {
        return montantTTC;
    }

    public void setMontantTTC(double montantTTC) {
        this.montantTTC = montantTTC;
    }

    public String getComposelib() {
        return composelib;
    }

    public String getIdUnite() {
        return idUnite;
    }

    public void setIdUnite(String idUnite) {
        this.idUnite = idUnite;
    }

    public void setComposelib(String composelib) {
        this.composelib = composelib;
    }

    public double getTaux() {
        return taux;
    }

    public void setTaux(double taux) {
        this.taux = taux;
    }

    public String getUniteLib() {
        return uniteLib;
    }

    public void setUniteLib(String uniteLib) {
        this.uniteLib = uniteLib;
    }

    public String getIdcategorieingredient() {
        return idcategorieingredient;
    }

    public void setIdcategorieingredient(String idcategorieingredient) {
        this.idcategorieingredient = idcategorieingredient;
    }

    public String getActifLib() {
        return actifLib;
    }

    public void setActifLib(String actifLib) {
        this.actifLib = actifLib;
    }

    public String getIdcategorie() {
        return idcategorie;
    }

    public void setIdcategorie(String idcategorie) {
        this.idcategorie = idcategorie;
    }

    public IngredientsLib() {
        setNomTable("AS_INGREDIENTS_LIB");
    }

    @Override
    public String[] getMotCles() {
        String[] motCles={"id","parfums","libelle","unite"};
        return motCles;
    }

    @Override
    public String[] getValMotCles() {
        String[] motCles={"id","parfums","libelle","unite"};
        return motCles;
    }

    public String getCompte() {
        return compte;
    }

    public void setCompte(String compte) {
        this.compte = compte;
    }

    public String getRefpostLib() {
        return refpostLib;
    }

    public void setRefpostLib(String refpostLib) {
        this.refpostLib = refpostLib;
    }

    public String getRefqualificationLib() {
        return refqualificationLib;
    }

    public void setRefqualificationLib(String refqualificationLib) {
        this.refqualificationLib = refqualificationLib;
    }

    public String getIdFamilleLib() {
        return idFamilleLib;
    }

    public void setIdFamilleLib(String idFamilleLib) {
        this.idFamilleLib = idFamilleLib;
    }
}
