package paie.employe;

import bean.ClassMAPTable;

import java.sql.Connection;

public class CodeBarre extends ClassMAPTable {

    private String id;

    private String idIng;

    private String image;

    public CodeBarre(){
        this.setNomTable("CODEBARRE");
    }

    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        setNomTable("codebarre");
        this.preparePk("CBING", "GETSEQcodebarre");
        this.setId(makePK(c));
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdIng() {
        return idIng;
    }

    public void setIdIng(String idIng) {
        this.idIng = idIng;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }
}
