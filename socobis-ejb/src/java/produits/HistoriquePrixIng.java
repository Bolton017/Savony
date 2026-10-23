package produits;

import bean.ClassMAPTable;

import java.sql.Connection;
import java.sql.Date;

public class HistoriquePrixIng extends ClassMAPTable {
    String id,remarque,idIngredients;
    java.sql.Date daty;
    double pu;

    public String getIdIngredients() {
        return idIngredients;
    }

    public void setIdIngredients(String idIngredients) {
        this.idIngredients = idIngredients;
    }

    public HistoriquePrixIng() {
        super.setNomTable("historiquePuIng");
    }

    public void construirePK(Connection c) throws Exception {
        this.preparePk("HIG", "GETseqHistoriquePuIng");
        this.setId(makePK(c));
    }
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getRemarque() {
        return remarque;
    }

    public void setRemarque(String remarque) {
        this.remarque = remarque;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public double getPu() {
        return pu;
    }

    public void setPu(double pu) throws Exception {
        if (this.getMode().equals("modif") && pu < 0) {
            throw new Exception("Pu ne peut pas &ecirc;tre inf&eacute;rieur &agrave; 0");
        }
        this.pu = pu;
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
