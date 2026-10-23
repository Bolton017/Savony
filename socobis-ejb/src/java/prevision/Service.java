package prevision;

import bean.ClassMAPTable;

import java.sql.Connection;

public class Service extends ClassMAPTable {

    private String id,libelle,compte,code,departement;

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

    public String getCompte() {
        return compte;
    }

    public void setCompte(String compte) {
        this.compte = compte;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getDepartement() {
        return departement;
    }

    public void setDepartement(String departement) {
        this.departement = departement;
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("SERV", "getseqservice");
        super.construirePK(c);
    }


    @Override
    public String getTuppleID() {
        return this.getId();
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    @Override
    public String[] getMotCles() {
        return new String[]{"id","compte","libelle"};
    }

    public Service() {
        this.setNomTable("service");
    }

    public Service(String id, String libelle, String compte, String code) {
        this.setId(id);
        this.setLibelle(libelle);
        this.setCompte(compte);
        this.setCode(code);
    }
}


