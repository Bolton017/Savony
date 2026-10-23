package magasin;

import bean.ClassMAPTable;
import java.sql.Connection;

public class CategorieIngredientMagasin extends ClassMAPTable {
    private String id;
    private String idMagasin;
    private String idCategorieIngredient;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdMagasin() {
        return idMagasin;
    }

    public void setIdMagasin(String idMagasin) {
        this.idMagasin = idMagasin;
    }

    public String getIdCategorieIngredient() {
        return idCategorieIngredient;
    }

    public void setIdCategorieIngredient(String idCategorieIngredient) {
        this.idCategorieIngredient = idCategorieIngredient;
    }

    public CategorieIngredientMagasin() throws Exception {
        this.setNomTable("CATEGORIEINGREDIENTMAGASIN");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("CIM","get_seq_CIM");
        this.setId(makePK(c));
    }

    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }
}

