package paie.edition;

/**
 *
 * @author Tsiky
 */
public class PaieRecap extends EtatPaie {
    double heuresupp30ni;
    double heuresupp30i;
    double heuresupp50ni;
    double heuresupp50i;
    double majnuit;
    double majferie;
    double majweekend;
    double abbatement;
    String moislib;


    public PaieRecap() {
        this.setNomTable("SITUATION_SALAIRE_COMPLET");
    }

    public double getHeuresupp30ni() {
        return heuresupp30ni;
    }

    public void setHeuresupp30ni(double heuresupp30ni) {
        this.heuresupp30ni = heuresupp30ni;
    }

    public double getHeuresupp30i() {
        return heuresupp30i;
    }

    public void setHeuresupp30i(double heuresupp30i) {
        this.heuresupp30i = heuresupp30i;
    }

    public double getHeuresupp50ni() {
        return heuresupp50ni;
    }

    public void setHeuresupp50ni(double heuresupp50ni) {
        this.heuresupp50ni = heuresupp50ni;
    }

    public double getHeuresupp50i() {
        return heuresupp50i;
    }

    public void setHeuresupp50i(double heuresupp50i) {
        this.heuresupp50i = heuresupp50i;
    }

    public double getMajnuit() {
        return majnuit;
    }

    public void setMajnuit(double majnuit) {
        this.majnuit = majnuit;
    }

    public double getMajferie() {
        return majferie;
    }

    public void setMajferie(double majferie) {
        this.majferie = majferie;
    }

    public double getMajweekend() {
        return majweekend;
    }

    public void setMajweekend(double majweekend) {
        this.majweekend = majweekend;
    }

    public double getAbbatement() {
        return abbatement;
    }

    public void setAbbatement(double abbatement) {
        this.abbatement = abbatement;
    }

    public String getMoislib() {
        return moislib;
    }

    public void setMoislib(String moislib) {
        this.moislib = moislib;
    }
    


}