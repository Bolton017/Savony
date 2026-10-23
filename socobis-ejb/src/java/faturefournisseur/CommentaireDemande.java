
package faturefournisseur;

import java.sql.Connection;
import java.sql.Date;
import bean.ClassMAPTable;

public class CommentaireDemande extends ClassMAPTable{
    private String id;
    private int refuser;
    private String nomUser;
    private Date daty;
    private String commentaire , idObjet;

    public CommentaireDemande() {
        setNomTable("commentaireDemande");
    }

    public String getIdObjet() {
        return idObjet;
    }

    public void setIdObjet(String idObjet) {
        this.idObjet = idObjet;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public int getRefuser() {
        return refuser;
    }

    public void setRefuser(int refuser) {
        this.refuser = refuser;
    }

    public String getNomUser() {
        return nomUser;
    }

    public void setNomUser(String nomUser) {
        this.nomUser = nomUser;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public String getCommentaire() {
        return commentaire;
    }

    public void setCommentaire(String commentaire) {
        this.commentaire = commentaire;
    }
    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("CD", "get_seq_commentaireDemande");
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
