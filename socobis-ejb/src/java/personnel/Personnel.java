package personnel;

import java.sql.Connection;
import  bean.ClassMAPTable;

public class Personnel extends ClassMAPTable{
    String id,nom,telephone,mail,adresse,remarque,compte;

    public Personnel() {
        setNomTable("PERSONNEL");
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
        this.preparePk("PERS", "get_seq_personnelle");
        this.setId(makePK(c));
    }

    @Override
    public String[] getMotCles() {
        // TODO Auto-generated method stub
        String[] motCles={"id","nom","telephone"};
        return motCles;
    }

    @Override
    public String[] getValMotCles() {
	String[] motCles={"id", "nom","telephone"};
        return motCles;
    }

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

    public String getTelephone() {
        return telephone;
    }

    public void setTelephone(String telephone) {
        this.telephone = telephone;
    }

    public String getMail() {
        return mail;
    }

    public void setMail(String mail) {
        this.mail = mail;
    }

    public String getAdresse() {
        return adresse;
    }

    public void setAdresse(String adresse) {
        this.adresse = adresse;
    }

    public String getRemarque() {
        return remarque;
    }

    public void setRemarque(String remarque) {
        this.remarque = remarque;
    }

    public String getCompte() {
        return compte;
    }

    public void setCompte(String compte) {
        this.compte = compte;
    }
}
