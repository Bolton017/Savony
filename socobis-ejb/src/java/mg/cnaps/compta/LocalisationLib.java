package mg.cnaps.compta;

import java.sql.Connection;

public class LocalisationLib extends Localisation {

    String typecomptelib , magasinLib , departementLib;

    public String getMagasinLib() {
        return magasinLib;
    }

    public void setMagasinLib(String magasinLib) {
        this.magasinLib = magasinLib;
    }

    public String getDepartementLib() {
        return departementLib;
    }

    public void setDepartementLib(String departementLib) {
        this.departementLib = departementLib;
    }

    public String getTypecomptelib() {
        return typecomptelib;
    }

    public void setTypecomptelib(String typecomptelib) {
        this.typecomptelib = typecomptelib;
    }

    public LocalisationLib() {
        super.setNomTable("LocalisationLib");
    }

}