package paie;

public class MaterniteLib extends Maternite{
    private String idPersonnelLib,matricule,idFonction,idFonctionLib;
    public MaterniteLib() {
        super.setNomTable("v_maternite_lib");
    }

    public String getIdPersonnelLib() {
        return idPersonnelLib;
    }

    public void setIdPersonnelLib(String idPersonnelLib) {
        this.idPersonnelLib = idPersonnelLib;
    }

    public String getMatricule() {
        return matricule;
    }

    public void setMatricule(String matricule) {
        this.matricule = matricule;
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
}
