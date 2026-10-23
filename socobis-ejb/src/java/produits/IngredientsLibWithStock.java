package produits;

public class IngredientsLibWithStock extends IngredientsLib{
    private double entree;
    private double sortie;
    private double reste;
    public IngredientsLibWithStock(){
        setNomTable("as_ingredients_lib_with_stock");
    }

    public double getEntree() {
        return entree;
    }

    public void setEntree(double entree) {
        this.entree = entree;
    }

    public double getSortie() {
        return sortie;
    }

    public void setSortie(double sortie) {
        this.sortie = sortie;
    }

    @Override
    public double getReste() {
        return reste;
    }

    @Override
    public void setReste(double reste) {
        this.reste = reste;
    }
}
