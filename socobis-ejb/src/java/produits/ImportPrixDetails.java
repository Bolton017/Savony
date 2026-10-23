package produits;

import bean.ClassFille;
import bean.ClassMAPTable;

import java.sql.Connection;
import java.sql.Date;

public class ImportPrixDetails extends ClassFille {
    private String id;
    private String idTypeClient;
    private String idIngredient;
    private Date daty;
    private double prixUnitaire;
    private String unite;
    private String idmere;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdTypeClient() {
        return idTypeClient;
    }

    public void setIdTypeClient(String idTypeClient) {
        this.idTypeClient = idTypeClient;
    }

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

    public String getUnite() {
        return unite;
    }

    public void setUnite(String unite) {
        this.unite = unite;
    }

    public String getIdmere() {
        return idmere;
    }

    public void setIdmere(String idmere) {
        this.idmere = idmere;
    }

    @Override
    public ClassMAPTable createObject(String u, Connection c) throws Exception {
        TarifIngredients tarif = new TarifIngredients();
        tarif.setDaty(this.getDaty());
        tarif.setIdIngredient(this.getIdIngredient());
        tarif.setIdTypeClient(this.getIdTypeClient());
        tarif.setPrixUnitaire(this.getPrixUnitaire());
        tarif.setUnite(this.getUnite());
        tarif.createObject(u, c);
        return super.createObject(u, c);
    }

    @Override
    public String getNomClasseMere() {
        return "produits.ImportPrix";
    }

    @Override
    public String getLiaisonMere() {
        return "idMere";
    }

    public ImportPrixDetails() throws Exception {
        this.setNomTable("IMPORTPRIXDETAILS");
        this.setNomClasseMere("produits.ImportPrix");
        this.setLiaisonMere("idMere");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("IPD","GETseqimportprixdetails");
        this.setId(makePK(c));
    }

    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }
}

