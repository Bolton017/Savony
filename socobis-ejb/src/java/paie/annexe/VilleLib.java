package paie.annexe;

public class VilleLib extends Ville{
    String idPaysLib;

    public VilleLib() {
        this.setNomTable("VILLELIB");
    }

    public String getIdPaysLib() {
        return idPaysLib;
    }

    public void setIdPaysLib(String idPaysLib) {
        this.idPaysLib = idPaysLib;
    }

    @Override
    public String[] getMotCles() {
        String[] motCles={"id", "nom","idPaysLib", "codePostal"};
        return motCles;
    }

    @Override
    public String[] getValMotCles() {
        String[] motCles={"id", "nom","idPaysLib", "codePostal"};
        return motCles;
    }

}
