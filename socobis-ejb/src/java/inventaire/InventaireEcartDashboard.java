package inventaire;
import bean.ClassMere;

public class InventaireEcartDashboard extends ClassMere {
    private String id, idMagasinLib, idProduitLib;
    private double ecart, valeurEcart, nbEcart;
    private java.sql.Date daty;


    public InventaireEcartDashboard() { this.setNomTable("V_INVENTAIRE_ECART_DASHBOARD"); }

    @Override public String getTuppleID() { return id; }
    @Override public String getAttributIDName() { return "id"; }

    // Getters et Setters

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public double getNbEcart() {
        return nbEcart;
    }

    public void setNbEcart(double nbEcart) {
        this.nbEcart = nbEcart;
    }

    public String getIdMagasinLib() { return idMagasinLib; }
    public void setIdMagasinLib(String idMagasinLib) { this.idMagasinLib = idMagasinLib; }
    public String getIdProduitLib() { return idProduitLib; }
    public void setIdProduitLib(String idProduitLib) { this.idProduitLib = idProduitLib; }
    public double getEcart() { return ecart; }
    public void setEcart(double ecart) { this.ecart = ecart; }
    public double getValeurEcart() { return valeurEcart; }
    public void setValeurEcart(double valeurEcart) { this.valeurEcart = valeurEcart; }
    public java.sql.Date getDaty() { return daty; }
    public void setDaty(java.sql.Date daty) { this.daty = daty; }

}