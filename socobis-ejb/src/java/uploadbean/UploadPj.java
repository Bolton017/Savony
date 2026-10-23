package uploadbean;

import java.sql.Connection;

import bean.ClassMAPTable;

/**
 *
 * @author NERD
 */
public class UploadPj extends ClassMAPTable {

    private String id;
    private String libelle;
    private String chemin;
    private String mere;

    public UploadPj(String nomTable, String nomProcedure, String suff, String libelle, String chemin, String mere) {
        super.setNomTable(nomTable);
        super.setNomProcedureSequence(nomProcedure);
        super.setIndicePk(suff);
        this.setLibelle(libelle);
        this.setChemin(chemin);
        this.setMere(mere);
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk(this.getINDICE_PK(), this.getNomProcedureSequence());
        this.setId(makePK(c));
    }

    public UploadPj(String nt) {
        super.setNomTable(nt);
    }

    public UploadPj() {
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    @Override
    public String getTuppleID() {
        return id;
    }

    public String getChemin() {
        return chemin;
    }

    public void setChemin(String chemin) {
        this.chemin = chemin;
    }

    public String getMere() {
        return mere;
    }

    public void setMere(String mere) {
        this.mere = mere;
    }

    public void setLibelle(String libelle) {
        if (libelle == null) {
            this.libelle = "-";
        } else {
            this.libelle = libelle;
        }
    }

    public String getLibelle() {
        return libelle;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getId() {
        return id;
    }
}
