package paie.evaluation;

import bean.ClassFille;
import java.sql.Connection;

public class EvaluationDetail extends ClassFille {
    private String id;
    private String idevaluation;
    private String idcritere;
    private double note;
    private String commentaire;
    private String idTypeCompetenceFP, competence, appreciation, remarque;
    private double autoEvaluation, evaluationSuperieur, synthese;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdevaluation() {
        return idevaluation;
    }

    public void setIdevaluation(String idevaluation) {
        this.idevaluation = idevaluation;
    }

    public String getIdcritere() {
        return idcritere;
    }

    public void setIdcritere(String idcritere) {
        this.idcritere = idcritere;
    }

    public double getNote() {
        return note;
    }

    public void setNote(double note) {
        this.note = note;
    }

    public String getCommentaire() {
        return commentaire;
    }

    public void setCommentaire(String commentaire) {
        this.commentaire = commentaire;
    }

    public String getIdTypeCompetenceFP() {
        return idTypeCompetenceFP;
    }

    public void setIdTypeCompetenceFP(String idTypeCompetenceFP) {
        this.idTypeCompetenceFP = idTypeCompetenceFP;
    }

    public String getCompetence() {
        return competence;
    }

    public void setCompetence(String competence) {
        this.competence = competence;
    }

    public String getAppreciation() {
        return appreciation;
    }

    public void setAppreciation(String appreciation) {
        this.appreciation = appreciation;
    }

    public String getRemarque() {
        return remarque;
    }

    public void setRemarque(String remarque) {
        this.remarque = remarque;
    }

    public double getAutoEvaluation() {
        return autoEvaluation;
    }

    public void setAutoEvaluation(double autoEvaluation) throws Exception {
        if (this.getMode().equals("modif")) {
            if (autoEvaluation < 1 || autoEvaluation > 4){
                throw new Exception("Les notes doivent \\u00EAtres comprises entre 1 et 4");
            }
        }
        this.autoEvaluation = autoEvaluation;
    }

    public double getEvaluationSuperieur() {
        return evaluationSuperieur;
    }

    public void setEvaluationSuperieur(double evaluationSuperieur) throws Exception {
        if (evaluationSuperieur < 1 || evaluationSuperieur > 4){
            throw new Exception("Les notes doivent \\u00EAtres comprises entre 1 et 4");
        }
        this.evaluationSuperieur = evaluationSuperieur;
    }

    public double getSynthese() {
        return synthese;
    }

    public void setSynthese(double synthese) {
        this.synthese = synthese;
    }

    @Override
    public String getNomClasseMere() {
        return "paie.evaluation.EvaluationAnnuelle";
    }

    @Override
    public String getLiaisonMere() {
        return "idevaluation";
    }

    public EvaluationDetail() throws Exception {
        this.setNomTable("EVALUATION_DETAIL");
        this.setNomClasseMere("paie.evaluation.EvaluationAnnuelle");
        this.setLiaisonMere("idevaluation");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("EVD","GETSEQ_EVALUATION_DETAIL");
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

