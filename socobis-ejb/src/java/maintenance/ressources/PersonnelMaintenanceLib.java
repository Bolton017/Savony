package maintenance.ressources;

public class PersonnelMaintenanceLib extends PersonnelMaintenance{
    private String idDepartementLib;

    public PersonnelMaintenanceLib() {
        setNomTable("personnemaintenancecpl");
    }

    public String getIdDepartementLib() {
        return idDepartementLib;
    }

    public void setIdDepartementLib(String idDepartementLib) {
        this.idDepartementLib = idDepartementLib;
    }
}
