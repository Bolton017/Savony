package paie.accident;

import bean.ClassMAPTable;
import java.sql.Connection;

public class TauxGravite extends ClassMAPTable {
    private String id;
    private String idaccident;
    private String idpersonnel;
    private String cause;
    private int nbjourpris;
    private int heuretotalenormale;
    private int heuretotalperdue;
    private int pourcentagegravite;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdaccident() {
        return idaccident;
    }

    public void setIdaccident(String idaccident) {
        this.idaccident = idaccident;
    }

    public String getIdpersonnel() {
        return idpersonnel;
    }

    public void setIdpersonnel(String idpersonnel) {
        this.idpersonnel = idpersonnel;
    }

    public String getCause() {
        return cause;
    }

    public void setCause(String cause) {
        this.cause = cause;
    }

    public int getNbjourpris() {
        return nbjourpris;
    }

    public void setNbjourpris(int nbjourpris) {
        this.nbjourpris = nbjourpris;
    }

    public int getHeuretotalenormale() {
        return heuretotalenormale;
    }

    public void setHeuretotalenormale(int heuretotalenormale) {
        this.heuretotalenormale = heuretotalenormale;
    }

    public int getHeuretotalperdue() {
        return heuretotalperdue;
    }

    public void setHeuretotalperdue(int heuretotalperdue) {
        this.heuretotalperdue = heuretotalperdue;
    }

    public int getPourcentagegravite() {
        return pourcentagegravite;
    }

    public void setPourcentagegravite(int pourcentagegravite) {
        this.pourcentagegravite = pourcentagegravite;
    }



    public TauxGravite() throws Exception {
        this.setNomTable("V_TAUX_GRAVITE_ACCIDENT");
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

