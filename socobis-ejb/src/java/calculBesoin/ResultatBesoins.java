package calculBesoin;

import produits.IngredientsLib;
import produits.Recette;

import java.sql.Connection;
import java.util.ArrayList;
import java.util.List;

public class ResultatBesoins {
    private String id;
    private String idIngredient;
    private String idIngredientLib;
    private String idMatiere;
    private String idMatiereLib;
    private String uniteLib;
    private double quantite;
    private double pu;

    public static ResultatBesoins[] getResultatBesoin(String idProduit, double qte, Connection c) throws Exception {
        IngredientsLib ing = (IngredientsLib) new IngredientsLib().getById(idProduit, "as_ingredients_lib", c);
        if (ing.getCompose() == 0){
            throw new Exception("L'ingrédient " + ing.getLibelle() + " n'est pas composé, il ne peut pas être décomposé en matières premières.");
        }

        Recette[] listeBase = ing.decomposerBase(c);
        List<ResultatBesoins> res = new ArrayList<>();

        for (Recette r : listeBase) {
            ResultatBesoins rb = new ResultatBesoins();
            rb.setIdIngredient(idProduit);
            rb.setIdIngredientLib(ing.getLibelle());
            rb.setIdMatiere(r.getIdingredients());
            rb.setIdMatiereLib(r.getLibIngredients());
            rb.setQuantite(r.getQuantite() * qte);
            rb.setUniteLib(r.getUnite());
            rb.setPu(r.getQteav());
            res.add(rb);
        }

        return res.toArray(new ResultatBesoins[]{});
    }

    public String getUniteLib() {
        return uniteLib;
    }

    public void setUniteLib(String uniteLib) {
        this.uniteLib = uniteLib;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdIngredient() {
        return idIngredient;
    }

    public void setIdIngredient(String idIngredient) {
        this.idIngredient = idIngredient;
    }

    public String getIdIngredientLib() {
        return idIngredientLib;
    }

    public void setIdIngredientLib(String idIngredientLib) {
        this.idIngredientLib = idIngredientLib;
    }

    public double getQuantite() {
        return quantite;
    }

    public void setQuantite(double quantite) {
        this.quantite = quantite;
    }

    public String getIdMatiere() {
        return idMatiere;
    }

    public void setIdMatiere(String idMatiere) {
        this.idMatiere = idMatiere;
    }

    public String getIdMatiereLib() {
        return idMatiereLib;
    }

    public void setIdMatiereLib(String idMatiereLib) {
        this.idMatiereLib = idMatiereLib;
    }

    public double getPu() {
        return pu;
    }

    public void setPu(double pu) {
        this.pu = pu;
    }
}