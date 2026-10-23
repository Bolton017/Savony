package fabrication.equipe;

import bean.ClassFille;
import java.sql.Connection;
import java.sql.Date;

public class CompositionEquipe extends ClassFille {
    private String id;
    private Date daty;
    private String idEquipe;
    private String idPersonnel;
    private String remarque;
    private String idPoste;

    public String getIdPoste() {
        return idPoste;
    }

    public void setIdPoste(String idPoste) {
        this.idPoste = idPoste;
    }

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
        this.daty = daty;
    }

    public String getIdEquipe() {
        return idEquipe;
    }

    public void setIdEquipe(String idEquipe) {
        this.idEquipe = idEquipe;
    }

    public String getIdPersonnel() {
        return idPersonnel;
    }

    public void setIdPersonnel(String idPersonnel) {
        this.idPersonnel = idPersonnel;
    }

    public String getRemarque() {
        return remarque;
    }

    public void setRemarque(String remarque) {
        this.remarque = remarque;
    }


    @Override
    public String getNomClasseMere() {
        return "fabrication.equipe.Equipe";
    }

    @Override
    public String getLiaisonMere() {
        return "idEquipe";
    }

    public CompositionEquipe() throws Exception {
        this.setNomTable("COMPOSITIONEQUIPE");
        this.setNomClasseMere("fabrication.equipe.Equipe");
        this.setLiaisonMere("idEquipe");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("CEQ","GETSEQcompositionEquipe");
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

