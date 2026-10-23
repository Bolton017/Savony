package fabrication.equipe;

public class CompositionEquipeLib extends CompositionEquipe{
    private String idPersonnelLib;
    private String idEquipeLib;

    public String getIdPersonnelLib() {
        return idPersonnelLib;
    }

    public void setIdPersonnelLib(String idPersonnelLib) {
        this.idPersonnelLib = idPersonnelLib;
    }

    public String getIdEquipeLib() {
        return idEquipeLib;
    }

    public void setIdEquipeLib(String idEquipeLib) {
        this.idEquipeLib = idEquipeLib;
    }

    public CompositionEquipeLib() throws Exception{
        this.setNomTable("COMPOSITIONEQUIPELIB");
    }
}
