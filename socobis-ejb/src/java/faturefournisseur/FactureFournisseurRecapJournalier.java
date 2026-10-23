package faturefournisseur;

import bean.ClassMAPTable;

import java.sql.Date;

public class FactureFournisseurRecapJournalier extends ClassMAPTable {
    Date daty;
    double montantttc, montantpaye, montantreste, montantresteacejour;
    int nombre;


    public FactureFournisseurRecapJournalier(){
        this.setNomTable("FACTUREFOURNISSEUR_RECAP_JOUR");
    }



    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public double getMontantttc() {
        return montantttc;
    }

    public void setMontantttc(double montantttc) {
        this.montantttc = montantttc;
    }

    public double getMontantpaye() {
        return montantpaye;
    }

    public void setMontantpaye(double montantpaye) {
        this.montantpaye = montantpaye;
    }

    public double getMontantreste() {
        return montantreste;
    }

    public void setMontantreste(double montantreste) {
        this.montantreste = montantreste;
    }

    public int getNombre() {
        return nombre;
    }

    public void setNombre(int nombre) {
        this.nombre = nombre;
    }

    public double getMontantresteacejour() {
        return montantresteacejour;
    }

    public void setMontantresteacejour(double montantresteacejour) {
        this.montantresteacejour = montantresteacejour;
    }

    @Override
    public String getTuppleID() {
        return "";
    }

    @Override
    public String getAttributIDName() {
        return "";
    }
}
