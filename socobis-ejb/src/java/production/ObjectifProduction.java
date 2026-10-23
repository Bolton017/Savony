
package production;
import bean.ClassMAPTable;
import java.sql.Connection;

public class ObjectifProduction extends ClassMAPTable{
    private String id , idProduit , unite;
    double qte;

    public ObjectifProduction() {
        this.setNomTable("objectifproduction");
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

    public String getUnite() {
        return unite;
    }

    public void setUnite(String unite) {
        this.unite = unite;
    }

    public double getQte() {
        return qte;
    }

    public void setQte(double qte) {
        this.qte = qte;
    }
    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("OBP", "getSeqObjectifProduction");
        this.setId(makePK(c));
    }
    @Override
    public String getTuppleID() {
        return this.getId();
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }
}
