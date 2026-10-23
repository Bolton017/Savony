package paie.conge;

public class EtatConge extends MouvementAbsence {

    private String nomPersonnel;
    private String matricule;
    private double congePris;
    private String idDirection;
    private double solde;
    private double droit;

    public EtatConge() {
        this.setNomTable("SOLDECONGE_PERS_CPL");
    }

    @Override
    public double getSolde() {
        return solde;
    }

    @Override
    public void setSolde(double solde) {
        this.solde = solde;
    }

    public String getIdDirection() {
        return idDirection;
    }

    public void setIdDirection(String idDirection) {
        this.idDirection = idDirection;
    }

    public String getNomPersonnel() {
        return nomPersonnel;
    }

    public void setNomPersonnel(String nomPersonnel) {
        this.nomPersonnel = nomPersonnel;
    }

    public String getMatricule() {
        return matricule;
    }

    public void setMatricule(String matricule) {
        this.matricule = matricule;
    }

    public double getCongePris() {
        return congePris;
    }

    public void setCongePris(double congePris) {
        this.congePris = congePris;
    }

    public double getDroit() {
        return droit;
    }

    public void setDroit(double droit) {
        this.droit = droit;
    }
}
