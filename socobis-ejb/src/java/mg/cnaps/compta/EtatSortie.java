package mg.cnaps.compta;

import bean.ClassMAPTable;

import java.sql.Connection;

public class EtatSortie  extends ClassMAPTable {

    String id;
    String libelle;
    String formule1;
    String formule2;
    String nom;
    String categorie;
    int rang;
    int niveau;
    String idParent;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getLibelle() {
        return libelle;
    }

    public void setLibelle(String libelle) {
        this.libelle = libelle;
    }

    public String getFormule1() {
        return formule1;
    }

    public void setFormule1(String formule1) {
        this.formule1 = formule1;
    }

    public String getFormule2() {
        return formule2;
    }

    public void setFormule2(String formule2) {
        this.formule2 = formule2;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public String getCategorie() {
        return categorie;
    }

    public void setCategorie(String categorie) {
        this.categorie = categorie;
    }

    public int getRang() {
        return rang;
    }

    public void setRang(int rang) {
        this.rang = rang;
    }

    public int getNiveau() {
        return niveau;
    }

    public void setNiveau(int niveau) {
        this.niveau = niveau;
    }

    public String getIdParent() {
        return idParent;
    }

    public void setIdParent(String idParent) {
        this.idParent = idParent;
    }
    public EtatSortie() {
        super.setNomTable("EtatSortie");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("ETSO", "GET_SEQ_COMPTA_JOURNAL");
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
