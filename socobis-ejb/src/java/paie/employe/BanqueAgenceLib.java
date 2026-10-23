package paie.employe;

public class BanqueAgenceLib extends BanqueAgence{

    private String idBanqueLib;

    public BanqueAgenceLib() throws Exception
    {
        super.setNomTable("BanqueAgenceLib");
    }

    public String getIdBanqueLib() {
        return idBanqueLib;
    }

    public void setIdBanqueLib(String idBanqueLib) {
        this.idBanqueLib = idBanqueLib;
    }

    @Override
    public String[] getMotCles() {

        String[] motCles = {"id", "nom", "idBanqueLib"};
        return motCles;

    }

    @Override
    public String[] getValMotCles() {
        String[] valMotCles={"nom", "idBanqueLib"};
        return valMotCles;
    }
}
