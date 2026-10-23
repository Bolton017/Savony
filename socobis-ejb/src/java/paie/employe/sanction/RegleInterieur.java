package paie.employe.sanction;

import bean.ClassMAPTable;

import java.sql.Connection;

public class RegleInterieur extends ClassMAPTable {
    private String id, descriptionRegle;
    private int numeroRegle, niveau;

    public RegleInterieur() {
        this.setNomTable("REGLEMENTINTERIEUR");
    }

    @Override
    public String getValColLibelle() {
        return this.getId() + ";" + this.getNumeroRegle() + ";" + this.getDescriptionRegle();
    }


    @Override
    public String[] getMotCles() {
        String[] motCles={"id","numeroRegle", "descriptionRegle","niveau"};
        return motCles;
    }

     @Override
    public String[] getValMotCles() {
	 String[] valMotCles={"id","descriptionRegle","niveau"};
        return valMotCles;
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("RGI", "GETSEQREGLEINTERIEUR");
        this.setId(makePK(c));
    }
    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getDescriptionRegle() {
        return descriptionRegle;
    }

    public void setDescriptionRegle(String descriptionRegle) {
        this.descriptionRegle = descriptionRegle;
    }

    public int getNumeroRegle() {
        return numeroRegle;
    }

    public void setNumeroRegle(int numeroRegle) {
        this.numeroRegle = numeroRegle;
    }

    public int getNiveau() {
        return niveau;
    }

    public void setNiveau(int niveau) {
        this.niveau = niveau;
    }
}
