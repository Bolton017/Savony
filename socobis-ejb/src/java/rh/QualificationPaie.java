package rh;
import bean.TypeObjet;

public class QualificationPaie extends TypeObjet {
    String idPoste;

    public String getIdPoste() {
        return idPoste;
    }

    public void setIdPoste(String idPoste) {
        this.idPoste = idPoste;
    }

    public QualificationPaie() {
        super.setNomTable("QUALIFICATION_PAIE");
    }
}