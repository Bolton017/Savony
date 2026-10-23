package produits;

import panier.Panier;
import utilitaire.Utilitaire;

public class IngredientVente extends IngredientsLib{
    private String idTypeClient;
    private String idTypeClientLib;
    private String idUnite;
    private String idUniteLib;
    private double poids;
    private double qte;
    private double prixUnitaire;

    public String getPuUniteLib() {
        return Utilitaire.formaterAr(this.getPrixUnitaire()) +" MGA / "+this.getIdUniteLib();
    }

    public IngredientVente() {
        setNomTable("AS_INGREDIENT_VENTE_LIB");
    }

    @Override
    public String[] getMotCles() {
        String[] motCles={"id","libelle"};
        return motCles;
    }

    @Override
    public String[] getValMotCles() {
        String[] motCles={"libelle"};
        return motCles;
    }

    public String getIdTypeClient() {
        return idTypeClient;
    }

    public void setIdTypeClient(String idTypeClient) {
        this.idTypeClient = idTypeClient;
    }

    public String getIdTypeClientLib() {
        return idTypeClientLib;
    }

    public void setIdTypeClientLib(String idTypeClientLib) {
        this.idTypeClientLib = idTypeClientLib;
    }

    public String getIdUnite() {
        return idUnite;
    }

    public void setIdUnite(String idUnite) {
        this.idUnite = idUnite;
    }

    public String getIdUniteLib() {
        return idUniteLib;
    }

    public void setIdUniteLib(String idUniteLib) {
        this.idUniteLib = idUniteLib;
    }

    public double getPoids() {
        return poids;
    }

    public void setPoids(double poids) {
        this.poids = poids;
    }

    public double getQte() {
        return qte;
    }

    public void setQte(double qte) {
        this.qte = qte;
    }

    public double getPrixUnitaire() {
        return prixUnitaire;
    }

    public void setPrixUnitaire(double prixUnitaire) {
        this.prixUnitaire = prixUnitaire;
    }

    public Panier toPanier() throws Exception {
        Panier panier = new Panier();
        panier.setMode("modif");
        panier.setIdProduit(this.getId());
        panier.setPu(this.getPrixUnitaire());
        panier.setIdUnite(this.getUnite());
        panier.setDaty(Utilitaire.dateDuJourSql());
        return panier;
    }
}
