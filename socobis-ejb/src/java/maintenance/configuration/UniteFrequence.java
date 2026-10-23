package maintenance.configuration;

import bean.TypeObjet;

public class UniteFrequence extends TypeObjet {
    double echelle;

    public UniteFrequence() {
        this.setNomTable("UNITE_FREQUENCE");
    }

    public double getEchelle() {
        return echelle;
    }

    public void setEchelle(double echelle) {
        this.echelle = echelle;
    }
}
