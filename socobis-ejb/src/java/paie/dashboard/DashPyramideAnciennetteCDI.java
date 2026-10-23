package paie.dashboard;

import bean.ClassMAPTable;
import java.sql.Connection;

public class DashPyramideAnciennetteCDI extends ClassMAPTable {
    private String tranche_anciennete;
    private int nb_hommes, nb_femmes;
    private int effectif;

    public String getTranche_anciennete() {
        return tranche_anciennete;
    }

    public void setTranche_anciennete(String tranche_anciennete) {
        this.tranche_anciennete = tranche_anciennete;
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

    public DashPyramideAnciennetteCDI() throws Exception {
        this.setNomTable("V_DASH_PYRAMIDE_ANCIENNETE_CDI");
    }

    @Override
    public String getTuppleID() {
        return tranche_anciennete;
    }

    @Override
    public String getAttributIDName() {
        return "tranche_anciennete";
    }
}

