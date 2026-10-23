package declaration;

public class LiaisonCodeImpotLib extends LiaisonCodeImpot{
    private String idCodeImpotLib;
    public LiaisonCodeImpotLib() throws Exception {
        super.setNomTable("LIAISONCODELIB");
    }

    public String getIdCodeImpotLib() {
        return idCodeImpotLib;
    }

    public void setIdCodeImpotLib(String idCodeImpotLib) {
        this.idCodeImpotLib = idCodeImpotLib;
    }
}
