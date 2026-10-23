package paie.accident;

import bean.ClassEtat;
import java.sql.Connection;
import java.sql.Date;

public class GravitesAccidentStats  extends GraviteAccident {
    private Date mois, daty;
    private int totaljourperdue;
    private int tauxgravite;

    public Date getMois() {
        return mois;
    }

    public void setMois(Date mois) {
        this.mois = mois;
    }

    public int getTotaljourperdue() {
        return totaljourperdue;
    }

    public void setTotaljourperdue(int totaljourperdue) {
        this.totaljourperdue = totaljourperdue;
    }

    public int getTauxgravite() {
        return tauxgravite;
    }

    public void setTauxgravite(int tauxgravite) {
        this.tauxgravite = tauxgravite;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public GravitesAccidentStats() throws Exception {
        this.setNomTable("V_TAUX_GRAVITE");
    }

}

