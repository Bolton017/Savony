package paie.dashboard;

import bean.ClassMAPTable;
import java.sql.Connection;

public class EffectifsCDIHFCategorie extends ClassMAPTable {
    private String id_categorie;
    private String categorie;
    private int nb_total;
    private int nb_hommes;
    private int nb_femmes;
    private int pct_hommes;
    private int pct_femmes;

    public String getId_categorie() {
        return id_categorie;
    }

    public void setId_categorie(String id_categorie) {
        this.id_categorie = id_categorie;
    }

    public String getCategorie() {
        return categorie;
    }

    public void setCategorie(String categorie) {
        this.categorie = categorie;
    }

    public int getNb_total() {
        return nb_total;
    }

    public void setNb_total(int nb_total) {
        this.nb_total = nb_total;
    }

    public int getNb_hommes() {
        return nb_hommes;
    }

    public void setNb_hommes(int nb_hommes) {
        this.nb_hommes = nb_hommes;
    }

    public int getNb_femmes() {
        return nb_femmes;
    }

    public void setNb_femmes(int nb_femmes) {
        this.nb_femmes = nb_femmes;
    }

    public int getPct_hommes() {
        return pct_hommes;
    }

    public void setPct_hommes(int pct_hommes) {
        this.pct_hommes = pct_hommes;
    }

    public int getPct_femmes() {
        return pct_femmes;
    }

    public void setPct_femmes(int pct_femmes) {
        this.pct_femmes = pct_femmes;
    }

    public EffectifsCDIHFCategorie() throws Exception {
        this.setNomTable("V_EFFECTIFS_CDI_HF_CATEGORIE");
    }

    @Override
    public String getTuppleID() {
        return id_categorie;
    }

    @Override
    public String getAttributIDName() {
        return "id_categorie";
    }
}

