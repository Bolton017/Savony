package annexe;

import bean.ClassMAPTable;
import equivalenceproduit.EquivalenceProduit;
import utilitaire.UtilDB;
import vente.EquivalenceVente;

import java.sql.Connection;

public class EquivalenceCarton extends ClassMAPTable {
    String id, idPetris, idCarton;
    double nbcarton;

    public EquivalenceCarton() {
        this.setNomTable("equivalencecarton");
    }

    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("EQCRT", "getSeqequivalencecarton");
        this.setId(makePK(c));
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdPetris() {
        return idPetris;
    }

    public void setIdPetris(String idPetris) {
        this.idPetris = idPetris;
    }

    public String getIdCarton() {
        return idCarton;
    }

    public void setIdCarton(String idCarton) {
        this.idCarton = idCarton;
    }

    public double getNbcarton() {
        return nbcarton;
    }

    public void setNbcarton(double nbcarton) {
        this.nbcarton = nbcarton;
    }

    @Override
    public ClassMAPTable createObject(String u, Connection c) throws Exception {
        EquivalenceVente vente = new EquivalenceVente();
        vente.setIdproduit1(this.getIdPetris());
        vente.setIdproduit2(this.getIdCarton());
        vente.setQuantite((int) this.getNbcarton());
        vente.createObject(u,c);

        EquivalenceProduit pr = new EquivalenceProduit();
        pr.setIdProduitEq(this.getIdPetris());
        pr.setIdProduitBase(this.getIdCarton());
        pr.setQuantite((int) this.getNbcarton());
        pr.createObject(u,c);

        return super.createObject(u, c);
    }
}
