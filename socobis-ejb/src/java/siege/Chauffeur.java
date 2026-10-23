package siege;

import bean.ClassMAPTable;

import java.sql.Connection;

public class Chauffeur extends ClassMAPTable{
    String id;
    String nom;
    String numero;
    String adresse;
    String compte;

    public Chauffeur() {
        this.setNomTable("CHAUFFEUR");
    }
    public String getId() {
        return this.id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getNom() {
        return this.nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public String getNumero() {
        return this.numero;
    }

    public void setNumero(String numero) {
        this.numero = numero;
    }

    public String getAdresse() {
        return this.adresse;
    }

    public void setAdresse(String adresse) {
        this.adresse = adresse;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    @Override
    public String getTuppleID() {
        return id;
    }
    @Override
    public String[] getMotCles() {
        String[] motCles={"id","nom"};
        return motCles;
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("CHF", "GETSEQ_CHAUFFEUR");
        this.setId(makePK(c));
    }

    public String getCompte() {
        return compte;
    }

    public void setCompte(String compte) throws Exception {
        if(this.getMode().equalsIgnoreCase("modif")) {
            if(compte==null || compte.compareToIgnoreCase("")==0) {
                throw new Exception("Le compte est obligatoire!");
            }
        }
        this.compte = compte;
    }

    @Override
    public void controler(Connection c) throws Exception {
        super.controler(c);
        checkNumero();
    }

    protected void checkNumero() throws Exception
    {
        String telephoneval = this.getNumero().replaceAll("[^0-9]", "");
        if( telephoneval.length()!=10){
            throw new Exception("Numero de telephone invalide:"+this.getNumero() + " doit contenir 10 chiffres" );
        }
    }


}
