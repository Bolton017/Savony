package machine;

public class ElementInspectionMachineLib extends ElementInspectionMachine{
    String idElementInspectionLib;
    String idMachineLib;

    public String getIdElementInspectionLib() {
        return idElementInspectionLib;
    }

    public void setIdElementInspectionLib(String idElementInspectionLib) {
        this.idElementInspectionLib = idElementInspectionLib;
    }

    public String getIdMachineLib() {
        return idMachineLib;
    }

    public void setIdMachineLib(String idMachineLib) {
        this.idMachineLib = idMachineLib;
    }

    public ElementInspectionMachineLib() throws Exception {
        super.setNomTable("ElementInspectionMachineLib");
    }

    @Override
    public String[] getMotCles() {
        String[] motCles={"id","idElementInspectionLib","idMachineLib"};
        return motCles;
    }

    @Override
    public String[] getValMotCles() {
        String[] valMotCles={"id"};
        return valMotCles;
    }
}
