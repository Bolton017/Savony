package utils;

public class ConstanteEtatStation {

    private static final int etatTouche = ParametreConstante.getInt("PRMS213", 20);

    private static final int ETATENCAISSE = ParametreConstante.getInt("PRMS214", 22);

    private static final int ETATPREPARER = ParametreConstante.getInt("PRMS537", 3);

    public static int getEtatTouche() {
        return etatTouche;
    }

    public static int getEtatEncaisse() {
        return ETATENCAISSE;
    }

    public static int getEtatPreparer() {
        return ETATPREPARER;
    }
}