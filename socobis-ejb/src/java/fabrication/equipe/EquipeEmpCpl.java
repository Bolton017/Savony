
package fabrication.equipe;

import bean.TypeObjet;
import java.sql.Connection;

public class EquipeEmpCpl  extends EquipeEmp{

    String idEquipe;
    String idEmploye;
    String nomEmploye;
    String nomEquipe;

      public EquipeEmpCpl() {
        this.setNomTable("EQUIPE_EMP_CPL");
    }


    public String getIdEquipe() {
        return idEquipe;
    }

    public void setIdEquipe(String idEquipe) {
        this.idEquipe = idEquipe;
    }

    public String getIdEmploye() {
        return idEmploye;
    }

    public void setIdEmploye(String idEmploye) {
        this.idEmploye = idEmploye;
    }

    public String getNomEmploye() {
        return nomEmploye;
    }

    public void setNomEmploye(String nomEmploye) {
        this.nomEmploye = nomEmploye;
    }

    public String getNomEquipe() {
        return nomEquipe;
    }

    public void setNomEquipe(String nomEquipe) {
        this.nomEquipe = nomEquipe;
    }

  



}