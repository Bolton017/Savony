package mg.cnaps.compta;

import bean.ClassMAPTable;

public class LigneBilan extends ClassMAPTable {

    String libelle;
    double valeur1;
    double valeur2;
    String type;

    public String getLibelle() {
        return libelle;
    }

    public void setLibelle(String libelle) {
        this.libelle = libelle;
    }

    public double getValeur1() {
        return valeur1;
    }

    public void setValeur1(double valeur1) {
        this.valeur1 = valeur1;
    }

    public double getValeur2() {
        return valeur2;
    }

    public void setValeur2(double valeur2) {
        this.valeur2 = valeur2;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    @Override
    public String getTuppleID() {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public String getAttributIDName() {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

}
