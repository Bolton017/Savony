package carburant;

import bean.ClassMAPTable;

import java.sql.Connection;
import java.sql.Date;

public class SemaineCarburant extends ClassMAPTable {
    private String id;
    private int numeroSemaine;
    private Date daty;
    private double montant;
    private String personne;

    public SemaineCarburant() {
        setNomTable("semaineCarburant");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("SC", "getSeqSemaineCarburant");
        this.setId(makePK(c));
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public int getNumeroSemaine() {
        return numeroSemaine;
    }

    public void setNumeroSemaine(int numeroSemaine) {
        this.numeroSemaine = numeroSemaine;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public double getMontant() {
        return montant;
    }

    public void setMontant(double montant) {
        this.montant = montant;
    }

    public String getPersonne() {
        return personne;
    }

    public void setPersonne(String personne) {
        this.personne = personne;
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
