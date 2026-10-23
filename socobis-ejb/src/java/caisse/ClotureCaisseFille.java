package caisse;

import bean.ClassFille;

import java.sql.Connection;
import java.sql.Date;

public class ClotureCaisseFille  extends ClassFille{

    private String id, idcloture,idCaisse,explication, caisseLib;
    private double montant,montantTheorique;
    private Date daty;
    private double ecart;
    private String idbilletage;

    public ClotureCaisseFille() throws Exception {
        super.setNomTable("CLOTURECAISSEFILLE");
        setLiaisonMere("idcloture");
        setNomClasseMere("caisse.ClotureCaisse");
    }
    public void construirePK(Connection c) throws Exception {
        this.preparePk("CCAF", "getseqcloturecaissefille");
        this.setId(makePK(c));
    }
    @Override
    public String getNomClasseMere()
    {
        return "caisse.ClotureCaisse";
    }
    @Override
    public String getAttributIDName() {
        return "id";
    }
    @Override
    public String getTuppleID() {
        return id;
    }
    public String getId() {
        return id;
    }

    public String getIdbilletage() {
        return idbilletage;
    }

    public void setIdbilletage(String idbilletage) {
        this.idbilletage = idbilletage;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdcloture() {
        return idcloture;
    }

    public void setIdcloture(String idcloture) {
        this.idcloture = idcloture;
    }

    public String getIdCaisse() {
        return idCaisse;
    }

    public void setIdCaisse(String idCaisse) {
        this.idCaisse = idCaisse;
    }

    public String getExplication() {
        return explication;
    }

    public void setExplication(String explication) {
        this.explication = explication;
    }

    public double getMontant() {
        return montant;
    }

    public void setMontant(double montant) {
        this.montant = montant;
    }
    public double getMontantTheorique() {
        return montantTheorique;
    }

    public void setMontantTheorique(double montantTheorique) {
        this.montantTheorique = montantTheorique;
    }

    public String getCaisseLib() {
        return caisseLib;
    }

    public void setCaisseLib(String caisseLib) {
        this.caisseLib = caisseLib;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public double getEcart() {
        return ecart;
    }

    public void setEcart(double ecart) {
        this.ecart = ecart;
    }
}
