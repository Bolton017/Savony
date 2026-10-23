package lot;

public class LotLib extends Lot {
    private String idProduitLib;
    private String idEquipeLib;

    public LotLib(){
        setNomTable("LOTLIB");
    }

    public String getIdProduitLib() {
        return idProduitLib;
    }

    public void setIdProduitLib(String idProduitLib) {
        this.idProduitLib = idProduitLib;
    }

    public String getIdEquipeLib() {
        return idEquipeLib;
    }

    public void setIdEquipeLib(String idEquipeLib) {
        this.idEquipeLib = idEquipeLib;
    }

    @Override
    public String[] getMotCles() {
        return new String[]{"daty", "idProduitLib", "idEquipeLib"};
    }

}
