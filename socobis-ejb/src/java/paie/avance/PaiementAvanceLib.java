package paie.avance;

public class PaiementAvanceLib extends PaiementAvance{
    String moisLib;
    String etatLib;
    String typeAvanceLib;

    public PaiementAvanceLib() {
        this.setNomTable("PAIEMENTAVANCELIB");
    }

    public String getMoisLib() {
        return moisLib;
    }

    public void setMoisLib(String moisLib) {
        this.moisLib = moisLib;
    }

    public String getEtatLib() {
        return etatLib;
    }

    public void setEtatLib(String etatLib) {
        this.etatLib = etatLib;
    }

    public String getTypeAvanceLib() {
        return typeAvanceLib;
    }

    public void setTypeAvanceLib(String typeAvanceLib) {
        this.typeAvanceLib = typeAvanceLib;
    }
}
