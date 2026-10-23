package lot;

import bean.ClassMAPTable;

import java.sql.Connection;
import java.sql.Date;

public class Lot extends ClassMAPTable {
    private String id;
    private Date daty;
    private String idProduit;
    private String idEquipe;
    private String remarque;

    public Lot(){
        setNomTable("LOTLIB");
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

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public String getIdProduit() {
        return idProduit;
    }

    public void setIdProduit(String idProduit) {
        this.idProduit = idProduit;
    }

    public String getIdEquipe() {
        return idEquipe;
    }

    public void setIdEquipe(String idEquipe) {
        this.idEquipe = idEquipe;
    }

    public String getRemarque() {
        return remarque;
    }

    public void setRemarque(String remarque) {
        this.remarque = remarque;
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("LOT", "getSeqLot");
        this.setId(makePK(c));
    }
}
