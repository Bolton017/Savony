package paie.employe;

import bean.ClassMAPTable;

import java.sql.Connection;

public class BanqueAgence extends ClassMAPTable {

    private String id;
    private String nom;
    private String codeAgence;
    private String idBanque;

    public BanqueAgence() throws Exception
    {
        super.setNomTable("Banque_agence");
    }

    public void construirePK(Connection c) throws Exception {
        this.preparePk("BNQAG", "getSeqBanque_Agence");
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

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getCodeAgence() {
        return codeAgence;
    }

    public void setCodeAgence(String codeAgence) {
        this.codeAgence = codeAgence;
    }

    public String getIdBanque() {
        return idBanque;
    }

    public void setIdBanque(String idBanque) {
        this.idBanque = idBanque;
    }

}
