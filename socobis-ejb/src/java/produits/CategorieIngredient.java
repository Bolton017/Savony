package produits;

import bean.TypeObjet;

import java.sql.Connection;

public class CategorieIngredient extends TypeObjet
{
    private String iddepartement;

    public CategorieIngredient() {
        setNomTable("CATEGORIEINGREDIENT");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("CATING", "GETSEQCATEGING");
        this.setId(makePK(c));
    }


    public String getIddepartement() {
        return iddepartement;
    }

    public void setIddepartement(String iddepartement) {
        this.iddepartement = iddepartement;
    }

    @Override
    public String[] getMotCles() {
        String[] motCles={"id","val"};
        return motCles;
    }

    @Override
    public String[] getValMotCles() {
        String[] motCles={"id","val"};
        return motCles;
    }
}
