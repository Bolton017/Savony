package caisse;

import java.sql.Date;

public class MvtCaisseTraite extends MvtCaisse {
    String valcaisse, libelle, etatversementlib, etatlib;
    double montant;

    public MvtCaisseTraite() {
        super.setNomTable("TRAITE_JC");
    }

    public String getValcaisse() {
        return valcaisse;
    }

    public void setValcaisse(String valcaisse) {
        this.valcaisse = valcaisse;
    }

    public String getLibelle() {
        return libelle;
    }

    public void setLibelle(String libelle) {
        this.libelle = libelle;
    }

    public String getEtatversementlib() {
        return etatversementlib;
    }

    public void setEtatversementlib(String etatversementlib) {
        this.etatversementlib = etatversementlib;
    }

    public String getEtatlib() {
        return etatlib;
    }

    public void setEtatlib(String etatlib) {
        this.etatlib = etatlib;
    }

    public double getMontant() {
        return montant;
    }

    public void setMontant(double montant) {
        this.montant = montant;
    }
}
