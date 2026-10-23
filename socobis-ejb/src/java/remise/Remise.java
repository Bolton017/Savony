package remise;

import bean.ClassMere;
import utilitaire.Utilitaire;

import java.sql.Connection;
import java.sql.Date;

public class Remise extends ClassMere {
    private String id;
    private Date daty;
    private String nom;
    private Date datedebut;
    private Date datefin;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        if(daty == null){
           this.daty = Utilitaire.dateDuJourSql();
        } else {
            this.daty = daty;
        }
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public Date getDatedebut() {
        return datedebut;
    }

    public void setDatedebut(Date datedebut) {
        this.datedebut = datedebut;
    }

    public Date getDatefin(){
        return datefin;
    }

    public void setDatefin(Date datefin)  throws  Exception {
        if(Utilitaire.compareDaty(datedebut, datefin)>0){
            throw new Exception("Date de fin superieur a la date debut");
        }
        this.datefin = datefin;
    }



    public Remise() throws Exception {
        this.setNomTable("REMISE");
        this.setNomClasseFille("remise.RemiseFille");
        this.setLiaisonFille("idremise");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("RMS","GETSEQ_REMISE");
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

    @Override
    public String getNomClasseFille() {
        return "remise.RemiseFille";
    }

    @Override
    public String getLiaisonFille() {
        return "idremise";
    }
}

