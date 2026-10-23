package stat;

import bean.ClassMAPTable;

public class RepartitionCoutOF extends ClassMAPTable {
    private String idMere;
    private String categorieingredient;
    private double montantsortie;
    private String idCategorieingredient;

    public RepartitionCoutOF() {
        setNomTable("stockEtDepOfFabTheCatGroupe");
    }

    public String getIdMere() {
        return idMere;
    }

    public void setIdMere(String idMere) {
        this.idMere = idMere;
    }

    public String getCategorieingredient() {
        return categorieingredient;
    }

    public void setCategorieingredient(String categorieingredient) {
        this.categorieingredient = categorieingredient;
    }

    public double getMontantsortie() {
        return montantsortie;
    }

    public void setMontantsortie(double montantsortie) {
        this.montantsortie = montantsortie;
    }

    public String getIdCategorieingredient() {
        return idCategorieingredient;
    }

    public void setIdCategorieingredient(String idCategorieingredient) {
        this.idCategorieingredient = idCategorieingredient;
    }

    @Override
    public String getTuppleID() {
        return idMere;
    }

    @Override
    public String getAttributIDName() {
        return "idMere";
    }
}
