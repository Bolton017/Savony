package mg.cnaps.compta;

public class ClotureMoisAnneeLib extends ClotureMoisAnnee{

    private String moisLib;

    public String getMoisLib() {
        return moisLib;
    }

    public void setMoisLib(String moisLib) {
        this.moisLib = moisLib;
    }

    public ClotureMoisAnneeLib() throws Exception{
        this.setNomTable("CLOTURE_MOIS_ANNEE_LIB");
    }

}
