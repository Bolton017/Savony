package paie.annexe;

import bean.ClassMAPTable;

import java.sql.Connection;

public class Ville extends ClassMAPTable {
    String id;
    String nom;
    String codePostal;
    String idPays;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public String getCodePostal() {
        return codePostal;
    }

    public void setCodePostal(String codePostal) {
        this.codePostal = codePostal;
    }

    public String getIdPays() {
        return idPays;
    }

    public void setIdPays(String idPays) {
        this.idPays = idPays;
    }

    public Ville() {
        this.setNomTable("VILLE");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("VIL","getseq_ville");
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
