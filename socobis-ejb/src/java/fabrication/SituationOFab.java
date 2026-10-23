package fabrication;

import bean.ClassMAPTable;
import java.sql.Connection;

public class SituationOFab extends ClassMAPTable {
    private String idmere;
    private String id;
    private String idingredients;
    private String libingredients;
    private int qteof;
    private int qtefabrique;
    private int raf;
    private String atelier;
    private String atelierlib;

    public String getIdmere() {
        return idmere;
    }

    public void setIdmere(String idmere) {
        this.idmere = idmere;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
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

    public int getQteof() {
        return qteof;
    }

    public void setQteof(int qteof) {
        this.qteof = qteof;
    }

    public int getQtefabrique() {
        return qtefabrique;
    }

    public void setQtefabrique(int qtefabrique) {
        this.qtefabrique = qtefabrique;
    }

    public int getRaf() {
        return raf;
    }

    public void setRaf(int raf) {
        this.raf = raf;
    }

    public String getAtelier() {
        return atelier;
    }

    public void setAtelier(String atelier) {
        this.atelier = atelier;
    }

    public String getAtelierlib() {
        return atelierlib;
    }

    public void setAtelierlib(String atelierlib) {
        this.atelierlib = atelierlib;
    }



    public SituationOFab() throws Exception {
        this.setNomTable("SITUATIONOFAB");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("","");
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
}

