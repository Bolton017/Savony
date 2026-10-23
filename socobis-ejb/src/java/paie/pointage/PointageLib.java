package paie.pointage;

public class PointageLib extends Pointage {

    private String moisLib, directionLib;

    public PointageLib() throws Exception {
        super.setNomTable("POINTAGE_LIB");
    }


    public String getMoisLib() {
        return moisLib;
    }

    public void setMoisLib(String moisLib) {
        this.moisLib = moisLib;
    }

    public String getDirectionLib() {
        return directionLib;
    }

    public void setDirectionLib(String directionLib) {
        this.directionLib = directionLib;
    }
}
