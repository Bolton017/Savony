package vente.stat;

import bean.ClassMAPTable;

public class CaJourSemaine extends ClassMAPTable {

    String id,libjour;
    int numsemaine,numjour;

    public CaJourSemaine() {
        this.setNomTable("JOURSEMAINE");
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getLibjour() {
        return libjour;
    }

    public void setLibjour(String libjour) {
        this.libjour = libjour;
    }

    public int getNumsemaine() {
        return numsemaine;
    }

    public void setNumsemaine(int numsemaine) {
        this.numsemaine = numsemaine;
    }

    public int getNumjour() {
        return numjour;
    }

    public void setNumjour(int numjour) {
        this.numjour = numjour;
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
