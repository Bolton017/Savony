package maintenance.configuration;

import bean.TypeObjet;

import java.sql.Connection;

public class UniteMaintenance extends TypeObjet {

    int echelle;

    public UniteMaintenance() {
        this.setNomTable("unitemaintenance");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("TM", "getSeqUniteMaintenance");
        this.setId(makePK(c));
    }

    public int getEchelle() {
        return echelle;
    }

    public void setEchelle(int echelle) {
        this.echelle = echelle;
    }
}
