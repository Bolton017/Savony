package paie.evaluation;

public class EvaluationAnnuelleLib extends EvaluationAnnuelle{
    String idpersonnellib;
    String etatlib;
    String idFonction, idFonctionLib, matricule;
    public EvaluationAnnuelleLib() throws Exception {
        this.setNomTable("EVALUATION_ANNUELLE_LIB");
    }

    public String getIdpersonnellib() {
        return idpersonnellib;
    }

    public void setIdpersonnellib(String idpersonnellib) {
        this.idpersonnellib = idpersonnellib;
    }

    public String getEtatlib() {
        return etatlib;
    }

    public void setEtatlib(String etatlib) {
        this.etatlib = etatlib;
    }


    public String getIdFonction() {
        return idFonction;
    }

    public void setIdFonction(String idFonction) {
        this.idFonction = idFonction;
    }

    public String getIdFonctionLib() {
        return idFonctionLib;
    }

    public void setIdFonctionLib(String idFonctionLib) {
        this.idFonctionLib = idFonctionLib;
    }

    public String getMatricule() {
        return matricule;
    }

    public void setMatricule(String matricule) {
        this.matricule = matricule;
    }
}
