package rapport.mapping;

import bean.ClassMere;

import java.sql.Connection;

public class CRContent extends ClassMere {

    private String id;

    private String titre;

    private String paragraphe;

    private String mapping;

    private String vue;

    private int graphe;

    public CRContent()throws Exception{

        this.setNomTable("CRCONTENT");
        this.setNomClasseFille("rapport.mapping.CRContentFille");
        this.setLiaisonFille("idCrContent");
    }

    public void construirePK(Connection c) throws Exception {
        this.preparePk("CRC", "getseqCRContent");
        this.setId(makePK(c));
    }

    @Override
    public String getTuppleID() {
        return this.id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getTitre() {
        return titre;
    }

    public void setTitre(String titre) {
        this.titre = titre;
    }

    public String getParagraphe() {
        return paragraphe;
    }

    public void setParagraphe(String paragraphe) {
        this.paragraphe = paragraphe;
    }

    public String getMapping() {
        return mapping;
    }

    public void setMapping(String mapping) {
        this.mapping = mapping;
    }

    public String getVue() {
        return vue;
    }

    public void setVue(String vue) {
        this.vue = vue;
    }

    public int getGraphe() {
        return graphe;
    }

    public void setGraphe(int graphe) {
        this.graphe = graphe;
    }
}
