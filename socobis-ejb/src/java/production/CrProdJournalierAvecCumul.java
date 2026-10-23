package production;

import bean.ClassMAPTable;
import java.sql.Connection;
import java.sql.Date;

public class CrProdJournalierAvecCumul extends ClassMAPTable {
    private String idIngredients;
    private String libelle;
    private Date daty;
    private String moisAnnee;
    private int qteCarton;
    private int qteFabrique;
    private int qteKg;
    private int qteFabriqueKg;
    private int objectif;
    private int ecartObjectif;
    private int cumulMois;

    public String getIdIngredients() {
        return idIngredients;
    }

    public void setIdIngredients(String idIngredients) {
        this.idIngredients = idIngredients;
    }

    public String getLibelle() {
        return libelle;
    }

    public void setLibelle(String libelle) {
        this.libelle = libelle;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public String getMoisAnnee() {
        return moisAnnee;
    }

    public void setMoisAnnee(String moisAnnee) {
        this.moisAnnee = moisAnnee;
    }

    public int getQteCarton() {
        return qteCarton;
    }

    public void setQteCarton(int qteCarton) {
        this.qteCarton = qteCarton;
    }

    public int getQteFabrique() {
        return qteFabrique;
    }

    public void setQteFabrique(int qteFabrique) {
        this.qteFabrique = qteFabrique;
    }

    public int getQteKg() {
        return qteKg;
    }

    public void setQteKg(int qteKg) {
        this.qteKg = qteKg;
    }

    public int getQteFabriqueKg() {
        return qteFabriqueKg;
    }

    public void setQteFabriqueKg(int qteFabriqueKg) {
        this.qteFabriqueKg = qteFabriqueKg;
    }

    public int getObjectif() {
        return objectif;
    }

    public void setObjectif(int objectif) {
        this.objectif = objectif;
    }

    public int getEcartObjectif() {
        return ecartObjectif;
    }

    public void setEcartObjectif(int ecartObjectif) {
        this.ecartObjectif = ecartObjectif;
    }

    public int getCumulMois() {
        return cumulMois;
    }

    public void setCumulMois(int cumulMois) {
        this.cumulMois = cumulMois;
    }



    public CrProdJournalierAvecCumul() throws Exception {
        this.setNomTable("CRPRODJOURNALIERAVECCUMUL");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("","");
        this.setIdIngredients(makePK(c));
    }

    @Override
    public String getTuppleID() {
        return idIngredients;
    }

    @Override
    public String getAttributIDName() {
        return "idIngredients";
    }
}

