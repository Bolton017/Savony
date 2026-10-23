package paie.evaluation;

import bean.ClassMere;
import caisse.CategorieCaisse;
import rapport.Utilitaire;
import vente.VenteDetails;
import bean.*;
import java.sql.Connection;
import java.util.HashSet;
import java.util.Set;

public class EvaluationAnnuelle extends ClassMere {
    private String id;
    private String idpersonnel;
    private int annee;
    private double noteglobale;
    private String commentaire;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdpersonnel() {
        return idpersonnel;
    }

    public void setIdpersonnel(String idpersonnel) {
        this.idpersonnel = idpersonnel;
    }

    public int getAnnee() {
        return annee;
    }

    public void setAnnee(int annee) {
        this.annee = annee;
    }

    public double getNoteglobale() {
        return noteglobale;
    }

    public void setNoteglobale(double noteglobale) {
        this.noteglobale = noteglobale;
    }

    public String getCommentaire() {
        return commentaire;
    }

    public void setCommentaire(String commentaire) {
        this.commentaire = commentaire;
    }



    public EvaluationAnnuelle() throws Exception {
        this.setNomTable("EVALUATION_ANNUELLE");
        this.setNomClasseFille("paie.evaluation.EvaluationDetail");
        this.setLiaisonFille("idevaluation");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("EVM","GETSEQ_EVALUATION_ANNUELLE");
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
    public ClassMAPTable createObject(String u, Connection c) throws Exception {
        double sommeNote=0;
        double noteGlobale=0;
        EvaluationDetail[] listeFille = (EvaluationDetail[]) this.getFille();
        if(listeFille.length>0)
        {
            for(int i=0;i<listeFille.length;i++)
            {
                listeFille[i].setNote(listeFille[i].getSynthese());
                sommeNote +=listeFille[i].getNote();
            }
            noteGlobale=sommeNote/listeFille.length;
        }
        this.setNoteglobale(noteGlobale);
        return super.createObject(u, c);
    }
    /*  @Override
    public int updateObject(String u, Connection c) throws Exception {
        double sommeNote=0;
        double noteGlobale=0;
        EvaluationDetail[] listeFille = (EvaluationDetail[]) CGenUtil.rechercher(new EvaluationDetail(), null, null, c, " and idevaluation='"+this.getId()+"'");
        if(listeFille.length>0)
        {
            for(int i=0;i<listeFille.length;i++)
            {
                sommeNote +=listeFille[i].getNote();
            }
            noteGlobale=sommeNote/listeFille.length;
            System.out.println("noteglobale = "+noteGlobale);
        }
        this.setNoteglobale(noteGlobale);
        return super.updateObject(u, c);
    } */
}

