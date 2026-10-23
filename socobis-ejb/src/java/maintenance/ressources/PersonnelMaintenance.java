package maintenance.ressources;

import personnel.Personnel;

public class PersonnelMaintenance extends Personnel {
    private String idDepartement;

    public PersonnelMaintenance() {
        super();
    }

    public String getIdDepartement() {
        return idDepartement;
    }

    public void setIdDepartement(String idDepartement) {
        this.idDepartement = idDepartement;
    }

    @Override
    public String[] getMotCles() {
        String[] motCles={"id","nom"};
        return motCles;
    }

    @Override
    public String[] getValMotCles() {
        String[] valMotCles={"nom"};
        return valMotCles;
    }
}
