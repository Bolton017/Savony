package paie.dashboard;

import bean.ClassMAPTable;
import java.sql.Connection;

public class ReppartionEffectifContrat extends ClassMAPTable {
    private String id_type_contrat;
    private String type_contrat;
    private int nb_employes;
    private int nb_hommes;
    private int nb_femmes;
    private int pct_effectif;

    public String getId_type_contrat() {
        return id_type_contrat;
    }

    public void setId_type_contrat(String id_type_contrat) {
        this.id_type_contrat = id_type_contrat;
    }

    public String getType_contrat() {
        return type_contrat;
    }

    public void setType_contrat(String type_contrat) {
        this.type_contrat = type_contrat;
    }

    public int getNb_employes() {
        return nb_employes;
    }

    public void setNb_employes(int nb_employes) {
        this.nb_employes = nb_employes;
    }

    public int getNb_hommes() {
        return nb_hommes;
    }

    public void setNb_hommes(int nb_hommes) {
        this.nb_hommes = nb_hommes;
    }

    public int getNb_femmes() {
        return nb_femmes;
    }

    public void setNb_femmes(int nb_femmes) {
        this.nb_femmes = nb_femmes;
    }

    public int getPct_effectif() {
        return pct_effectif;
    }

    public void setPct_effectif(int pct_effectif) {
        this.pct_effectif = pct_effectif;
    }


    public ReppartionEffectifContrat() throws Exception {
        this.setNomTable("V_REPARTITION_EFF_CONTRAT");
    }

    @Override
    public String getTuppleID() {
        return id_type_contrat;
    }

    @Override
    public String getAttributIDName() {
        return "id_type_contrat";
    }
}

