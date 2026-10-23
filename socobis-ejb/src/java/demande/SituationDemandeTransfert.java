package demande;
import bean.ClassMAPTable;
public class SituationDemandeTransfert extends ClassMAPTable{
    private String id,idProduit,produit;
    private double qteDemande,qteLivre,qteRecu,qteStock;
    public SituationDemandeTransfert() throws Exception{
        this.setNomTable("SITUATIONDEMANDETRANSFERT");
    }
    public String getTuppleID() {
        return id;
    }

    public String getAttributIDName() {
        return "id";
    }
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdProduit() {
        return idProduit;
    }

    public void setIdProduit(String idProduit) {
        this.idProduit = idProduit;
    }

    public String getProduit() {
        return produit;
    }

    public void setProduit(String produit) {
        this.produit = produit;
    }

    public double getQteDemande() {
        return qteDemande;
    }

    public void setQteDemande(double qteDemande) {
        this.qteDemande = qteDemande;
    }

    public double getQteLivre() {
        return qteLivre;
    }

    public void setQteLivre(double qteLivre) {
        this.qteLivre = qteLivre;
    }

    public double getQteRecu() {
        return qteRecu;
    }

    public void setQteRecu(double qteRecu) {
        this.qteRecu = qteRecu;
    }

    public double getQteStock() {
        return qteStock;
    }

    public void setQteStock(double qteStock) {
        this.qteStock = qteStock;
    }
}