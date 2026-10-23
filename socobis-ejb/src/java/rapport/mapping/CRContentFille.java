package rapport.mapping;

import bean.ClassFille;

import java.sql.Connection;

public class CRContentFille extends ClassFille {

    private String id;

    private String idCrContent;

    private String libEntete;

    private String libEnteteAfficher;

    private int colSomme;

    private int colDate;

    public CRContentFille()throws Exception{
        this.setNomTable("CRCONTENTFILLE");
        this.setNomClasseMere("rapport.mapping.CRContent");
        this.setLiaisonMere("idCrContent");
    }

    public void construirePK(Connection c) throws Exception {
        this.preparePk("CRCF", "getseqCRContentFille");
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

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdCrContent() {
        return idCrContent;
    }

    public void setIdCrContent(String idCrContent) {
        this.idCrContent = idCrContent;
    }

    public String getLibEntete() {
        return libEntete;
    }

    public void setLibEntete(String libEntete) {
        this.libEntete = libEntete;
    }

    public String getLibEnteteAfficher() {
        return libEnteteAfficher;
    }

    public void setLibEnteteAfficher(String libEnteteAfficher) {
        this.libEnteteAfficher = libEnteteAfficher;
    }

    public int getColSomme() {
        return colSomme;
    }

    public void setColSomme(int colSomme) {
        this.colSomme = colSomme;
    }

    public int getColDate() {
        return colDate;
    }

    public void setColDate(int colDate) {
        this.colDate = colDate;
    }
}
