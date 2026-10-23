package produits;

import bean.ClassMAPTable;

import java.sql.Connection;
import java.sql.Date;

public class TarifIngredients extends ClassMAPTable {
    private String id;

    private String idTypeClient;
    private String idIngredient;
    private Date daty;
    private String unite;
    private double prixUnitaire;

    public TarifIngredients() {
        this.setNomTable("tarif_ingredients");
    }

    public void construirePK(Connection c) throws Exception {
        this.preparePk("TI", "getSeqTarifIngredients");
        this.setId(this.makePK(c));
    }

    public String getIdTypeClient() {
        return idTypeClient;
    }

    public void setIdTypeClient(String idTypeClient) {
        this.idTypeClient = idTypeClient;
    }

    public String getUnite() {
        return unite;
    }

    public void setUnite(String unite) {
        this.unite = unite;
    }

    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

/*    public String getidTypeClient() {
        return idTypeClient;
    }

    public void setidTypeClient(String idTypeClient) {
        this.idTypeClient = TarifIngredients.this.idTypeClient;
    }
*/
    public String getIdIngredient() {
        return idIngredient;
    }

    public void setIdIngredient(String idIngredient) {
        this.idIngredient = idIngredient;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public double getPrixUnitaire() {
        return prixUnitaire;
    }

    public void setPrixUnitaire(double prixUnitaire) {
        this.prixUnitaire = prixUnitaire;
    }
}
