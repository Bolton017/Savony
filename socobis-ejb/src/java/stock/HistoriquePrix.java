package stock;

import bean.ClassEtat;
import java.sql.Connection;
import java.sql.Date;

public class HistoriquePrix extends ClassEtat {
    public String id, idProduit, remarque, idFacturefournisseurfille;
    public Date daty;
    public double pv;

    public HistoriquePrix(){
        this.setNomTable("HISTORIQUEPRIX");
    }

    public void construirePK(Connection c) throws Exception {
        this.preparePk("HISTOP", "getseqhistoprix");
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

    public String getRemarque() {
        return remarque;
    }

    public void setRemarque(String remarque) {
        this.remarque = remarque;
    }

    public String getIdFacturefournisseurfille() {
        return idFacturefournisseurfille;
    }

    public void setIdFacturefournisseurfille(String idFacturefournisseurfille) {
        this.idFacturefournisseurfille = idFacturefournisseurfille;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public double getPv() {
        return pv;
    }

    public void setPv(double pv) {
        this.pv = pv;
    }
}
