package magasin;

public class DirectionMagasinLib extends DirectionMagasin{

    private String idMagasinLib;
    private String idDirectionLib;

    public String getIdDirectionLib() {
        return idDirectionLib;
    }

    public void setIdDirectionLib(String idDirectionLib) {
        this.idDirectionLib = idDirectionLib;
    }

    public String getIdMagasinLib() {
        return idMagasinLib;
    }

    public void setIdMagasinLib(String idMagasinLib) {
        this.idMagasinLib = idMagasinLib;
    }

    public DirectionMagasinLib() throws Exception
    {
        this.setNomTable("DIRECTIONMAGASINLIB");
    }

}
