package ristourne;

import bean.ClassFille;
import java.sql.Connection;

public class RistourneDetails extends ClassFille {
    String id, idRistourne, idProduit, idOrigine;
    double taux1, taux2;
    int qte;
    double pu;
    public int getQte() {
        return qte;
    }

    public void setQte(int qte) {
        this.qte = qte;
    }

    public double getPu() {
        return pu;
    }

    public void setPu(double pu) {
        this.pu = pu;
    }
    public String getIdMere() {
        return idRistourne;
    }

    public RistourneDetails() throws Exception {
        super.setNomTable("RistourneDetails");
        setLiaisonMere("idRistourne");
        setNomClasseMere("ristourne.Ristourne");
    }

    @Override
    public String getNomClasseMere()
    {
        return "ristourne.Ristourne";
    }

    @Override
    public String getLiaisonMere()
    {
        return "idRistourne";
    }

    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("RISDET", "getseqristournedetails");
        this.setId(makePK(c));
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdRistourne() {
        return idRistourne;
    }

    public void setIdRistourne(String idRistourne) {
        this.idRistourne = idRistourne;
    }

    public String getIdProduit() {
        return idProduit;
    }

    public void setIdProduit(String idProduit) {
        this.idProduit = idProduit;
    }

    public String getIdOrigine() {
        return idOrigine;
    }

    public void setIdOrigine(String idOrigine) {
        this.idOrigine = idOrigine;
    }

    public double getTaux1() {
        return taux1;
    }

    public void setTaux1(double taux1) {
        this.taux1 = taux1;
    }

    public double getTaux2() {
        return taux2;
    }

    public void setTaux2(double taux2) {
        this.taux2 = taux2;
    }
}
