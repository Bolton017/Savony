package paie.dashboard;

import bean.ClassMAPTable;
import java.sql.Connection;

public class DashPyramidAgeCDI extends ClassMAPTable {
    private String tranche_age;
    private int effectif;
    private int nb_hommes, nb_femmes;

    public String getTranche_age() {
        return tranche_age;
    }

    public void setTranche_age(String tranche_age) {
        this.tranche_age = tranche_age;
    }

    public int getEffectif() {
        return effectif;
    }

    public void setEffectif(int effectif) {
        this.effectif = effectif;
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

    public DashPyramidAgeCDI() throws Exception {
        this.setNomTable("V_DASH_PYRAMIDE_AGE_CDI");
    }

    @Override
    public String getTuppleID() {
        return tranche_age;
    }

    @Override
    public String getAttributIDName() {
        return "tranche_age";
    }
}

