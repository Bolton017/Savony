package paie.employe.sanction;

public class SanctionCPL extends  Sanction{

    private String nompersonnel;
    private String reglementLib;
    private int numeroRegle;
    private String matricule;
    
    public String getMatricule() {
        return matricule;
    }

    public void setMatricule(String matricule) {
        this.matricule = matricule;
    }

    public SanctionCPL() {
        this.setNomTable("SANCTION_CPL");
    }

    public String getReglementLib() {
        return reglementLib;
    }

    public void setReglementLib(String reglementLib) {
        this.reglementLib = reglementLib;
    }

    public int getNumeroRegle() {
        return numeroRegle;
    }

    public void setNumeroRegle(int numeroRegle) {
        this.numeroRegle = numeroRegle;
    }

    public String getNompersonnel() {
        return nompersonnel;
    }

    public void setNompersonnel(String nompersonnel) {
        this.nompersonnel = nompersonnel;
    }
}