package produits;

public class IngredientsPos extends IngredientsLib{

    public IngredientsPos() {
        super.setNomTable("AS_INGREDIENTS_LIB");
    }

    @Override
    public String[] getMotCles() {
        String[] motCles={"parfums","libelle","uniteLib"};
        return motCles;
    }

    @Override
    public String[] getValMotCles() {
        String[] motCles={"parfums","libelle","uniteLib"};
        return motCles;
    }
}
