package paie.dashboard;

import bean.ClassMAPTable;
import java.sql.Connection;

public class DashSalaireCategorieCDI extends ClassMAPTable {
    private String categorie;
    private int salaire_moyen_total,salaire_moyen_homme, salaire_moyen_femme;

    public String getCategorie() {
        return categorie;
    }

    public void setCategorie(String categorie) {
        this.categorie = categorie;
    }

    public int getSalaire_moyen_total() {
        return salaire_moyen_total;
    }

    public void setSalaire_moyen_total(int salaire_moyen_total) {
        this.salaire_moyen_total = salaire_moyen_total;
    }

    public int getSalaire_moyen_homme() {
        return salaire_moyen_homme;
    }

    public void setSalaire_moyen_homme(int salaire_moyen_homme) {
        this.salaire_moyen_homme = salaire_moyen_homme;
    }

    public int getSalaire_moyen_femme() {
        return salaire_moyen_femme;
    }

    public void setSalaire_moyen_femme(int salaire_moyen_femme) {
        this.salaire_moyen_femme = salaire_moyen_femme;
    }

    public DashSalaireCategorieCDI() throws Exception {
        this.setNomTable("V_DASH_SALAIRE_CATEGORIE_CDI");
    }

    @Override
    public String getTuppleID() {
        return categorie;
    }

    @Override
    public String getAttributIDName() {
        return "categorie";
    }
}

