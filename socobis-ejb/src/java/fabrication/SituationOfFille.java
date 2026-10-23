package fabrication;

import bean.ClassMAPTable;
import java.sql.Connection;

public class SituationOfFille extends ClassMAPTable {
    private String id;
    private String idproduits;
    private String idingredients;
    private String libingredients;
    private double qteof;
    private double qtefabrique;
    private double raf;
    private String atelier;
    private String atelierLib;

    public String getAtelier() {
        return atelier;
    }

    public void setAtelier(String atelier) {
        this.atelier = atelier;
    }

    public String getAtelierLib() {
        return atelierLib;
    }

    public void setAtelierLib(String atelierLib) {
        this.atelierLib = atelierLib;
    }

    public String getIdproduits() {
        return idproduits;
    }

    public void setIdproduits(String idproduits) {
        this.idproduits = idproduits;
    }

    public String getIdingredients() {
        return idingredients;
    }

    public void setIdingredients(String idingredients) {
        this.idingredients = idingredients;
    }

    public String getLibingredients() {
        return libingredients;
    }

    public void setLibingredients(String libingredients) {
        this.libingredients = libingredients;
    }

    public double getQteof() {
        return qteof;
    }

    public void setQteof(double qteof) {
        this.qteof = qteof;
    }

    public double getQtefabrique() {
        return qtefabrique;
    }

    public void setQtefabrique(double qtefabrique) {
        this.qtefabrique = qtefabrique;
    }

    public double getRaf() {
        return raf;
    }

    public void setRaf(double raf) {
        this.raf = raf;
    }

    public SituationOfFille() throws Exception {
        this.setNomTable("SITUATIONOFFILLE");
    }

    @Override
    public String getTuppleID() {
        return getId();
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
}

